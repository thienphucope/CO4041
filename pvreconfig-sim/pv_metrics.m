function m = pv_metrics(V, I, Vbat)
%PV_METRICS  Chỉ tiêu so sánh từ một đường I-V.
%   m.Pmax  công suất cực đại toàn cục (GMPP) [W]
%   m.Vmpp  điện áp tại GMPP [V]
%   m.npk   số đỉnh cục bộ trên đường P-V (độ nổi >= 2% Pmax)
%   m.Pbat  công suất tại V = Vbat (khi bộ sạc là PWM) [W]

V = V(:);  I = I(:);  P = V .* I;
[m.Pmax, k] = max(P);
m.Vmpp = V(k);
m.Pbat = interp1(V, P, Vbat);

% Đếm đỉnh: điểm lớn hơn hai bên, và trũng giữa hai đỉnh liên tiếp đủ sâu.
pk = find(P(2:end-1) > P(1:end-2) & P(2:end-1) >= P(3:end)) + 1;
pk = pk(P(pk) > 0);
keep = [];
for j = 1:numel(pk)
    if isempty(keep)
        keep = pk(j);
    else
        dip = min(P(keep(end):pk(j)));
        if min(P(keep(end)), P(pk(j))) - dip >= 0.02 * m.Pmax
            keep(end+1) = pk(j); %#ok<AGROW>
        elseif P(pk(j)) > P(keep(end))
            keep(end) = pk(j);
        end
    end
end
m.npk = numel(keep);
end
