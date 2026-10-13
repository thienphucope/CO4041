function T = sl_module_tests()
%SL_MODULE_TESTS  PV-01..04 trên models/pv1.slx, so với mô hình tham chiếu (reference/).
%   PV-01: 1000 W/m^2, 25 °C          PV-02: 400 / 700 W/m^2, 25 °C
%   PV-03: 1000 W/m^2, 45 / 60 °C     PV-04: tấm 300 W/m^2 bị ép dòng 2,5 A (diode bypass kẹp)
%   Trả về bảng kết quả và ghi results/pv_module_simulink.csv.

cfg = sl_config();
addpath(cfg.modeldir, fullfile(cfg.here, 'reference'));
mdl = cfg.mdl_module;
load_system(fullfile(cfg.modeldir, [mdl '.slx']));
p = pv_module_params();

ca = {'PV-01', 1000, 25; 'PV-02', 400, 25; 'PV-02', 700, 25; 'PV-03', 1000, 45; 'PV-03', 1000, 60};
n = size(ca, 1);
for k = 1:n
    in(k) = Simulink.SimulationInput(mdl); %#ok<AGROW>
    in(k) = in(k).setVariable('G', ca{k, 2}, 'Workspace', mdl);
    in(k) = in(k).setVariable('T', ca{k, 3}, 'Workspace', mdl);
end
% PV-04: quét -1..2 V ở 300 W/m^2, tìm điện áp tại 2,5 A
in(n+1) = Simulink.SimulationInput(mdl);
in(n+1) = in(n+1).setVariable('G', 300, 'Workspace', mdl);
in(n+1) = in(n+1).setVariable('Vmin', -1, 'Workspace', mdl);
in(n+1) = in(n+1).setVariable('Vmax', 2, 'Workspace', mdl);
out = sim(in, 'ShowProgress', 'off');

vg = (0:0.002:cfg.Vmax_module)';
rows = {};
fprintf('\n== PV-01..03: Simulink so với tham chiếu\n');
fprintf('%-6s %5s %3s | %7s %7s %7s %7s %7s | %7s %7s %7s | %s\n', 'Ca', 'G', 'T', ...
    'Isc', 'Voc', 'Vmp', 'Imp', 'Pmax', 'Isc_ref', 'Voc_ref', 'Pm_ref', 'lệch Pmax');
for k = 1:n
    [V, I, msg] = sl_iv(out(k));
    if ~isempty(msg), warning('%s G=%d T=%d lỗi: %s', ca{k, :}, msg); continue; end
    s = char_pts(V, I);
    r = char_pts(vg, pv_module_current(vg, ca{k, 2}, ca{k, 3}, p));
    d = 100 * (s.Pmax / r.Pmax - 1);
    fprintf('%-6s %5d %3d | %7.3f %7.3f %7.3f %7.3f %7.3f | %7.3f %7.3f %7.3f | %+6.2f %%\n', ...
        ca{k, 1}, ca{k, 2}, ca{k, 3}, s.Isc, s.Voc, s.Vmp, s.Imp, s.Pmax, r.Isc, r.Voc, r.Pmax, d);
    rows(end+1, :) = {ca{k, 1}, ca{k, 2}, ca{k, 3}, s.Isc, s.Voc, s.Vmp, s.Imp, s.Pmax, ...
        r.Isc, r.Voc, r.Vmp, r.Imp, r.Pmax, d}; %#ok<AGROW>
end

[V, I, msg] = sl_iv(out(n+1));
if isempty(msg)
    [Iu, iu] = unique(I);
    vb = interp1(Iu, V(iu), 2.5);
    vb_ref = fzero(@(x) pv_module_current(x, 300, 25, p) - 2.5, [-2, 0]);
    fprintf('\n== PV-04: điện áp tấm ở 2,5 A = %.3f V (tham chiếu %.3f V)\n', vb, vb_ref);
else
    warning('PV-04 lỗi: %s', msg);
end

T = cell2table(rows, 'VariableNames', {'test', 'G', 'T', 'Isc', 'Voc', 'Vmp', 'Imp', 'Pmax', ...
    'Isc_ref', 'Voc_ref', 'Vmp_ref', 'Imp_ref', 'Pmax_ref', 'dPmax_pct'});
if ~exist(cfg.resdir, 'dir'), mkdir(cfg.resdir); end
writetable(T, fullfile(cfg.resdir, 'pv_module_simulink.csv'));
if all(abs(T.dPmax_pct) <= 0.5)
    fprintf('PV-01..03: ĐẠT (Pmax lệch <= 0,5 %%)\n');
else
    fprintf('PV-01..03: LỆCH > 0,5 %% -> xem lại tham số Solar Cell (sl_conf_solar)\n');
end
end

function s = char_pts(V, I)
V = V(:);  I = I(:);
s.Isc = interp1(V, I, 0);
pos = V >= 0;
Vp = V(pos);  Ip = I(pos);
j = find(Ip <= 0, 1);
if isempty(j) || j == 1
    s.Voc = NaN;
else
    s.Voc = interp1(Ip(j-1:j), Vp(j-1:j), 0);
end
P = Vp .* Ip;
[s.Pmax, m] = max(P);
s.Vmp = Vp(m);  s.Imp = Ip(m);
end
