# Info — tài liệu đang dùng

Trọng tâm giai đoạn 1 theo [ghi nhận buổi họp ngày 23/09/2026](qa2.md): PCB cho mạch chuyển cấu hình dàn PV 3 × 3 và mô phỏng thuật toán trên MATLAB; đo, so sánh hiệu suất giữa các cấu hình. Cập nhật [05/10/2026](qa2.md#cập-nhật-05102026--chốt-phạm-vi): mục tiêu chỉ còn **PCB + mô phỏng MATLAB cho PV reconfiguration**; bộ sạc Suoer ST-S1230 lo sạc/bảo vệ pin, nhóm không làm BMS và không làm cân bằng cell.

**Tiến độ (việc đã làm / chưa làm):** [`docs/progress/`](../progress/README.md) · **Cài MATLAB (gói cần có):** [cai-dat-matlab.md](cai-dat-matlab.md)

## PV và chuyển cấu hình

- [Mô hình tấm PV](core-pv-model.md)
- [Che bóng một phần, hotspot và diode](core-partial-shading.md)
- [PV array reconfiguration](core-pv-reconfig.md)
- [Hướng dẫn mô phỏng dàn 3 × 3 trên MATLAB/Simulink](huong-dan-simulink-pv3x3.md)
- [Bàn giao mô phỏng Simulink (file tự đủ: spec + số liệu tham chiếu)](simulink-handoff-pv3x3.md)
- [Ba nút thắt PV reconfiguration — ghi chú để Astra kiểm chứng](pv-reconfig-verify-astra.md)

## Ghi nhận và thuật ngữ

- [Q&A vòng 1](qa1.md) — lưu nguyên văn trao đổi trước đây; phạm vi mới xem ở [qa2](qa2.md).
- [Thuật ngữ dự án](glossary.md)
- [Tư liệu BMS và IoT theo phương án cũ](../archives/info-bms/README.md) — lưu để tham khảo, không còn là đầu ra tự thiết kế của giai đoạn 1.
