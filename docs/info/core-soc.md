# Core — Ước lượng SoC (State of Charge)

> **Cái gì:** đo % pin còn lại. Mạch tham khảo chỉ **suy từ điện áp** → điểm yếu; nhóm đề xuất **coulomb counting + hiệu chỉnh OCV** (đúng chất KTMT = thuật toán/firmware).
> **Tại sao quan trọng với đồ án:** là 1 trong 4 khối BMS thầy chốt ([`qa1.md`](qa1.md) §A1) và là **điểm khác biệt #1** ([`../plan/proposal.md`](../plan/proposal.md) B7.1).
> **Nguồn:** Ref 2 — Kulkarni 2025 ([`../references/extracted/02-bms-iot/02-bms-iot.md`](../references/extracted/02-bms-iot/02-bms-iot.md)) + kiến thức nền BMS.
> Liên quan: [[core-cell-balancing]] · [[core-thermal]] · [[core-protection]] · [[core-iot-monitoring]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **SoC** | State of Charge | % dung lượng còn lại so với đầy (0–100%). |
| **SoH** | State of Health | Sức khoẻ/độ chai pin so với lúc mới. |
| **OCV** | Open-Circuit Voltage | Áp hở mạch (khi pin nghỉ, không tải) — tương quan với SoC. |
| **CC (coulomb counting)** | — | Tích phân dòng theo thời gian để cộng/trừ điện tích. |
| **C-rate** | — | Tốc độ sạc/xả: **I = C × Capacity** (Ref 2, Eq 1). |
| **Ah / Wh** | Ampere-hour / Watt-hour | Dung lượng / năng lượng pin. |
| **ECM** | Equivalent Circuit Model | Mô hình mạch tương đương pin (Ref 2 nomenclature) — dùng cho SoC nâng cao (Kalman). |
| **Q / Q_rated** | — | Dung lượng danh định [Ah]. |
| **η** | Coulombic efficiency | Hiệu suất coulomb (≈1 với LiFePO4). |

---

## 2. Các phương pháp ước lượng SoC

| Phương pháp | Cách làm | Ưu | Nhược |
|---|---|---|---|
| **Đọc điện áp (terminal V)** | Tra V → SoC | Rất đơn giản | Sai lớn khi có tải (sụt áp R_nội); LiFePO4 đường áp **rất phẳng** → gần như không suy ra SoC được. **← đây là cách mạch tham khảo dùng.** |
| **OCV lookup** | Để pin **nghỉ**, đo OCV → tra bảng OCV–SoC | Chính xác khi nghỉ | Phải ngừng tải & chờ ổn định; không đo lúc đang dùng. |
| **Coulomb counting (CC)** | Tích phân dòng vào/ra | Đo được **liên tục** khi đang dùng | **Trôi (drift)** do sai số/offset cảm biến dòng tích luỹ. |
| **CC + hiệu chỉnh OCV** ⭐ | CC liên tục + reset SoC bằng OCV lúc pin nghỉ | Cân bằng tốt, rẻ | Cần đo được cả V và I. **← hướng nhóm chọn.** |
| **Model-based (Kalman/ECM)** | Lọc Kalman trên mô hình ECM | Chính xác nhất | Phức tạp; quá tầm mốc proposal. |

### Công thức coulomb counting
```
SoC(t) = SoC(t0) − (1 / Q) · ∫[t0→t] η·I(t) dt
```
- `I > 0` = xả (trừ), `I < 0` = sạc (cộng); Q = dung lượng [As] = Ah×3600.
- Thực tế: lấy mẫu dòng mỗi Δt → `SoC -= η·I·Δt / Q`.

### Hiệu chỉnh OCV (chống trôi)
Khi phát hiện pin **nghỉ đủ lâu** (dòng ≈ 0 một khoảng) → đo OCV → tra bảng OCV–SoC → **ghi đè** giá trị SoC đang tích luỹ. Loại bỏ sai số trôi của CC.

### C-rate (Ref 2, Eq 1) — liên quan đo dòng
```
I = C × Capacity
```
Vd pin 2 Ah, sạc 0.5C → I = 1 A. Quyết định dải dòng cần đo & bảo vệ ([[core-protection]]).

---

## 3. Ref 2 làm gì (để đối chiếu)
- Ref 2 **chỉ đo điện áp từng cell** (voltage divider/voltage sensor) + hiển thị; **không** coulomb counting. OCV chỉ xuất hiện ở nomenclature, không dùng để hiệu chỉnh.
- Đo cell: so với đồng hồ vạn năng có **sai số %** → Ref 2 nhấn **hiệu chuẩn (calibration)** (Table 1: C1 4.50%, C2 2.92%, C3 1.50%). → Bài học: **phải có bước calibration** cho cảm biến áp.
- Báo "đầy 99%" là suy từ áp đạt ~4.2 V/cell, **không** phải SoC coulomb thực.
👉 Đây chính là **lỗ hổng** nhóm lấp để khác biệt: SoC bằng CC+OCV thay vì chỉ đọc áp.

## 4. Áp dụng vào đồ án
- **Ở proposal:** thiết kế **mức concept** khối SoC: đo V (voltage divider) + I (INA226/shunt — xem [[core-iot-monitoring]]) → firmware coulomb counting + mốc hiệu chỉnh OCV.
- Cần **đo dòng** → khác mạch tham khảo (chỉ đo áp). Đây là lý do chọn cảm biến có cả V–I–P.
- Ghi rõ là **phương pháp** ở báo cáo 2 tuần; code chi tiết để sau mốc proposal.

## 5. Còn mở
- **Loại pin chưa chốt** ([`../plan/proposal.md`](../plan/proposal.md) B3): LiFePO4 áp phẳng → CC càng cần thiết; SLA thì OCV–SoC dễ tra hơn. Ảnh hưởng bảng OCV–SoC.
- Dung lượng Q giả định 12V–15Ah (~180Wh) — **chưa chốt**.
- Bảng OCV–SoC lấy từ datasheet pin thực tế — **tự tìm thêm**.

*Cập nhật: 2026-09-10.*
