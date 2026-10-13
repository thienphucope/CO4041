# Firmware ESP32: đo, điều khiển công tắc, thuật toán chọn cấu hình (mốc M5)

**Ưu tiên:** trung bình (sau khi có PCB) · **Phụ trách:** firmware (Hoàng Ngô Thiên Phúc) · Kế hoạch: tuần 6–8

## Việc cần làm

- [ ] Đọc áp và dòng đầu ra dàn; hiệu chuẩn; tính công suất.
- [ ] Điều khiển 4 công tắc theo đúng trình tự đã chốt. Có khóa phần mềm, nhưng an toàn chính vẫn dựa vào phần cứng.
- [ ] Hiện thực thuật toán chọn cấu hình. Ứng viên lấy từ kết quả mức 2 ([undone/02](02-chay-muc-2-day-du.md)): quét đủ 16 trạng thái định kỳ, quét khi công suất đổi, hoặc leo đồi. Thời gian chuyển và đo thật phải khớp giả thiết của mô phỏng, hoặc đưa ngược vào mô phỏng.
- [ ] Ghi dữ liệu (thời gian, trạng thái, V, I, P) và gửi lên nền tảng IoT.
- [ ] Kiểm tra từng khối trên PCB: chuyển được cả 16 trạng thái, số đo đúng.
