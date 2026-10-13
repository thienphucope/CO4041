function sl_conf_diode(blk)
%SL_CONF_DIODE  Diode bypass: mô hình mũ, IS = 1 uA, N = 1,5 (kẹp khoảng -0,55 V ở 2,5 A).
%   Nếu chỉ có diode tuyến tính từng đoạn (Foundation), đặt Vf = 0,55 V để gần đúng.
v = sl_pv_values();
% R2026b+: Diode (ee_lib) có 3 biến thể; mô hình mũ nằm ở biến thể "physical".
try, set_param(blk, 'SourceFile', 'ee.semiconductors.diodes.physical'); catch, end
dp = get_param(blk, 'DialogParameters');
expo = false;
if isfield(dp, 'ModelTypePhysical')
    try
        set_param(blk, 'ModelTypePhysical', 'ee.enum.diode.physicalModelType.exponential');
        expo = true;
    catch
    end
end
if ~expo
    try, expo = ~isempty(sl_set(blk, 'Diode model', 'Exponential', '', true)); catch, end
end
if ~expo
    sl_set(blk, 'Forward voltage', 0.55, 'V');
    sl_set(blk, 'On resistance', 1e-3, 'Ohm', true);
    sl_set(blk, 'Off conductance', 1e-8, '1/Ohm', true);
    warning('sl_conf_diode:pwl', 'Dùng diode tuyến tính từng đoạn; PV-04 và vùng bypass sẽ lệch nhẹ.');
    return;
end
if isfield(dp, 'prmExp')
    set_param(blk, 'prmExp', 'ee.enum.diode.expParam.useIsN');
else
    sl_set(blk, '^\s*Parameteri[sz]ation', 'IS and N|IS, N|useIsN', '', true);
end
sl_set(blk, '^\s*Saturation current', v.Is_bp, 'A');
sl_set(blk, 'Emission coefficient', v.N_bp);
sl_set(blk, 'Ohmic resistance', 1e-4, 'Ohm', true);
sl_set(blk, 'Zero-bias junction capacitance|CJ0', 0, 'F', true);
sl_set(blk, 'simulation temperature', 'T', 'degC', true);
end
