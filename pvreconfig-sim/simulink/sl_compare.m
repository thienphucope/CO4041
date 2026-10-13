function C = sl_compare(tol_pct)
%SL_COMPARE  Đối chiếu results/arr_summary_simulink.csv với results/arr_summary.csv (tham chiếu).
%   C = sl_compare()       ngưỡng mặc định 1 %
%   C = sl_compare(tol)    ngưỡng tol %
%   In lệch lớn nhất theo ca, kiểm tra trạng thái tốt nhất có trùng không
%   (hai trạng thái chênh < 0,2 W coi như hòa), ghi results/compare_simulink_vs_ref.csv.

if nargin < 1, tol_pct = 1; end
cfg = sl_config();
ref = readtable(fullfile(cfg.resdir, 'arr_summary.csv'), 'Delimiter', ',');
sl  = readtable(fullfile(cfg.resdir, 'arr_summary_simulink.csv'), 'Delimiter', ',');
ref.Properties.VariableNames{1} = 'ca';   % cột "case" trùng từ khóa MATLAB
sl.Properties.VariableNames{1}  = 'ca';
C = innerjoin(sl(:, {'ca', 'state', 'label', 'Pmax_W', 'Pbat_W', 'n_peaks'}), ...
              ref(:, {'ca', 'state', 'Pmax_W', 'Pbat_W', 'n_peaks'}), ...
              'Keys', {'ca', 'state'}, ...
              'LeftVariables', {'ca', 'state', 'label', 'Pmax_W', 'Pbat_W', 'n_peaks'}, ...
              'RightVariables', {'Pmax_W', 'Pbat_W', 'n_peaks'});
C.Properties.VariableNames = {'ca', 'state', 'label', 'Pmax_sl', 'Pbat_sl', 'npk_sl', ...
                              'Pmax_ref', 'Pbat_ref', 'npk_ref'};
C.dPmax_pct = 100 * (C.Pmax_sl ./ C.Pmax_ref - 1);
C.dPbat_pct = 100 * (C.Pbat_sl ./ C.Pbat_ref - 1);
writetable(C, fullfile(cfg.resdir, 'compare_simulink_vs_ref.csv'));

names = unique(C.ca, 'stable');
fprintf('\n== Simulink so với tham chiếu (ngưỡng %.1f %%)\n', tol_pct);
fprintf('%-11s %10s %10s %8s  %-14s %-14s\n', 'Ca', 'max|dPmax|', 'max|dPbat|', 'số đỉnh', 'best Simulink', 'best tham chiếu');
allok = true;
for k = 1:numel(names)
    r = C(strcmp(C.ca, names{k}), :);
    eP = max(abs(r.dPmax_pct));  eB = max(abs(r.dPbat_pct));
    bs = r.Pmax_sl  >= max(r.Pmax_sl)  - 0.2;      % tập trạng thái "tốt nhất" (tính cả hòa)
    br = r.Pmax_ref >= max(r.Pmax_ref) - 0.2;
    same = any(bs & br);
    npk_ok = all(r.npk_sl == r.npk_ref);
    ok = eP <= tol_pct && eB <= tol_pct && same;
    allok = allok && ok;
    fprintf('%-11s %9.2f%% %9.2f%% %8s  %-14s %-14s %s\n', names{k}, eP, eB, tf(npk_ok, 'khớp', 'khác'), ...
        best_label(r, 'Pmax_sl'), best_label(r, 'Pmax_ref'), tf(ok, 'ĐẠT', '<-- LỆCH'));
end
fprintf('%s\nChi tiết: results/compare_simulink_vs_ref.csv\n', tf(allok, 'TẤT CẢ ĐẠT', 'CÓ CA LỆCH'));
end

function s = best_label(r, col)
[~, i] = max(r.(col));
s = r.label{i};
end

function s = tf(c, a, b)
if c, s = a; else, s = b; end
end
