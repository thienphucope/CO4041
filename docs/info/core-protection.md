# Core — Mạch bảo vệ pin (protection circuit)

> **Cái gì:** ngắt/giới hạn khi pin vượt giới hạn an toàn — **quá áp, thấp áp, quá dòng, quá nhiệt** (và ngắn mạch). Là "hàng rào an toàn" của BMS.
> **Tại sao quan trọng với đồ án:** 1 trong 4 khối BMS thầy chốt ([`qa1.md`](qa1.md) §A1).
> **Nguồn:** Ref 2 — Kulkarni 2025 ([`../references/extracted/02-bms-iot/02-bms-iot.md`](../references/extracted/02-bms-iot/02-bms-iot.md)) + kiến thức nền BMS.
> Liên quan: [[core-soc]] · [[core-cell-balancing]] · [[core-thermal]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **OVP** | Over-Voltage Protection | Bảo vệ **quá áp** (sạc quá mức). |
| **UVP** | Under-Voltage Protection | Bảo vệ **thấp áp** (xả kiệt). |
| **OCP** | Over-Current Protection | Bảo vệ **quá dòng**. |
| **SCP** | Short-Circuit Protection | Bảo vệ **ngắn mạch**. |
| **OTP** | Over-Temperature Protection | Bảo vệ **quá nhiệt** (xem [[core-thermal]]). |
| **Interlock** | — | Khoá chéo: đang sạc thì cấm xả & ngược lại (Ref 2). |
| **MOSFET / Relay** | — | Phần tử đóng/ngắt mạch sạc–xải. |
| **Cut-off threshold** | — | Ngưỡng áp/dòng/nhiệt để ngắt. |

---

## 2. Các loại bảo vệ & ngưỡng

| Bảo vệ | Điều kiện kích | Hành động |
|---|---|---|
| **OVP** (quá áp) | V_cell > V_max (vd Li-ion ~4.2 V) | Ngắt **sạc** |
| **UVP** (thấp áp) | V_cell < V_min (vd Li-ion ~2.5 V) | Ngắt **tải (xả)** |
| **OCP** (quá dòng) | I > I_max (theo C-rate) | Ngắt mạch |
| **SCP** (ngắn mạch) | dI/dt rất lớn / I cực lớn | Ngắt tức thì |
| **OTP** (quá nhiệt) | T > T_max | Cảnh báo → giảm dòng → ngắt ([[core-thermal]]) |

Dải an toàn Li-ion theo Ref 2 (dẫn [8,9], Trang 1): **áp cell 2.5–4.2 V**. C-rate quyết định I_max: `I = C × Capacity` (Ref 2, Eq 1).

## 3. Cách thực hiện
- **Đo:** V từng cell (voltage divider), I (shunt/INA226 — [[core-iot-monitoring]]), T (LM35 — [[core-thermal]]).
- **So ngưỡng:** trong firmware MCU (hoặc IC bảo vệ chuyên dụng ở pack thật).
- **Ngắt:** **MOSFET** (sạc & xả riêng) hoặc **relay** mở mạch.
- **Interlock (Ref 2, Trang 5):** khi đang **sạc** thì **cấm xả**; **ngắt pin khỏi nguồn sạc khi đầy**; có chỉ báo mức xả để người dùng hành động.

## 4. Ref 2 làm gì (đối chiếu)
- Ref 2 đặt **giới hạn sạc/xả**, **interlock** sạc↔xả, tự ngắt khi đầy, giám sát nhiệt + cooling (Trang 5). Đây là khuôn bảo vệ mức hệ thống tốt.
- Chi tiết ngưỡng OCP/SCP không nêu sâu → nhóm tự bổ sung theo datasheet pin.

## 5. Áp dụng vào đồ án
- **Ở proposal (mức concept):** liệt kê 5 bảo vệ (OVP/UVP/OCP/SCP/OTP) + phần tử ngắt (MOSFET/relay) + logic interlock. Nêu phương pháp; mô phỏng chức năng Proteus (đặt ngưỡng, kích ngắt).
- Ngưỡng lấy từ [[core-soc]] (áp cell) + [[core-thermal]] (nhiệt) + C-rate (dòng).

## 6. Còn mở
- Ngưỡng cụ thể phụ thuộc **loại pin chưa chốt** ([`../plan/proposal.md`](../plan/proposal.md) B3): LiFePO4 (2.5–3.65 V/cell) vs SLA (dải khác). → Tra datasheet rồi chốt bảng ngưỡng.
- Dùng IC bảo vệ sẵn (vd BQ769x, DW01) hay tự làm bằng MCU+MOSFET — quyết theo hướng "tự làm thuật toán" (KTMT) của đề tài.

*Cập nhật: 2026-09-10.*
