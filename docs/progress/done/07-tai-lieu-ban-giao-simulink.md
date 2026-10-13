# Tài liệu bàn giao mô phỏng Simulink

**Trạng thái:** xong · **Thời gian:** 12/10/2026

## Đã làm

- [`docs/info/simulink-handoff-pv3x3.md`](../../info/simulink-handoff-pv3x3.md) là file tự đủ để gửi cho người làm Simulink. Nội dung gồm:
  - Bối cảnh, phạm vi; lý do phải xuất cả Pmax lẫn P(13 V).
  - Thông số tấm và tham số một diode (cả tấm và quy về từng cell).
  - Sơ đồ dàn, quy ước S1–S4, cách đánh số 16 trạng thái.
  - Cách đặt block Solar Cell để khớp đúng mô hình tham chiếu (tham số mạch tương đương, Rs và Rp chia 12, TXIS1 = 3,9), kèm cách dự phòng.
  - Các bước dựng model bằng tay; script quét; 9 ca che bóng.
  - Bảng tham chiếu Pmax và Pbat đủ 16 × 9, sai số chấp nhận, lỗi thường gặp.
  - Đặc tả ARR-05, danh sách đầu ra cần nộp lại, các mức mô phỏng đã có code.
- Danh sách gói cần cài, ghi riêng ở [`docs/info/cai-dat-matlab.md`](../../info/cai-dat-matlab.md): MATLAB, Simulink, Simscape, Simscape Electrical. Tùy chọn: Parallel Computing Toolbox, Stateflow. Không cần Fluids, Multibody, Battery.
- [`pvreconfig-sim/README.md`](../../../pvreconfig-sim/README.md): các mức mô phỏng, cấu trúc thư mục, giả thiết, kết quả đã có.

## Ghi chú

- File cũ [`huong-dan-simulink-pv3x3.md`](../../info/huong-dan-simulink-pv3x3.md) còn dùng bộ 7 ca có `rand`, không khớp bộ 9 ca của bảng tham chiếu. Xem [undone/09](../undone/09-don-dep-tai-lieu-repo.md).
