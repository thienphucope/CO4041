# Thiết kế PCB mạch chuyển cấu hình (mốc M4)

**Ưu tiên:** cao (gia công là rủi ro tiến độ chính) · **Phụ trách:** PCB (Lê Thanh Phú) · Kế hoạch: tuần 3–5, làm song song với mô phỏng

## Đầu vào đã có

- **Topology:** 4 công tắc nối chéo S1–S4; phần nối tiếp đấu cứng nên không thể tạo 9S hay 9P ([done/03](../done/03-chot-pham-vi-va-cau-hinh.md)).
- **Ứng suất mỗi công tắc:** dòng max 3,55 A, áp max 7,77 V. Gợi ý MOSFET có V_DS ≥ 20 V, dòng ≥ 5 A ([done/05](../done/05-ung-suat-cong-tac.md)).
- **Báo giá gia công:** thienlampcb.com ([`docs/pcb/order-pcb-at.md`](../../pcb/order-pcb-at.md)).

## Việc cần làm

- [ ] **Công tắc:** 2 MOSFET đấu ngược chung cực S mỗi công tắc (áp trên công tắc mở đổi chiều theo bóng che, một MOSFET sẽ dẫn qua diode ký sinh), hoặc relay. Chọn mã linh kiện; tính tổn hao dẫn I²·2R_DS(on).
- [ ] **Mạch kích:** cực S chung nằm ở điện thế nút (nút 1 ≈ 12 V, nút 2 ≈ 6 V, thay đổi theo điểm làm việc), nên mạch kích cổng phải thả nổi theo cực S, cách ly với mass của vi điều khiển. Một mạch kích cho cả cặp MOSFET (G chung – S chung). Dùng photovoltaic driver, charge-pump cách ly, hoặc nguồn cách ly nhỏ + gate driver. **Không dùng bootstrap:** công tắc giữ trạng thái đóng liên tục, không băm xung nên tụ bootstrap không được nạp lại. Tham khảo phân tích áp chịu đựng theo vị trí công tắc trong Ref R4 (Ng & Ertugrul 2025).
- [ ] **Đo lường:** bắt buộc áp và dòng đầu ra dàn, vì thuật toán quét phải đo công suất từng trạng thái (giả thiết 20 ms mỗi trạng thái trong `algo/run_arr05.m`). Mở rộng: áp tại các nút trung gian, dòng từng nhánh, để nhận biết bóng che.
- [ ] **Bảo vệ:** diode bypass (nếu tấm chưa có), cầu chì đầu ra, đầu nối chịu khoảng 8 A, công tắc ngắt dàn khỏi bộ sạc.
- [ ] **Xung dòng khi đóng:** đỉnh 123–368 A ở mức 3 ([done/10](../done/10-chay-simulink.md)) chỉ là cận trên của mô hình: công tắc lý tưởng đóng tức thì nên đỉnh = ΔV / R_on, chưa có điện cảm vòng và thời gian bật MOSFET. Xung do điện dung tấm xả qua công tắc (không phải dòng tấm cấp, dòng xác lập vẫn ≤ I_sc), năng lượng nhỏ (≤ 1,8 mJ mỗi lần, `transient_simulink.csv`). Photovoltaic driver vốn bật chậm nên nhiều khả năng **không cần mạch đóng chậm riêng**. Khi chọn MOSFET và driver: so I_DM và SOA xung trong datasheet với xung ước lượng lại theo thời gian bật thật. Với 4 công tắc, mọi tổ hợp trung gian đều là trạng thái hợp lệ, nên thứ tự đóng không ảnh hưởng an toàn.
- [ ] Vẽ schematic và layout, rà soát chéo, xuất BOM và file gia công, rồi đặt gia công.
- [ ] Sau khi chọn MOSFET: cập nhật `cfg.tr.Rsw` trong `pvreconfig-sim/simulink/sl_config.m` và thời gian chuyển mạch trong `algo/run_arr05.m`.
