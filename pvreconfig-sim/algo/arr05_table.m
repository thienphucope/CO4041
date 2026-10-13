function tab = arr05_table(sc, family, o)
%ARR05_TABLE  Bảng công suất theo thời gian của mọi cấu hình, cho một kịch bản bóng.
%   tab = arr05_table(sc, family, o)
%   family : 'tie' = 16 trạng thái 4 công tắc nối chéo;  'des' = 3025 cách chia hàng DES
%   o.dt_tab [s] (1), o.Vg lưới điện áp, o.Vbat, o.T, o.source 'reference' | 'simulink' (chỉ 'tie')
%   tab.t (K), tab.G (3x3xK), tab.Pmax, tab.Pbat (K x nC), tab.Vg, tab.labels, tab.nC
%   tie: tab.I (nV x nC x K) đường I-V;  des: tab.M (mặt nạ hàng), đường I-V tính khi cần.
%   Kết quả được lưu đệm trong results/cache/.
root = setup_path();
cdir = fullfile(root, 'results', 'cache');
if ~exist(cdir, 'dir'), mkdir(cdir); end
key = sprintf('arr05_%s_%s_%s_dt%g.mat', family, sc.name, o.source, o.dt_tab);
cf = fullfile(cdir, key);
if exist(cf, 'file')
    s = load(cf);  tab = s.tab;
    return;
end

p = pv_module_params();
t = (0:o.dt_tab:sc.Tend)';
K = numel(t);
G = zeros(3, 3, K);
for k = 1:K, G(:, :, k) = sc.Gfun(t(k)); end
tab = struct('family', family, 'scenario', sc.name, 't', t, 'G', G, 'Vg', o.Vg(:), 'Vbat', o.Vbat);
t0 = tic;
switch family
    case 'tie'
        [states, labels] = pv_states();
        nC = 16;
        I = zeros(numel(o.Vg), nC, K);
        if strcmp(o.source, 'simulink')
            vars = struct('G', {}, 'S', {});
            for k = 1:K
                for c = 1:nC, vars(end+1) = struct('G', G(:, :, k), 'S', states(c, :)); end %#ok<AGROW>
            end
            B = sl_sweep_batch('array', vars, o.Vg);
            I = reshape(B.I, numel(o.Vg), nC, K);
        else
            for k = 1:K
                for c = 1:nC
                    I(:, c, k) = pv_array_iv(o.Vg, G(:, :, k), states(c, :), p, o.T);
                end
            end
        end
        Pmax = zeros(K, nC);  Pbat = Pmax;
        for k = 1:K
            for c = 1:nC
                ok = ~isnan(I(:, c, k));
                m = pv_metrics(o.Vg(ok), I(ok, c, k), o.Vbat);
                Pmax(k, c) = m.Pmax;  Pbat(k, c) = m.Pbat;
            end
        end
        tab.I = I;  tab.labels = labels;  tab.states = states;
        tab.start = 1;                                % SP
    case 'des'
        D = des_partitions();
        nC = size(D.M, 1);
        Pmax = zeros(K, nC);  Pbat = Pmax;
        for k = 1:K
            Vsub = pv_des_subsets(G(:, :, k), p, o.T);
            [Pmax(k, :), Pbat(k, :)] = pv_des_eval(Vsub, D.M, o.Vbat);
        end
        tab.M = D.M;  tab.labels = D.label;  tab.eq = D.eq;  tab.D = D;
        tab.start = D.tct;                            % TCT gốc
    otherwise
        error('arr05_table: family không hợp lệ');
end
tab.Pmax = Pmax;  tab.Pbat = Pbat;  tab.nC = nC;  tab.T = o.T;
fprintf('   bảng %s / %s: %d mốc thời gian x %d cấu hình (%.0f s)\n', family, sc.name, K, nC, toc(t0));
save(cf, 'tab');
end
