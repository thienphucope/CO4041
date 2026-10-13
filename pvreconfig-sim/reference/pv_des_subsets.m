function Vsub = pv_des_subsets(G, p, T, Iq)
%PV_DES_SUBSETS  Điện áp v(I) của mọi nhóm tấm mắc song song (511 tập con khác rỗng của 9 tấm).
%   Vsub = pv_des_subsets(G, p, T, Iq)
%   G   : 3x3 bức xạ [W/m^2];  T : nhiệt độ [°C], vô hướng hoặc 3x3 (mặc định 25)
%   Iq  : vector dòng [A] (mặc định des_current_grid())
%   Vsub(m, :) : điện áp hai đầu nhóm gồm các tấm có bit trong m (m = 1..511), tại dòng Iq.
%   Bit j (1..9) của m ứng với tấm G(j) theo thứ tự cột: G(1,1), G(2,1), G(3,1), G(1,2), ...
%
%   Dùng cho DES (Ref 3): mỗi hàng là một nhóm tấm song song, các hàng nối tiếp,
%   nên điện áp dàn tại dòng I = tổng điện áp 3 hàng tại dòng I (xem pv_des_eval).
if nargin < 3 || isempty(T), T = 25; end
if nargin < 4 || isempty(Iq), Iq = des_current_grid(); end
if isscalar(T), T = T * ones(3); end
vg = unique([linspace(-1.5, -0.3, 300), linspace(-0.3, 8.5, 1500)])';
Ip = zeros(numel(vg), 9);
for j = 1:9
    Ip(:, j) = pv_module_current(vg, G(j), T(j), p);
end
Iq = Iq(:).';
Vsub = zeros(511, numel(Iq));
for m = 1:511
    Ir = sum(Ip(:, bitget(m, 1:9) == 1), 2);   % dòng nhóm, giảm đơn điệu theo v
    Vsub(m, :) = interp1(flipud(Ir), flipud(vg), Iq, 'linear', 'extrap');
end
end
