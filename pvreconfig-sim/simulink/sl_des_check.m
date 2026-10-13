function T = sl_des_check(tol_pct)
%SL_DES_CHECK  Mức 4: kiểm tra model DES Simulink (pv3x3_des) so với mô hình tham chiếu DES.
%   Vài ca che bóng x 2 cách chia hàng (TCT gốc, cách chia tốt nhất theo tham chiếu - có ca
%   hàng không đều). Pmax, P(Vbat) phải lệch <= tol_pct (mặc định 1 %).
%   Ghi results/des_check_simulink.csv.
if nargin < 1, tol_pct = 1; end
cfg = sl_config();
p = pv_module_params();
D = des_partitions();
cs = pv_shading_cases();
names = {'deu', 'mot-tam', 'hang-1', 'goc-2x2', 'ngau-nhien'};
vars = struct('G', {}, 'R', {}, 'T', {}, 'Vmax', {});
ref = [];  lab = {};
for i = 1:numel(names)
    G = cs(strcmp({cs.name}, names{i})).G;
    [Pm, Pb] = pv_des_eval(pv_des_subsets(G, p), D.M, cfg.Vbat);
    [~, ib] = max(Pm);
    sel = unique([D.tct, ib]);        % TCT gốc + cách chia tốt nhất (mot-tam: hàng 4-4-1)
    for c = sel
        vars(end+1) = struct('G', G, 'R', reshape(D.row(c, :), 3, 3), 'T', cfg.T, 'Vmax', cfg.Vmax_array); %#ok<AGROW>
        ref(end+1, :) = [Pm(c), Pb(c)]; %#ok<AGROW>
        lab(end+1, :) = {names{i}, D.label{c}}; %#ok<AGROW>
    end
end
Vg = (0:cfg.dV:cfg.Vmax_array)';
B = sl_sweep_batch('des', vars, Vg);
fprintf('\n== Mức 4: DES Simulink so với tham chiếu (ngưỡng %.1f %%)\n', tol_pct);
fprintf('%-11s %-36s %8s %8s %8s %8s\n', 'Ca', 'cách chia hàng', 'Pmax', 'ref', 'Pbat', 'ref');
rows = {};  allok = true;
for j = 1:numel(vars)
    if ~isempty(B.err{j})
        fprintf('LỖI %s %s: %s\n', lab{j, :}, strtok(B.err{j}, newline));  allok = false;  continue;
    end
    ok = ~isnan(B.I(:, j));
    m = pv_metrics(Vg(ok), B.I(ok, j), cfg.Vbat);
    d = 100 * abs([m.Pmax, m.Pbat] ./ ref(j, :) - 1);
    allok = allok && all(d <= tol_pct);
    fprintf('%-11s %-36s %8.2f %8.2f %8.2f %8.2f %s\n', lab{j, :}, m.Pmax, ref(j, 1), m.Pbat, ref(j, 2), ...
        tern(all(d <= tol_pct), '', '<-- LỆCH'));
    rows(end+1, :) = {lab{j, :}, m.Pmax, ref(j, 1), m.Pbat, ref(j, 2)}; %#ok<AGROW>
end
fid = fopen(fullfile(cfg.resdir, 'des_check_simulink.csv'), 'w');
fprintf(fid, 'case,rows,Pmax_sl,Pmax_ref,Pbat_sl,Pbat_ref\n');
for k = 1:size(rows, 1), fprintf(fid, '%s,%s,%.4f,%.4f,%.4f,%.4f\n', rows{k, :}); end
fclose(fid);
fprintf('%s\n', tern(allok, 'DES Simulink: ĐẠT', 'DES Simulink: CÓ LỆCH'));
T = rows;
end

function s = tern(c, a, b)
if c, s = a; else, s = b; end
end
