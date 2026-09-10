# Core — Mô hình hoá tấm pin PV & mô phỏng trên Proteus

> **Cái gì:** cách mô tả tấm pin mặt trời bằng toán (single-diode model) rồi dựng lại trong Proteus để vẽ đường **I–V / P–V** dưới mọi điều kiện bức xạ G và nhiệt độ T — **trước khi** làm phần cứng.
> **Tại sao quan trọng với đồ án:** thầy chốt dùng **Proteus** mô phỏng cả BMS lẫn tấm pin ([`qa1.md`](qa1.md) §A4). Đây là khuôn mẫu PV.
> **Nguồn chính:** Ref 1 — Yaqoob et al. 2022 ([`../references/extracted/01-pv-proteus/01-pv-proteus.md`](../references/extracted/01-pv-proteus/01-pv-proteus.md)).
> Liên quan: [[core-partial-shading]] · [[core-pv-reconfig]] · [[core-iot-monitoring]]

---

## 1. Viết tắt (abbreviation) dùng trong phần này

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **PV** | Photovoltaic | Tấm/pin quang điện, biến ánh sáng → điện DC. |
| **I–V curve** | Current–Voltage | Đường dòng theo áp của tấm pin. |
| **P–V curve** | Power–Voltage | Đường công suất theo áp; có 1 đỉnh = MPP. |
| **MPP** | Maximum Power Point | Điểm công suất cực đại; P_MPP = V_MPP × I_MPP. |
| **STC** | Standard Test Conditions | **G = 1000 W/m², T = 25 °C (298.15 K)** — điều kiện chuẩn. |
| **G** | Irradiance | Bức xạ mặt trời [W/m²]. |
| **V_OC** | Open-Circuit Voltage | Áp hở mạch (I = 0). |
| **I_SC** | Short-Circuit Current | Dòng ngắn mạch (V = 0). |
| **I_PH** | Photo-generated current | Dòng quang sinh — "lõi" phát điện của tấm pin. |
| **I_D** | Shockley diode current | Dòng qua diode trong mô hình. |
| **I_O / I_S** | (Reverse) saturation current | Dòng bão hoà ngược của diode. |
| **I_RSH** | Shunt-resistor current | Dòng rò qua R_SH. |
| **R_S** | Series resistance | Điện trở nối tiếp (tổn hao dây/tiếp xúc). |
| **R_SH** | Shunt resistance | Điện trở song song (mô tả dòng rò). |
| **N_S** | Number of series cells | Số cell nối tiếp trong tấm. |
| **K_I** | Temperature-current coeff. | Hệ số nhiệt–dòng [A/°C]. |
| **K_V** | Voltage-temperature coeff. | Hệ số áp–nhiệt [V/°C]. |
| **α** | Ideality factor | Hệ số lý tưởng của diode. |
| **K** | Boltzmann constant | 1.380653 × 10⁻²³ J/K. |
| **q** | Electron charge | 1.60217646 × 10⁻¹⁹ C. |
| **AVCVS / AVCCS** | Arbitrary Voltage-Controlled Voltage/Current Source | Linh kiện Proteus để dựng phương trình PV (Ref 1, Trang 6). |
| **MD(I)/MD(P)** | Maximum Difference in current/power | Sai số lớn nhất tại MPP (Ref 1 dùng để đánh giá độ chính xác). |

(Danh mục đầy đủ toàn đề tài: [`glossary.md`](glossary.md).)

---

## 2. Mô hình single-diode (mạch tương đương 1 diode)

Tấm pin ≈ diode P–N phơi sáng. Dòng ra tổng tính theo định luật Kirchhoff dòng (Ref 1, Eq 1, Trang 3):

```
I = I_PH − I_D − I_RSH
```

Mạch tương đương: nguồn dòng I_PH // diode // R_SH, nối tiếp R_S ra tải.
→ Xem **Fig. 1** (Ref 1, Trang 3): [`../references/extracted/01-pv-proteus/images/p03-img01-x37.jpeg`](../references/extracted/01-pv-proteus/images/p03-img01-x37.jpeg)

### Các thành phần (Ref 1 §2.1–2.3)

**Dòng quang sinh** — tỉ lệ thuận G, hiệu chỉnh theo nhiệt (Eq 2):
```
I_PH = (I_SC − K_I·(T − T_STC)) · G / G_STC
```
Tại STC: `I_PH,STC ≈ I_SC`.

**Dòng bão hoà** (Eq 3) và **dòng diode** (Eq 4):
```
I_O = (I_SC + K_I·(T−T_STC)) / ( exp( q·(V_OC + K_V·(T−T_STC)) / (α·K·N_S·T_c) ) − 1 )
I_D = I_O · ( exp( q·(V + I·R_S) / (α·K·N_S·T) ) − 1 )
```

**Dòng rò qua shunt** (Eq 5):
```
I_RSH = (V + I·R_S) / R_SH
```

**Phương trình tổng cuối cùng** (Ref 1, Eq 6), với `A = α·K·N_S / q`:
```
I = I_PH − I_S·( exp[ (V + I·R_S) / (A·T) ] − 1 ) − (V + I·R_S) / R_SH
```

### Ảnh hưởng của tham số lên đường I–V (Ref 1 §3.2, Trang 5)
- **R_SH ↓** → đổi **độ dốc** phần trên (vùng nguồn dòng) tới MPP.
- **R_S ↑** → đổi hình phần dưới (vùng nguồn áp) và sau MPP.
- **α** → ảnh hưởng vùng **"knee"** (đầu gối) của đường I–V.
- Ảnh hưởng này rõ ở **G thấp / T cao**; ở G cao thì nhỏ.

### Ảnh hưởng môi trường (quy tắc cần nhớ)
- **G tăng** → I_PH tăng gần **tuyến tính** → dòng (và công suất) tăng mạnh.
- **T tăng** → I_SC tăng nhẹ nhưng **V_OC giảm mạnh** → công suất **giảm**. (Cùng kết luận ở Ref 3 §2.1–2.2.)

---

## 3. Dựng mô hình trong Proteus (Ref 1 §3.3, Trang 6)

**2 bước:** (1) trích tham số ẩn R_S, R_SH, I_O,STC, α (Ref 1 dùng *PV array tool* của MATLAB — Fig. 2, Trang 4); (2) dựng Eq (2)–(6) bằng **component mode** trong thư viện Proteus.

Mô hình chia **6 block**: (1) I_PH, (2) I_O, (3) I_D, (4) I_RSH, (5) tổng dòng PV → đưa vào **AVCCS**, (6) tham số datasheet.

**Các bước thao tác trong Proteus (nguyên văn Ref 1):**
1. Mở Schematic Capture → Component Mode → Pick Devices.
2. Mở **Laplace Primitives** → thêm toán tử Addition / Subtraction / Multiplication / Division.
3. Thêm **AVCVS** và **AVCCS** từ "Modeling Primitives".
4. Dùng **DC Generator** đặt giá trị datasheet; nối đầu ra PV với **bypass diode** + **tải điện trở biến thiên**.
5. Dùng **DC Voltage Source** làm tải biến thiên (0 < V < V_OC) để quét trục áp.
6. Dùng **DC SWEEP ANALYSIS** để vẽ **I–V** và **P–V**.

Kết quả gói thành **sub-circuit**: 2 input (G, T) + 2 output (±). Xem sơ đồ mô phỏng Fig. 5–7 (Trang 5–6).

**Lợi thế Proteus so với MATLAB/PSIM (lý do thầy chọn):** chứa sẵn **Arduino/PIC/FPGA** → test luôn thuật toán (MPPT, sun-tracker…) trên cùng môi trường, không phải viết lại code khi sang phần cứng (Ref 1, Trang 3).

---

## 4. Thông số 2 tấm pin mẫu (Ref 1, Table 1–2, Trang 4)

| Tham số | KC200GT (multi) | SM55 (mono) |
|---|---|---|
| P_MPP | 200 W | 55 W |
| V_MPP / I_MPP | 26.3 V / 7.61 A | 17.4 V / 3.15 A |
| V_OC / I_SC | 32.9 V / 8.21 A | 21.7 V / 3.45 A |
| K_V / K_I | −0.123 V/°C / 0.0032 A/°C | −0.077 V/°C / 0.0012 A/°C |
| N_S | 54 | 36 |
| R_S (trích) | 0.335 Ω | 0.528 Ω |
| R_SH (trích) | 159.72 Ω | 134.64 Ω |
| α (trích) | 1.0015 | 0.9645 |

Độ chính xác: Ref 1 so với datasheet/PVsyst/Villalva/Chalh, sai số MD(I) cỡ vài chục mA, MD(P) ~0.3–2 W — **chấp nhận được** (Table 3–8). Điểm mạnh: chạy được cả khi **T thay đổi** (model Chalh fail khi T≠25°C).

---

## 5. Áp dụng vào đồ án
- **Ở proposal (bắt buộc):** nêu **phương pháp** mô phỏng PV trên Proteus theo khuôn Ref 1 (6 block, AVCVS/AVCCS, DC sweep). Chưa cần chạy xong schematic đầy đủ ([`../plan/proposal.md`](../plan/proposal.md) A1, checklist 4).
- **Thông số pin của nhóm chưa chốt** → tạm lấy 1 tấm mẫu (SM55 đơn giản) để minh hoạ; chốt sau khi có BOM ([[core-pv-reconfig]] B3).
- Đường I–V/P–V mô phỏng là **đầu vào** để hiểu shading ([[core-partial-shading]]) và reconfiguration ([[core-pv-reconfig]]).

## 6. Còn mở / cần tự tìm thêm
- Proteus **không có** tấm pin sẵn → phải tự dựng bằng phương trình (đúng như Ref 1). Cần thử trong Proteus bản nhóm đã cài.
- Trích tham số ẩn (R_S, R_SH, α, I_O): Ref 1 dùng MATLAB PV array tool — nhóm cần cách thay thế nếu không dùng MATLAB (tự giải từ datasheet, hoặc lấy tham số công bố).

*Cập nhật: 2026-09-10.*
