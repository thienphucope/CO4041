%VERIFY_SP  Kiểm tra độc lập solver mạng bằng cách ghép nối tiếp/song song trực tiếp.
%   SP : mỗi chuỗi cùng dòng -> V_chuoi(I) = tổng V_tấm(I); 3 chuỗi cùng áp -> cộng dòng.
%   TCT: mỗi hàng cùng áp -> I_hàng(V) = tổng I_tấm(V); 3 hàng cùng dòng -> cộng áp.
%   So với pv_array_iv; sai lệch phải rất nhỏ (chỉ do nội suy).

p = pv_module_params();
cases = pv_shading_cases();
V = (0:0.05:21.5)';                       % vùng phát công suất (dưới Voc dàn)
vgrid = linspace(-1.2, 8, 6000)';         % bảng I-V từng tấm (có vùng bypass)
worst = 0;

for k = 1:numel(cases)
    G = cases(k).G;
    % Bảng I(v) từng tấm; I giảm đơn điệu theo v nên đảo được thành v(I).
    Itab = zeros(numel(vgrid), 9);
    for j = 1:9, Itab(:, j) = pv_module_current(vgrid, G(j), 25, p); end

    % --- SP
    Iq = linspace(-3, 3.5, 8000)';          % dòng chuỗi: từ âm (V > Voc) tới hơn Isc
    Isp = zeros(size(V));
    for c = 1:3
        Vs = zeros(size(Iq));
        for r = 1:3
            j = sub2ind([3 3], r, c);
            Vs = Vs + interp1(flipud(Itab(:, j)), flipud(vgrid), Iq, 'linear', 'extrap');
        end
        Isp = Isp + interp1(flipud(Vs), flipud(Iq), V, 'linear', 'extrap');
    end
    Inet = pv_array_iv(V, G, [0 0 0 0], p);
    e_sp = max(abs(Inet - Isp));

    % --- TCT
    Iq2 = linspace(-9, 10.5, 12000)';        % dòng dàn TCT
    Vt = zeros(size(Iq2));
    for r = 1:3
        Ir = zeros(size(vgrid));
        for c = 1:3, Ir = Ir + Itab(:, sub2ind([3 3], r, c)); end
        Vt = Vt + interp1(flipud(Ir), flipud(vgrid), Iq2, 'linear', 'extrap');
    end
    Itct = interp1(flipud(Vt), flipud(Iq2), V, 'linear', 'extrap');
    Inet2 = pv_array_iv(V, G, [1 1 1 1], p);
    e_tct = max(abs(Inet2 - Itct));

    fprintf('%-11s  max|dI| SP = %.2e A   TCT = %.2e A\n', cases(k).name, e_sp, e_tct);
    worst = max([worst, e_sp, e_tct]);
end
if worst < 5e-3
    fprintf('VERIFY_SP: OK (sai lệch lớn nhất %.2e A)\n', worst);
else
    fprintf('VERIFY_SP: LỆCH (sai lệch lớn nhất %.2e A) -> kiểm tra solver\n', worst);
end
