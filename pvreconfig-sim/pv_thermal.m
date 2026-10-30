function th = pv_thermal(name)
%PV_THERMAL  Kịch bản nhiệt độ tấm cho các lần chạy mức 1, 1b, 2, 4.
%   th = pv_thermal('stc')    25 °C mọi tấm: điều kiện chuẩn, như các bảng trước 30/10/2026
%   th = pv_thermal('noct')   ngoài trời, mô hình NOCT: T = Tamb + G/800 * (NOCT - 20)
%                             Tamb = 30 °C, NOCT = 45 °C (giả thiết, tấm mono thường 42-47 °C)
%                             -> tấm nắng 1000 W/m² khoảng 61 °C, tấm bị che 300 W/m² khoảng 39 °C
%   th.T(G)   nhiệt độ từng tấm [°C] cho ca che tĩnh (bóng đứng yên đủ lâu để tấm nguội)
%   th.Tmove  nhiệt độ cho bóng di chuyển (mức 2): bóng qua trong vài chục giây, ngắn hơn hằng số
%             thời gian nhiệt của tấm (vài phút), nên mọi tấm giữ nhiệt độ lúc nắng đủ
%   th.suffix hậu tố tên file kết quả: '' (stc) hoặc '_noct'
if nargin < 1, name = 'stc'; end
th.name = name;
switch name
    case 'stc'
        th.Tamb = 25;  th.NOCT = NaN;
        th.T = @(G) 25 * ones(size(G));
        th.Tmove = 25;
        th.suffix = '';
        th.desc = '25 °C mọi tấm';
    case 'noct'
        th.Tamb = 30;  th.NOCT = 45;
        th.T = @(G) th.Tamb + G / 800 * (th.NOCT - 20);
        th.Tmove = th.Tamb + 1000 / 800 * (th.NOCT - 20);
        th.suffix = '_noct';
        th.desc = sprintf('ngoài trời %g °C, NOCT %g °C', th.Tamb, th.NOCT);
    otherwise
        error('pv_thermal: không có kịch bản "%s" (dùng stc | noct)', name);
end
end
