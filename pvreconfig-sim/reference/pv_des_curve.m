function I = pv_des_curve(G, masks, p, T, V)
%PV_DES_CURVE  Đường I(V) của dàn DES với một cách chia hàng (masks = 1x3 mặt nạ bit).
if nargin < 4 || isempty(T), T = 25; end
if isscalar(T), T = T * ones(3); end
Iq = des_current_grid();
vg = unique([linspace(-1.5, -0.3, 300), linspace(-0.3, 8.5, 1500)])';
Va = zeros(size(Iq));
for r = 1:3
    idx = find(bitget(masks(r), 1:9));
    Ir = zeros(size(vg));
    for j = idx, Ir = Ir + pv_module_current(vg, G(j), T(j), p); end
    Va = Va + interp1(flipud(Ir), flipud(vg), Iq, 'linear', 'extrap');
end
I = interp1(fliplr(Va), fliplr(Iq), V, 'linear', 'extrap');
end
