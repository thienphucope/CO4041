function r = simulate_algo(tab, alg, chg, o)
%SIMULATE_ALGO  Mô phỏng theo thời gian một thuật toán chọn cấu hình + bộ sạc (ARR-05).
%   r = simulate_algo(tab, alg, chg, o)
%   tab : arr05_table (công suất mọi cấu hình theo thời gian)
%   alg : thuật toán (struct)
%     .type  'fixed'      giữ cấu hình alg.cfg
%            'oracle'     luôn ở cấu hình tốt nhất tức thời, không tốn thời gian quét (cận trên)
%            'scan'       mỗi Tscan giây thử lần lượt mọi cấu hình, giữ cấu hình đo được lớn nhất
%            'scan-event' quét khi công suất đổi quá alg.thr so với sau lần quét trước, hoặc sau Tmax
%            'hill'       mỗi Tscan thử 4 trạng thái lân cận (đảo 1 công tắc); tốt hơn thì chuyển
%                         và thử tiếp từ đó (chỉ cho 'tie')
%            'des-ei'     mỗi Tscan ước lượng bức xạ từng tấm, chia hàng theo alg.method (des_assign)
%            'des-model'  mỗi Tscan ước lượng bức xạ, tính bằng mô hình cách chia cho công suất lớn nhất
%     .Tscan [s], .settle [s] (thời gian công tắc chuyển + ổn định), .dwell [s] (thời gian đo mỗi cấu hình)
%     .thr, .Tmax (scan-event), .margin (hill), .method (des-ei), .noise (sai số ước lượng G, tương đối)
%   chg : bộ sạc
%     .type 'pwm'  dàn bị kẹp ở Vbat -> P = P(Vbat) của cấu hình
%           'mppt' MPPT lý tưởng, luôn ở GMPP -> P = Pmax của cấu hình
%           'po'   MPPT kiểu P&O: mỗi Tpo giây nhích điện áp dV theo hướng công suất tăng
%                  (có thể kẹt ở đỉnh cục bộ, bị nhiễu khi cấu hình đổi)
%     .Vbat, .Tpo, .dV, .V0
%   o.dt : bước thời gian mô phỏng [s]
%   r.E_Wh, r.Pavg, r.nsw (số lần đổi cấu hình), r.scan_frac (tỉ lệ thời gian đang quét), r.trace
%
%   Trong lúc công tắc chuyển (settle), công suất lấy bằng min của cấu hình cũ và mới.
%   Phép đo lấy công suất tức thời ở cuối thời gian dwell (với P&O: tại điện áp đang làm việc).

dt = o.dt;
Tend = tab.t(end);
n = round(Tend / dt);
nC = tab.nC;
isDes = strcmp(tab.family, 'des');
if strcmp(chg.type, 'pwm'), Ptab = tab.Pbat; else, Ptab = tab.Pmax; end
dtt = tab.t(2) - tab.t(1);
K = numel(tab.t);
curves = containers.Map('KeyType', 'double', 'ValueType', 'any');
p = [];
if isDes && strcmp(chg.type, 'po'), p = pv_module_params(); end

% --- trạng thái
c = tab.start;  if strcmp(alg.type, 'fixed'), c = alg.cfg; end
cprev = c;  settle_until = -Inf;
mode = 'hold';  queue = [];  meas = [];  qi = 0;  t_meas = Inf;  chome = c;
next_scan = 0;  t_last_scan = -Inf;  Pref = NaN;  t_scan0 = 0;
Vop = chg.V0;  Pprev = 0;  dirn = 1;  next_po = 0;
E = 0;  nsw = 0;  tscan = 0;  dec = 0;
ntr = round(Tend / 0.1) + 1;
tr = struct('t', zeros(ntr, 1), 'p', zeros(ntr, 1), 'c', zeros(ntr, 1), 'V', zeros(ntr, 1));
itr = 0;

for i = 0:n - 1
    t = i * dt;
    [k, w] = tidx(t);

    % ---------------- quyết định của thuật toán
    switch alg.type
        case 'fixed'
        case 'oracle'
            pv = (1 - w) * Ptab(k, :) + w * Ptab(k + 1, :);
            [pb, cb] = max(pv);
            if cb ~= c && pb > pv(c) * (1 + 1e-6) + 1e-9           % chỉ đổi khi tốt hơn thật
                cprev = cb;  c = cb;  nsw = nsw + 1;                 % lý tưởng: không mất thời gian
            end
        case {'scan', 'scan-event', 'hill'}
            if strcmp(mode, 'hold')
                trig = t >= next_scan;
                if strcmp(alg.type, 'scan-event')
                    pnow = Pdel(c, t, k, w);
                    trig = isnan(Pref) || abs(pnow - Pref) > alg.thr * Pref || t - t_last_scan >= alg.Tmax;
                end
                if trig
                    mode = 'scan';  t_scan0 = t;  chome = c;
                    if strcmp(alg.type, 'hill')
                        queue = [c, neighbors(c)];
                    else
                        queue = [c, setdiff(1:nC, c)];
                    end
                    meas = nan(size(queue));  qi = 1;
                    goto_cfg(queue(1), t);
                end
            end
            if strcmp(mode, 'scan')
                tscan = tscan + dt;
                if t >= t_meas
                    meas(qi) = Pdel(c, t, k, w);
                    qi = qi + 1;
                    if qi <= numel(queue)
                        goto_cfg(queue(qi), t);
                    else
                        [mb, ib] = max(meas);
                        best = queue(ib);
                        if strcmp(alg.type, 'hill') && mb <= meas(1) * (1 + alg.margin)
                            best = chome;
                        end
                        goto_cfg(best, t);
                        t_meas = Inf;
                        mode = 'hold';  t_last_scan = t;  Pref = mb;
                        next_scan = t_scan0 + alg.Tscan;
                        if strcmp(alg.type, 'hill') && best ~= chome
                            next_scan = t;                         % leo tiếp từ cấu hình mới
                        end
                    end
                end
            end
        case {'des-ei', 'des-model'}
            if t >= next_scan
                dec = dec + 1;
                Gt = (1 - w) * tab.G(:, :, k) + w * tab.G(:, :, k + 1);
                Gest = Gt .* (1 + alg.noise * prandn(dec, alg.seed));
                if strcmp(alg.type, 'des-ei')
                    cb = des_assign(Gest, tab.D, alg.method);
                else
                    if isempty(p), p = pv_module_params(); end
                    [Pm, Pb] = pv_des_eval(pv_des_subsets(Gest, p, tab.T), tab.M, tab.Vbat);
                    if strcmp(chg.type, 'pwm'), [~, cb] = max(Pb); else, [~, cb] = max(Pm); end
                end
                goto_cfg(cb, t);
                next_scan = next_scan + alg.Tscan;
            end
        otherwise
            error('simulate_algo: alg.type không hợp lệ: %s', alg.type);
    end

    % ---------------- công suất giao cho bộ sạc
    if t < settle_until
        pw = min(Pdel(cprev, t, k, w), Pdel(c, t, k, w));
    else
        pw = Pdel(c, t, k, w);
    end
    E = E + pw * dt;

    % ---------------- P&O của bộ sạc MPPT
    if strcmp(chg.type, 'po') && t >= next_po
        if pw < Pprev, dirn = -dirn; end
        Pprev = pw;
        Vop = min(max(Vop + dirn * chg.dV, 1), tab.Vg(end) - 0.5);
        next_po = next_po + chg.Tpo;
    end

    if mod(i, round(0.1 / dt)) == 0
        itr = itr + 1;
        tr.t(itr) = t;  tr.p(itr) = pw;  tr.c(itr) = c;  tr.V(itr) = Vop;
    end
end
tr.t = tr.t(1:itr);  tr.p = tr.p(1:itr);  tr.c = tr.c(1:itr);  tr.V = tr.V(1:itr);
r = struct('E_Wh', E / 3600, 'Pavg', E / Tend, 'nsw', nsw, 'scan_frac', tscan / Tend, 'trace', tr);

% ======================================================================
    function [k, w] = tidx(t)
        k = min(floor(t / dtt) + 1, K - 1);
        w = (t - tab.t(k)) / dtt;
    end

    function goto_cfg(cn, t)
        if cn ~= c
            cprev = c;  c = cn;  nsw = nsw + 1;
            settle_until = t + alg.settle;
            t_meas = t + alg.settle + alg.dwell;
        else
            t_meas = t + alg.dwell;
        end
    end

    function pw = Pdel(cc, t, k, w) %#ok<INUSL>
        if ~strcmp(chg.type, 'po')
            pw = (1 - w) * Ptab(k, cc) + w * Ptab(k + 1, cc);
        else
            pw = Vop * ((1 - w) * Icurve(k, cc, Vop) + w * Icurve(k + 1, cc, Vop));
        end
    end

    function I = Icurve(kk, cc, V)
        if ~isDes
            I = interp1(tab.Vg, tab.I(:, cc, kk), V);
            return;
        end
        key = kk * 1e5 + cc;
        if ~isKey(curves, key)
            curves(key) = pv_des_curve(tab.G(:, :, kk), tab.M(cc, :), p, tab.T, tab.Vg);
        end
        I = interp1(tab.Vg, curves(key), V);
    end

    function nb = neighbors(cc)
        s = tab.states(cc, :);
        nb = zeros(1, 4);
        for b = 1:4
            s2 = s;  s2(b) = 1 - s2(b);
            nb(b) = find(all(tab.states == s2, 2));
        end
    end
end

function z = prandn(i, seed)
% Số ngẫu nhiên chuẩn 3x3 tái lập được (không phụ thuộc rng của MATLAB/Octave).
u = mod(sin((1:18) * 12.9898 + i * 78.233 + seed * 3.7) * 43758.5453, 1);
u = min(max(u, 1e-9), 1 - 1e-9);
z = sqrt(-2 * log(u(1:9))) .* cos(2 * pi * u(10:18));
z = reshape(z, 3, 3);
end
