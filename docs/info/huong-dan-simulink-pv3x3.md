# Hướng dẫn mô phỏng dàn PV 3 × 3 trên MATLAB/Simulink

> **Mục tiêu:** dựng mô hình Simulink của dàn 9 tấm 6 V/15 W với 4 công tắc nối chéo S1–S4 (đúng như PCB trong báo cáo, Hình 4.1), quét đường I–V/P–V cho từng trạng thái công tắc dưới các ca che bóng, rồi so công suất giữa SP / TCT / BL / HC.
> **Liên quan:** [phạm vi & bảng cấu hình](qa2.md) · [lý thuyết reconfiguration](core-pv-reconfig.md) · báo cáo `report/proposal/chapters/05-cau-hinh-pv-3x3.tex`, `06-ke-hoach-mo-phong.tex`.

---

## 0. Cần cài gì

| Thành phần | Dùng để |
|---|---|
| MATLAB | chạy script |
| Simulink | môi trường sơ đồ khối |
| Simscape | mạng điện vật lý (nút, dây, nguồn, công tắc) |
| Simscape Electrical | block **Solar Cell** |

Gõ `ver` trong MATLAB để xem đã có đủ 4 dòng trên chưa. MATLAB Online (https://matlab.mathworks.com) có toolbox nào là tùy license của tài khoản.

Không có Simulink thì vẫn làm được mô hình bằng script `.m` thuần (giải phương trình một diode), chạy cả trên GNU Octave. Xem mục 7.

---

## 1. Ý tưởng mô hình

```
        + ─────┬──────────┬──────────┬───── (+) ra tải quét
               │          │          │
             PV11       PV12       PV13
               │          │          │
     nút 1:    ●──S1──────●──S2──────●
               │          │          │
             PV21       PV22       PV23
               │          │          │
     nút 2:    ●──S3──────●──S4──────●
               │          │          │
             PV31       PV32       PV33
               │          │          │
        − ─────┴──────────┴──────────┴───── (−)
```

- Mỗi cột luôn là **3 tấm nối tiếp**, đấu cứng. Chỉ S1–S4 thay đổi.
- `S = [0 0 0 0]` → **SP**; `S = [1 1 1 1]` → **TCT**; các tổ hợp còn lại → nối chéo một phần (BL, HC…). Mẫu S cụ thể của BL/HC lấy theo Fig. 4 của Ref 3 ([hình](../references/extracted/03-pv-reconfig/images/p06-img01-x157.png)). Ta quét đủ **16 trạng thái**, nên dù gán nhãn thế nào cũng không bỏ sót trạng thái nào.
- Mỗi tấm có **diode bypass** mắc ngược song song. Thiếu diode này thì khi một tấm bị che, cả cột bị “bóp” dòng, solver dễ lỗi, và kết quả không giống thực tế.
- Đầu ra nối với **nguồn áp điều khiển** quét từ 0 V đến quá V_oc của dàn. Đo dòng ở mỗi điểm sẽ cho đường I–V, từ đó tính P = V·I.

---

## 2. Dựng một tấm pin (subsystem `PV`)

1. Gõ `ssc_new` để tạo model Simscape trống, đã có sẵn Solver Configuration và Electrical Reference. Lưu tên `pv3x3.slx`.
2. Thả các block (dùng Library Browser hoặc gõ tên trên canvas):
   - **Solar Cell** (Simscape › Electrical › Sources).
   - **Diode**: mắc song song với Solar Cell, **ngược chiều**: anode nối cực − của tấm, cathode nối cực +.
   - **Simulink-PS Converter**: đưa bức xạ (số Simulink) vào cổng `Ir` của Solar Cell. Đặt *Input signal unit* = `W/m^2`.
3. Tham số Solar Cell cho tấm 6 V/15 W (giả thiết hiện tại, thay bằng datasheet khi có):

   | Tham số | Giá trị | Ghi chú |
   |---|---|---|
   | Parameterize by | theo Isc và Voc (tên mục khác nhau tùy phiên bản) | |
   | Short-circuit current Isc | `2.75` A | |
   | Open-circuit voltage Voc | `0.6` V | **của 1 cell** |
   | Number of series cells | `12` | 12 × 0,6 = 7,2 V cho cả tấm |
   | Irradiance used for measurements Ir0 | `1000` W/m² | |

   Theo tài liệu MathWorks, khi *Number of series cells* > 1, block vẫn giải phương trình cho **1 cell** rồi nhân điện áp lên. Vì vậy Voc nhập là giá trị của 1 cell. **Kiểm chứng:** chạy riêng 1 tấm ở 1000 W/m² (ca PV-01). Đo hở mạch phải ra ≈ 7,2 V. Nếu ra ≈ 86 V tức là đang nhập theo cả tấm; khi đó sửa lại.
4. Gom 3 block trên thành **Subsystem** (chọn → Ctrl+G), đặt tên `PV`. Subsystem có 2 cổng điện (`+`, `−`) và 1 cổng vào Simulink `G`.

---

## 3. Dựng dàn 3 × 3 và 4 công tắc

1. Copy subsystem `PV` ra 9 bản, đặt tên `PV11 … PV33` (hàng–cột).
2. Mỗi cột nối tiếp: `−` của PV1c nối `+` của PV2c; `−` của PV2c nối `+` của PV3c. Các nút này là **nút 1** và **nút 2** trên sơ đồ.
3. `+` của PV11, PV12, PV13 chập chung làm **bus +**; `−` của PV31, PV32, PV33 chập chung làm **bus −**. Nối bus − với **Electrical Reference**.
4. Công tắc: 4 block **Switch** (Simscape › Foundation › Electrical › Electrical Elements). Đây là công tắc điều khiển bằng tín hiệu vật lý: đóng khi tín hiệu > *Threshold* (để 0.5).
   - S1: nút 1 cột 1 ↔ nút 1 cột 2 · S2: nút 1 cột 2 ↔ nút 1 cột 3
   - S3: nút 2 cột 1 ↔ nút 2 cột 2 · S4: nút 2 cột 2 ↔ nút 2 cột 3
   - Điều khiển: block **Constant** giá trị `S(1)` … `S(4)` → Simulink-PS Converter → cổng điều khiển của Switch.
   - Để mặc định *Closed resistance* (nhỏ) và *Open conductance* (rất nhỏ). Sau này có thể đặt *Closed resistance* bằng R_DS(on) của 2 MOSFET đấu ngược để tính tổn hao công tắc.
5. Bức xạ: 9 block **Constant** `G(1,1)`, `G(1,2)`, … `G(3,3)` đưa vào cổng `G` của từng tấm. `G` là ma trận 3 × 3 sẽ được đặt từ script.

---

## 4. Tải quét I–V và đo

1. **Controlled Voltage Source** (Foundation › Electrical › Electrical Sources): `+` nối bus +, `−` nối bus −. Ngõ điều khiển lấy từ block **Ramp** (Simulink), slope = `Vmax`, start time 0 → Simulink-PS Converter (unit `V`).
2. **Current Sensor** mắc nối tiếp giữa bus + và nguồn. **Voltage Sensor** mắc giữa bus + và bus −. Mỗi sensor đi qua **PS-Simulink Converter** rồi vào block **To Workspace**, đặt tên biến `Vpv`, `Ipv`, *Save format* = `Array`.
3. Chiều dòng: dàn **phát** điện thì dòng chảy ra ở bus +. Script ở mục 5 tự chuẩn hóa dấu, không cần lật sensor. Khi V vượt V_oc, dòng đổi chiều (dàn hấp thụ điện), nên **không được** lấy `abs()`.
4. Cấu hình solver (Model Settings › Solver): variable-step, `ode23t` (hoặc `daessc` nếu có), *Max step size* = `1e-3`, *Stop time* = `1`. Ramp chạy từ 0 đến `Vmax` trong 1 s ảo; dàn không có tụ nên quét thế này coi như tĩnh.
5. Đặt `Vmax = 24` (lớn hơn V_oc dàn 21,6 V).

---

## 5. Script quét 16 trạng thái × các ca che bóng

Lưu thành `sim/run_pv3x3.m` cạnh model:

```matlab
mdl = 'pv3x3';
load_system(mdl);
Vmax = 24;                      % V, > Voc của dàn
Vbat = 13.0;                    % V, điểm làm việc nếu ST-S1230 là PWM

states = dec2bin(0:15) - '0';   % 16 x 4, cột = [S1 S2 S3 S4]
cases  = pv_shading_cases();    % xem bên dưới

nC = numel(cases);  nS = size(states,1);
Pmax = zeros(nC,nS);  Pbat = zeros(nC,nS);

for k = 1:nC
    for s = 1:nS
        in = Simulink.SimulationInput(mdl);
        in = in.setVariable('G', cases(k).G);
        in = in.setVariable('S', states(s,:));
        in = in.setVariable('Vmax', Vmax);
        out = sim(in);
        V = out.Vpv(:);  I = out.Ipv(:);
        I = I * sign(I(1));        % dòng gần ngắn mạch phải dương; KHÔNG dùng abs()
        P = V .* I;                % P < 0 khi V > Voc, không ảnh hưởng max
        [V, iu] = unique(V);  P = P(iu);
        Pmax(k,s) = max(P);
        Pbat(k,s) = interp1(V, P, Vbat);
    end
    [best, sBest] = max(Pmax(k,:));
    fprintf('%-14s  SP=%6.1f W  TCT=%6.1f W  best=%6.1f W (S=%s)\n', ...
        cases(k).name, Pmax(k,1), Pmax(k,16), best, num2str(states(sBest,:)));
end
save('ket-qua-pv3x3.mat', 'cases', 'states', 'Pmax', 'Pbat');
```

Lưu ý: `states(1,:) = [0 0 0 0]` là SP và `states(16,:) = [1 1 1 1]` là TCT. Có Parallel Computing Toolbox thì thay vòng lặp trong bằng một mảng `SimulationInput` rồi gọi `parsim` để chạy nhanh hơn.

`sim/pv_shading_cases.m`: các mẫu che theo Ref R2/R3 trong [references](../references/references.md). Giá trị G tính bằng W/m², hàng 1 là hàng trên cùng.

```matlab
function c = pv_shading_cases()
    S = 300;  F = 1000;                         % bị che / nắng đủ
    c(1).name = 'deu';        c(1).G = F*ones(3);
    c(2).name = 'mot-tam';    c(2).G = F*ones(3); c(2).G(2,2) = S;
    c(3).name = 'hang-1';     c(3).G = F*ones(3); c(3).G(1,:) = S;
    c(4).name = 'cot-1';      c(4).G = F*ones(3); c(4).G(:,1) = S;
    c(5).name = 'cheo';       c(5).G = F*ones(3) - (F-S)*eye(3);
    c(6).name = 'goc-2x2';    c(6).G = F*ones(3); c(6).G(1:2,1:2) = S;
    rng(1);
    c(7).name = 'ngau-nhien'; c(7).G = round(S + (F-S)*rand(3));
end
```

Mẫu ARR-05 (bóng di chuyển) làm sau. Cách làm: cho G thay đổi theo thời gian bằng các block **From Workspace** thay cho Constant, rồi mô phỏng thuật toán quét chọn trạng thái theo chu kỳ.

---

## 6. Kiểm tra kết quả có hợp lý không

| Ca | Phải thấy | Nếu không thấy |
|---|---|---|
| PV-01 (1 tấm, 1000 W/m²) | Voc ≈ 7,2 V, Isc ≈ 2,75 A, Pmax ≈ 15 W | Sai tham số Solar Cell (mục 2.3) |
| ARR-01 `deu` | 16 trạng thái **cùng** ≈ 135 W (chênh lệch nhỏ do tham số) | Đấu sai cột/nút, hoặc công tắc đóng sai chỗ |
| `mot-tam`, `hang-1`, `cot-1`… | Đường P–V có nhiều đỉnh; các trạng thái bắt đầu khác nhau | Thiếu diode bypass, hoặc diode lắp ngược chiều |
| Mọi ca | Pmax ≤ tổng công suất 9 tấm ở bức xạ tương ứng | Sai dấu dòng hoặc đơn vị bức xạ |

Kết quả cần đưa vào báo cáo: bảng `Pmax` và `Pbat` (ca × cấu hình), mức tăng so với SP `(P − P_SP)/P_SP`, và đồ thị P–V của SP vs TCT vs trạng thái tốt nhất cho từng ca.

---

## 7. Lỗi hay gặp

- **“Each physical network must have a Solver Configuration” / thiếu Electrical Reference**: mỗi mạng Simscape cần đúng 1 Solver Configuration và ít nhất 1 Electrical Reference.
- **Solver không hội tụ khi che bóng**: kiểm tra diode bypass; giảm *Max step size*; thử `daessc`.
- **Cảnh báo đơn vị ở Simulink-PS Converter**: đặt unit đúng (`W/m^2` cho bức xạ, `V` cho ramp, `1` cho tín hiệu công tắc).
- **Hở mạch ra ~86 V**: Voc đang bị nhập theo cả tấm trong khi đã đặt 12 cell (xem mục 2.3).

---

## 8. Cách không cần Simulink (mô hình tham chiếu)

Đã làm trong `pvreconfig-sim/reference/`: `pv_module_current.m` giải phương trình một diode cho 1 tấm, có diode bypass; `pv_array_iv.m` giải hệ phương trình nút cho mọi trạng thái công tắc, kể cả nối chéo một phần. Chạy bằng MATLAB lõi, dùng để **đối chiếu** với Simulink (`sl_compare`).

Dự án không dùng Octave nữa (từ 12/10/2026); thư mục `.octave/` đã xoá ngày 30/10/2026.

*Nguồn tham số block:* [MathWorks — Solar Cell block](https://au.mathworks.com/help/sps/ref/solarcell.html).

*Cập nhật: 2026-10-05.*
