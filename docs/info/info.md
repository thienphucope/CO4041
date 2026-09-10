# Info — Chỉ mục các "core" kỹ thuật của đồ án

> Mỗi file = 1 **core** (vấn đề/khối chức năng) của microgrid PV + BMS + IoT, viết đầy đủ: lý thuyết, công thức, viết tắt, cách áp dụng vào đồ án, bám 3 ref thầy cấp ([`../references/extracted/`](../references/extracted/)).
> Bản đồ vấn đề tổng thể: [`../plan/proposal.md`](../plan/proposal.md) · Thuật ngữ toàn đề tài: [`glossary.md`](glossary.md) · Q&A thầy: [`qa1.md`](qa1.md).
> **Cấu trúc 2 môn:** **GĐ1 = môn 4041 (toàn đồ án này)** · **GĐ2 = đồ án tốt nghiệp** (phát triển tiếp, ngoài scope). Hiện tại = **mốc proposal** của GĐ1 (báo cáo tiến độ LMS, chỉ tổng quan). Trong file dùng "mốc proposal" vs "phần sau của 4041" để phân biệt thời điểm *trong* GĐ1.

## 🔋 BMS — 4 khối thầy chốt (trọng tâm mốc proposal)
- [SoC — ước lượng dung lượng](core-soc.md) — coulomb counting + hiệu chỉnh OCV (≠ chỉ đọc áp). *Điểm khác biệt #1.*
- [Cell balancing — cân bằng cell](core-cell-balancing.md) — passive vs active; chọn passive.
- [Thermal — giám sát & quản lý nhiệt](core-thermal.md) — LM35 + bảo vệ quá nhiệt. *Điểm khác biệt #2 (lấp lỗ hổng mạch tham khảo).*
- [Protection — mạch bảo vệ](core-protection.md) — OVP/UVP/OCP/SCP/OTP + interlock.

## ☀️ PV — tấm pin & bóng râm
- [PV model & mô phỏng Proteus](core-pv-model.md) — single-diode, I–V/P–V, dựng bằng AVCVS/AVCCS (Ref 1).
- [Partial shading, hotspot & diode](core-partial-shading.md) — vì sao tụt công suất, bypass/blocking diode.
- [PV array reconfiguration](core-pv-reconfig.md) — TCT + DES + irradiance equalization/EI, hybrid DP+SC (Ref 3).

## 🌐 Hệ thống & IoT (làm sau mốc proposal, vẫn trong 4041)
- [IoT giám sát & chuyển nguồn hybrid](core-iot-monitoring.md) — ESP32 + ThingSpeak + DPDT (Ref 2). *Điểm khác biệt #3: IoT hai chiều.*

---

### Chưa tách file riêng (YAGNI — chưa cần ở mốc proposal)
- **Charge controller / MPPT vs PWM:** thuộc 4041 nhưng làm sau mốc proposal, chưa có ref riêng → gộp ý trong [core-pv-model](core-pv-model.md) §2 & [core-iot-monitoring](core-iot-monitoring.md). Tách file khi quyết làm.
- **Inverter, microgrid vận hành, tải, app:** thuộc 4041 nhưng làm sau mốc proposal ([`../plan/proposal.md`](../plan/proposal.md) B4) — proposal chỉ nêu tổng quan.

*Cập nhật: 2026-09-10.*
