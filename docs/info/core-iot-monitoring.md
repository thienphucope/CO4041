# Core — IoT giám sát & chuyển nguồn hybrid (ESP32 + ThingSpeak + DPDT)

> **Cái gì:** thu thập V/I/P/nhiệt + SoC → đẩy lên cloud để xem/điều khiển từ xa; và chuyển nguồn PV ↔ điện lưới để cấp điện liên tục.
> **Tại sao quan trọng với đồ án:** trụ "IoT" của đề tài ([`../specifications/specs.md`](../specifications/specs.md)); làm **sau mốc proposal** (vẫn trong 4041), nhưng kiến trúc bám Ref 2. **Điểm khác biệt #3** = IoT **hai chiều** ([`../plan/proposal.md`](../plan/proposal.md) B7.3).
> **Nguồn:** Ref 2 — Kulkarni 2025 ([`../references/extracted/02-bms-iot/02-bms-iot.md`](../references/extracted/02-bms-iot/02-bms-iot.md)).
> Liên quan: [[core-soc]] · [[core-thermal]] · [[core-protection]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **IoT** | Internet of Things | Nối thiết bị lên mạng để giám sát/điều khiển từ xa. |
| **ESP32** | Espressif Systems 32-bit | MCU có WiFi/BT — gửi dữ liệu lên cloud. |
| **MCU** | Microcontroller Unit | Vi điều khiển (Arduino Nano, ESP32…). |
| **ThingSpeak** | — | Nền tảng IoT/dashboard hiển thị & lưu dữ liệu (Ref 2 dùng). |
| **DPDT** | Double-Pole Double-Throw | Công tắc đảo 2 cực — chọn nguồn PV / điện lưới (Ref 2). |
| **I²C** | Inter-Integrated Circuit | Bus 2 dây nối MCU ↔ LCD/cảm biến (INA226). |
| **UART (Tx/Rx)** | — | Giao tiếp nối tiếp; Ref 2 nối **Arduino Nano Tx → ESP32 Rx**. |
| **INA219/INA226** | — | IC đo **V–I–P** qua I²C (cho coulomb counting & giám sát). |
| **Voltage divider** | Cầu phân áp | Chia áp để ADC đo áp cao. |
| **Auth token** | — | Khoá xác thực khi ESP32 gửi dữ liệu lên ThingSpeak. |
| **HEV/EV** | (Hybrid) Electric Vehicle | Bối cảnh ứng dụng BMS trong Ref 2. |

---

## 2. Kiến trúc hệ (Ref 2 §2, Fig. 1–2)
Thành phần: **PV + nguồn lưới → DPDT → BMS → controller → IoT**.
- PV phát DC; khi nắng đủ → sạc pin; **thiếu nắng → DPDT tự chuyển sang điện lưới** → cấp điện liên tục (hybrid). Inverter lấy từ pin cấp tải.
- BMS đo: loại pin, **V, nhiệt độ, công suất tiêu thụ, SoC, chu kỳ sạc**; theo dõi SoH.
→ Sơ đồ hệ Fig. 1: [`../references/extracted/02-bms-iot/images/p02-img01-x75.jpeg`](../references/extracted/02-bms-iot/images/p02-img01-x75.jpeg) · Sơ đồ mạch Fig. 2: [`../references/extracted/02-bms-iot/images/p03-img01-x86.jpeg`](../references/extracted/02-bms-iot/images/p03-img01-x86.jpeg)

**Sơ đồ khối nhóm đề xuất** ([`../plan/proposal.md`](../plan/proposal.md) B4): PV → charge controller → battery + BMS → tải; nhánh cảm biến (V/I/P) → ESP32 → IoT/app.

## 3. Luồng dữ liệu (Ref 2, Trang 3–4)
```
Cảm biến (V divider, LM35, dòng) → Arduino Nano (đọc ADC, đổi số)
   → LCD 16×2 (qua I²C)  [hiển thị tại chỗ]
   → ESP32 (Arduino Tx → ESP32 Rx, UART)  [WiFi]
       → ThingSpeak (auth token)  → dashboard mobile/PC
```
ThingSpeak vẽ đồ thị **sạc/xả real-time** từng cell; app hiện cả dạng **đồ thị + số**.
→ Dashboard mobile Fig. 6: [`../references/extracted/02-bms-iot/images/p06-img01-x198.jpeg`](../references/extracted/02-bms-iot/images/p06-img01-x198.jpeg)

**Phần cứng Ref 2 dùng:** Arduino Nano, ESP32, pack Li-ion 12.6 V (cell 4.2 V), DPDT, LCD 16×2, LM35, tấm pin 12 V, voltage divider + mạch BMS.

## 4. Đo V–I–P (liên kết SoC)
- **Áp:** voltage divider → ADC. **Dòng + công suất:** nên dùng **INA226/INA219** (I²C) thay vì chỉ đo áp như Ref 2 → mới làm được **coulomb counting** ([[core-soc]]).
- Lưu ý Ref 2: đo áp có **sai số %** → **bắt buộc hiệu chuẩn (calibration)** (Table 1).

## 5. Điểm khác biệt nhóm đề xuất
- **IoT hai chiều** (không chỉ dashboard xem): **điều khiển ngược** (bật/tắt tải, đổi nguồn, đặt ngưỡng) + **cảnh báo chủ động** (quá nhiệt/thấp áp) ([`../plan/proposal.md`](../plan/proposal.md) B7.3). Ref 2 chủ yếu **một chiều** (đẩy lên xem).
- **Định lượng "chi phí tối ưu"** (BOM + so sánh) — bám tên đề tài (B7.4).

## 6. Áp dụng vào đồ án
- **Ở proposal:** chủ yếu **mô tả kiến trúc + chọn nền tảng** (ThingSpeak theo Ref 2) + nêu điểm khác biệt. **IoT/app triển khai sau mốc proposal** (vẫn trong 4041) ([`../plan/proposal.md`](../plan/proposal.md) B4).
- DPDT (chuyển nguồn) & inverter thuộc 4041 nhưng triển khai sau mốc proposal.

## 7. Còn mở
- Giao thức: Ref 2 HTTP→ThingSpeak; cân nhắc **MQTT** nếu cần điều khiển ngược/real-time. Chốt sau mốc proposal.
- Arduino Nano + ESP32 (Ref 2) vs **chỉ ESP32** (gọn hơn, đủ WiFi+ADC) — nhóm nên cân nhắc dùng ESP32 đơn.

*Cập nhật: 2026-09-10.*
