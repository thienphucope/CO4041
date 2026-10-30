function R = run_sensitivity()
%RUN_SENSITIVITY  Độ nhạy của kết quả tại 13 V (bộ sạc PWM) theo Voc tấm và nhiệt độ tấm.
%   Voc của tấm TEKI 6 V / 15 W là GIẢ THIẾT (1,2 x Vmp = 7,2 V, xem pv_module_params). Ở 13 V,
%   cột SP có 1 tấm bị che chỉ chạy được dòng đầy khi 2 tấm sáng gánh đủ 13 V + sụt áp diode bypass
%   (~0,55 V), tức mỗi tấm ~6,8 V: rất sát Voc. Vì vậy Voc thật và nhiệt độ quyết định SP thắng hay thua.
%   Quét Voc = 7,2 .. 8,1 V (Vmp, Imp, Isc giữ nguyên) x {25 °C, NOCT}; mỗi ô là P@13V [W] của
%   SP, TCT, BL, HC, DES 3-3-3 tốt nhất, DES tự do tốt nhất.
%   Ghi results/sensitivity_voc.csv.
root = setup_path();
Vbat = 13;
V = (0:0.1:26)';
vocs = [7.2 7.5 7.8 8.1];         % Voc < 7,2 V không khớp được với n = 1,3
ths = {pv_thermal('stc'), pv_thermal('noct')};
cases = pv_shading_cases();
D = des_partitions();
named = {'SP', 0; 'TCT', 15; 'BL', 9; 'HC', 6};
states = pv_states();

rows = {};
t0 = tic;
for iv = 1:numel(vocs)
    try
        p = pv_module_params(struct('Voc', vocs(iv)));
    catch err
        fprintf('Voc = %.1f V: bỏ qua (%s)\n', vocs(iv), err.message);
        continue;
    end
    for it = 1:numel(ths)
        th = ths{it};
        for k = 1:numel(cases)
            G = cases(k).G;  T = th.T(G);
            Pb = zeros(1, 4);
            for q = 1:4
                I = pv_array_iv(V, G, states(named{q, 2} + 1, :), p, T);
                m = pv_metrics(V, I, Vbat);
                Pb(q) = m.Pbat;
            end
            [~, Pd] = pv_des_eval(pv_des_subsets(G, p, T), D.M, Vbat);
            rows(end+1, :) = {vocs(iv), th.name, cases(k).name, Pb(1), Pb(2), Pb(3), Pb(4), ...
                max(Pd(D.eq)), max(Pd)}; %#ok<AGROW>
        end
    end
end
fprintf('Đã quét %d tổ hợp trong %.0f s\n', size(rows, 1), toc(t0));

fid = fopen(fullfile(root, 'results', 'sensitivity_voc.csv'), 'w');
fprintf(fid, 'Voc_V,thermal,case,SP,TCT,BL,HC,des_eq,des_all\n');
for k = 1:size(rows, 1)
    fprintf(fid, '%.2f,%s,%s,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n', rows{k, :});
end
fclose(fid);

% Tóm tắt: ở mỗi Voc, SP có thắng 4 công tắc ở ca nào không, và DES hơn SP bao nhiêu (trung bình 9 ca)
fprintf('\n== P@13V: SP so với nối chéo / DES theo Voc tấm\n');
fprintf('%-6s %-5s | %-28s | %10s %10s\n', 'Voc', 'nhiệt', 'ca SP cao nhất 4 công tắc', 'TB 4ct/SP', 'TB DES/SP');
for iv = 1:numel(vocs)
    for it = 1:numel(ths)
        sel = cell2mat(rows(:, 1)) == vocs(iv) & strcmp(rows(:, 2), ths{it}.name);
        if ~any(sel), continue; end
        r = rows(sel, :);
        sp = cell2mat(r(:, 4));  t4 = max(cell2mat(r(:, 5:7)), [], 2);  ds = cell2mat(r(:, 9));
        win = r(sp > t4 + 0.05, 3);
        fprintf('%-6.1f %-5s | %-28s | %+9.1f%% %+9.1f%%\n', vocs(iv), ths{it}.name, strjoin(win', ' '), ...
            100 * mean(max(sp, t4) ./ sp - 1), 100 * mean(ds ./ sp - 1));
    end
end
fprintf('Đã ghi results/sensitivity_voc.csv\n');
R = rows;
end
