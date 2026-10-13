function [V, I, msg] = sl_iv(out)
%SL_IV  Đọc đường I-V từ một lần chạy: điện áp và dòng của nguồn quét CVS (Simscape log).
%   Dòng được chuẩn hóa dấu: dương = tấm/dàn phát điện (dòng gần V = 0 phải dương).
%   msg khác rỗng nếu lần chạy lỗi (V, I khi đó rỗng).
V = [];  I = [];  msg = '';
if ~isempty(out.ErrorMessage), msg = out.ErrorMessage; return; end
lg = out.simlog;
V = lg.CVS.v.series.values('V');
I = lg.CVS.i.series.values('A');
V = V(:);  I = I(:);
[~, i0] = min(abs(V));
if I(i0) < 0, I = -I; end
[V, iu] = unique(V);  I = I(iu);
end
