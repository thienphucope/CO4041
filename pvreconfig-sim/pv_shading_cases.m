function c = pv_shading_cases()
%PV_SHADING_CASES  Bộ ca che bóng cho ARR-01..04 (G tính bằng W/m^2).
%   Hàng 1 là hàng trên cùng (nối bus +). Mẫu che tham khảo R2/R3 trong
%   docs/references/references.md: hàng, cột, chéo, góc, ngẫu nhiên.

F = 1000;  S = 300;                       % nắng đủ / bị che
c = struct('name', {}, 'desc', {}, 'G', {});
c(end+1) = mk('deu',        'Bức xạ đều (ARR-01)',            F*ones(3));
c(end+1) = mk('mot-tam',    'Một tấm giữa bị che',            setp(F*ones(3), 2, 2, S));
c(end+1) = mk('hai-tam',    'Hai tấm PV11, PV22 bị che',      setp(setp(F*ones(3), 1, 1, S), 2, 2, S));
c(end+1) = mk('hang-1',     'Che cả hàng trên',               setrow(F*ones(3), 1, S));
c(end+1) = mk('cot-1',      'Che cả cột trái',                setcol(F*ones(3), 1, S));
c(end+1) = mk('cheo',       'Che theo đường chéo',            F*ones(3) - (F - S)*eye(3));
c(end+1) = mk('goc-2x2',    'Che góc 2x2 trên-trái',          blk(F*ones(3), 1:2, 1:2, S));
c(end+1) = mk('bong-dai',   'Bóng dài: cột trái + giữa nhạt', [S 600 F; S 600 F; S 600 F]);
c(end+1) = mk('ngau-nhien', 'Ngẫu nhiên (cố định)',           [820 410 960; 300 1000 550; 700 650 380]);
end

function s = mk(name, desc, G)
s.name = name;  s.desc = desc;  s.G = G;
end
function G = setp(G, r, c, v),   G(r, c) = v; end
function G = setrow(G, r, v),    G(r, :) = v; end
function G = setcol(G, c, v),    G(:, c) = v; end
function G = blk(G, r, c, v),    G(r, c) = v; end
