function sc = shadow_profiles(names)
%SHADOW_PROFILES  Kịch bản bóng di chuyển cho ARR-05 (60 s).
%   sc = shadow_profiles()            mọi kịch bản
%   sc = shadow_profiles({'canh-ngang'})
%   sc(i).name, .desc, .Tend [s], .Gfun(t) -> ma trận 3x3 [W/m^2]
%   Toạ độ theo bề rộng tấm: cột c chiếm x = c-1..c, hàng r chiếm y = r-1..r (hàng 1 trên cùng).
%   Bức xạ tương đương của tấm = F - (F - Gs) * (tỉ lệ diện tích bị bóng), lấy mẫu 10 x 10 điểm/tấm.
%   Giả thiết tỉ lệ diện tích là lạc quan: thực tế bóng phủ một phần các cell nối tiếp
%   làm tấm giảm công suất mạnh hơn tỉ lệ diện tích.
Tend = 60;
sc = struct('name', {}, 'desc', {}, 'Tend', {}, 'Gfun', {});
sc(end+1) = mk('canh-ngang', 'Mép bóng thẳng đứng đi từ trái sang phải', Tend, 200, ...
    @(x, y, t) x < -0.25 + 3.5 * t / Tend);
sc(end+1) = mk('canh-cheo', 'Mép bóng chéo đi từ góc trên-trái', Tend, 200, ...
    @(x, y, t) (x + y) < -0.5 + 7 * t / Tend);
sc(end+1) = mk('cot-dien', 'Bóng cột điện (dải rộng 0,5 tấm) quét ngang', Tend, 300, ...
    @(x, y, t) abs(x - (-0.5 + 4 * t / Tend)) < 0.25);
sc(end+1) = mk('dam-may', 'Đám mây tròn bán kính 1 tấm đi chéo', Tend, 350, ...
    @(x, y, t) (x - (-1 + 5 * t / Tend)).^2 + (y - (-0.5 + 4 * t / Tend)).^2 < 1);
if nargin > 0
    sc = sc(ismember({sc.name}, names));
end
end

function s = mk(name, desc, Tend, Gs, f)
s.name = name;  s.desc = desc;  s.Tend = Tend;
s.Gfun = @(t) shade_G(f, t, Gs);
end

function G = shade_G(f, t, Gs)
F = 1000;  n = 10;
u = ((1:n) - 0.5) / n;
G = zeros(3);
for r = 1:3
    for c = 1:3
        [X, Y] = meshgrid(c - 1 + u, r - 1 + u);
        m = f(X, Y, t);
        G(r, c) = F - (F - Gs) * mean(m(:));
    end
end
end
