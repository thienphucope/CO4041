function S = run_arr05(o)
%RUN_ARR05  Mức 2: bóng di chuyển + thuật toán chọn cấu hình theo thời gian (ARR-05), và DES theo thời gian.
%   S = run_arr05()        mặc định đầy đủ (4 kịch bản x 3 kiểu bộ sạc, 4 công tắc + DES)
%   S = run_arr05(o)       ghi đè tùy chọn, vd o.scenarios = {'canh-ngang'}; o.dt_tab = 2; o.des = false
%   Tùy chọn:
%     o.scenarios  tên kịch bản (shadow_profiles)       o.chargers  {'pwm','mppt','po'}
%     o.dt_tab     bước bảng công suất [s] (1)           o.dt        bước mô phỏng [s] (0.005)
%     o.source     'reference' | 'simulink' (bảng 4 công tắc lấy từ model Simulink)
%     o.des        true: chạy thêm DES (đổi nhóm từng tấm, 3025 cách chia hàng)
%     o.T          nhiệt độ tấm [°C] (25); ngoài trời dùng pv_thermal('noct').Tmove
%     o.suffix     hậu tố tên file kết quả (''), vd '_noct'
%   Ghi results/arr05_summary<suffix>.csv và results/arr05_traces<suffix>.mat (vẽ bằng plot_arr05).
%
%   Thời gian giả định: MOSFET chuyển + ổn định 5 ms, đo 20 ms mỗi cấu hình; relay 20 ms + 100 ms.
%   Bộ sạc P&O: mỗi 0,1 s nhích 0,2 V, bắt đầu ở 17 V.

root = setup_path();
if nargin < 1, o = struct(); end
o = defaults(o, struct('scenarios', {{}}, 'chargers', {{'pwm', 'mppt', 'po'}}, 'dt_tab', 1, ...
    'dt', 0.005, 'source', 'reference', 'des', true, 'Vg', (0:0.1:23.5)', 'Vbat', 13, 'T', 25, 'suffix', ''));
sc = shadow_profiles();
if ~isempty(o.scenarios), sc = shadow_profiles(o.scenarios); end
fprintf('Nhiệt độ tấm: %g °C\n', o.T);

chgdef = struct('pwm', struct('type', 'pwm'), 'mppt', struct('type', 'mppt'), 'po', struct('type', 'po'));
rows = {};
traces = struct('scenario', {}, 'charger', {}, 'alg', {}, 'family', {}, 'trace', {});
for i = 1:numel(sc)
    fprintf('\n== Kịch bản %s: %s\n', sc(i).name, sc(i).desc);
    tabs.tie = arr05_table(sc(i), 'tie', o);
    if o.des
        oo = o;  oo.source = 'reference';
        tabs.des = arr05_table(sc(i), 'des', oo);
    end
    fam = {'tie'};  if o.des, fam{end+1} = 'des'; end %#ok<AGROW>
    for j = 1:numel(o.chargers)
        chg = chgdef.(o.chargers{j});
        chg.Vbat = o.Vbat;  chg.Tpo = 0.1;  chg.dV = 0.2;  chg.V0 = 17;
        Esp = NaN;  Eor = NaN;
        fprintf('\n   bộ sạc %-4s  %-26s %8s %8s %8s %6s %7s\n', o.chargers{j}, 'thuật toán', 'E (Wh)', '% oracle', 'so SP', 'đổi', 'quét');
        for f = 1:numel(fam)
            tab = tabs.(fam{f});
            A = alg_list(fam{f}, tab);
            res = cell(numel(A), 1);
            for a = 1:numel(A)
                res{a} = simulate_algo(tab, A(a), chg, o);
            end
            iorc = find(strcmp({A.type}, 'oracle'), 1);
            if strcmp(fam{f}, 'tie'), Esp = res{1}.E_Wh;  Eor = res{iorc}.E_Wh; end
            Eor_f = res{iorc}.E_Wh;
            for a = 1:numel(A)
                r = res{a};
                pct_or = 100 * r.E_Wh / Eor_f;
                gain = 100 * (r.E_Wh / Esp - 1);
                fprintf('   [%s] %-30s %8.4f %7.1f%% %+7.1f%% %6d %6.1f%%\n', fam{f}, A(a).name, r.E_Wh, pct_or, gain, r.nsw, 100 * r.scan_frac);
                rows(end+1, :) = {sc(i).name, o.chargers{j}, fam{f}, A(a).name, r.E_Wh, r.Pavg, pct_or, gain, ...
                    100 * (r.E_Wh / Eor - 1), r.nsw, 100 * r.scan_frac}; %#ok<AGROW>
                traces(end+1) = struct('scenario', sc(i).name, 'charger', o.chargers{j}, 'alg', A(a).name, ...
                    'family', fam{f}, 'trace', r.trace); %#ok<AGROW>
            end
        end
    end
end

fid = fopen(fullfile(root, 'results', ['arr05_summary' o.suffix '.csv']), 'w');
fprintf(fid, 'scenario,charger,family,algorithm,E_Wh,Pavg_W,pct_of_family_oracle,gain_vs_SP_pct,vs_tie_oracle_pct,n_switch,scan_time_pct\n');
for k = 1:size(rows, 1)
    % tên thuật toán có dấu phẩy nên bọc ngoặc kép
    fprintf(fid, '%s,%s,%s,"%s",%.5f,%.3f,%.2f,%.2f,%.2f,%d,%.2f\n', rows{k, :});
end
fclose(fid);
G = struct();
for i = 1:numel(sc)
    t = (0:0.5:sc(i).Tend)';
    Gt = zeros(3, 3, numel(t));
    for k = 1:numel(t), Gt(:, :, k) = sc(i).Gfun(t(k)); end
    G.(strrep(sc(i).name, '-', '_')) = struct('t', t, 'G', Gt);
end
save(fullfile(root, 'results', ['arr05_traces' o.suffix '.mat']), 'traces', 'G', 'o');
fprintf('\nĐã ghi results/arr05_summary%s.csv, results/arr05_traces%s.mat\n', o.suffix, o.suffix);
S = rows;
end

% ======================================================================
function A = alg_list(family, tab)
mos = struct('settle', 0.005, 'dwell', 0.02);
rel = struct('settle', 0.020, 'dwell', 0.10);
A = struct('name', {}, 'type', {}, 'cfg', {}, 'Tscan', {}, 'settle', {}, 'dwell', {}, 'thr', {}, ...
    'Tmax', {}, 'margin', {}, 'method', {}, 'noise', {}, 'seed', {});
if strcmp(family, 'tie')
    A(end+1) = mk('cố định SP', 'fixed', 1, 0, mos);
    A(end+1) = mk('cố định TCT', 'fixed', 16, 0, mos);
    A(end+1) = mk('oracle (16 trạng thái)', 'oracle', [], 0, mos);
    for T = [2 5 10 30]
        A(end+1) = mk(sprintf('quét 16, %g s, MOSFET', T), 'scan', [], T, mos); %#ok<AGROW>
    end
    A(end+1) = mk('quét 16, 10 s, relay', 'scan', [], 10, rel);
    a = mk('quét khi P đổi 5 %, MOSFET', 'scan-event', [], 0, mos);  a.thr = 0.05;  a.Tmax = 30;
    A(end+1) = a;
    a = mk('leo đồi 4 lân cận, 5 s', 'hill', [], 5, mos);  a.margin = 0.01;
    A(end+1) = a;
else
    A(end+1) = mk('DES cố định TCT', 'fixed', tab.start, 0, mos);
    A(end+1) = mk('DES oracle (3025 cách)', 'oracle', [], 0, mos);
    a = mk('DES EI min 3025, 2 s', 'des-ei', [], 2, mos);  a.method = 'ei-all';  A(end+1) = a;
    a = mk('DES EI min 3025, 2 s, sai số 5%', 'des-ei', [], 2, mos);  a.method = 'ei-all';  a.noise = 0.05;  A(end+1) = a;
    a = mk('DES EI min 280, 2 s', 'des-ei', [], 2, mos);  a.method = 'ei-eq';  A(end+1) = a;
    a = mk('DES tham lam, 2 s', 'des-ei', [], 2, mos);  a.method = 'greedy';  A(end+1) = a;
    a = mk('DES theo mô hình, 2 s, sai số 5%', 'des-model', [], 2, mos);  a.noise = 0.05;  A(end+1) = a;
end
end

function a = mk(name, type, cfg, Tscan, tm)
a = struct('name', name, 'type', type, 'cfg', cfg, 'Tscan', Tscan, 'settle', tm.settle, 'dwell', tm.dwell, ...
    'thr', 0, 'Tmax', Inf, 'margin', 0, 'method', '', 'noise', 0, 'seed', 1);
end

function o = defaults(o, d)
f = fieldnames(d);
for k = 1:numel(f)
    if ~isfield(o, f{k}), o.(f{k}) = d.(f{k}); end
end
end
