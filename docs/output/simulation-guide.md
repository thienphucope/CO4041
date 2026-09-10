# Hướng dẫn dựng mô phỏng Proteus — PV + BMS

> Đề tài: **Microgrid năng lượng mặt trời chi phí tối ưu + IoT** (HK261-DAGD1-133).
> File này hướng dẫn **dựng được từng bước** 2 mô phỏng Proteus mà thầy chốt: **(1) tấm pin (PV)** và **(2) chức năng BMS**.
> Nguồn tham chiếu: [`../references/refs-extract.md`](../references/refs-extract.md) (Ref 1 = PV Proteus, Ref 2 = BMS+IoT) · Q&A thầy: [`../info/qa1.md`](../info/qa1.md) · Report nộp: [`proposal.md`](proposal.md).

---

## 0. Chuẩn bị

- **Phần mềm:** Proteus 8.x (Professional). Cần module **Proteus VSM** để mô phỏng chạy có tương tác.
- **Bạn sẽ tạo 2 file `.pdsprj` riêng:**
  - `pv-model.pdsprj` — mô phỏng tấm pin, vẽ đường I–V / P–V.
  - `bms-sim.pdsprj` — mô phỏng 4 chức năng BMS (SoC, nhiệt độ, cân bằng cell, bảo vệ).
- **Linh kiện sẽ dùng** (gõ tên trong *Pick Devices* — phím `P`): `ARDUINO UNO`/`ARDUINO NANO`, `LM35`, `LM016L` (LCD), `RES`, `POT-HG`, `CAP`, `IRLZ44N`/`IRLR7843` (MOSFET), `1N4007`, `LED`, `RELAY`, `LM358` (op-amp/comparator), `AVCVS`/`AVCCS` (cho PV). `INA219` có thể **không có sẵn** → xem mục 2.2 (có phương án thay thế không cần thư viện).
- **Mẹo:** để mô phỏng Arduino chạy, cần nạp file `.hex` (biên dịch từ Arduino IDE) vào thuộc tính *Program File* của con Arduino trong Proteus.

> ⚠️ **Proteus không có model pin sạc thật.** Cách chuẩn (Ref 2 & nhóm khoá trước cũng làm vậy): **giả lập cell bằng tụ điện dung lượng lớn (10–50F)** đã nạp sẵn điện áp (đặt *Initial Voltage* trong thuộc tính tụ). Nạp/xả tụ = mô phỏng sạc/xả pin. Hệ quả: **SoC suy từ áp tụ ≠ SoC pin thật** → đây chính là lý do ta làm SoC bằng *coulomb counting* (mục 2.4d).

### 0.1. Nếu dùng bản Proteus DEMO (không lưu / không xuất file)

Bản demo **chặn Save · Export · Print** và **thường chặn nạp `.hex`** tự biên dịch vào MCU. Ảnh hưởng:

- **Phần analog CHẠY ĐƯỢC** (tấm pin, comparator, relay, cảm biến, MOSFET) → mô phỏng + **chụp màn hình** thoải mái.
- **Phần cần Arduino + firmware** (SoC coulomb counting, cân bằng bằng MCU) **có thể không chạy** trong demo.
- Không lưu được → **dựng xong chụp ngay trong MỘT lần mở, đừng đóng file.**

**→ Cách né cho mốc 2 tuần (dựng nhanh, chụp được):** đủ cho báo cáo tiến độ — thầy chỉ cần *chạy + hình*, không cần xuất file.

1. **Tấm pin (mục 1)** — chạy full, không firmware → chụp **I–V/P–V**. Nhanh nhất.
2. **Bảo vệ + nhiệt độ bằng COMPARATOR (`LM393`/`LM358`), KHÔNG dùng MCU** → áp cell / nhiệt (LM35) vượt ngưỡng đặt bằng biến trở → comparator lật → **relay/LED ngắt**. Chạy được trong demo, chụp cảnh ngắt. *(bản comparator này thay cho phần bảo vệ dùng MCU ở mục 2.4d — dùng khi demo không nạp được hex.)*
3. **SoC + cân bằng cell (cần MCU)** — chụp **schematic tĩnh + giải thích logic** (firmware ở mục 2.4), để chạy thật khi có Proteus đầy đủ / sau mốc proposal.

> 💡 Ước tính: bước 1 + 2 khoảng **nửa ngày** là có ảnh "chạy thật" cho báo cáo.

---

## 1. FILE 1 — Mô phỏng tấm pin (PV)

Mục tiêu: cho ra **đường I–V và P–V**, đổi được **bức xạ G** và **nhiệt độ T** (theo **Ref 1**).

### 1.1. Cách A — nhanh (nếu thư viện có sẵn `PVPANEL`/`SOLAR CELL`)

1. `P` → gõ `PVPANEL` (hoặc `SOLAR CELL`). Nếu có, đặt vào bản vẽ (PV1).
2. Nối **tải biến thiên**: một `POT-HG` (biến trở) nối qua 2 cực PV.
3. Gắn **DC Voltmeter** song song tải (đo V) và **DC Ammeter** nối tiếp (đo I).
4. Chỉnh nút bức xạ (W/m²) của PVPANEL ở vài mức: 400, 700, 1000.
5. Vặn biến trở từ 0→max, ghi từng cặp (V, I) → lập bảng → vẽ **I–V** (và P = V×I → **P–V**) bằng Excel.

> Nhược điểm: PVPANEL là "hộp đen", không đổi được nhiệt độ, và **không có trong nhiều bản Proteus**. Nếu không tìm thấy → dùng Cách B.

### 1.2. Cách B — chuẩn học thuật theo Ref 1 (không cần thư viện đặc biệt)

Dựng **mô hình 1 diode**: `I = I_PH − I_D − I_RSH`, trong đó
`I_D = I_O·(exp(q·(V+I·R_S)/(n·k·T)) − 1)` và `I_RSH = (V + I·R_S)/R_SH`.

**Các bước:**

1. **Lấy tham số tấm pin** từ datasheet (vd **KC200GT** hoặc **SM55** như Ref 1): `I_SC`, `V_OC`, `I_MPP`, `V_MPP`, số cell nối tiếp `N_s`, hệ số nhiệt. Rồi trích `R_S`, `R_SH`, `I_O`, hệ số lý tưởng `n` bằng **PV Array tool của MATLAB/Simulink** (Ref 1 làm đúng bước này) — hoặc lấy bộ tham số mẫu có sẵn trong Ref 1.
2. Trong Proteus, `P` → thêm các khối toán **Laplace Primitives** (`ADDER`, `SUBTRACTOR`, `MULTIPLIER`, `DIVIDER`) và nguồn điều khiển **AVCVS** (nguồn áp) / **AVCCS** (nguồn dòng).
3. Dựng lần lượt 3 dòng: `I_PH` (phụ thuộc **G** và **T**), `I_D` (hàm mũ theo V, T), `I_RSH`. Ghép lại thành `I = I_PH − I_D − I_RSH` bằng khối trừ, đưa ra một **AVCCS** = dòng tấm pin.
4. Đặt **G** và **T** bằng 2 **DC Generator** (2 núm chỉnh) để đổi bức xạ & nhiệt độ khi mô phỏng.
5. Nối đầu ra PV qua **bypass diode** (`1N4007`) + **tải biến thiên**.
6. Chạy **DC Sweep Analysis** (Graph Mode → *DC Sweep*): quét điện áp tải 0→V_OC, trục Y = I và P → Proteus **tự vẽ I–V và P–V**.
7. **Kiểm chứng:** đổi G (1000→700→400) đường cong tụt xuống; tăng T thì V_OC giảm. So với datasheet → sai số nhỏ = đạt.

> **Bằng chứng "chạy đúng":** có đồ thị I–V và P–V; đỉnh P–V = **MPP**; tăng nắng → dòng tăng; tăng nhiệt → áp giảm.

### 1.3. Mở rộng shading (không bắt buộc GĐ1)

Ref 1 chỉ mô phỏng **1 tấm**. Muốn thử **bóng râm / reconfiguration** thì nhân bản mô hình thành dàn (mỗi tấm 1 giá trị G khác nhau) — nhưng phần *reconfiguration* thầy chỉ dặn **tìm hiểu**, và nếu mô phỏng chạy thì công cụ tự nhiên là **MATLAB–Simulink** (Ref 3), không phải Proteus.

---

## 2. FILE 2 — Mô phỏng chức năng BMS

Mục tiêu: minh hoạ **4 chức năng** thầy chốt chạy đúng: **SoC · nhiệt độ · cân bằng cell · bảo vệ**.

### 2.1. Bản tối thiểu vs bản đầy đủ

| Mức | Số cell | Chứng minh được | Dùng khi |
|---|---|---|---|
| **Tối thiểu** | 1 cell (1 tụ) | SoC, nhiệt độ, bảo vệ OV/UV | Lấy ảnh nhanh cho báo cáo |
| **Đầy đủ** | 2–4 cell (2–4 tụ) | thêm **cân bằng cell** | sau mốc proposal |

> Cân bằng cell cần **≥2 cell**. Báo cáo 2 tuần: dựng **bản tối thiểu 1 cell** là đủ gây ấn tượng; bản 4 cell để sau mốc proposal.

### 2.2. Danh sách linh kiện (bản đầy đủ 4 cell)

| Linh kiện | Số lượng | Vai trò |
|---|---|---|
| `ARDUINO UNO` (hoặc NANO) | 1 | Bộ não: đọc cảm biến, ra quyết định, in LCD |
| `CAP` 10–50F (đặt Initial Voltage) | 4 | Giả lập 4 cell nối tiếp |
| `RES` (cặp phân áp, vd 10k/10k) | 4 cặp | Đo áp từng cell → ADC (chia áp cho ≤5V) |
| `RES` shunt 0.1Ω | 1 | Đo dòng pack (qua sụt áp) |
| `LM358` (op-amp) | 1 | Khuếch đại áp shunt cho ADC |
| `LM35` | 1 | Đo nhiệt độ pack |
| `IRLZ44N`/`IRLR7843` (MOSFET) | 1 (charge) + 1 (discharge) | Đóng/cắt bảo vệ |
| `RES` 33Ω + `IRLZ44N` | 4 bộ | Điện trở xả + MOSFET **cân bằng** mỗi cell |
| `LM016L` (LCD 16×2) | 1 | Hiển thị SoC/áp/nhiệt/trạng thái |
| `LED` + `RES` | vài | Báo trạng thái sạc/xả/lỗi |

> **INA219** (đo V–I–P sẵn qua I²C) tiện nhưng **có thể thiếu trong thư viện Proteus**. Bản trên dùng **cầu phân áp + shunt + op-amp** — thuần linh kiện cơ bản, **chắc chắn dựng được**. Nếu máy bạn có thư viện INA219 thì thay cụm shunt+op-amp bằng nó cho gọn.

### 2.3. Nối dây theo từng chức năng

- **Đo áp cell:** mỗi cell → **cầu phân áp** (chia đôi áp) → 1 chân **Analog In** của Arduino (`A0..A3`).
- **Đo dòng:** dòng pack qua **shunt 0.1Ω** → sụt áp nhỏ → `LM358` khuếch đại ×~20 → chân `A4`.
- **Đo nhiệt:** `LM35` (10mV/°C) → chân `A5`.
- **Bảo vệ:** 2 MOSFET nối tiếp ở **đường âm** của pack (charge FET + discharge FET), cổng (gate) nối 2 chân Digital của Arduino (`D2`, `D3`).
- **Cân bằng:** mỗi cell có **điện trở xả 33Ω nối tiếp MOSFET**, gate nối 1 chân Digital (`D4..D7`); bật = xả bớt cell đó.
- **LCD:** nối 6 dây song song (RS,E,D4..D7) vào `D8..D13`, hoặc qua `PCF8574` nếu muốn I²C.

### 2.4. Firmware Arduino (khung — biên dịch ra `.hex` nạp vào Proteus)

```cpp
// BMS 4 chức năng — khung mô phỏng Proteus (Arduino UNO/NANO)
// Biên dịch trong Arduino IDE -> lấy .hex -> nạp vào thuộc tính Program File của Arduino trong Proteus.
#include <LiquidCrystal.h>
LiquidCrystal lcd(8, 9, 10, 11, 12, 13); // RS,E,D4,D5,D6,D7

// ==== HẰNG SỐ HIỆU CHỈNH (calib theo mạch/pin thật) ====
const float VREF      = 5.0;      // áp tham chiếu ADC
const float DIV_GAIN  = 2.0;      // hệ số cầu phân áp (10k/10k -> chia 2)
const float SHUNT_OHM = 0.1;      // điện trở shunt
const float AMP_GAIN  = 20.0;     // hệ số khuếch đại op-amp cho shunt
const float CAP_MAX_V = 3.65;     // áp cell đầy (LiFePO4)
const float CAP_MIN_V = 2.50;     // áp cell cạn
const float CAPACITY_AH = 15.0;   // dung lượng danh định
// Ngưỡng bảo vệ
const float OV = 3.65, UV = 2.50; // quá/thấp áp cell (V)
const float OC = 15.0;            // quá dòng (A)
const float OT = 55.0;            // quá nhiệt (°C)
const float BAL_START = 3.40, BAL_DELTA = 0.03; // bắt đầu cân bằng

const uint8_t CELL_PIN[4] = {A0, A1, A2, A3};
const uint8_t BAL_PIN[4]  = {4, 5, 6, 7};
const uint8_t CHG_FET = 2, DSG_FET = 3;

float soc = 100.0;                // % — coulomb counting
unsigned long tPrev;

float readV(uint8_t pin, float gain) { return analogRead(pin) * VREF / 1023.0 * gain; }

void setup() {
  lcd.begin(16, 2);
  for (uint8_t i = 0; i < 4; i++) pinMode(BAL_PIN[i], OUTPUT);
  pinMode(CHG_FET, OUTPUT); pinMode(DSG_FET, OUTPUT);
  digitalWrite(CHG_FET, HIGH); digitalWrite(DSG_FET, HIGH); // mặc định thông
  tPrev = millis();
}

void loop() {
  // --- (a) ĐO ---
  float vcell[4], vmax = 0, vmin = 9;
  for (uint8_t i = 0; i < 4; i++) {
    vcell[i] = readV(CELL_PIN[i], DIV_GAIN);
    vmax = max(vmax, vcell[i]); vmin = min(vmin, vcell[i]);
  }
  float vshunt = readV(A4, 1.0) / AMP_GAIN;
  float current = vshunt / SHUNT_OHM;              // + sạc / - xả (tuỳ đấu)
  float tempC   = readV(A5, 1.0) / 0.01;           // LM35: 10mV/°C

  // --- (b) SoC bằng COULOMB COUNTING (điểm khác biệt) ---
  unsigned long now = millis();
  float dt_h = (now - tPrev) / 3600000.0;          // ms -> giờ
  tPrev = now;
  soc += (current * dt_h) / CAPACITY_AH * 100.0;   // tích phân dòng
  soc = constrain(soc, 0, 100);
  // hiệu chỉnh OCV khi nghỉ (dòng ~0): map áp cell -> % để chống trôi
  if (fabs(current) < 0.05) {
    float ocvSoc = (vmin - CAP_MIN_V) / (CAP_MAX_V - CAP_MIN_V) * 100.0;
    soc = 0.98 * soc + 0.02 * constrain(ocvSoc, 0, 100); // recalib nhẹ
  }

  // --- (c) CÂN BẰNG CELL ---
  for (uint8_t i = 0; i < 4; i++)
    digitalWrite(BAL_PIN[i],
      (vcell[i] > BAL_START && (vcell[i] - vmin) > BAL_DELTA) ? HIGH : LOW);

  // --- (d) BẢO VỆ ---
  bool fault = false;
  if (vmax >= OV || tempC >= OT) { digitalWrite(CHG_FET, LOW); fault = true; } // cấm sạc
  if (vmin <= UV || fabs(current) >= OC || tempC >= OT) {
    digitalWrite(DSG_FET, LOW); fault = true;                                  // cấm xả
  }
  if (!fault) { digitalWrite(CHG_FET, HIGH); digitalWrite(DSG_FET, HIGH); }

  // --- HIỂN THỊ ---
  lcd.clear();
  lcd.setCursor(0,0); lcd.print("SoC:"); lcd.print(soc,0);
  lcd.print("% T:"); lcd.print(tempC,0); lcd.print("C");
  lcd.setCursor(0,1);
  lcd.print(fault ? "PROTECT!" : "OK ");
  lcd.print("I:"); lcd.print(current,1); lcd.print("A");
  delay(500);
}
```

> **`ponytail:` hằng số hiệu chỉnh ở đầu file** — ADC, hệ số phân áp, gain op-amp, dung lượng pin đều là **núm calib**. Số trên là điểm khởi đầu; đo mạch/pin thật rồi chỉnh lại. Coulomb counting mô phỏng dùng `millis()` (thời gian mô phỏng), khi sang phần cứng phải calib lại theo dòng đo thật.

### 2.5. Cách chạy & kiểm chứng (bằng chứng "đúng")

| Chức năng | Thao tác khi mô phỏng | Phải thấy |
|---|---|---|
| **SoC** | Đặt cell đầy → cho dòng xả (đấu tải) | LCD % tụt dần theo thời gian |
| **Nhiệt độ** | Vặn núm `LM35` lên > 55°C | LCD báo `PROTECT!`, FET cắt |
| **Cân bằng** | Đặt 1 cell áp cao hơn ~50mV | MOSFET cân bằng cell đó bật (LED sáng), áp kéo về đều |
| **Bảo vệ OV** | Nạp 1 cell lên > 3.65V | charge FET cắt (cấm sạc) |
| **Bảo vệ UV/OC** | Xả cell < 2.5V hoặc ép dòng > 15A | discharge FET cắt (cấm xả) |

---

## 3. Dùng lại mạch tham khảo — CẨN THẬN

Có một mạch Proteus BMS 3 cell rất đầy đủ (INA219 ×3, relay cân bằng, MOSFET+opto điều khiển tải, LCD) — ảnh ở [`../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg`](../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg).

⚠️ **Nguồn gốc:** mạch này nằm trong **đồ án của nhóm khoá trước, CÙNG 2 thầy hướng dẫn** ([`../archives/extracted/solar-microgrid-project/solar-microgrid-project.md`](../archives/extracted/solar-microgrid-project/solar-microgrid-project.md)), và bản thân nó lấy từ **TheEngineeringProjects.com** (watermark). Tức là **thầy đã thấy mạch này**.

**→ Nguyên tắc dùng:**
- **Được** tham khảo cách bố trí (đo từng cell, cân bằng bằng relay, opto cách ly PWM tải).
- **Không** bê nguyên — sẽ bị nhận ra ngay và không có điểm khác biệt.
- **Phải thêm cái nó thiếu** để thành "hàng của mình":
  - **Cảm biến nhiệt độ (LM35)** — mạch đó **không có** dù thầy yêu cầu đo nhiệt.
  - **SoC bằng coulomb counting** — mạch đó chỉ suy từ áp.
  - **IoT hai chiều** (ESP32 điều khiển ngược + cảnh báo) — mạch đó chỉ Arduino + LCD tại chỗ.
- **Trích nguồn** rõ ràng trong báo cáo.

---

## 4. Lỗi hay gặp

- **Arduino không chạy trong Proteus:** quên nạp `.hex` vào *Program File*, hoặc chọn sai board.
- **Tụ "pin" nạp/xả tức thì:** dung lượng tụ quá nhỏ → dùng 10–50F và đặt *Initial Voltage*.
- **ADC tràn 5V:** quên cầu phân áp cho cell nối tiếp (pack 12V > 5V) → cháy chân ADC (trong sim thì đọc sai).
- **INA219 báo thiếu linh kiện:** thư viện chưa cài → dùng phương án shunt + op-amp (mục 2.2).
- **DC Sweep không ra đường cong:** chưa đặt biến quét đúng nguồn/tải, hoặc chưa vào **Graph Mode**.

---

## 5. Mốc 2 tuần cần tới đâu?

Thầy chỉ yêu cầu **phương pháp + kế hoạch** cho báo cáo tiến độ — **KHÔNG** cần dựng chạy xong.

- ✅ **Bắt buộc:** mô tả được cách dựng (chính file này tóm lại) + sơ đồ khối.
- 💡 **Bonus (nên có):** dựng **File 2 bản tối thiểu 1 cell** (áp + LM35 → Arduino → LCD, có bảo vệ OT) và **File 1 vài đường I–V** → chụp màn hình bỏ vào báo cáo. Ít công, chứng minh nhóm làm thật.
- ❌ **Chưa cần:** mạch 4 cell đầy đủ, IoT/ESP32, phần cứng thật → sau mốc proposal.

---

*Tạo: 2026-09-08 — hướng dẫn dựng mô phỏng Proteus cho GĐ1. Đồng bộ với [`proposal.md`](proposal.md) và [`../plan/proposal.md`](../plan/proposal.md).*
