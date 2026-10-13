# Code mức 2: bóng di chuyển + thuật toán chọn cấu hình (ARR-05)

**Trạng thái:** code viết xong, đã chạy thử thông luồng với 1 kịch bản; **chưa có kết quả đầy đủ** · **Thời gian:** 12/10/2026
**Code:** `pvreconfig-sim/algo/` · Việc chạy đầy đủ: [undone/02](../undone/02-chay-muc-2-day-du.md)

## Đã viết

- **`shadow_profiles.m`:** 4 kịch bản bóng, mỗi kịch bản 60 s.
  - `canh-ngang`: mép bóng thẳng đứng đi ngang.
  - `canh-cheo`: mép bóng chéo.
  - `cot-dien`: dải bóng hẹp quét qua.
  - `dam-may`: đám mây tròn đi chéo.

  Bức xạ mỗi tấm tính theo tỉ lệ diện tích bị bóng.
- **`arr05_table.m`:** bảng công suất theo thời gian của 16 trạng thái (hoặc 3025 cách chia DES). Nguồn số liệu là mô hình tham chiếu hoặc model Simulink. Có lưu đệm.
- **`simulate_algo.m`:** mô phỏng theo thời gian, bước 5 ms. Có tính thời gian chuyển công tắc, thời gian đo mỗi cấu hình, và cách bộ sạc phản ứng:
  - `pwm`: dàn bị kẹp ở 13 V.
  - `mppt`: MPPT lý tưởng.
  - `po`: MPPT kiểu P&O, mỗi 0,1 s nhích 0,2 V.
- **Thuật toán:**
  - Cố định SP hoặc TCT.
  - Oracle: cận trên.
  - Quét đủ 16 trạng thái mỗi 2/5/10/30 s (MOSFET), hoặc 10 s (relay).
  - Quét khi công suất đổi quá 5 %.
  - Leo đồi: mỗi lần thử 4 trạng thái lân cận.
  - DES: chia theo EI 3025 hoặc 280 cách, tham lam, hoặc theo mô hình; có thể thêm sai số ước lượng 5 %.
- **`run_arr05.m`:** chạy tất cả, ghi `results/arr05_summary.csv` và `arr05_traces.mat`. **`plot_arr05.m`:** vẽ hình.

## Chạy thử (bảng thô 10 s, 1 kịch bản `canh-ngang`, bộ sạc pwm và po)

- Luồng code chạy thông từ đầu đến cuối.
- Ở kịch bản này mọi cấu hình 4 công tắc cho cùng điện năng. Điều này đúng vật lý: mép bóng thẳng đứng che theo cột, giống ca `cot-1`, nên nối chéo không giúp gì.
- Đã sửa lỗi oracle đổi cấu hình liên tục giữa các cấu hình bằng nhau.
- Lần chạy đầy đủ bị dừng giữa chừng ngày 12/10/2026, khi dự án chuyển hẳn sang MATLAB. Kết quả dở dang đã xóa.
