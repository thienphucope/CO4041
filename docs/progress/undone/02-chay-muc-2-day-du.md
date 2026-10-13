# Chạy đầy đủ mức 2 (ARR-05) và phân tích

**Ưu tiên:** cao · **Phụ trách:** mô phỏng · **Chờ:** MATLAB
**Code:** `pvreconfig-sim/algo/` (xem [done/09](../done/09-code-muc-2-arr05.md))

## Việc cần làm

- [ ] `run_arr05` với mặc định: 4 kịch bản × 3 kiểu bộ sạc, bảng công suất 1 s, cả 4 công tắc và DES. Ghi ra `results/arr05_summary.csv` và `arr05_traces.mat`.
- [ ] `plot_arr05` và `plot_cases`: vẽ hình vào `results/fig/`.
- [ ] Phân tích, trả lời các câu hỏi:
  - Thuật toán quét định kỳ đạt bao nhiêu % so với oracle? Chu kỳ quét nào hợp lý (2/5/10/30 s)?
  - Thời gian quét làm mất bao nhiêu? Dùng relay so với MOSFET khác nhau thế nào?
  - Leo đồi có đủ tốt so với quét đủ 16 trạng thái không?
  - Với bộ sạc P&O, có ca nào bị kẹt ở đỉnh cục bộ không? Nối chéo có giúp giảm số đỉnh không?
  - DES tăng thêm bao nhiêu điện năng so với 4 công tắc? Sai số ước lượng bức xạ 5 % ảnh hưởng ra sao?
- [ ] (Tùy chọn) `run_arr05(struct('source','simulink','des',false))`: lấy bảng công suất từ model Simulink thay cho mô hình tham chiếu.
- [ ] Ghi kết luận vào README và chuyển file này sang `done/`.

## Lưu ý

- Bức xạ tấm đang tính theo tỉ lệ diện tích bị bóng. Giả thiết này lạc quan cho tấm bị phủ một phần. Xem [undone/08](08-mo-phong-mo-rong.md).
- Các giá trị thời gian (MOSFET 5 ms + 20 ms, relay 20 ms + 100 ms) là giả thiết. Cần cập nhật sau khi chọn linh kiện và viết firmware.
