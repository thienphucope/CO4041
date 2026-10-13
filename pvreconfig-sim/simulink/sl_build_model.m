function sl_build_model(recalibrate)
%SL_BUILD_MODEL  Dựng tự động models/pv1.slx (1 tấm) và models/pv3x3.slx (dàn 3x3 + S1..S4),
%   rồi models/pv3x3_tr.slx (mức 3, quá độ) và models/pv3x3_des.slx (mức 4, DES).
%   sl_build_model()       dùng models/portmap.mat nếu đã có
%   sl_build_model(true)   dò lại thứ tự cổng trước khi dựng
%
%   Mỗi tấm = subsystem PVrc: Solar Cell + diode bypass ngược song song, cổng vào G (W/m^2).
%   Dàn:  + ──┬────────┬────────┬──
%           PV11     PV12     PV13
%             ●──S1────●──S2────●      nút 1
%           PV21     PV22     PV23
%             ●──S3────●──S4────●      nút 2
%           PV31     PV32     PV33
%         − ──┴────────┴────────┴──
%   Nguồn quét: Ramp (Vmin -> Vmax trong 1 s) -> Controlled Voltage Source nối bus +/-.
%   Đo: Simscape log của CVS (v, i). Biến điều khiển (model workspace): G, S, T, Vmin, Vmax.

if nargin < 1, recalibrate = false; end
cfg = sl_config();
pm = sl_calibrate_ports(recalibrate);

for attempt = 1:2
    build_module(cfg, pm);
    build_array(cfg, pm);
    if pm.polarity_checked, break; end
    if check_polarity(cfg)
        pm.polarity_checked = true;
        save(cfg.portmap, 'pm');
        fprintf('   Chiều nguồn quét so với tấm: đúng\n');
        break;
    end
    if attempt == 2
        error('sl_build_model:polarity', 'Đảo chiều nguồn quét vẫn không ra I-V hợp lý; xem lại pv1.slx bằng tay.');
    end
    fprintf('   Chiều nguồn quét ngược so với tấm -> đảo và dựng lại\n');
    [pm.cvs_p, pm.cvs_n] = deal(pm.cvs_n, pm.cvs_p);
end
sl_build_transient(cfg, pm);
sl_build_des(cfg, pm);
fprintf('== Đã dựng %s, %s, %s, %s (.slx) trong %s\n', cfg.mdl_module, cfg.mdl_array, ...
    cfg.mdl_transient, cfg.mdl_des, cfg.modeldir);
end

% ========================================================================
function build_module(cfg, pm)
mdl = cfg.mdl_module;
vars = struct('G', 1000, 'T', cfg.T, 'Vmin', 0, 'Vmax', cfg.Vmax_module);
sl_new_model(mdl, cfg, vars);
sl_make_pv(cfg, pm, [mdl '/PV'], [300 100 380 180]);
add_block('simulink/Sources/Constant', [mdl '/G'], 'Value', 'G', 'Position', [180 125 230 155]);
add_line(mdl, 'G/1', 'PV/1', 'autorouting', 'on');
h = sl_conn([mdl '/PV']);
sl_add_sweep(cfg, pm, mdl, h(1), h(2), [500 100]);
sl_save_model(cfg, mdl);
end

function build_array(cfg, pm)
mdl = cfg.mdl_array;
vars = struct('G', 1000*ones(3), 'S', [0 0 0 0], 'T', cfg.T, 'Vmin', 0, 'Vmax', cfg.Vmax_array);
sl_new_model(mdl, cfg, vars);

dx = 300;  dy = 180;  x0 = 250;  y0 = 80;
hp = zeros(3);  hn = zeros(3);
for r = 1:3
    for c = 1:3
        name = sprintf('PV%d%d', r, c);
        pos = [x0 + (c-1)*dx, y0 + (r-1)*dy, x0 + (c-1)*dx + 80, y0 + (r-1)*dy + 80];
        if r == 1 && c == 1
            sl_make_pv(cfg, pm, [mdl '/' name], pos);
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
for c = 1:3                                % 3 tấm nối tiếp trong mỗi cột (đấu cứng)
    sl_line(mdl, hn(1, c), hp(2, c));
    sl_line(mdl, hn(2, c), hp(3, c));
end
for c = 1:2                                % bus + và bus -
    sl_line(mdl, hp(1, c), hp(1, c+1));
    sl_line(mdl, hn(3, c), hn(3, c+1));
end

% Công tắc nối chéo: S1 nút1 c1-c2, S2 nút1 c2-c3, S3 nút2 c1-c2, S4 nút2 c2-c3
pairs = [1 1; 1 2; 2 1; 2 2];             % [mức nút, cột trái]
for k = 1:4
    l = pairs(k, 1);  c = pairs(k, 2);
    xs = x0 + (c-1)*dx + 160;  ys = y0 + (l-1)*dy + 110;
    sw = sl_add(cfg, 'sw', sprintf('%s/S%d', mdl, k), [xs, ys, xs + 50, ys + 40]);
    sl_set(sw, 'Closed resistance', cfg.R_closed, 'Ohm');
    sl_set(sw, 'Open conductance', cfg.G_open, '1/Ohm');
    sl_set(sw, 'Threshold', 0.5, '', true);
    cmd = sl_add(cfg, 'psconst', sprintf('%s/S%d_cmd', mdl, k), [xs + 5, ys - 50, xs + 45, ys - 25]);
    sl_set(cmd, '^\s*Constant', sprintf('S(%d)', k), '1');
    h = sl_conn(sw);
    sl_line(mdl, sl_conn(cmd), h(pm.sw_ctrl));
    sl_line(mdl, h(pm.sw_e(1)), hn(l, c));
    sl_line(mdl, h(pm.sw_e(2)), hn(l, c+1));
end

sl_add_sweep(cfg, pm, mdl, hp(1, 3), hn(3, 3), [x0 + 3*dx, y0 + dy]);
sl_save_model(cfg, mdl);
end

function ok = check_polarity(cfg)
% Quét 1 tấm từ 0 đến 1 V ở 1000 W/m^2. Đúng chiều: dòng ~Isc (2,75 A).
% Ngược chiều: diode bypass bị phân cực thuận -> dòng rất lớn hoặc solver lỗi.
mdl = cfg.mdl_module;
in = Simulink.SimulationInput(mdl);
in = in.setVariable('Vmax', 1, 'Workspace', mdl);
ok = false;
try
    out = sim(in);
    [~, I, msg] = sl_iv(out);
    ok = isempty(msg) && max(abs(I)) < 4 && min(abs(I)) > 2;
catch
end
end
