function [Id, dId] = pv_module_current(v, G, T, p)
%PV_MODULE_CURRENT  Dòng 1 tấm PV (kèm diode bypass) cấp ra ở cực +.
%   [Id, dId] = pv_module_current(v, G, T, p)
%   v   : điện áp hai cực tấm [V] (mảng bất kỳ)
%   G   : bức xạ [W/m^2] (vô hướng hoặc cùng kích thước v)
%   T   : nhiệt độ cell [°C]
%   p   : struct từ pv_module_params
%   Id  : dòng cấp ra = dòng mô hình một diode + dòng diode bypass
%   dId : dId/dv (luôn âm), dùng cho Jacobian của solver mạng.

[Iph, I0, a] = operating_params(G, T, p);
v = v + zeros(size(Iph));                 % broadcast
Rs = p.Rs;  Rsh = p.Rsh;

% Newton trên I cho phương trình ẩn:
% f(I) = Iph - I0*(exp((v+I*Rs)/a)-1) - (v+I*Rs)/Rsh - I = 0   (f giảm đơn điệu theo I)
I = Iph + zeros(size(v));
for it = 1:60
    x  = (v + I*Rs) ./ a;
    [ex, dex] = safe_exp(x);
    f  = Iph - I0.*(ex - 1) - (v + I*Rs)/Rsh - I;
    df = -I0.*dex*Rs./a - Rs/Rsh - 1;
    dI = -f ./ df;
    I  = I + dI;
    if max(abs(dI(:))) < 1e-12, break; end
end
x = (v + I*Rs) ./ a;
[~, dex] = safe_exp(x);
g = I0.*dex./a + 1/Rsh;
dI_cell = -g ./ (1 + Rs*g);

% Diode bypass: anode ở cực -, cathode ở cực +; dẫn khi v < 0.
vt_bp = p.n_bp * p.kB * (T + 273.15) / p.q;
[eb, deb] = safe_exp(-v ./ vt_bp);
Ib  = p.Is_bp * (eb - 1);
dIb = -p.Is_bp * deb ./ vt_bp;

Id  = I + Ib;
dId = dI_cell + dIb;
end

% ------------------------------------------------------------------------
function [Iph, I0, a] = operating_params(G, T, p)
TK  = T + 273.15;
Iph = p.Iph * (G/1000) .* (1 + p.ki*(T - 25));
a   = p.n * p.Ns * p.kB * TK / p.q;
I0  = p.I0 * (TK/p.Tref).^3 .* exp(p.q*p.Eg/(p.n*p.kB) * (1/p.Tref - 1./TK));
end

function [e, de] = safe_exp(x)
% exp tuyến tính hoá khi x lớn để Newton không tràn số.
xm = 40;
big = x > xm;
e = exp(min(x, xm));
de = e;
e(big) = e(big) .* (1 + x(big) - xm);
end
