function R = run_des(th)
%RUN_DES  Mức 4 (tĩnh): DES - đổi nhóm từng tấm giữa 3 hàng TCT (Ref 3), so với 4 công tắc nối chéo.
%   run_des()      25 °C
%   run_des(th)    kịch bản nhiệt khác, vd run_des(pv_thermal('noct'))
%   Với mỗi ca che bóng: Pmax và P(Vbat) của
%     SP, TCT, trạng thái 4 công tắc tốt nhất (từ results/arr_summary<suffix>.csv),
%     DES tốt nhất (280 cách hàng 3 tấm / 3025 cách), và cách chia do thuật toán chọn từ bức xạ:
%     EI nhỏ nhất (3025 / 280 cách) và tham lam (greedy).
%   Ghi results/des_summary<suffix>.csv.
root = setup_path();
if nargin < 1, th = pv_thermal('stc'); end
p = pv_module_params();
cases = pv_shading_cases();
D = des_partitions();
A = read_arr_summary(fullfile(root, 'results', ['arr_summary' th.suffix '.csv']));
Vbat = 13;
meth = {'ei-all', 'ei-eq', 'greedy'};

rows = {};
fprintf('\n== DES (mức 4, tĩnh, %s) - W\n', th.desc);
fprintf('%-11s %-5s %7s %7s %7s %-6s | %7s %7s | %7s %7s %7s\n', 'Ca', 'chỉ', 'SP', 'TCT', '4cttốt', 'trạng', ...
    'DES280', 'DES3025', 'EI-all', 'EI-eq', 'greedy');
for k = 1:numel(cases)
    G = cases(k).G;
    Vsub = pv_des_subsets(G, p, th.T(G));
    [Pm, Pb] = pv_des_eval(Vsub, D.M, Vbat);
    ia = find(strcmp(A.case, cases(k).name));
    sel = zeros(1, numel(meth));
    for q = 1:numel(meth), sel(q) = des_assign(G, D, meth{q}); end
    for metric = {'Pmax', 'Pbat'}
        if strcmp(metric{1}, 'Pmax'), P = Pm; Pt = A.Pmax(ia); else, P = Pb; Pt = A.Pbat(ia); end
        [bt, it] = max(Pt);
        Peq = P;  Peq(~D.eq) = -Inf;
        [be, ie] = max(Peq);
        [ba, iall] = max(P);
        r = {cases(k).name, metric{1}, Pt(1), Pt(16), bt, A.label{ia(it)}, be, D.label{ie}, ba, D.label{iall}, ...
             P(sel(1)), P(sel(2)), P(sel(3)), D.label{sel(1)}};
        rows(end+1, :) = r; %#ok<AGROW>
        fprintf('%-11s %-5s %7.2f %7.2f %7.2f %-6s | %7.2f %7.2f | %7.2f %7.2f %7.2f\n', r{1:6}, be, ba, r{11:13});
    end
end
fprintf('\nDES3025 tốt nhất mỗi ca (theo Pmax):\n');
for k = 1:2:size(rows, 1)
    fprintf('  %-11s %s\n', rows{k, 1}, rows{k, 10});
end

hdr = {'case', 'metric', 'SP', 'TCT', 'best_tie', 'best_tie_state', 'des_best_eq', 'des_best_eq_rows', ...
       'des_best_all', 'des_best_all_rows', 'ei_all', 'ei_eq', 'greedy', 'ei_all_rows'};
fname = ['des_summary' th.suffix '.csv'];
fid = fopen(fullfile(root, 'results', fname), 'w');
fprintf(fid, '%s\n', strjoin(hdr, ','));
for k = 1:size(rows, 1)
    fprintf(fid, '%s,%s,%.4f,%.4f,%.4f,%s,%.4f,%s,%.4f,%s,%.4f,%.4f,%.4f,%s\n', rows{k, :});
end
fclose(fid);
fprintf('Đã ghi results/%s\n', fname);
R = rows;
end
