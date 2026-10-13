# Phần mô phỏng còn thiếu / có thể mở rộng

**Ưu tiên:** thấp đến trung bình · **Phụ trách:** mô phỏng
Đây là các giới hạn của bộ code hiện tại, xếp theo mức độ ảnh hưởng.

| # | Việc | Vì sao chưa làm | Ảnh hưởng nếu bỏ qua |
|---|---|---|---|
| 1 | Mô hình MOSFET thật và mạch kích cổng trong model quá độ (thay block Switch lý tưởng) | Chưa chọn linh kiện | Xung dòng ở mức 3 là trường hợp xấu nhất, chưa phải số thật |
| 2 | Mô hình bộ sạc ST-S1230 (PWM: khóa đóng/cắt; MPPT: bộ biến đổi + P&O) | Chưa biết PWM hay MPPT ([undone/03](03-xac-nhan-thong-so.md)) | Đang xấp xỉ bằng pin 13 V hoặc P&O lý tưởng hóa |
| 3 | Che bóng ở mức cell (12 cell/tấm; số diode bypass thật) | Chưa có datasheet tấm | Tấm bị phủ một phần đang tính theo tỉ lệ diện tích, nên lạc quan |
| 4 | Hiện thực đúng thuật toán DP + Smart Choice của Ref 3 | Đang dùng EI nhỏ nhất bằng duyệt hết (cận tốt nhất của DP) và cách tham lam | Chưa so được đúng với kết quả bài báo |
| 5 | Ước lượng bức xạ từng tấm từ I, V (Eq 1 Ref 3) | Mới giả lập bằng sai số ngẫu nhiên 5 % | Chưa biết sai số thật của phép ước lượng |
| 6 | Nhiệt độ tấm thay đổi theo thời gian / theo tấm | Ngoài phạm vi hiện tại | Mọi ca đang ở 25 °C |
| 7 | Điện tự tiêu thụ của mạch điều khiển và mạch kích, tính vào điện năng ròng | Chưa có số | Lợi ích ròng ở mức 2 đang hơi lạc quan |
| 8 | Thuật toán trong Simulink bằng Stateflow (thay cho bộ mô phỏng script) | Bộ mô phỏng script đủ để so sánh, nhanh hơn | Chỉ cần nếu báo cáo yêu cầu sơ đồ Stateflow |
| 9 | Dựng bảng công suất mức 2 từ Simulink (`o.source = 'simulink'`) | Đã có code, chưa chạy | Hiện bảng lấy từ mô hình tham chiếu |
| 10 | Điện trở công tắc thật (MOSFET back-to-back ~20 mΩ) trong mô hình tĩnh | Mô hình tĩnh đang dùng R_closed = 1 mΩ | Bỏ qua sụt áp do dòng ngang trên N1, N2 / S1–S4; ước lượng xấu nhất 1–2 % |
| 11 | Điện cảm vòng + thời gian chuyển mạch trong model quá độ | Chưa chọn linh kiện, chưa có layout | Đỉnh 123–368 A ở mức 3 chỉ là cận trên (ΔV / Rsw) |
