function sl_build_transient(cfg, pm)
%SL_BUILD_TRANSIENT  Mức 3: models/pv3x3_tr.slx - quá độ khi đóng/cắt công tắc nối chéo.
%   Khác pv3x3:
%     - mỗi tấm có tụ Cpv (điện dung tương đương của cell) song song;
%     - công tắc Sk đổi từ Sa(k) sang Sb(k) tại thời điểm tsw(k) (Step), điện trở đóng = Rsw
%       (2 x R_DS(on) của cặp MOSFET đấu ngược);
%     - đầu ra nối pin qua dây: bus+ -> Rline -> Lline -> nguồn áp Vbat -> bus-
%       (tương ứng bộ sạc PWM đang đóng: dàn nối thẳng vào pin).
%   Biến (model workspace): G, Sa, Sb, tsw, Vbat, Rsw, Cpv, Rline, Lline, T, tend.
%   Khởi động từ xác lập (Solver Configuration: Start from steady state).
%   Không mô hình mạch kích cổng, đặc tính chuyển mạch của MOSFET: công tắc đổi tức thời,
%   nên xung dòng tính được là trường hợp xấu nhất về độ dốc.
if nargin < 1, cfg = sl_config(); end
if nargin < 2, pm = sl_calibrate_ports(); end
mdl = cfg.mdl_transient;
vars = struct('G', 1000*ones(3), 'Sa', [0 0 0 0], 'Sb', [1 1 1 1], 'tsw', 0.01*ones(1, 4), ...
    'Vbat', cfg.Vbat, 'Rsw', cfg.tr.Rsw, 'Cpv', cfg.tr.Cpv, 'Rline', cfg.tr.Rline, ...
    'Lline', cfg.tr.Lline, 'T', cfg.T, 'tend', cfg.tr.tend);
sl_new_model(mdl, cfg, vars);
set_param(mdl, 'StopTime', 'tend', 'MaxStep', num2str(cfg.tr.maxstep));

dx = 300;  dy = 180;  x0 = 250;  y0 = 80;
hp = zeros(3);  hn = zeros(3);
for r = 1:3
    for c = 1:3
        name = sprintf('PV%d%d', r, c);
        pos = [x0 + (c-1)*dx, y0 + (r-1)*dy, x0 + (c-1)*dx + 80, y0 + (r-1)*dy + 80];
        if r == 1 && c == 1
            sl_make_pv(cfg, pm, [mdl '/' name], pos, true);
        else
            add_block([mdl '/PV11'], [mdl '/' name], 'Position', pos);
        end
        g = sprintf('G%d%d', r, c);
        add_block('simulink/Sources/Constant', [mdl '/' g], 'Value', sprintf('G(%d,%d)', r, c), ...
            'Position', [pos(1) - 110, pos(2) + 25, pos(1) - 50, pos(2) + 55]);
        add_line(mdl, [g '/1'], [name '/1'], 'autorouting', 'on');
        h = sl_conn([mdl '/' name]);
        hp(r, c) = h(1);  hn(r, c) = h(2);
    end
end
for c = 1:3
    sl_line(mdl, hn(1, c), hp(2, c));
    sl_line(mdl, hn(2, c), hp(3, c));
end
for c = 1:2
    sl_line(mdl, hp(1, c), hp(1, c+1));
    sl_line(mdl, hn(3, c), hn(3, c+1));
end

pairs = [1 1; 1 2; 2 1; 2 2];
for k = 1:4
    l = pairs(k, 1);  c = pairs(k, 2);
    xs = x0 + (c-1)*dx + 160;  ys = y0 + (l-1)*dy + 110;
    sw = sl_add(cfg, 'sw', sprintf('%s/S%d', mdl, k), [xs, ys, xs + 50, ys + 40]);
    sl_set(sw, 'Closed resistance', 'Rsw', 'Ohm');
    sl_set(sw, 'Open conductance', cfg.G_open, '1/Ohm');
    sl_set(sw, 'Threshold', 0.5, '', true);
    st = sprintf('%s/S%d_step', mdl, k);
    add_block('simulink/Sources/Step', st, 'Time', sprintf('tsw(%d)', k), ...
        'Before', sprintf('Sa(%d)', k), 'After', sprintf('Sb(%d)', k), 'SampleTime', '0', ...
        'Position', [xs - 90, ys - 60, xs - 60, ys - 30]);
    sps = sl_add(cfg, 'sps', sprintf('%s/S%d_PS', mdl, k), [xs - 30, ys - 57, xs, ys - 33]);
    sl_set(sps, 'signal unit|^\s*Unit', '1');
    try   % không lọc lệnh đóng/cắt (tên lựa chọn khác nhau giữa các bản)
        sl_set(sps, 'Input handling|Filtering', 'signal only|None|No filter', '', true);
    catch
    end
    add_line(mdl, sprintf('S%d_step/1', k), sprintf('S%d_PS/1', k), 'autorouting', 'on');
    h = sl_conn(sw);
    sl_line(mdl, sl_conn(sps), h(pm.sw_ctrl));
    sl_line(mdl, h(pm.sw_e(1)), hn(l, c));
    sl_line(mdl, h(pm.sw_e(2)), hn(l, c+1));
end

% Đầu ra: bus+ -> Rline -> Lline -> CVS(Vbat) -> bus-
x = x0 + 3*dx;  y = y0 + dy;
rl = sl_add(cfg, 'res', [mdl '/Rline'], [x, y0, x + 40, y0 + 30]);
sl_set(rl, '^\s*Resistance', 'Rline', 'Ohm');
ll = sl_add(cfg, 'ind', [mdl '/Lline'], [x + 80, y0, x + 120, y0 + 30]);
sl_set(ll, '^\s*Inductance', 'Lline', 'H');
hr = sl_conn(rl);  hl = sl_conn(ll);
sl_line(mdl, hp(1, 3), hr(1));
sl_line(mdl, hr(2), hl(1));
add_block('simulink/Sources/Constant', [mdl '/Vbat'], 'Value', 'Vbat', 'Position', [x + 140, y - 60, x + 180, y - 40]);
sps = sl_add(cfg, 'sps', [mdl '/V_to_PS'], [x + 200, y - 62, x + 230, y - 38]);
sl_set(sps, 'signal unit|^\s*Unit', 'V');
add_line(mdl, 'Vbat/1', 'V_to_PS/1', 'autorouting', 'on');
cvs = sl_add(cfg, 'cvs', [mdl '/CVS'], [x + 160, y + 20, x + 210, y + 80]);
hc = sl_conn(cvs);
sl_line(mdl, sl_conn(sps), hc(pm.cvs_ctrl));
sl_line(mdl, hc(pm.cvs_p), hl(2));
sl_line(mdl, hc(pm.cvs_n), hn(3, 3));
gnd = sl_add(cfg, 'gnd', [mdl '/GND'], [x + 170, y + 140, x + 200, y + 170]);
scf = sl_add(cfg, 'solvercfg', [mdl '/SolverCfg'], [x + 40, y + 140, x + 100, y + 170]);
try
    sl_set(scf, 'steady state', 'on', '', true);
catch
    warning('sl_build_transient:dc', 'Không bật được "Start from steady state"; bật tay trong Solver Configuration.');
end
sl_line(mdl, sl_conn(gnd), hn(3, 3));
sl_line(mdl, sl_conn(scf), hn(3, 3));
sl_save_model(cfg, mdl);
end
