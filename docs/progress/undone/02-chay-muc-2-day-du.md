# Chạy đầy đủ mức 2 (ARR-05) và phân tích

**Ưu tiên:** cao · **Phụ trách:** mô phỏng · **Chờ:** —
**Code:** `pvreconfig-sim/algo/` (xem [done/09](../done/09-code-muc-2-arr05.md))

## Việc cần làm

- [x] `run_arr05` với mặc định: 4 kịch bản × 3 kiểu bộ sạc, bảng công suất 1 s, cả 4 công tắc và DES. Chạy 30/10/2026 bằng `matlab -batch` (157 s), ghi `results/arr05_summary.csv`, `arr05_traces.mat`, log `arr05_log.txt`.
- [x] `plot_arr05`: hình `results/fig/arr05_<kịch bản>_<bộ sạc>.png`.
- [ ] `plot_cases`: chưa chạy lại lần này.
- [x] Phân tích lần đầu (V_pin = 13 V), xem "Kết quả 30/10/2026" bên dưới.
- [ ] Thay V_pin cố định 13 V bằng dải 12,5–14,3 V (bộ sạc đã xác nhận là PWM, ắc quy axit-chì, [undone/03](03-xac-nhan-thong-so.md)).
- [ ] Thêm kịch bản bóng không thẳng đứng: `canh-ngang` và `cot-dien` che đều từng cột nên mọi cấu hình cho như nhau, không phân biệt được thuật toán.
- [ ] (Tùy chọn) `run_arr05(struct('source','simulink','des',false))`: lấy bảng công suất từ model Simulink thay cho mô hình tham chiếu.
- [ ] Ghi kết luận vào README và chuyển file này sang `done/`.

## Kết quả 30/10/2026 (mô hình tham chiếu, V_pin = 13 V, so với SP cố định)

| Kịch bản | 4 công tắc, tối ưu (oracle) | 4 công tắc, thuật toán tốt nhất | DES, EI min 3025, 2 s | DES, tham lam |
|---|---|---|---|---|
| `canh-ngang` | 0 % | 0 % | 0 % | 0 % |
| `cot-dien` | 0 % | 0 % | 0 % | 0 % |
| `canh-cheo` | +1,0 % | +0,1 % (leo đồi) | +9,8 % | +8,4 % |
| `dam-may` | +0,4 % | +0,1 % (quét khi P đổi 5 %) | +6,0 % | +5,5 % |

- **4 công tắc:** khi bóng di chuyển, lợi ích rất nhỏ (≤ 1 % với PWM, ≤ 2,5 % với MPPT, mà MPPT thì TCT cố định đã đạt gần hết). Quét chậm còn thua SP: quét 16 trạng thái mỗi 10 s ở `canh-cheo` −2,3 %; TCT cố định −4,7 %.
- **Leo đồi** cho điện năng ngang quét 16 trạng thái mỗi 2 s, nhưng chỉ đổi cấu hình 60–89 lần thay vì ~480 lần trong 60 s.
- **Thời gian quét:** quét đủ 16 trạng thái mỗi 2 s chiếm 21 % thời gian. Relay so với MOSFET (quét 10 s) chênh ≤ 1,3 điểm, không rõ chiều.
- **DES:** +6–10 % (PWM), +8–15 % (MPPT). Chọn theo EI đạt 99,8 % so với DES oracle; sai số ước lượng bức xạ 5 % chỉ mất 0,2–0,3 điểm.
- **Bộ sạc P&O:** "oracle" không phải cận trên, vì đổi cấu hình liên tục làm nhiễu P&O: ở `canh-cheo`, TCT cố định đạt 100,6 % oracle, DES EI đạt 106 % DES oracle.

## Lưu ý

- Bức xạ tấm đang tính theo tỉ lệ diện tích bị bóng. Giả thiết này lạc quan cho tấm bị phủ một phần. Xem [undone/08](08-mo-phong-mo-rong.md).
- Các giá trị thời gian (MOSFET 5 ms + 20 ms, relay 20 ms + 100 ms) là giả thiết. Cần cập nhật sau khi chọn linh kiện và viết firmware.
