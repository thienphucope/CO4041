# Thực nghiệm dàn 3 × 3 và đối chiếu mô phỏng (mốc M6)

**Ưu tiên:** trung bình (sau PCB + firmware) · **Phụ trách:** cả nhóm · Kế hoạch: tuần 9–11

## Việc cần làm

- [ ] Lắp dàn 3 × 3 với PCB, ST-S1230, pin, tải.
- [ ] Tái tạo các ca che bóng bằng tấm che. Bộ 9 ca trong `pvreconfig-sim/pv_shading_cases.m` đã mô tả đủ chi tiết để dựng lại.
- [ ] Đo đủ 16 trạng thái cho từng ca (đo P tại điểm làm việc thật của bộ sạc; nếu có tải điện tử thì đo thêm đường I–V).
- [ ] Chạy thuật toán quét với bóng di chuyển (ARR-05 thực nghiệm) và so điện năng với cấu hình cố định.
- [ ] Đối chiếu với mô phỏng: cùng thông số tấm đã đo, cùng ca che. Vẽ đồ thị mô phỏng so với thực nghiệm.
- [ ] Ghi nhật ký đo (ngày, giờ, nhiệt độ tấm, bức xạ nếu có).
