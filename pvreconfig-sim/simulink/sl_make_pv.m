function sl_make_pv(cfg, pm, sub, pos, withCap)
%SL_MAKE_PV  Subsystem 1 tấm: Solar Cell + diode bypass ngược song song.
%   Cổng vào Simulink G (W/m^2); cổng điện: trái = "+", phải = "-" (sl_conn(sub) = [+ -]).
%   withCap = true: thêm tụ điện dung tấm (biến Cpv) giữa hai cực, dùng cho mô phỏng quá độ.
if nargin < 5, withCap = false; end
add_block('built-in/Subsystem', sub, 'Position', pos);
add_block('built-in/Inport', [sub '/G'], 'Position', [20 43 50 57]);
sps = sl_add(cfg, 'sps', [sub '/G_to_PS'], [90 38 120 62]);
sl_set(sps, 'signal unit|^\s*Unit', 'W/m^2');
add_line(sub, 'G/1', 'G_to_PS/1');
sc  = sl_add(cfg, 'solar', [sub '/SC'], [180 30 240 110]);
sl_conf_solar(sc);
dio = sl_add(cfg, 'diode', [sub '/D'], [180 160 240 200]);
sl_conf_diode(dio);
pp = sl_add(cfg, 'connport', [sub '/pos'], [320 40 350 60]);
nn = sl_add(cfg, 'connport', [sub '/neg'], [320 120 350 140]);
set_param(pp, 'Port', '1');  set_param(nn, 'Port', '2');
try
    set_param(pp, 'Side', 'Left');  set_param(nn, 'Side', 'Right');
catch
end
hs = sl_conn(sc);  hd = sl_conn(dio);
sl_line(sub, sl_conn(sps), hs(pm.sc_ir));
sl_line(sub, hd(pm.d_a), hs(pm.sc_a));     % diode ngược song song (bypass)
sl_line(sub, hd(pm.d_b), hs(pm.sc_b));
sl_line(sub, sl_conn(pp), hs(pm.sc_a));
sl_line(sub, sl_conn(nn), hs(pm.sc_b));
if withCap
    cp = sl_add(cfg, 'cap', [sub '/Cpv'], [260 160 300 200]);
    sl_set(cp, '^\s*Capacitance', 'Cpv', 'F');
    hc = sl_conn(cp);
    sl_line(sub, hc(1), hs(pm.sc_a));
    sl_line(sub, hc(2), hs(pm.sc_b));
end
end
