function [c, EI] = des_assign(Gest, D, method)
%DES_ASSIGN  Chọn cách chia hàng DES từ bức xạ ước lượng từng tấm (Ref 3: cân bằng bức xạ hàng).
%   [c, EI] = des_assign(Gest, D, method)
%   Gest   : 3x3 bức xạ ước lượng;  D : des_partitions()
%   method : 'ei-all'    EI nhỏ nhất trên cả 3025 cách (mục tiêu của DP trong Ref 3)
%            'ei-eq'     EI nhỏ nhất trên 280 cách mỗi hàng 3 tấm
%            'greedy'    xếp tấm theo G giảm dần, mỗi tấm vào hàng có tổng nhỏ nhất còn chỗ
%                        (hàng 3 tấm) - đủ nhẹ để chạy trên vi điều khiển
%   EI = max(G_i) - min(G_i), G_i = tổng bức xạ hàng i.
%   Hòa EI thì ưu tiên tổng hàng nhỏ nhất lớn hơn (dòng dàn lớn hơn).
g = Gest(:);
switch method
    case {'ei-all', 'ei-eq'}
        S = zeros(size(D.M));
        for b = 1:3, S(:, b) = sum(bitget(repmat(D.M(:, b), 1, 9), repmat(1:9, size(D.M, 1), 1)) .* g', 2); end
        ei = max(S, [], 2) - min(S, [], 2);
        score = ei - 1e-6 * min(S, [], 2);
        if strcmp(method, 'ei-eq'), score(~D.eq) = Inf; end
        [~, c] = min(score);
        EI = ei(c);
    case 'greedy'
        [~, order] = sort(g, 'descend');
        rsum = zeros(1, 3);  cnt = zeros(1, 3);  row = zeros(1, 9);
        for j = order'
            cand = find(cnt < 3);
            [~, i] = min(rsum(cand));
            b = cand(i);
            row(j) = b;  rsum(b) = rsum(b) + g(j);  cnt(b) = cnt(b) + 1;
        end
        w = 2.^(0:8);
        m = sort([sum(w(row == 1)), sum(w(row == 2)), sum(w(row == 3))]);
        c = find(all(sort(D.M, 2) == m, 2), 1);
        EI = max(rsum) - min(rsum);
    otherwise
        error('des_assign: method không hợp lệ: %s', method);
end
end
