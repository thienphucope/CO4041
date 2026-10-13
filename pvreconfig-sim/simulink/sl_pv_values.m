function v = sl_pv_values()
%SL_PV_VALUES  Giá trị tham số block Solar Cell / Diode, suy từ pv_module_params().
%   v.cell : nhập theo 1 cell, dùng khi block có ô "Number of series cells" (Ns = 12)
%   v.lump : gộp cả tấm vào 1 "cell", dùng khi block không có ô đó
%   Hai cách cho cùng phương trình với mô hình tham chiếu:
%     I = Iph - I0*(exp((V + I*Rs)/(n*Ns*Vt)) - 1) - (V + I*Rs)/Rsh
%   Nhiệt độ (theo mô tả block): Is(T) = Is*(T/T1)^(TXIS1/N)*exp(EG/(N*Vt)*(T/T1 - 1))
%   => TXIS1 = 3*N, EG = Eg*(số cell gộp) để khớp I0(T) của mô hình tham chiếu.

p = pv_module_params();

v.Iph0  = p.Iph;        % A
v.Is    = p.I0;         % A
v.Ir0   = 1000;         % W/m^2
v.TIPH1 = p.ki;         % 1/K
v.Tmeas = 25;           % degC

v.cell.Ns    = p.Ns;
v.cell.N     = p.n;
v.cell.Rs    = p.Rs  / p.Ns;
v.cell.Rp    = p.Rsh / p.Ns;
v.cell.EG    = p.Eg;
v.cell.TXIS1 = 3 * p.n;

v.lump.Ns    = 1;
v.lump.N     = p.n * p.Ns;
v.lump.Rs    = p.Rs;
v.lump.Rp    = p.Rsh;
v.lump.EG    = p.Eg * p.Ns;
v.lump.TXIS1 = 3 * p.n * p.Ns;

v.Is_bp = p.Is_bp;      % A, diode bypass
v.N_bp  = p.n_bp;
end
