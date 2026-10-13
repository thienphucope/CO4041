function sl_build_des(cfg, pm)
%SL_BUILD_DES  Mức 4: models/pv3x3_des.slx - ma trận chuyển mạch DES (Ref 3), 54 công tắc.
%   Bốn nút hàng N0 (bus +), N1, N2, N3 (bus -); hàng r nằm giữa N(r-1) và N(r).
%   Tấm j có 6 công tắc: U(j,r) nối cực + với N(r-1), L(j,r) nối cực - với N(r), r = 1..3.
%   Tấm j thuộc hàng R(j) <=> U(j,R(j)) và L(j,R(j)) đóng, các công tắc khác của tấm mở.
%   Biến (model workspace): G (3x3), R (3x3, chỉ số hàng 1..3 của từng tấm), T, Vmin, Vmax.
%   R(j) theo chỉ số tuyến tính (thứ tự cột), trùng bit j trong des_partitions.
%   Mỗi hàng phải có ít nhất 1 tấm. Nguồn quét giống pv3x3.
if nargin < 1, cfg = sl_config(); end
if nargin < 2, pm = sl_calibrate_ports(); end
mdl = cfg.mdl_des;
vars = struct('G', 1000*ones(3), 'R', repmat((1:3)', 1, 3), 'T', cfg.T, 'Vmin', 0, 'Vmax', cfg.Vmax_array);
sl_new_model(mdl, cfg, vars);

dx = 420;  dy = 260;  x0 = 250;  y0 = 80;
anchor = zeros(1, 4);                      % handle đại diện cho nút N0..N3
for j = 1:9
    [r0, c0] = ind2sub([3 3], j);
    name = sprintf('PV%d%d', r0, c0);
    px = x0 + (c0-1)*dx;  py = y0 + (r0-1)*dy;
    pos = [px, py, px + 80, py + 80];
    if j == 1
        sl_make_pv(cfg, pm, [mdl '/' name], pos);
    else
        add_block([mdl '/PV11'], [mdl '/' name], 'Position', pos);
    end
    g = sprintf('G%d%d', r0, c0);
    add_block('simulink/Sources/Constant', [mdl '/' g], 'Value', sprintf('G(%d,%d)', r0, c0), ...
        'Position', [px - 110, py + 25, px - 50, py + 55]);
    add_line(mdl, [g '/1'], [name '/1'], 'autorouting', 'on');
    h = sl_conn([mdl '/' name]);
    for r = 1:3
        for side = 1:2                     % 1 = U (cực + -> N(r-1)), 2 = L (cực - -> N(r))
            ul = 'UL';
            tag = sprintf('%s%d_r%d', ul(side), j, r);
            sx = px + 120 + (side-1)*120;  sy = py + (r-1)*80;
            sw = sl_add(cfg, 'sw', [mdl '/' tag], [sx, sy, sx + 40, sy + 30]);
            sl_set(sw, 'Closed resistance', cfg.R_closed, 'Ohm');
            sl_set(sw, 'Open conductance', cfg.G_open, '1/Ohm');
            sl_set(sw, 'Threshold', 0.5, '', true);
            cmd = sl_add(cfg, 'psconst', [mdl '/' tag '_cmd'], [sx, sy - 25, sx + 40, sy - 5]);
            sl_set(cmd, '^\s*Constant', sprintf('double(R(%d)==%d)', j, r), '1');
            hs = sl_conn(sw);
            sl_line(mdl, sl_conn(cmd), hs(pm.sw_ctrl));
            sl_line(mdl, hs(pm.sw_e(1)), h(side));     % h(1) = cực +, h(2) = cực -
            nidx = r + side - 1;                       % U: N(r-1) -> chỉ số r; L: N(r) -> r+1
            if anchor(nidx) == 0
                anchor(nidx) = hs(pm.sw_e(2));
            else
                sl_line(mdl, hs(pm.sw_e(2)), anchor(nidx));
            end
        end
    end
end
sl_add_sweep(cfg, pm, mdl, anchor(1), anchor(4), [x0 + 3*dx, y0 + dy]);
sl_save_model(cfg, mdl);
end
