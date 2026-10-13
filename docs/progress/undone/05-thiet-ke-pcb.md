# Thiết kế PCB mạch chuyển cấu hình (mốc M4)

**Ưu tiên:** cao (gia công là rủi ro tiến độ chính) · **Phụ trách:** PCB (Lê Thanh Phú) · Kế hoạch: tuần 3–5, làm song song với mô phỏng

## Đầu vào đã có

- **Topology:** 4 công tắc nối chéo S1–S4; phần nối tiếp đấu cứng nên không thể tạo 9S hay 9P ([done/03](../done/03-chot-pham-vi-va-cau-hinh.md)).
- **Ứng suất mỗi công tắc:** dòng max 3,55 A, áp max 7,77 V. Gợi ý MOSFET có V_DS ≥ 20 V, dòng ≥ 5 A ([done/05](../done/05-ung-suat-cong-tac.md)).
- **Báo giá gia công:** thienlampcb.com ([`docs/pcb/order-pcb-at.md`](../../pcb/order-pcb-at.md)).

## Việc cần làm

- [ ] **Công tắc:** 2 MOSFET đấu ngược mỗi công tắc, hoặc relay. Chọn mã linh kiện; tính tổn hao dẫn I²·2R_DS(on).
- [ ] **Mạch kích:** các nút nối chéo nằm ở điện thế khác nhau, nên mạch kích cổng phải thả nổi hoặc cách ly với mass của vi điều khiển (photovoltaic driver, gate driver cách ly, hoặc bootstrap). Tham khảo phân tích áp chịu đựng theo vị trí công tắc trong Ref R4 (Ng & Ertugrul 2025).
- [ ] **Đo lường:** tối thiểu áp và dòng đầu ra dàn. Mở rộng: áp tại các nút trung gian, dòng từng nhánh, để nhận biết bóng che.
- [ ] **Bảo vệ:** diode bypass (nếu tấm chưa có), cầu chì đầu ra, đầu nối chịu khoảng 8 A, công tắc ngắt dàn khỏi bộ sạc.
- [ ] **Trình tự chuyển mạch:** tránh trạng thái trung gian gây xung dòng. Kết quả mức 3 ([done/10](../done/10-chay-simulink.md)): với công tắc lý tưởng, đóng lần lượt cách 1 ms không giảm đỉnh dòng (123 → tới 181 A ở một công tắc); đỉnh do ΔV / R_on nên cần giới hạn tốc độ đóng (mạch kích cổng chậm, điện trở cổng) chứ không chỉ đổi thứ tự.
- [ ] Vẽ schematic và layout, rà soát chéo, xuất BOM và file gia công, rồi đặt gia công.
- [ ] Sau khi chọn MOSFET: cập nhật `cfg.tr.Rsw` trong `pvreconfig-sim/simulink/sl_config.m` và thời gian chuyển mạch trong `algo/run_arr05.m`.
