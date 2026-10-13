function D = des_partitions()
%DES_PARTITIONS  Mọi cách chia 9 tấm vào 3 hàng khác rỗng (thứ tự hàng không quan trọng): 3025 cách.
%   D.M     : 3025 x 3 mặt nạ bit của 3 hàng (bit j = tấm G(j), thứ tự cột của ma trận 3x3)
%   D.row   : 3025 x 9 chỉ số hàng của từng tấm (1..3)
%   D.eq    : true nếu mỗi hàng đúng 3 tấm (280 cách)
%   D.tct   : chỉ số của TCT gốc (hàng r = các tấm hàng r của dàn)
%   D.label : chuỗi mô tả, vd '11 12 13 | 21 22 23 | 31 32 33' (tấm rc = hàng r, cột c của dàn)
%   Ma trận DES theo Ref 3: mỗi tấm nối được vào 3 hàng qua công tắc; dàn luôn là 3 hàng nối tiếp
%   (V_oc ~ 21,6 V, hợp với ST-S1230), số tấm mỗi hàng có thể khác nhau.
n = 9;
rows = zeros(3^8, n);
k = 0;
for code = 0:3^8 - 1
    a = [1, mod(floor(code ./ 3.^(0:7)), 3) + 1];
    ok = true;  mx = 1;
    for j = 2:n                               % chuỗi tăng có hạn (mỗi phân hoạch đếm 1 lần)
        if a(j) > mx + 1, ok = false; break; end
        mx = max(mx, a(j));
    end
    if ok && mx == 3
        k = k + 1;
        rows(k, :) = a;
    end
end
rows = rows(1:k, :);
w = 2.^(0:n-1);
M = zeros(k, 3);
for b = 1:3, M(:, b) = (rows == b) * w'; end
cnt = [sum(rows == 1, 2), sum(rows == 2, 2), sum(rows == 3, 2)];
D.M = M;  D.row = rows;  D.eq = all(cnt == 3, 2);
tm = sort([sum(w([1 4 7])), sum(w([2 5 8])), sum(w([3 6 9]))]);
D.tct = find(all(sort(M, 2) == tm, 2), 1);
names = {'11', '21', '31', '12', '22', '32', '13', '23', '33'};
D.label = cell(k, 1);
for c = 1:k
    parts = cell(1, 3);
    for b = 1:3, parts{b} = strjoin(sort(names(rows(c, :) == b)), ' '); end
    D.label{c} = strjoin(parts, ' | ');
end
end
