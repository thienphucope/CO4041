# Core — Giám sát nhiệt độ & quản lý nhiệt (thermal / BTMS)

> **Cái gì:** đo nhiệt độ pack bằng cảm biến (LM35), cảnh báo/ngắt khi quá nhiệt, có thể kích làm mát. Mạch tham khảo **thiếu hẳn** cảm biến nhiệt dù thầy yêu cầu đo nhiệt → nhóm lấp.
> **Tại sao quan trọng với đồ án:** 1 trong 4 khối BMS thầy chốt ([`qa1.md`](qa1.md) §A1); là **điểm khác biệt #2** ([`../plan/proposal.md`](../plan/proposal.md) B7.2).
> **Nguồn:** Ref 2 — Kulkarni 2025 ([`../references/extracted/02-bms-iot/02-bms-iot.md`](../references/extracted/02-bms-iot/02-bms-iot.md)) + datasheet LM35.
> Liên quan: [[core-protection]] · [[core-soc]] · [[core-iot-monitoring]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **BTMS** | Battery Thermal Management System | Hệ quản lý nhiệt pin (Ref 2 nomenclature). |
| **LM35** | — | Cảm biến nhiệt analog, **10 mV/°C**, ra tuyến tính 0–100 °C. |
| **OTP** | Over-Temperature Protection | Bảo vệ quá nhiệt (ngắt/cảnh báo) — xem [[core-protection]]. |
| **ADC** | Analog-to-Digital Converter | Chuyển áp LM35 → số cho MCU đọc. |
| **Thermal runaway** | — | Phản ứng nhiệt dây chuyền ở Li-ion → cháy nổ; lý do phải giám sát nhiệt. |

---

## 2. Vì sao giám sát nhiệt
- Quá sạc / nhiệt ngoài → pin **quá nhiệt** → nguy hiểm, giảm tuổi thọ, nặng nhất là **thermal runaway** (Li-ion).
- Dải an toàn Li-ion (Ref 2 dẫn [8,9], Trang 1): áp cell **2.5–4.2 V**. *(Ref 2 ghi "temp 40–60 °C" — diễn giải nên hiểu là ngưỡng/giới hạn vận hành theo nguồn họ dẫn; nhóm cần kiểm lại theo datasheet pin thực tế, vì sạc Li-ion thường khuyến nghị 0–45 °C.)*
- Ref 2 quan sát **dao động 7–8 °C** khi sạc/xả; nếu vượt ngưỡng → **bật làm mát (cooling system)** để giữ trong giới hạn (Trang 5–7).

## 3. Đo bằng LM35 (kiến thức nền + Ref 2)
- LM35 ra **10 mV/°C** → `T(°C) = V_out / 10mV`. Nối thẳng chân ADC của MCU.
- Ref 2: LM35 nối **pack + Arduino Nano**; MCU đổi analog→số; hiện nhiệt lên **LCD 16×2** (qua **I²C**) và đẩy lên **ThingSpeak**.
- Đặt cảm biến **sát pack**; nhiều điểm nếu pack lớn.

## 4. Hành động khi quá nhiệt (thang tăng dần)
1. **Cảnh báo** (LED/buzzer + báo lên app IoT).
2. **Giảm dòng / ngừng sạc** (interlock — xem [[core-protection]]).
3. **Kích làm mát** (quạt) nếu vượt ngưỡng cao (Ref 2 dùng cooling system).
4. **Ngắt tải/nguồn** nếu tới ngưỡng nguy hiểm.

## 5. Ref 2 làm gì (đối chiếu) & lỗ hổng mạch tham khảo
- Ref 2 **có** LM35 + giám sát nhiệt liên tục + cooling system + đẩy IoT → khuôn mẫu tốt cho nhóm.
- ⚠️ Nhưng **mạch BMS nhóm khoá trước** ([`../plan/proposal.md`](../plan/proposal.md) B6) **THIẾU cảm biến nhiệt** dù thầy yêu cầu đo nhiệt → **đây là chỗ nhóm thêm LM35 + bảo vệ quá nhiệt để khác biệt** (B7.2).

## 6. Áp dụng vào đồ án
- **Ở proposal (mức concept):** khối đo nhiệt = LM35 → ADC MCU → so ngưỡng → cảnh báo/ngắt + đẩy IoT. Nêu phương pháp, mô phỏng chức năng Proteus.
- Nhiệt độ cũng là input để **bảo vệ** ([[core-protection]]) và ảnh hưởng ước lượng SoC ([[core-soc]]).

## 7. Còn mở
- Ngưỡng nhiệt cụ thể **theo loại pin chưa chốt** ([`../plan/proposal.md`](../plan/proposal.md) B3) — tra datasheet.
- LM35 (analog) vs cảm biến số (DS18B20, NTC) — chọn sau; Ref 2 dùng LM35 nên bám theo cho nhất quán.

*Cập nhật: 2026-09-10.*
