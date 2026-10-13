function mode = sl_conf_solar(blk)
%SL_CONF_SOLAR  Đặt tham số block Solar Cell cho tấm 6 V/15 W (khớp mô hình tham chiếu).
%   mode = 'lump': gộp cả tấm vào 1 cell (N = 15,6, Rs, Rp của cả tấm, N_series = 1).
%   Nhiệt độ mô phỏng lấy từ biến T (°C) trong workspace của model.
v = sl_pv_values();
% Mô hình 5 tham số của Simscape bỏ qua Rp (coi Rp = inf) -> dùng mô hình 8 tham số
% với Is2 = 0 (tắt diode thứ hai) để có đủ Rs, Rp như mô hình tham chiếu.
sl_set(blk, 'Parameteri[sz](ation|e by)', 'equivalent circuit.*8|eightParameter');
sl_set(blk, 'saturation current, Is2', 0, 'A', true);
% Dùng 'lump' (gộp cả tấm vào 1 cell, N_series = 1): đúng nguyên phương trình tham chiếu.
sl_set(blk, 'series(-connected)? cells', 1, '', true);
mode = 'lump';  c = v.lump;
sl_set(blk, 'Solar-generated current', v.Iph0, 'A');
sl_set(blk, 'Irradiance used for measurements', v.Ir0, 'W/m^2');
sl_set(blk, 'Diode saturation current', v.Is, 'A');
sl_set(blk, 'Quality factor', c.N);
sl_set(blk, 'Series resistance', c.Rs, 'Ohm');
sl_set(blk, 'Parallel resistance', c.Rp, 'Ohm');
sl_set(blk, 'TIPH1', v.TIPH1, '1/K', true);
sl_set(blk, 'Energy gap', c.EG, 'eV', true);
sl_set(blk, 'TXIS1', c.TXIS1, '', true);
sl_set(blk, 'Measurement temperature', v.Tmeas, 'degC', true);
sl_set(blk, 'simulation temperature', 'T', 'degC', true);
end
