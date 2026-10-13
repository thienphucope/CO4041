function sl_add_sweep(cfg, pm, mdl, hpos, hneg, xy)
%SL_ADD_SWEEP  Nguồn quét: Ramp (Vmin -> Vmax trong 1 s) -> CVS giữa hpos và hneg;
%   đất và Solver Configuration nối ở hneg. Đo bằng Simscape log của block CVS (v, i).
x = xy(1);  y = xy(2);
add_block('simulink/Sources/Ramp', [mdl '/Ramp'], 'slope', 'Vmax-Vmin', 'start', '0', ...
    'InitialOutput', 'Vmin', 'Position', [x + 160, y - 100, x + 190, y - 70]);
sps = sl_add(cfg, 'sps', [mdl '/V_to_PS'], [x + 160, y - 40, x + 190, y - 16]);
sl_set(sps, 'signal unit|^\s*Unit', 'V');
add_line(mdl, 'Ramp/1', 'V_to_PS/1', 'autorouting', 'on');
cvs = sl_add(cfg, 'cvs', [mdl '/CVS'], [x + 60, y + 20, x + 110, y + 80]);
hc = sl_conn(cvs);
sl_line(mdl, sl_conn(sps), hc(pm.cvs_ctrl));
sl_line(mdl, hc(pm.cvs_p), hpos);
sl_line(mdl, hc(pm.cvs_n), hneg);
gnd = sl_add(cfg, 'gnd', [mdl '/GND'], [x + 70, y + 140, x + 100, y + 170]);
scf = sl_add(cfg, 'solvercfg', [mdl '/SolverCfg'], [x - 60, y + 140, x, y + 170]);
sl_line(mdl, sl_conn(gnd), hneg);
sl_line(mdl, sl_conn(scf), hneg);
end
