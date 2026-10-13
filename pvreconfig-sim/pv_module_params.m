function p = pv_module_params(ds)
%PV_MODULE_PARAMS  Tham số mô hình một diode cho 1 tấm PV, trích từ datasheet.
%   p = pv_module_params()      dùng thông số mặc định tấm 6 V / 15 W (giả thiết).
%   p = pv_module_params(ds)    ds là struct có các trường như bên dưới.
%
%   Giải 4 điều kiện (ngắn mạch, hở mạch, đi qua MPP, dP/dV = 0 tại MPP)
%   để tìm Iph, I0, Rs, Rsh với hệ số lý tưởng n cho trước.
%   Chỉ dùng fzero (có sẵn trong MATLAB lõi và Octave).

if nargin < 1, ds = struct(); end
d = default_datasheet();
f = fieldnames(ds);
for k = 1:numel(f), d.(f{k}) = ds.(f{k}); end

q = 1.602176634e-19;  kB = 1.380649e-23;
Tref = 25 + 273.15;
a = d.n * d.Ns * kB * Tref / q;          % điện áp nhiệt quy đổi cả tấm [V]

% Với Rs cho trước: tìm Rsh để mô hình đi qua (Vmp, Imp);
% sau đó tìm Rs để dP/dV = 0 tại Vmp.
% Cận trên của Rs: tại đó dù Rsh rất lớn mô hình vẫn không đi qua được MPP.
Rsh_max = 1e6;
Rs_lim = (d.Voc - d.Vmp) / d.Imp;
Rs_hi = fzero(@(Rs) mpp_point_resid(Rs, Rsh_max, d, a), [1e-9, 0.999*Rs_lim]);
Rs_hi = 0.999 * Rs_hi;
if mpp_point_resid(1e-9, Rsh_max, d, a) <= 0
    error('pv_module_params: n = %.2f quá lớn so với thông số, giảm n.', d.n);
end

resid_mpp = @(Rs) mpp_slope_resid(Rs, d, a, Rsh_max);
r_lo = resid_mpp(1e-9);  r_hi = resid_mpp(Rs_hi);
if sign(r_lo) ~= sign(r_hi)
    Rs = fzero(resid_mpp, [1e-9, Rs_hi]);
else
    % Không có nghiệm chính xác cho dP/dV = 0 -> chọn Rs làm |dP/dV| nhỏ nhất.
    Rs = fminbnd(@(Rs) abs(resid_mpp(Rs)), 1e-9, Rs_hi);
    warning('pv_module_params: dP/dV tại Vmp không về 0 được (n = %.2f), dùng xấp xỉ.', d.n);
end
[~, Rsh, I0, Iph] = mpp_slope_resid(Rs, d, a, Rsh_max);

p = d;
p.Rs = Rs;  p.Rsh = Rsh;  p.I0 = I0;  p.Iph = Iph;  p.a_ref = a;
p.Tref = Tref;  p.q = q;  p.kB = kB;
end

% ------------------------------------------------------------------------
function d = default_datasheet()
% Tấm mono 6 V / 15 W (TEKI 35x35 cm). Voc, Isc là GIẢ THIẾT (1,2*Vmp; 1,1*Imp)
% -> thay bằng datasheet / số đo khi có.
d.Vmp = 6.0;     d.Imp = 2.5;
d.Voc = 7.2;     d.Isc = 2.75;
d.Ns  = 12;      % số cell nối tiếp trong tấm
d.n   = 1.3;     % hệ số lý tưởng diode (chọn)
d.ki  = 0.0005;  % hệ số nhiệt của Isc [1/K] (tương đối)
d.Eg  = 1.12;    % độ rộng vùng cấm Si [eV]
% Diode bypass (Schottky điển hình), mắc ngược song song mỗi tấm
d.Is_bp = 1e-6;  d.n_bp = 1.5;
end

function [r, Rsh, I0, Iph] = mpp_slope_resid(Rs, d, a, Rsh_max)
Rsh = fzero(@(lR) mpp_point_resid(Rs, exp(lR), d, a), [log(1), log(Rsh_max)]);
Rsh = exp(Rsh);
[I0, Iph] = i0_iph(Rs, Rsh, d, a);
x = (d.Vmp + d.Imp*Rs) / a;
g = I0/a*exp(x) + 1/Rsh;                 % -dI/dV (chưa chia Rs)
dIdV = -g / (1 + Rs*g);
r = d.Imp + d.Vmp*dIdV;                  % dP/dV tại Vmp
end

function r = mpp_point_resid(Rs, Rsh, d, a)
[I0, Iph] = i0_iph(Rs, Rsh, d, a);
x = (d.Vmp + d.Imp*Rs) / a;
r = Iph - I0*(exp(x) - 1) - (d.Vmp + d.Imp*Rs)/Rsh - d.Imp;
end

function [I0, Iph] = i0_iph(Rs, Rsh, d, a)
I0  = (d.Isc - (d.Voc - d.Isc*Rs)/Rsh) / (exp(d.Voc/a) - exp(d.Isc*Rs/a));
Iph = I0*(exp(d.Voc/a) - 1) + d.Voc/Rsh;
end
