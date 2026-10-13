function R = sl_run_compare(caseNames)
%SL_RUN_COMPARE  ARR-01..04 trên models/pv3x3.slx: quét 16 trạng thái x các ca che bóng.
%   R = sl_run_compare()                  mọi ca trong pv_shading_cases
%   R = sl_run_compare({'deu','mot-tam'}) chỉ một số ca (chạy thử nhanh)
%   Ghi:
%     results/arr_summary_simulink.csv     cùng cột với results/arr_summary.csv (tham chiếu)
%     results/switch_stress_simulink.csv   |dòng| max qua công tắc đóng, |áp| max trên công tắc mở
%     results/sl_results.mat               đường I-V, điện áp từng tấm tại GMPP
cfg = sl_config();
cases = pv_shading_cases();
if nargin > 0, cases = cases(ismember({cases.name}, caseNames)); end
[states, labels] = pv_states();
nC = numel(cases);  nS = 16;

vars = struct('G', {}, 'S', {}, 'T', {}, 'Vmax', {});
closed = zeros(nC*nS, 4);
for k = 1:nC
    for s = 1:nS
        vars(end+1) = struct('G', cases(k).G, 'S', states(s, :), 'T', cfg.T, 'Vmax', cfg.Vmax_array); %#ok<AGROW>
        closed((k-1)*nS + s, :) = states(s, :);
    end
end
Vg = (0:cfg.dV:cfg.Vmax_array)';
t0 = tic;
B = sl_sweep_batch('array', vars, Vg, struct('switches', {{'S1', 'S2', 'S3', 'S4'}}, ...
    'panels', true, 'closed', closed));
fprintf('Đã chạy %d lần mô phỏng trong %.1f s\n\n', numel(vars), toc(t0));

Pmax = nan(nC, nS);  Vmpp = Pmax;  npk = Pmax;  Pbat = Pmax;
curves = nan(numel(Vg), nS, nC);  Vpanel = nan(3, 3, nS, nC);
for k = 1:nC
    for s = 1:nS
        j = (k-1)*nS + s;
        if ~isempty(B.err{j})
            fprintf('LỖI %s, S=%s: %s\n', cases(k).name, sprintf('%d', states(s, :)), strtok(B.err{j}, newline));
            continue;
        end
        ok = ~isnan(B.I(:, j));
        m = pv_metrics(Vg(ok), B.I(ok, j), cfg.Vbat);
        Pmax(k, s) = m.Pmax;  Vmpp(k, s) = m.Vmpp;  npk(k, s) = m.npk;  Pbat(k, s) = m.Pbat;
        curves(:, s, k) = B.I(:, j);
        [~, iv] = min(abs(Vg - m.Vmpp));
        Vpanel(:, :, s, k) = B.Vp(:, :, iv, j);
    end
end

iSP = 1;  iTCT = 16;  iBL = bin2dec('1001') + 1;
fprintf('%-11s %8s %8s %8s %8s  %-9s %7s | %8s %8s\n', 'Ca', 'SP', 'TCT', 'BL', 'Best', 'S_best', 'dP/SP', 'Pbat SP', 'Pbat TCT');
for k = 1:nC
    b = max(Pmax(k, :));
    sb = find(Pmax(k, :) >= b - 0.01, 1);
    fprintf('%-11s %8.2f %8.2f %8.2f %8.2f  %-9s %+6.1f%% | %8.2f %8.2f\n', cases(k).name, ...
        Pmax(k, iSP), Pmax(k, iTCT), Pmax(k, iBL), b, labels{sb}, ...
        100 * (b - Pmax(k, iSP)) / Pmax(k, iSP), Pbat(k, iSP), Pbat(k, iTCT));
end

if ~exist(cfg.resdir, 'dir'), mkdir(cfg.resdir); end
fid = fopen(fullfile(cfg.resdir, 'arr_summary_simulink.csv'), 'w');
fprintf(fid, 'case,state,S1,S2,S3,S4,label,Pmax_W,Vmpp_V,n_peaks,Pbat_W,gain_vs_SP_pct\n');
for k = 1:nC
    for s = 1:nS
        fprintf(fid, '%s,%d,%d,%d,%d,%d,%s,%.4f,%.3f,%d,%.4f,%.3f\n', cases(k).name, s - 1, ...
            states(s, :), labels{s}, Pmax(k, s), Vmpp(k, s), npk(k, s), Pbat(k, s), ...
            100 * (Pmax(k, s) - Pmax(k, iSP)) / Pmax(k, iSP));
    end
end
fclose(fid);

fid = fopen(fullfile(cfg.resdir, 'switch_stress_simulink.csv'), 'w');
fprintf(fid, 'case,state,label,Imax_S1,Imax_S2,Imax_S3,Imax_S4,Umax_S1,Umax_S2,Umax_S3,Umax_S4,Ibat_S1,Ibat_S2,Ibat_S3,Ibat_S4,Ubat_S1,Ubat_S2,Ubat_S3,Ubat_S4\n');
for k = 1:nC
    for s = 1:nS
        j = (k-1)*nS + s;
        fprintf(fid, '%s,%d,%s', cases(k).name, s - 1, labels{s});
        fprintf(fid, ',%.4f', B.Imax(j, :), B.Umax(j, :), B.Ibat(j, :), B.Ubat(j, :));
        fprintf(fid, '\n');
    end
end
fclose(fid);
fprintf('\nỨng suất công tắc (9 ca): |I| max = %.2f A, |U| max = %.2f V\n', max(B.Imax(:)), max(B.Umax(:)));

R = struct('cases', {cases}, 'states', states, 'labels', {labels}, 'V', Vg, 'curves', curves, ...
    'Pmax', Pmax, 'Vmpp', Vmpp, 'npk', npk, 'Pbat', Pbat, 'Vpanel', Vpanel, 'Vbat', cfg.Vbat, ...
    'Imax', B.Imax, 'Umax', B.Umax);
save(fullfile(cfg.resdir, 'sl_results.mat'), '-struct', 'R');
fprintf('Đã ghi results/arr_summary_simulink.csv, switch_stress_simulink.csv, sl_results.mat\n');
end
