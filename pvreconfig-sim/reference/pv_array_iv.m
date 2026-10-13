function [I, Vpanel] = pv_array_iv(V, G, S, p, T)
%PV_ARRAY_IV  Đường I-V của dàn 3x3 với 4 công tắc nối chéo S1..S4.
%   [I, Vpanel] = pv_array_iv(V, G, S, p, T)
%   V      : vector điện áp đầu ra dàn cần tính [V], nên tăng dần (dùng nghiệm trước làm điểm đầu)
%   G      : ma trận bức xạ 3x3 [W/m^2], G(r,c) = hàng r (1 = trên cùng), cột c
%   S      : [S1 S2 S3 S4] (0 = mở, 1 = đóng)
%              S1: nút1 cột1-cột2   S2: nút1 cột2-cột3
%              S3: nút2 cột1-cột2   S4: nút2 cột2-cột3
%            [0 0 0 0] = SP, [1 1 1 1] = TCT
%   p      : struct từ pv_module_params
%   T      : nhiệt độ cell [°C], vô hướng hoặc 3x3 (mặc định 25)
%   I      : dòng đầu ra dàn tại từng V [A] (dương = dàn phát)
%   Vpanel : 3x3xnumel(V) điện áp từng tấm (để xem tấm nào đang bị bypass)
%
%   Mỗi cột luôn là 3 tấm nối tiếp. Công tắc đóng được coi là lý tưởng (gộp nút).
%   Giải KCL tại các nút trung gian bằng Newton, có giới hạn bước.

if nargin < 5, T = 25; end
if isscalar(T), T = T * ones(3); end
V = V(:);  S = logical(S(:).');

% --- Đánh số nút: 0 = bus -, -1 = bus +, nút trung gian n(l,c) với l = 1,2
% Gộp nút theo công tắc (union-find đơn giản trên 6 nút).
id = reshape(1:6, 2, 3);                  % id(l,c)
parent = 1:6;
pairs = [id(1,1) id(1,2); id(1,2) id(1,3); id(2,1) id(2,2); id(2,2) id(2,3)];
for k = 1:4
    if S(k)
        ra = root(parent, pairs(k,1));  rb = root(parent, pairs(k,2));
        parent(max(ra,rb)) = min(ra,rb);
    end
end
r6 = arrayfun(@(i) root(parent, i), 1:6);
[~, ~, unk] = unique(r6);                 % chỉ số ẩn cho từng nút trung gian
nU = max(unk);

% Tấm (r,c): cực + nối nút trên, cực - nối nút dưới. Mã nút: 0 = bus-, -1 = bus+, k>0 = ẩn k
plusN = zeros(3);  minusN = zeros(3);
for c = 1:3
    plusN(1,c) = -1;              minusN(1,c) = unk(id(1,c));
    plusN(2,c) = unk(id(1,c));    minusN(2,c) = unk(id(2,c));
    plusN(3,c) = unk(id(2,c));    minusN(3,c) = 0;
end
plusN = plusN(:);  minusN = minusN(:);  Gv = G(:);  Tv = T(:);

% Ma trận liên thuộc: A(u,k) = +1 nếu tấm k cấp dòng vào nút u (cực + tại u), -1 nếu rút ra.
A = zeros(nU, 9);
for k = 1:9
    if plusN(k)  > 0, A(plusN(k),  k) = A(plusN(k),  k) + 1; end
    if minusN(k) > 0, A(minusN(k), k) = A(minusN(k), k) - 1; end
end
top = (plusN == -1);

% Điểm đầu: chia đều theo hàng
x = zeros(nU, 1);
I = zeros(numel(V), 1);
Vpanel = zeros(3, 3, numel(V));
for iv = 1:numel(V)
    Vo = V(iv);
    if iv == 1
        for u = 1:nU
            rows = [find(plusN == u); find(minusN == u)];
            x(u) = Vo * (1 - mean(mod(rows - 1, 3) + 1) / 3 + 1/6);
        end
    end
    for it = 1:200
        [vk, J] = panel_volt(x, Vo, plusN, minusN);
        [Id, dId] = pv_module_current(vk, Gv, Tv, p);
        F = A * Id;
        Jac = A * diag(dId) * J;
        dx = -Jac \ F;
        m = max(abs(dx));
        if m > 0.3, dx = dx * 0.3 / m; end       % giới hạn bước 0,3 V
        x = x + dx;
        if m < 1e-9, break; end
    end
    vk = panel_volt(x, Vo, plusN, minusN);
    Id = pv_module_current(vk, Gv, Tv, p);
    I(iv) = sum(Id(top));
    Vpanel(:, :, iv) = reshape(vk, 3, 3);
end
end

% ------------------------------------------------------------------------
function [vk, J] = panel_volt(x, Vo, plusN, minusN)
% Điện áp từng tấm và Jacobian d(vk)/dx.
nU = numel(x);
vk = node_v(x, Vo, plusN) - node_v(x, Vo, minusN);
J = zeros(9, nU);
for k = 1:9
    if plusN(k)  > 0, J(k, plusN(k))  = J(k, plusN(k))  + 1; end
    if minusN(k) > 0, J(k, minusN(k)) = J(k, minusN(k)) - 1; end
end
end

function v = node_v(x, Vo, n)
v = zeros(size(n));
v(n == -1) = Vo;
v(n > 0) = x(n(n > 0));
end

function r = root(parent, i)
while parent(i) ~= i, i = parent(i); end
r = i;
end
