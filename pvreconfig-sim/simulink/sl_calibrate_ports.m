function pm = sl_calibrate_ports(force)
%SL_CALIBRATE_PORTS  Dò thứ tự cổng của các block Simscape dùng trong model, lưu models/portmap.mat.
%   pm = sl_calibrate_ports()        dùng file đã lưu nếu có
%   pm = sl_calibrate_ports(true)    dò lại (vd sau khi đổi phiên bản MATLAB)
%
%   PortHandles chỉ cho [LConn RConn], không cho biết cổng nào là +, -, hay tín hiệu PS.
%   Hàm này dựng các mạch thử nhỏ và chọn cách nối cho kết quả đúng vật lý:
%     Solar Cell + Diode : cổng nào là Ir, và diode nối chiều nào thì là bypass (hở mạch ra ~7,2 V)
%     Switch, CVS        : cổng nào là cổng điều khiển PS (nối sai miền thì model không biên dịch)
%   Chiều + / - tổng thể (tấm so với nguồn quét) được chốt sau trong sl_build_model.
%
%   pm.sc_ir, pm.sc_a, pm.sc_b : chỉ số cổng Solar Cell (Ir, cực "+" tạm, cực "-" tạm)
%   pm.d_a, pm.d_b             : cổng diode nối vào sc_a, sc_b
%   pm.sw_ctrl, pm.sw_e        : cổng điều khiển và 2 cổng điện của Switch
%   pm.cvs_ctrl, pm.cvs_p, pm.cvs_n : cổng của Controlled Voltage Source (p nối bus "+")

if nargin < 1, force = false; end
cfg = sl_config();
if ~force && exist(cfg.portmap, 'file')
    s = load(cfg.portmap);
    pm = s.pm;
    return;
end
if ~exist(cfg.modeldir, 'dir'), mkdir(cfg.modeldir); end
fprintf('== Dò thứ tự cổng block Simscape (chạy một lần)\n');
pm = struct();

% --- 1. Solar Cell + diode bypass
found = false;
for ir = 1:3
    e = setdiff(1:3, ir);
    for dd = {[1 2], [2 1]}
        d = dd{1};
        [ok, info] = test_solar(cfg, ir, e, d);
        fprintf('   Solar Cell: Ir = cổng %d, diode [%d %d] -> %s\n', ir, d, info);
        if ok
            pm.sc_ir = ir;  pm.sc_a = e(1);  pm.sc_b = e(2);
            pm.d_a = d(1);  pm.d_b = d(2);
            found = true;
            break;
        end
    end
    if found, break; end
end
if ~found
    error('sl_calibrate_ports:solar', ['Không tìm được cách nối Solar Cell + diode cho hở mạch ~7,2 V.\n' ...
        'Kiểm tra tham số Solar Cell (sl_conf_solar) bằng tay trên một model nhỏ.']);
end

% --- 2. Switch: cổng điều khiển
pm.sw_ctrl = find_ctrl(cfg, 'sw', '1');
pm.sw_e = setdiff(1:3, pm.sw_ctrl);

% --- 3. Controlled Voltage Source: cổng điều khiển
pm.cvs_ctrl = find_ctrl(cfg, 'cvs', 'V');
e = setdiff(1:3, pm.cvs_ctrl);
pm.cvs_p = e(1);  pm.cvs_n = e(2);        % chiều tạm; sl_build_model kiểm tra và đảo nếu cần
pm.polarity_checked = false;
pm.matlab = version;

save(cfg.portmap, 'pm');
fprintf('   Đã lưu %s\n', cfg.portmap);
end

% ========================================================================
function [ok, info] = test_solar(cfg, ir, e, d)
% Tấm hở mạch ở 1000 W/m^2: đúng thì điện áp Solar Cell ~7,2 V;
% diode nối sai chiều thì bị kẹp ~0,57 V; Ir nối sai cổng thì không biên dịch.
mdl = 'sl_portcal';
ok = false;
try
    sl_new_model(mdl, cfg, struct('T', 25));
    set_param(mdl, 'StopTime', '0.01');
    sc  = sl_add(cfg, 'solar', [mdl '/SC'], [200 50 260 130]);   sl_conf_solar(sc);
    dio = sl_add(cfg, 'diode', [mdl '/D'], [200 200 260 240]);   sl_conf_diode(dio);
    irr = sl_add(cfg, 'psconst', [mdl '/Ir'], [60 60 100 90]);
    sl_set(irr, '^\s*Constant', 1000, 'W/m^2');
    gnd = sl_add(cfg, 'gnd', [mdl '/GND'], [320 260 350 290]);
    scf = sl_add(cfg, 'solvercfg', [mdl '/SolverCfg'], [60 260 120 290]);
    hs = sl_conn(sc);  hd = sl_conn(dio);
    sl_line(mdl, sl_conn(irr), hs(ir));
    sl_line(mdl, hd(d(1)), hs(e(1)));
    sl_line(mdl, hd(d(2)), hs(e(2)));
    sl_line(mdl, sl_conn(gnd), hs(e(2)));
    sl_line(mdl, sl_conn(scf), hs(e(2)));
    sl_simlog_on(mdl);
    out = sim(mdl);
    lg = out.simlog;
    try
        v = sl_log_v(lg.SC);
        vend = abs(v(end));
        ok = vend > 6 && vend < 8.5;
        info = sprintf('V_SC = %.3f V', vend);
    catch
        i = lg.D.i.series.values('A');       % dự phòng: dòng diode ~0 khi đúng chiều
        ok = abs(i(end)) < 0.1;
        info = sprintf('I_D = %.3g A', i(end));
    end
catch err
    info = ['không chạy được (' first_line(err.message) ')'];
end
close_model(mdl);
end

function c = find_ctrl(cfg, kind, unit)
% Cổng điều khiển là cổng duy nhất nối được với PS Constant mà model vẫn biên dịch.
mdl = 'sl_portcal';
c = [];
for k = 1:3
    try
        sl_new_model(mdl, cfg);
        set_param(mdl, 'StopTime', '0.01');
        b = sl_add(cfg, kind, [mdl '/B'], [200 50 260 110]);
        h = sl_conn(b);
        if numel(h) ~= 3
            error('Block %s có %d cổng, script giả định 3.', kind, numel(h));
        end
        cst = sl_add(cfg, 'psconst', [mdl '/C'], [60 60 100 90]);
        sl_set(cst, '^\s*Constant', 1, unit);
        gnd = sl_add(cfg, 'gnd', [mdl '/GND'], [320 200 350 230]);
        scf = sl_add(cfg, 'solvercfg', [mdl '/SolverCfg'], [60 200 120 230]);
        e = setdiff(1:3, k);
        sl_line(mdl, sl_conn(cst), h(k));
        if strcmp(kind, 'cvs')                % nguồn áp cần tải, không chập
            r = sl_add(cfg, 'res', [mdl '/R'], [200 150 260 180]);
            hr = sl_conn(r);
            sl_line(mdl, h(e(1)), hr(1));
            sl_line(mdl, hr(2), h(e(2)));
        else
            sl_line(mdl, h(e(1)), h(e(2)));
        end
        sl_line(mdl, sl_conn(gnd), h(e(2)));
        sl_line(mdl, sl_conn(scf), h(e(2)));
        sim(mdl);
        fprintf('   %s: cổng điều khiển = %d\n', kind, k);
        c = k;
        close_model(mdl);
        return;
    catch
        close_model(mdl);
    end
end
error('sl_calibrate_ports:ctrl', 'Không xác định được cổng điều khiển của block %s.', kind);
end

function close_model(mdl)
if bdIsLoaded(mdl), close_system(mdl, 0); end
end

function s = first_line(s)
s = strtrim(strtok(s, newline));
end
