function run_module_tests()
%RUN_MODULE_TESTS  Ca thử PV-01..04 cho mô hình 1 tấm (in số liệu ra màn hình).
%   PV-01: STC, so với thông số datasheet giả thiết.
%   PV-02: thay đổi bức xạ 400/700/1000 W/m^2 ở 25 °C.
%   PV-03: thay đổi nhiệt độ 25/45/60 °C ở 1000 W/m^2.
%   PV-04: diode bypass kẹp điện áp âm khi tấm bị ép dòng.

p = pv_module_params();
fprintf('\n== Tham số một diode (n = %.2f, Ns = %d)\n', p.n, p.Ns);
fprintf('   Iph = %.4f A, I0 = %.3e A, Rs = %.4f ohm, Rsh = %.2f ohm\n', p.Iph, p.I0, p.Rs, p.Rsh);

v = linspace(0, 8, 4001);
fprintf('\n== PV-01  STC (1000 W/m^2, 25 °C)\n');
show(v, 1000, 25, p);
fprintf('   Datasheet  Isc = %.3f  Voc = %.3f  Vmp = %.3f  Imp = %.3f  Pmax = %.3f\n', ...
    p.Isc, p.Voc, p.Vmp, p.Imp, p.Vmp*p.Imp);

fprintf('\n== PV-02  bức xạ (25 °C)\n');
for G = [400 700 1000], show(v, G, 25, p); end

fprintf('\n== PV-03  nhiệt độ (1000 W/m^2)\n');
for T = [25 45 60], show(v, 1000, T, p); end

fprintf('\n== PV-04  tấm bị che 300 W/m^2 bị ép dòng 2,5 A của chuỗi\n');
vb = fzero(@(x) pv_module_current(x, 300, 25, p) - 2.5, [-2, 0]);
fprintf('   Điện áp tấm = %.3f V (diode bypass dẫn, kỳ vọng khoảng -0,4 .. -0,7 V)\n', vb);
end

function show(v, G, T, p)
I = pv_module_current(v, G, T, p);  P = v .* I;
[Pm, k] = max(P);
Voc = interp1(I(end:-1:1), v(end:-1:1), 0);
fprintf('   G = %4d  T = %2d   Isc = %.3f  Voc = %.3f  Vmp = %.3f  Imp = %.3f  Pmax = %6.3f\n', ...
    G, T, I(1), Voc, v(k), I(k), Pm);
end
