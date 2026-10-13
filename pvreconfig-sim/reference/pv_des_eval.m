function [Pmax, Pbat, Vmpp] = pv_des_eval(Vsub, M, Vbat, Iq)
%PV_DES_EVAL  Pmax, P(Vbat) của nhiều cách chia hàng DES cùng lúc.
%   [Pmax, Pbat, Vmpp] = pv_des_eval(Vsub, M, Vbat, Iq)
%   Vsub : từ pv_des_subsets;  M : nC x 3 mặt nạ bit của 3 hàng (des_partitions)
%   Điện áp dàn V(I) = tổng điện áp 3 hàng tại cùng dòng I (V giảm dần theo I).
if nargin < 4 || isempty(Iq), Iq = des_current_grid(); end
Iq = Iq(:).';
nC = size(M, 1);
Pmax = zeros(nC, 1);  Pbat = zeros(nC, 1);  Vmpp = zeros(nC, 1);
blk = 500;                                   % xử lý theo khối cho đỡ tốn bộ nhớ
for a = 1:blk:nC
    b = min(nC, a + blk - 1);
    Va = Vsub(M(a:b, 1), :) + Vsub(M(a:b, 2), :) + Vsub(M(a:b, 3), :);
    P = Va .* Iq;
    P(Va < 0) = -Inf;
    [Pmax(a:b), k] = max(P, [], 2);
    Vmpp(a:b) = Va(sub2ind(size(Va), (1:b-a+1)', k));
    % P(Vbat): Va giảm theo I -> số điểm có Va > Vbat là chỉ số ngay trước giao điểm
    j = sum(Va > Vbat, 2);
    j = min(max(j, 1), numel(Iq) - 1);
    r = (1:b-a+1)';
    v1 = Va(sub2ind(size(Va), r, j));  v2 = Va(sub2ind(size(Va), r, j + 1));
    w = (v1 - Vbat) ./ (v1 - v2);
    Pbat(a:b) = Vbat * (Iq(j)' + w .* (Iq(j + 1)' - Iq(j)'));
end
end
