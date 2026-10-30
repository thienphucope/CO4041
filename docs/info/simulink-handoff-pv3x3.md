# Bàn giao mô phỏng Simulink: dàn PV 3 × 3 có 4 công tắc nối chéo

> File này tự đủ: người nhận không cần repo. Gồm đề bài, thông số, cách dựng model, script, ca thử, số liệu tham chiếu để đối chiếu, và danh sách đầu ra cần nộp lại.
> Số liệu tham chiếu lấy từ mô hình script `.m` (một diode + diode bypass, giải KCL bằng Newton) đã chạy trên Octave. Model Simulink cần **khớp** các số này.
> Cập nhật: 2026-10-13 (thêm kết quả chạy Simulink R2026b, mục 10.1).

---

## 1. Bối cảnh và phạm vi

- Đề tài: **PV array reconfiguration**. Giai đoạn 1 gồm PCB mạch chuyển cấu hình cho dàn 3 × 3 và **mô phỏng trên MATLAB**. Phần mô phỏng trong file này là việc của bên nhận.
- Pin 12 V do bộ điều khiển sạc **Suoer ST-S1230** lo sạc/bảo vệ. Không làm BMS, không làm cân bằng cell, không mô phỏng pin.
- Tải: tải tĩnh, công suất cố định (chưa có số). Không cần mô phỏng tải.
- **Chưa biết ST-S1230 là PWM hay MPPT** → mọi kết quả phải xuất **cả hai** chỉ tiêu:
  - `Pmax`: công suất cực đại toàn cục (GMPP), đúng nếu bộ sạc là MPPT.
  - `Pbat`: công suất tại V = V_bat = **13,0 V**, đúng nếu bộ sạc là PWM (dàn bị kéo về điện áp pin, dải 12,5–14,4 V).

Mục tiêu mô phỏng: với mỗi dạng che bóng, trạng thái công tắc nào cho công suất lớn nhất, và hơn SP bao nhiêu.

---

## 2. Thông số

### 2.1. Tấm PV (mỗi tấm, 9 tấm giống nhau)

Tấm mono 6 V/15 W, TEKI 35 × 35 cm. V_oc, I_sc là **giả thiết** (1,2·V_mp; 1,1·I_mp), sẽ thay khi có datasheet/số đo.

| Thông số | Giá trị |
|---|---|
| V_mp / I_mp / P_mp | 6,0 V / 2,5 A / 15 W |
| V_oc / I_sc | 7,2 V / 2,75 A |
| Số cell nối tiếp N_s | 12 |
| Hệ số lý tưởng n | 1,3 |
| Hệ số nhiệt của I_sc | 0,0005 /K (tương đối) |
| E_g | 1,12 eV |
| Nhiệt độ chuẩn | 25 °C |

Tham số mô hình một diode đã trích (khớp đúng 4 điểm Isc, Voc, MPP, dP/dV = 0 tại MPP), **tính cho cả tấm**:

| Tham số | Cả tấm | Quy về 1 cell (÷ 12 với R) |
|---|---|---|
| I_ph | 2,75134 A | 2,75134 A |
| I_0 | 4,18044·10⁻⁸ A | 4,18044·10⁻⁸ A |
| R_s | 0,0336708 Ω | 0,00280590 Ω |
| R_sh | 69,3456 Ω | 5,77880 Ω |
| n | 1,3 (điện áp nhiệt quy đổi a = n·N_s·kT/q) | 1,3 |

Phương trình (cả tấm): `I = Iph − I0·[exp((V + I·Rs)/a) − 1] − (V + I·Rs)/Rsh`, với `Iph(G,T) = Iph·(G/1000)·(1 + 0,0005·(T − 25))`, `I0(T) = I0·(T/Tref)³·exp(q·Eg/(n·k)·(1/Tref − 1/T))`.

**Diode bypass** mỗi tấm (mắc ngược song song: anode ở cực −, cathode ở cực +): mô hình mũ, I_s = 1 µA, N = 1,5. Khi tấm bị che và bị ép dòng 2,5 A, điện áp tấm kẹp ≈ −0,55 V.

### 2.2. Dàn 3 × 3 và công tắc

```
        + ─────┬──────────┬──────────┬───── (+) ra bộ sạc / tải quét
             PV11       PV12       PV13
     nút 1:    ●──S1──────●──S2──────●
             PV21       PV22       PV23
     nút 2:    ●──S3──────●──S4──────●
             PV31       PV32       PV33
        − ─────┴──────────┴──────────┴───── (−)
```

- `PVrc`: hàng r (1 = trên cùng, nối bus +), cột c. Mỗi cột luôn là **3 tấm nối tiếp, đấu cứng**.
- 4 công tắc nối chéo, chỉ nối các nút **cùng mức** của hai cột kề nhau:
  - S1: nút 1 cột 1 ↔ nút 1 cột 2 · S2: nút 1 cột 2 ↔ nút 1 cột 3
  - S3: nút 2 cột 1 ↔ nút 2 cột 2 · S4: nút 2 cột 2 ↔ nút 2 cột 3
- Trạng thái `S = [S1 S2 S3 S4]`, 1 = đóng. 16 trạng thái, đánh số `s = 0..15` theo nhị phân `S1S2S3S4` (S1 là bit cao).
  - `0000` = **SP** (3S3P), `1111` = **TCT**, `1001` = **BL** (theo Fig. 4e của Ref 3), `0110` = **HC?** (tạm gán, chưa xác nhận từ tài liệu).
  - Dù nhãn BL/HC sau này đổi, vẫn quét đủ 16 trạng thái nên không thiếu.
- Công tắc trong mô hình tham chiếu là **lý tưởng** (gộp nút). Trong Simulink đặt điện trở đóng nhỏ (1 mΩ) để khớp. Phần cứng thật dự kiến dùng 2 MOSFET đấu ngược (dòng qua mối nối chéo đi được hai chiều); muốn tính tổn hao thì đặt R_closed = 2·R_DS(on) ở một lần chạy riêng.
- Do phần nối tiếp đấu cứng, không trạng thái nào tạo ra 9S (V_oc ≈ 64,8 V, vượt giới hạn ~50 V của bộ sạc) hay 9P. Không cần mô phỏng các cấu hình đó.

### 2.3. Giá trị kỳ vọng khi nắng đều (STC)

Mọi trạng thái: V_mp ≈ 18 V, V_oc ≈ 21,6 V, I_sc ≈ 8,25 A, P_max ≈ 135 W.

---

## 3. Toolbox cần có

> Bản đầy đủ, có cách kiểm tra: [`cai-dat-matlab.md`](cai-dat-matlab.md).

Khi cài, **chỉ tick 4 gói**:

| Gói | Vì sao cần |
|---|---|
| MATLAB | nền |
| Simulink | sơ đồ khối, `sim` |
| Simscape | mạng điện vật lý: Switch, nguồn áp điều khiển, sensor, Solver Configuration |
| Simscape Electrical | block **Solar Cell** và **Diode** (mô hình mũ) |

Tùy chọn, chỉ cài nếu cần:
- Parallel Computing Toolbox: chạy `parsim` cho nhanh. Không có thì script tự dùng `sim` tuần tự.
- Stateflow: chỉ khi làm ARR-05 dạng quá độ trong Simulink. Cách tựa tĩnh ở mục 8 không cần.

Không cần các gói khác (Control System, Optimization, Simscape Multibody, Simscape Fluids…). Kiểm tra sau khi cài bằng `ver`.

Không dùng block "PV Array" của Specialized Power Systems; dùng **Solar Cell** của Simscape Electrical để đặt được tham số một diode.

---

## 4. Dựng model `pv3x3.slx`

> Có sẵn script dựng tự động trong thư mục `pvreconfig-sim/` của repo: `sl_run_all` dựng model rồi chạy toàn bộ mục 6 (xem README trong thư mục đó). Các bước dưới đây là cách dựng bằng tay, cũng dùng để hiểu và sửa model do script tạo ra.

### 4.1. Subsystem một tấm `PV`

1. `ssc_new` → model Simscape trống (có sẵn Solver Configuration, Electrical Reference). Lưu `pv3x3.slx`.
2. Block **Solar Cell** (Simscape › Electrical › Sources). Đặt tham số theo **cách A** (khuyến nghị, khớp đúng mô hình tham chiếu):

   > **Đã kiểm trên R2026b (13/10/2026):** mô hình **5 parameter bỏ qua Rp** (coi Rp = ∞), làm Pmax cao hơn tham chiếu 3–9 %. Dùng **8 parameter** với Is2 = `0` (tắt diode thứ hai); các ô còn lại như bảng dưới. Script `sl_conf_solar` đã làm vậy, nhập kiểu gộp cả tấm (N_series = 1), cho Pmax lệch 0,00 %.

   **Cách A — By equivalent circuit parameters (8 parameter, Is2 = 0), 12 cell nối tiếp:**

   | Tham số block | Giá trị |
   |---|---|
   | Parameterization | By equivalent circuit parameters, 8 parameter (Is2 = 0) |
   | Solar-generated current for measurements, Iph0 | `2.75134` A |
   | Irradiance used for measurements, Ir0 | `1000` W/m² |
   | Diode saturation current, Is | `4.18044e-8` A |
   | Quality factor, N | `1.3` |
   | Series resistance, Rs | `0.0028059` Ω (**của 1 cell**) |
   | Parallel resistance, Rp | `5.7788` Ω (**của 1 cell**) |
   | Number of series cells | `12` |
   | First order temperature coefficient for Iph, TIPH1 | `0.0005` 1/K |
   | Energy gap, EG | `1.12` eV |
   | Temperature exponent for Is, TXIS1 | `3.9` (= 3·N, vì block dùng số mũ TXIS1/N) |
   | Measurement temperature | `25` °C |
   | Device simulation temperature | `25` °C (đổi khi chạy PV-03) |

   Block giải phương trình cho 1 cell rồi nhân điện áp với số cell, nên R_s, R_p nhập theo **1 cell**; I_ph, I_s, N giữ nguyên.

   **Nếu bản MATLAB không có ô "Number of series cells":** dùng 1 block cho cả tấm với tham số gộp: N = `15.6` (= 1,3 × 12), Rs = `0.0336708`, Rp = `69.3456`, Iph0 và Is như trên, EG = `13.44` (= 1,12 × 12), TXIS1 = `46.8` (= 3 × 15,6). Về toán học hai cách cho cùng đường I–V.

   **Cách B — By Isc and Voc** (chỉ dùng nếu không đặt được cách A): Isc = `2.75`, Voc = `0.6` (**của 1 cell**, 12 × 0,6 = 7,2 V), 12 cell. Cách này không đi qua đúng MPP 6 V/2,5 A nên Pmax lệch vài %; khi đó so **xu hướng** giữa các trạng thái, không so tuyệt đối.

   Phần temperature: công thức nhiệt của block có thể khác nhau giữa các phiên bản. Nếu PV-03 lệch bảng ở mục 6.1 quá 2 % thì ghi chú lại, không cần sửa (các ca dàn đều chạy ở 25 °C).
3. Block **Diode** (Simscape › Electrical › Semiconductors & Converters), mắc song song Solar Cell, **ngược chiều**: anode nối cực −, cathode nối cực + của tấm. Diode model = Exponential (R2026b: phải chọn biến thể *physical* của block thì mới có mô hình mũ); Saturation current IS = `1e-6` A; Emission coefficient N = `1.5`; tắt junction capacitance.
4. **Simulink-PS Converter**: tín hiệu bức xạ vào cổng `Ir` của Solar Cell, *Input signal unit* = `W/m^2`.
5. Gom lại (Ctrl+G) thành subsystem `PV`: 2 cổng điện (`+`, `−`), 1 cổng Simulink `G`.

### 4.2. Dàn và công tắc

1. 9 bản `PV11 … PV33`. Trong mỗi cột: `−` của PV1c nối `+` của PV2c (= nút 1 cột c); `−` của PV2c nối `+` của PV3c (= nút 2 cột c).
2. `+` của PV11, PV12, PV13 chập làm bus +; `−` của PV31, PV32, PV33 chập làm bus −, nối **Electrical Reference**.
3. 4 block **Switch** (Simscape › Foundation › Electrical › Electrical Elements) theo mục 2.2. *Threshold* = `0.5`, *Closed resistance* = `1e-3` Ω, *Open conductance* = `1e-8` 1/Ω.
   Điều khiển: Constant `S(1)` … `S(4)` → Simulink-PS Converter (unit `1`) → cổng điều khiển.
4. Bức xạ: 9 Constant `G(1,1)` … `G(3,3)` vào cổng `G` của từng tấm. `G` là ma trận 3 × 3 đặt từ script.

### 4.3. Tải quét I–V và đo

1. **Controlled Voltage Source**: `+` bus +, `−` bus −. Điều khiển từ **Ramp** (slope = `Vmax`, start 0) → Simulink-PS Converter (unit `V`). `Vmax = 24` (> V_oc dàn 21,6 V).
2. **Current Sensor** nối tiếp giữa bus + và nguồn; **Voltage Sensor** giữa bus + và bus −. Mỗi sensor → PS-Simulink Converter → **To Workspace** (`Vpv`, `Ipv`, *Save format* = `Array`).
3. Solver: variable-step, `daessc` (hoặc `ode23t`), *Max step size* = `1e-3`, *Stop time* = `1`. Dàn không có phần tử tích trữ nên quét ramp 1 s là tĩnh.
4. Dấu dòng: script tự chuẩn hóa sao cho dòng dương = dàn phát. Khi V > V_oc dòng đổi chiều; **không** dùng `abs()`.

---

## 5. Script

### 5.1. `pv_shading_cases.m` — 9 ca che bóng (dùng đúng bộ này để so được với tham chiếu)

```matlab
function c = pv_shading_cases()
% G tính bằng W/m^2; hàng 1 là hàng trên cùng (nối bus +).
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

function s = mk(name, desc, G), s.name = name; s.desc = desc; s.G = G; end
function G = setp(G, r, c, v),   G(r, c) = v; end
function G = setrow(G, r, v),    G(r, :) = v; end
function G = setcol(G, c, v),    G(:, c) = v; end
function G = blk(G, r, c, v),    G(r, c) = v; end
```

### 5.2. `pv_metrics.m` — chỉ tiêu từ một đường I–V

```matlab
function m = pv_metrics(V, I, Vbat)
% m.Pmax (GMPP) [W], m.Vmpp [V], m.npk số đỉnh P-V (độ nổi >= 2% Pmax), m.Pbat = P(Vbat) [W]
V = V(:);  I = I(:);
[V, iu] = unique(V);  I = I(iu);
P = V .* I;
[m.Pmax, k] = max(P);
m.Vmpp = V(k);
m.Pbat = interp1(V, P, Vbat);
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
```

Đường quét từ Simulink có bước không đều và có thể nhiễu nhỏ; nếu `npk` đếm thừa, nội suy về lưới đều 0,05 V trước khi gọi (`Vg = (0:0.05:Vmax)'; Ig = interp1(V, I, Vg);`).

### 5.3. `run_pv3x3.m` — quét 16 trạng thái × 9 ca, xuất CSV

```matlab
mdl  = 'pv3x3';
load_system(mdl);
Vmax = 24;   Vbat = 13.0;

states = dec2bin(0:15) - '0';             % hàng s+1 = [S1 S2 S3 S4]
labels = cellstr(num2str(states, '%d%d%d%d'));
labels{1} = 'SP';  labels{16} = 'TCT';  labels{bin2dec('1001')+1} = 'BL';  labels{bin2dec('0110')+1} = 'HC?';
cases  = pv_shading_cases();
nC = numel(cases);  nS = 16;

% Tạo toàn bộ SimulationInput rồi chạy (parsim nếu có PCT)
in = repmat(Simulink.SimulationInput(mdl), nC*nS, 1);
for k = 1:nC
    for s = 1:nS
        j = (k-1)*nS + s;
        in(j) = in(j).setVariable('G', cases(k).G);
        in(j) = in(j).setVariable('S', states(s,:));
        in(j) = in(j).setVariable('Vmax', Vmax);
    end
end
if license('test', 'Distrib_Computing_Toolbox'), out = parsim(in); else, out = sim(in); end

fid = fopen('arr_summary_simulink.csv', 'w');
fprintf(fid, 'case,state,S1,S2,S3,S4,label,Pmax_W,Vmpp_V,n_peaks,Pbat_W,gain_vs_SP_pct\n');
curves = struct('case', {}, 'state', {}, 'V', {}, 'I', {});
Pmax = zeros(nC, nS);  Pbat = zeros(nC, nS);
for k = 1:nC
    for s = 1:nS
        o = out((k-1)*nS + s);
        V = o.Vpv(:);  I = o.Ipv(:);
        I = I * sign(I(find(V < 1, 1)));  % gần ngắn mạch dòng phải dương; KHÔNG abs()
        m = pv_metrics(V, I, Vbat);
        Pmax(k,s) = m.Pmax;  Pbat(k,s) = m.Pbat;
        curves(end+1) = struct('case', cases(k).name, 'state', s-1, 'V', V, 'I', I); %#ok<SAGROW>
        fprintf(fid, '%s,%d,%d,%d,%d,%d,%s,%.4f,%.3f,%d,%.4f,%.3f\n', cases(k).name, s-1, ...
            states(s,:), labels{s}, m.Pmax, m.Vmpp, m.npk, m.Pbat, 100*(m.Pmax/Pmax(k,1) - 1));
    end
    [best, sb] = max(Pmax(k,:));
    fprintf('%-11s SP=%6.2f TCT=%6.2f best=%6.2f (%s)  Pbat SP=%6.2f TCT=%6.2f\n', cases(k).name, ...
        Pmax(k,1), Pmax(k,16), best, labels{sb}, Pbat(k,1), Pbat(k,16));
end
fclose(fid);
save('ket-qua-pv3x3.mat', 'cases', 'states', 'labels', 'Pmax', 'Pbat', 'curves', 'Vbat');
```

Ghi chú: `gain_vs_SP_pct` tính theo Pmax. Trong vòng lặp, `Pmax(k,1)` (SP) đã có trước khi tính các trạng thái sau vì s chạy từ 1.

---

## 6. Ca thử và số liệu tham chiếu

### 6.1. Một tấm (PV-01 … PV-04)

Chạy subsystem `PV` riêng (hoặc dàn với G chỉ 1 tấm, nhưng đơn giản nhất là 1 tấm + nguồn quét 0–8 V).

| Ca | Điều kiện | Isc (A) | Voc (V) | Vmp (V) | Imp (A) | Pmax (W) |
|---|---|---|---|---|---|---|
| PV-01 | 1000 W/m², 25 °C | 2,750 | 7,200 | 6,000 | 2,500 | 15,000 |
| PV-02 | 400 W/m², 25 °C | 1,100 | 6,811 | 5,664 | 0,956 | 5,416 |
| PV-02 | 700 W/m², 25 °C | 1,925 | 7,051 | 5,878 | 1,727 | 10,153 |
| PV-03 | 1000 W/m², 45 °C | 2,777 | 6,704 | 5,492 | 2,506 | 13,764 |
| PV-03 | 1000 W/m², 60 °C | 2,798 | 6,329 | 5,114 | 2,507 | 12,823 |
| PV-04 | tấm 300 W/m² bị ép dòng 2,5 A | — | điện áp tấm ≈ **−0,552 V** (diode bypass dẫn) | | | |

PV-04: nối tiếp 1 tấm 300 W/m² với nguồn dòng 2,5 A (hoặc đọc điện áp tấm PV11 trong ca `cot-1`/`hang-1` khi dàn chạy ở dòng cao).

**Sai số chấp nhận (cách A):** Isc, Voc, Pmax lệch ≤ 0,5 %. Nếu PV-01 ra Voc ≈ 86 V → đang nhập tham số theo cả tấm trong khi đặt 12 cell; sửa lại theo mục 4.1.

### 6.2. Dàn — Pmax (W) theo ca × trạng thái (25 °C)

Cột là `S1S2S3S4`; `0000` = SP, `1001` = BL, `0110` = HC?, `1111` = TCT.

| Ca | 0000 | 0001 | 0010 | 0011 | 0100 | 0101 | 0110 | 0111 | 1000 | 1001 | 1010 | 1011 | 1100 | 1101 | 1110 | 1111 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| deu | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 | 135.00 |
| mot-tam | 103.84 | 105.82 | 105.82 | 107.22 | 105.82 | 107.62 | 107.94 | 109.27 | 105.82 | 107.94 | 107.62 | 109.27 | 107.22 | 109.27 | 109.27 | 111.09 |
| hai-tam | 88.64 | 87.44 | 88.64 | 87.35 | 87.44 | 86.03 | 87.36 | 86.03 | 102.61 | 104.27 | 104.31 | 105.48 | 102.57 | 104.27 | 104.27 | 105.48 |
| hang-1 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 | 85.87 |
| cot-1 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 | 100.98 |
| cheo | 85.87 | 71.43 | 85.87 | 74.29 | 85.87 | 73.23 | 85.87 | 76.58 | 71.43 | 100.98 | 73.23 | 100.98 | 74.29 | 100.98 | 76.58 | 100.98 |
| goc-2x2 | 70.53 | 72.04 | 70.53 | 72.19 | 70.39 | 72.04 | 70.39 | 72.19 | 70.53 | 72.02 | 70.53 | 72.19 | 70.33 | 72.01 | 70.33 | 72.19 |
| bong-dai | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 | 81.78 |
| ngau-nhien | 56.33 | 57.83 | 56.59 | 58.96 | 62.12 | 62.21 | 74.11 | 74.85 | 62.21 | 62.27 | 72.53 | 77.09 | 62.52 | 62.61 | 76.62 | 78.72 |

### 6.3. Dàn — Pbat = P(13,0 V) (W)

| Ca | 0000 | 0001 | 0010 | 0011 | 0100 | 0101 | 0110 | 0111 | 1000 | 1001 | 1010 | 1011 | 1100 | 1101 | 1110 | 1111 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| deu | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 | 104.71 |
| mot-tam | 91.06 | 86.15 | 86.15 | 83.11 | 86.15 | 81.86 | 81.45 | 81.69 | 86.15 | 81.45 | 81.86 | 81.69 | 83.11 | 81.69 | 81.69 | 82.22 |
| hai-tam | 77.41 | 72.50 | 77.41 | 71.90 | 72.50 | 68.21 | 72.45 | 67.43 | 79.99 | 80.22 | 80.20 | 80.40 | 80.01 | 80.22 | 80.22 | 80.40 |
| hang-1 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 | 63.76 |
| cot-1 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 | 79.69 |
| cheo | 63.76 | 66.34 | 63.76 | 59.93 | 63.76 | 66.55 | 63.76 | 59.27 | 66.34 | 79.69 | 66.55 | 79.69 | 59.93 | 79.69 | 59.27 | 79.69 |
| goc-2x2 | 55.23 | 55.46 | 55.23 | 55.47 | 55.26 | 55.46 | 55.26 | 55.47 | 55.23 | 55.46 | 55.23 | 55.47 | 55.26 | 55.46 | 55.26 | 55.47 |
| bong-dai | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 | 65.40 |
| ngau-nhien | 42.95 | 47.86 | 43.04 | 45.18 | 50.62 | 50.64 | 58.38 | 58.72 | 47.65 | 47.61 | 57.03 | 60.64 | 48.00 | 47.98 | 59.45 | 61.21 |

### 6.4. Tóm tắt, số đỉnh, V_mpp

| Ca | SP | TCT | BL | Tốt nhất (trạng thái) | so với SP | Số đỉnh P–V SP / TCT | V_mpp SP / TCT (V) |
|---|---|---|---|---|---|---|---|
| deu | 135,00 | 135,00 | 135,00 | 135,00 (mọi trạng thái) | 0 % | 1 / 1 | 18,0 / 18,0 |
| mot-tam | 103,84 | 111,09 | 107,94 | 111,09 (TCT) | +7,0 % | 2 / 2 | 18,1 / 18,7 |
| hai-tam | 88,64 | 105,48 | 104,27 | 105,48 (1011, TCT) | +19,0 % | 2 / 1 | 11,8 / 18,1 |
| hang-1 | 85,87 | 85,87 | 85,87 | 85,87 (mọi trạng thái) | 0 % | 2 / 2 | 11,5 / 11,5 |
| cot-1 | 100,98 | 100,98 | 100,98 | 100,98 (mọi trạng thái) | 0 % | 1 / 1 | 17,7 / 17,7 |
| cheo | 85,87 | 100,98 | 100,98 | 100,98 (BL, TCT, …) | +17,6 % | 2 / 1 | 11,5 / 17,7 |
| goc-2x2 | 70,53 | 72,19 | 72,02 | 72,19 (0011, TCT, …) | +2,4 % | 2 / 2 | 17,9 / 18,1 |
| bong-dai | 81,78 | 81,78 | 81,78 | 81,78 (mọi trạng thái) | 0 % | 1 / 1 | 17,5 / 17,5 |
| ngau-nhien | 56,33 | 78,72 | 62,27 | 78,72 (TCT) | +39,8 % | 3 / 1 | 11,7 / 17,9 |

Điểm cần thấy được trong kết quả Simulink:
- Nắng đều, che nguyên hàng, nguyên cột, bóng dài theo cột: **16 trạng thái bằng nhau** (mất cân bằng không nằm giữa các nhánh trong cùng một hàng nên nối chéo không giúp gì).
- Che lệch giữa hàng/cột (`cheo`, `hai-tam`, `ngau-nhien`): nối chéo tăng 17–40 %.
- `cheo`: một số trạng thái nối chéo một phần (0001, 1000 …) **kém hơn SP**. Không phải cứ thêm công tắc đóng là tốt hơn.
- `mot-tam`: TCT có Pmax cao nhất, nhưng tại 13 V thì **SP lại hơn** (91,06 so với 82,22 W). Nếu bộ sạc là PWM, cấu hình tốt nhất khác hẳn.

**Sai số chấp nhận (cách A, R_closed = 1 mΩ):** Pmax và Pbat lệch ≤ 1 % so với bảng 6.2/6.3; trạng thái tốt nhất mỗi ca phải trùng (khi hai trạng thái chênh nhau < 0,2 W thì coi như hòa). Cách B: chỉ yêu cầu thứ hạng giữa các trạng thái giống nhau.

### 6.5. Lỗi thường gặp

| Hiện tượng | Nguyên nhân |
|---|---|
| PV-01 Voc ≈ 86 V | Nhập tham số theo cả tấm nhưng đặt 12 cell |
| `deu` mà các trạng thái khác nhau | Đấu sai nút / công tắc nối sai mức |
| Không có nhiều đỉnh khi che bóng; solver lỗi | Thiếu diode bypass hoặc diode lắp ngược chiều |
| P âm toàn bộ / Pmax quá nhỏ | Sai dấu dòng (xem mục 4.3) hoặc unit bức xạ sai |
| "Each physical network must have a Solver Configuration" | Thiếu Solver Configuration / Electrical Reference |
| Không hội tụ | Giảm Max step size, thử `daessc`, kiểm tra Open conductance của Switch không bằng 0 |

---

## 7. Chỉ tiêu cần tính thêm cho báo cáo

Với mỗi (ca, trạng thái):
- `Pmax`, số đỉnh P–V, `Pbat` (đã có trong CSV).
- Mức tăng so với SP: `ΔP = (P_cfg − P_SP)/P_SP`, tính cho cả Pmax và Pbat.
- Tổn hao không tương hợp: `P_ML = Σ P_mpp,ij − Pmax`, trong đó `P_mpp,ij` là Pmax của tấm đơn ở bức xạ G(i,j) (chạy 1 tấm ở 300, 410, 550, 600, 650, 700, 820, 960, 1000 W/m²; tham chiếu: 1000 → 15,000 W, 700 → 10,153 W, 400 → 5,416 W).
- Tùy chọn: quét Pbat theo V_bat ∈ {12,5; 13,0; 13,5; 14,4} V để xem trạng thái tốt nhất có đổi theo điện áp pin không.

---

## 8. ARR-05: bóng di chuyển + thuật toán quét (làm sau khi mục 6 khớp)

Đề xuất, chưa chốt, bên nhận có thể chỉnh nhưng ghi rõ giả thiết đã dùng:

- **Kịch bản bóng:** mép bóng đi từ trái sang phải qua dàn trong 60 s. Tấm bị bóng phủ một phần nhận G tuyến tính giữa 1000 và 300 W/m² theo phần diện tích bị phủ. Thêm một biến thể đi chéo (từ góc trên-trái).
- **Thuật toán cơ bản (giống firmware dự kiến trên ESP32):** cứ mỗi `Tscan` giây, thử lần lượt 16 trạng thái, mỗi trạng thái giữ `t_dwell` rồi đo công suất; giữ trạng thái có công suất lớn nhất đến lần quét sau. Chỉ tiêu đo là Pbat (giả thiết PWM) và làm lại với Pmax (giả thiết MPPT).
- **Tham số quét:** `Tscan` ∈ {5, 10, 30} s; `t_dwell` = 20 ms (MOSFET) và 100 ms (relay); trong lúc chuyển mạch tính công suất = công suất của trạng thái đang thử.
- **Đầu ra:** điện năng thu được trong 60 s cho từng `Tscan`, so với (a) luôn SP, (b) luôn TCT, (c) chọn lý tưởng tức thời (oracle, không mất thời gian quét).
- **Cách làm gợi ý:** chạy tựa tĩnh. Rời rạc thời gian bước 0,5 s, với mỗi G(t) lấy P của 16 trạng thái (từ Simulink qua `parsim`, hoặc model rút gọn đã khớp ở mục 6), rồi mô phỏng thuật toán bằng script trên bảng P(t, s). Chỉ dựng Simulink quá độ (From Workspace cho G, Stateflow cho thuật toán) nếu còn thời gian.

---

## 9. Đầu ra cần gửi lại

1. `pv3x3.slx` và các file `.m` (mục 5), ghi phiên bản MATLAB (`ver`).
2. `arr_summary_simulink.csv` (đúng cột như script; 144 dòng) và `ket-qua-pv3x3.mat`.
3. Bảng so sánh với mục 6.2/6.3: chênh lệch % từng ô, đánh dấu ô > 1 %.
4. Bảng PV-01..04 so với mục 6.1.
5. Đồ thị: I–V và P–V của 1 tấm (PV-02, PV-03); với mỗi ca che bóng, P–V của SP, TCT, BL và trạng thái tốt nhất trên cùng một hình, kẻ vạch dọc tại 13 V.
6. Ảnh chụp model (toàn dàn + bên trong subsystem `PV` + hộp tham số Solar Cell).
7. Nếu làm ARR-05: script, giả thiết đã chọn, bảng điện năng.
8. Ghi chú mọi chỗ phải đổi so với file này (tên block, tham số, cách B thay vì cách A …).

---

## 10. Các mức mô phỏng đã có code (thư mục `pvreconfig-sim/` của repo)

| Mức | Nội dung | Ghi chú |
|---|---|---|
| 1 | Tĩnh: mục 5–6 của file này, kèm ứng suất công tắc (dòng/áp lớn nhất để chọn MOSFET) | Tham chiếu 26 ca: \|I\| max 3,55 A, \|U\| max 7,77 V; 9 ca thường: 2,51 A / 7,58 V |
| 2 | Bóng di chuyển + thuật toán quét / leo đồi, bộ sạc PWM / MPPT / P&O (mở rộng mục 8) | `run_arr05` |
| 3 | Quá độ khi đóng/cắt: tụ tấm, dây, pin 13 V, đóng cùng lúc / lần lượt | `sl_transient_tests`, chỉ Simulink |
| 4 | DES (Ref 3): đổi nhóm từng tấm giữa 3 hàng, chọn theo EI / tham lam / mô hình; model Simulink 54 công tắc | `run_des`, `sl_des_check` |

Chạy tất cả: `run_all` trong `pvreconfig-sim/`. Chi tiết giả thiết và kết quả đã có: README trong thư mục đó.

### 10.1. Kết quả chạy Simulink (13/10/2026, MATLAB R2026b)

Lệnh: các bước trong `sl_run_all`. Log: `pvreconfig-sim/results/matlab_log2.txt`.

| Bước | Kết quả | File |
|---|---|---|
| PV-01..04 (`sl_module_tests`) | **Đạt**: Pmax lệch 0,00 %; bypass −0,552 V ở 2,5 A | `pv_module_simulink.csv` |
| Mức 1: 16 trạng thái × 9 ca (`sl_run_compare`, `sl_compare`) | **Đạt**: lệch Pmax, P@13 V ≤ 0,04 %, số đỉnh khớp | `arr_summary_simulink.csv`, `compare_simulink_vs_ref.csv` |
| Mức 1b: ứng suất công tắc (9 ca) | 2,51 A / 7,58 V, khớp tham chiếu cùng 9 ca | `switch_stress_simulink.csv` |
| Mức 3: quá độ (`sl_transient_tests`) | Đã chạy 7 ca. Đóng 4 công tắc cùng lúc: đỉnh dòng tới 368 A (ca `cheo`), bằng ΔV/Rsw và không phụ thuộc Cpv vì model chưa có điện cảm vòng và thời gian chuyển mạch MOSFET → trường hợp xấu nhất | `transient_simulink.csv`, `fig/transient_*.png` |
| Mức 4: DES (`sl_des_check`) | 9/10 cấu hình đạt. `mot-tam` chia hàng 4-4-1 lệch P@13 V 1,5 % (79,15 so với 80,36 W), Pmax lệch 0,26 %. Nguyên nhân (30/10/2026): R công tắc đóng 1 mΩ trong model, tham chiếu coi lý tưởng; tính lại với 1 mΩ ra 79,19 W | `des_check_simulink.csv` |
| Mức 2: thuật toán theo thời gian | **Chưa chạy** với Simulink (`run_arr05(struct('source','simulink'))`) | |

Sửa code để chạy được trên R2026b (thư mục `simulink/`):
- `sl_conf_solar`: 8 parameter, Is2 = 0, gộp cả tấm.
- `sl_conf_diode`: chuyển block sang biến thể `ee.semiconductors.diodes.physical`, `prmExp = useIsN`.
- `sl_set`: ô popup của block Simscape giờ có Type `string`, giá trị là tên enum đầy đủ (`ee.enum....`) → chọn theo tên thành viên enum.
- `sl_simlog_on` (mới): `SimscapeLogType` chỉ đặt được khi model đã có block Simscape → gọi lúc lưu và trước `sim`.
- `sl_log_v` (mới): Solar Cell không log biến `v`, lấy `p.v − n.v`.
- `sl_config`: `cfg.parallel = false`. `parsim` với 6 worker làm treo máy; chạy tuần tự mức 1 mất ~13 phút.

Mô hình 3D tương tác (4 công tắc + DES 54 công tắc): `pv3x3-3d.html` ở thư mục gốc repo.

---

## 11. Việc còn mở (không chặn mô phỏng)

- ST-S1230 là PWM hay MPPT; giới hạn V_oc và dòng PV đầu vào (thông tin sơ bộ: ~50 V).
- Datasheet/số đo thật của tấm TEKI 6 V/15 W → thay Isc, Voc, trích lại tham số mục 2.1.
- Mẫu công tắc chính xác của BL và HC cho dàn 3 cột (hiện `1001` và `0110?`).
- Loại công tắc trên PCB (MOSFET back-to-back hay relay) → R_closed và t_dwell.
- DES `mot-tam` hàng 4-4-1: Simulink lệch tham chiếu 1,5 % tại 13 V. Đã rõ (30/10/2026): do R công tắc 1 mΩ; cần thêm R công tắc vào tham chiếu DES.
- Nhiệt độ tấm: kết quả 13 V đổi khi tấm nóng (xem `pvreconfig-sim/README.md`, mục nhiệt độ). Cần đo Voc và nhiệt độ tấm thật.
- Quá độ: thêm điện cảm vòng và thời gian chuyển mạch MOSFET thật để có đỉnh dòng thực tế.
