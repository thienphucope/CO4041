%RUN_COMPARE  ARR-01..04: quét 16 trạng thái công tắc cho mọi ca che bóng.
%   In bảng so sánh SP / TCT / BL / trạng thái tốt nhất, và ghi:
%     results/arr_summary.csv  -- toàn bộ chỉ tiêu (ca x trạng thái)
%     results/reference.js     -- dữ liệu cho viewer/index.html (đường I-V từ Octave/MATLAB)

Vbat = 13.0;                     % V, điểm làm việc nếu ST-S1230 là PWM
T    = 25;                       % °C
V    = (0:0.1:23.5)';

p = pv_module_params();
cases = pv_shading_cases();
[states, labels] = pv_states();
nC = numel(cases);  nS = size(states, 1);

outdir = fullfile(fileparts(mfilename('fullpath')), '..', 'results');
if ~exist(outdir, 'dir'), mkdir(outdir); end

Pmax = zeros(nC, nS);  Vmpp = Pmax;  npk = Pmax;  Pbat = Pmax;
curves = zeros(numel(V), nS, nC);
t0 = tic;
for k = 1:nC
    for s = 1:nS
        I = pv_array_iv(V, cases(k).G, states(s, :), p, T);
        m = pv_metrics(V, I, Vbat);
        Pmax(k, s) = m.Pmax;  Vmpp(k, s) = m.Vmpp;  npk(k, s) = m.npk;  Pbat(k, s) = m.Pbat;
        curves(:, s, k) = I;
    end
end
fprintf('Đã chạy %d ca x %d trạng thái trong %.1f s\n\n', nC, nS, toc(t0));

% --- Bảng tóm tắt
iSP = 1;  iTCT = 16;  iBL = bin2dec('1001') + 1;
fprintf('%-11s %8s %8s %8s %8s  %-9s %7s | %8s %8s\n', 'Ca', 'SP', 'TCT', 'BL', 'Best', 'S_best', 'dP/SP', 'Pbat SP', 'Pbat TCT');
for k = 1:nC
    b = max(Pmax(k, :));
    sb = find(Pmax(k, :) >= b - 0.01, 1);   % hòa thì ưu tiên trạng thái đơn giản hơn (SP trước)
    fprintf('%-11s %8.2f %8.2f %8.2f %8.2f  %-9s %+6.1f%% | %8.2f %8.2f\n', cases(k).name, ...
        Pmax(k, iSP), Pmax(k, iTCT), Pmax(k, iBL), b, labels{sb}, ...
        100 * (b - Pmax(k, iSP)) / Pmax(k, iSP), Pbat(k, iSP), Pbat(k, iTCT));
end

% --- CSV
fid = fopen(fullfile(outdir, 'arr_summary.csv'), 'w');
fprintf(fid, 'case,state,S1,S2,S3,S4,label,Pmax_W,Vmpp_V,n_peaks,Pbat_W,gain_vs_SP_pct\n');
for k = 1:nC
    for s = 1:nS
        fprintf(fid, '%s,%d,%d,%d,%d,%d,%s,%.4f,%.3f,%d,%.4f,%.3f\n', cases(k).name, s - 1, ...
            states(s, :), labels{s}, Pmax(k, s), Vmpp(k, s), npk(k, s), Pbat(k, s), ...
            100 * (Pmax(k, s) - Pmax(k, iSP)) / Pmax(k, iSP));
    end
end
fclose(fid);

% --- reference.js cho viewer
ref.generated = datestr(now, 'yyyy-mm-dd HH:MM');
ref.Vbat = Vbat;  ref.T = T;  ref.V = V';
ref.params = rmfield(p, {'q', 'kB'});
ref.labels = labels';
ref.states = states;
for k = 1:nC
    ref.cases(k).name = cases(k).name;
    ref.cases(k).desc = cases(k).desc;
    ref.cases(k).G = cases(k).G;
    ref.cases(k).I = round(curves(:, :, k)' * 1e5) / 1e5;   % 16 x numel(V)
    ref.cases(k).Pmax = Pmax(k, :);
    ref.cases(k).Pbat = Pbat(k, :);
end
fid = fopen(fullfile(outdir, 'reference.js'), 'w');
fprintf(fid, 'window.PV_REF = %s;\n', jsonencode(ref));
fclose(fid);
fprintf('\nĐã ghi results/arr_summary.csv và results/reference.js\n');
