function st = pv_switch_stress(V, G, S, p, T)
%PV_SWITCH_STRESS  Dòng qua công tắc nối chéo đang đóng và điện áp trên công tắc đang mở.
%   st = pv_switch_stress(V, G, S, p, T)
%   st.I(iv, k) : dòng qua Sk [A], dương = chảy từ cột trái sang cột phải; NaN nếu Sk mở
%   st.U(iv, k) : điện áp trên Sk [V] = nút cột trái - nút cột phải; NaN nếu Sk đóng
%   st.Iarr     : dòng dàn tại từng V
%   Công tắc lý tưởng (như pv_array_iv). Dòng qua Sk suy từ KCL tại nút ở cột ngoài cùng:
%   S1, S3 (cột 1-2): dòng = dòng tấm dưới - dòng tấm trên tại nút cột 1
%   S2, S4 (cột 2-3): dòng = -(dòng tấm dưới - dòng tấm trên) tại nút cột 3
if nargin < 5, T = 25; end
if isscalar(T), T = T * ones(3); end
S = logical(S(:).');
[I, Vp] = pv_array_iv(V, G, S, p, T);
nV = numel(V);
st.I = nan(nV, 4);  st.U = nan(nV, 4);  st.Iarr = I;
lv = [1 1 2 2];  lc = [1 2 1 2];
for iv = 1:nV
    vp = Vp(:, :, iv);
    node = [V(iv) - vp(1, :); V(iv) - vp(1, :) - vp(2, :)];      % node(l, c)
    ip = pv_module_current(vp, G, T, p);
    inj = ip(2:3, :) - ip(1:2, :);                              % dòng bơm vào nút (l, c) từ cột c
    for k = 1:4
        l = lv(k);  c = lc(k);
        if S(k)
            if c == 1, st.I(iv, k) = inj(l, 1); else, st.I(iv, k) = -inj(l, 3); end
        else
            st.U(iv, k) = node(l, c) - node(l, c + 1);
        end
    end
end
end
