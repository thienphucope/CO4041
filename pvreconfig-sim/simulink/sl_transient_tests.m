function T = sl_transient_tests()
%SL_TRANSIENT_TESTS  Mức 3: quá độ khi đổi cấu hình trên models/pv3x3_tr.slx.
%   Các ca: SP -> TCT đóng 4 công tắc cùng lúc / lần lượt cách 1 ms, TCT -> SP, ca che chéo
%   (điện áp trên công tắc mở lớn), quét điện dung tấm Cpv 1 / 10 uF, ca bàn cờ (dòng nối chéo lớn).
%   Với mỗi công tắc: xung dòng lớn nhất trong 5 ms sau khi đổi, dòng xác lập, thời gian ổn định
%   (về trong 5 %), năng lượng tiêu tán trên công tắc; so dòng xác lập với mô hình tham chiếu.
%   Ghi results/transient_simulink.csv, results/transient_simulink.mat, hình results/fig/transient_*.png.
cfg = sl_config();
mdl = cfg.mdl_transient;
addpath(cfg.modeldir);
load_system(fullfile(cfg.modeldir, [mdl '.slx']));
p = pv_module_params();
cs = pv_shading_cases();
Gc = @(name) cs(strcmp({cs.name}, name)).G;
t1 = 0.01;
Z = [0 0 0 0];  O = [1 1 1 1];
sc = { ...
    'mot-tam SP->TCT cùng lúc',      Gc('mot-tam'), Z, O, t1*[1 1 1 1],          cfg.tr.Cpv;
    'mot-tam SP->TCT lần lượt 1 ms', Gc('mot-tam'), Z, O, t1 + [0 1 2 3]*1e-3,   cfg.tr.Cpv;
    'mot-tam TCT->SP',               Gc('mot-tam'), O, Z, t1*[1 1 1 1],          cfg.tr.Cpv;
    'cheo SP->TCT',                  Gc('cheo'),    Z, O, t1*[1 1 1 1],          cfg.tr.Cpv;
    'cheo SP->TCT, Cpv 1 uF',        Gc('cheo'),    Z, O, t1*[1 1 1 1],          1e-6;
    'cheo SP->TCT, Cpv 10 uF',       Gc('cheo'),    Z, O, t1*[1 1 1 1],          10e-6;
    'ban-co SP->TCT',                1000*[1 0 1; 0 1 0; 1 0 1], Z, O, t1*[1 1 1 1], cfg.tr.Cpv};
n = size(sc, 1);
for j = n:-1:1
    in(j) = Simulink.SimulationInput(mdl);
    in(j) = in(j).setVariable('G', sc{j, 2}, 'Workspace', mdl);
    in(j) = in(j).setVariable('Sa', sc{j, 3}, 'Workspace', mdl);
    in(j) = in(j).setVariable('Sb', sc{j, 4}, 'Workspace', mdl);
    in(j) = in(j).setVariable('tsw', sc{j, 5}, 'Workspace', mdl);
    in(j) = in(j).setVariable('Cpv', sc{j, 6}, 'Workspace', mdl);
end
out = sim(in, 'ShowProgress', 'on');

rows = {};  W = struct('name', {}, 't', {}, 'isw', {}, 'Iarr', {});
figdir = fullfile(cfg.resdir, 'fig');
if ~exist(figdir, 'dir'), mkdir(figdir); end
fprintf('\n== Mức 3: quá độ đóng/cắt (Rsw = %.0f mOhm, Rline = %.0f mOhm, Lline = %.1f uH, Vbat = %.1f V)\n', ...
    1e3*cfg.tr.Rsw, 1e3*cfg.tr.Rline, 1e6*cfg.tr.Lline, cfg.Vbat);
for j = 1:n
    if ~isempty(out(j).ErrorMessage)
        fprintf('LỖI %s: %s\n', sc{j, 1}, strtok(out(j).ErrorMessage, newline));
        continue;
    end
    lg = out(j).simlog;
    t = lg.CVS.i.series.time;
    Iarr = abs(lg.CVS.i.series.values('A'));
    isw = zeros(numel(t), 4);
    for k = 1:4, isw(:, k) = lg.(sprintf('S%d', k)).i.series.values('A'); end
    tend = t(end);
    fin = t > tend - 0.002;
    Iend = mean(Iarr(fin));
    % dòng nối chéo xác lập theo mô hình tham chiếu tại điện áp dàn = Vbat + Rline * I
    st = pv_switch_stress(cfg.Vbat + cfg.tr.Rline * Iend, sc{j, 2}, sc{j, 4}, p);
    fprintf('\n%s (Cpv = %.0f uF): I dàn %.2f -> %.2f A\n', sc{j, 1}, 1e6*sc{j, 6}, mean(Iarr(t < min(sc{j, 5}))), Iend);
    fprintf('   %-3s %10s %10s %10s %10s %10s\n', 'Sk', 'đỉnh (A)', 'xác lập', 'tham chiếu', 't ổn định', 'E (uJ)');
    for k = 1:4
        tk = sc{j, 5}(k);
        a = abs(isw(:, k));
        win = t >= tk & t <= tk + 0.005;
        pk = max(a(win));
        fv = mean(a(fin));
        dev = abs(a - fv) > max(0.05 * fv, 0.05) & t > tk;
        ts = 0;  if any(dev), ts = t(find(dev, 1, 'last')) - tk; end
        after = t >= tk;
        E = trapz(t(after), isw(after, k).^2) * cfg.tr.Rsw * sc{j, 4}(k);
        ref = abs(st.I(1, k));  if isnan(ref), ref = 0; end
        fprintf('   S%-2d %10.3f %10.3f %10.3f %8.2f ms %10.2f\n', k, pk, fv, ref, 1e3*ts, 1e6*E);
        rows(end+1, :) = {sc{j, 1}, 1e6*sc{j, 6}, k, pk, fv, ref, 1e3*ts, 1e6*E}; %#ok<AGROW>
    end
    W(end+1) = struct('name', sc{j, 1}, 't', t, 'isw', isw, 'Iarr', Iarr); %#ok<AGROW>
    try
        f = figure('Visible', 'off');
        subplot(2, 1, 1); plot(1e3*t, isw); grid on; ylabel('I công tắc (A)');
        legend('S1', 'S2', 'S3', 'S4', 'Location', 'best'); title(sc{j, 1});
        subplot(2, 1, 2); plot(1e3*t, Iarr); grid on; ylabel('I dàn (A)'); xlabel('t (ms)');
        print(f, fullfile(figdir, sprintf('transient_%d.png', j)), '-dpng', '-r120');
        close(f);
    catch
    end
end
fid = fopen(fullfile(cfg.resdir, 'transient_simulink.csv'), 'w');
fprintf(fid, 'scenario,Cpv_uF,switch,peak_A,final_A,final_ref_A,settle_ms,E_uJ\n');
for k = 1:size(rows, 1)
    fprintf(fid, '%s,%.1f,S%d,%.4f,%.4f,%.4f,%.3f,%.3f\n', rows{k, :});
end
fclose(fid);
save(fullfile(cfg.resdir, 'transient_simulink.mat'), 'W', 'rows');
fprintf('\nĐã ghi results/transient_simulink.csv, .mat và hình trong results/fig/\n');
T = rows;
end
