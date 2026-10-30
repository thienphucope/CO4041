# Thiết kế PCB mạch chuyển cấu hình (mốc M4)

**Ưu tiên:** cao (gia công là rủi ro tiến độ chính) · **Phụ trách:** PCB (Lê Thanh Phú) · Kế hoạch: tuần 3–5, làm song song với mô phỏng

## Đầu vào đã có

- **Topology:** 4 công tắc nối chéo S1–S4; phần nối tiếp đấu cứng nên không thể tạo 9S hay 9P ([done/03](../done/03-chot-pham-vi-va-cau-hinh.md)).
- **Ứng suất mỗi công tắc:** dòng max 3,55 A, áp max 7,77 V. Gợi ý MOSFET có V_DS ≥ 20 V, dòng ≥ 5 A ([done/05](../done/05-ung-suat-cong-tac.md)).
- **Báo giá gia công:** thienlampcb.com ([`docs/pcb/order-pcb-at.md`](../../pcb/order-pcb-at.md)).

## Đi dây và linh kiện dự kiến (30/10/2026)

**Đi dây:** mỗi cột 3 tấm nối tiếp ngay ở mặt sau dàn. Cực + của 3 cột luôn nối chung ở mọi cấu hình, nên gom bằng đầu nối chữ Y (3→1, loại MC4) ngay ở dàn thành 1 dây đỏ to (≥ 2,5 mm², ≤ 8,25 A); cực − cũng vậy. Hộp PCB nhận 8 dây: 6 dây nút (nút 1, nút 2 của 3 cột) và cặp dây nguồn; có 2 dây ra đầu vào PV của ST-S1230.

**Bố cục bo (bản phác 30/10/2026, 100 × 80 mm, 2 lớp):** J1 (3 cực nút 1) và J2 (3 cực nút 2) đặt ngay trên 4 ô công tắc, thứ tự trái → phải khớp cực D nên dây đi thẳng, không bắt chéo. Đường công suất là 2 cột đồng phủ rộng khoảng 8 mm dọc mép phải: J3 (vào) → shunt R17 (đo phía +) → cầu chì F1 → J4 (ra), cột − chạy thẳng song song, TVS D6 bắc ngang hai cột. GND phía điều khiển là lớp đồng phủ mặt dưới, nối liền cột −. Mô hình 3D: artifact "Hộp PCB dàn PV 3×3".

Đóng Sk tức là nối 2 dây nút tương ứng: S1 = nút 1 cột 1–2, S2 = nút 1 cột 2–3, S3 = nút 2 cột 1–2, S4 = nút 2 cột 2–3. Dòng tối đa: dây cột ≤ 2,75 A, dây nút ≤ 3,55 A, dây ra ≤ 8,25 A.

**Mỗi ô công tắc (× 4):**

| Linh kiện | Vai trò |
|---|---|
| 2 MOSFET đấu ngược, chung cực S | Chặn cả hai chiều |
| Driver photovoltaic (ví dụ VOM1271, TLP3906) | Tạo áp cổng thả nổi khoảng 8 V từ LED bên trong, cách ly với ESP32 |
| Điện trở GPIO → LED driver | Giới hạn dòng LED, khoảng 10 mA |
| Điện trở G–S 100 kΩ – 1 MΩ | Giữ MOSFET tắt khi không kích |
| TVS hoặc zener G–S (tùy chọn) | Chống quá áp cổng |

**Phần chung:**

| Linh kiện | Vai trò |
|---|---|
| Shunt + IC đo (ví dụ INA226, I²C) | Đo V, I đầu ra để tính P cho thuật toán quét |
| ESP32 | Điều khiển 4 công tắc (4 GPIO), đọc IC đo |
| Ổn áp 3,3 V + tụ 10 µF, 100 nF | Nuôi ESP32 từ 5 V (cổng USB 5 V/2 A của ST-S1230) |
| TVS đầu vào PV (khoảng 24 V, V_oc dàn 21,6 V) | Chống xung áp |
| Cầu chì đầu ra | Bảo vệ chạm chập |
| Cực bắt vít: J1, J2 3 cực nút ≥ 5 A; J3 vào, J4 ra 2 cực ≥ 10 A; J5 5 V | Theo dòng tối đa |
| LED trạng thái + điện trở | Gỡ lỗi |

Khoảng 40–50 linh kiện; bo ước lượng 10 × 8 cm, hộp khoảng 16 × 11 cm. Chỗ khó: thời gian bật/tắt của driver photovoltaic (cỡ ms), đường mạch đầu ra 8,25 A (rộng khoảng 3–4 mm với đồng 1 oz), và mass của ESP32 so với PV−.

## Việc cần làm

- [ ] Đo xem PV− và BAT− của ST-S1230 có thông nhau không. Nhiều bộ PWM đóng cắt ở dây âm; khi đó ESP32 lấy nguồn USB (mass theo pin) sẽ lệch mass với mạch đo phía PV, phải đo cách ly hoặc nuôi ESP32 từ phía dàn.

- [ ] **Công tắc:** 2 MOSFET đấu ngược chung cực S mỗi công tắc (áp trên công tắc mở đổi chiều theo bóng che, một MOSFET sẽ dẫn qua diode ký sinh), hoặc relay. Chọn mã linh kiện; tính tổn hao dẫn I²·2R_DS(on).
- [ ] **Mạch kích:** cực S chung nằm ở điện thế nút (nút 1 ≈ 12 V, nút 2 ≈ 6 V, thay đổi theo điểm làm việc), nên mạch kích cổng phải thả nổi theo cực S, cách ly với mass của vi điều khiển. Một mạch kích cho cả cặp MOSFET (G chung – S chung). Dùng photovoltaic driver, charge-pump cách ly, hoặc nguồn cách ly nhỏ + gate driver. **Không dùng bootstrap:** công tắc giữ trạng thái đóng liên tục, không băm xung nên tụ bootstrap không được nạp lại. Tham khảo phân tích áp chịu đựng theo vị trí công tắc trong Ref R4 (Ng & Ertugrul 2025).
- [ ] **Đo lường:** bắt buộc áp và dòng đầu ra dàn, vì thuật toán quét phải đo công suất từng trạng thái (giả thiết 20 ms mỗi trạng thái trong `algo/run_arr05.m`). Mở rộng: áp tại các nút trung gian, dòng từng nhánh, để nhận biết bóng che.
- [ ] **Bảo vệ:** diode bypass (nếu tấm chưa có), cầu chì đầu ra, đầu nối chịu khoảng 8 A, công tắc ngắt dàn khỏi bộ sạc.
- [ ] **Xung dòng khi đóng:** đỉnh 123–368 A ở mức 3 ([done/10](../done/10-chay-simulink.md)) chỉ là cận trên của mô hình: công tắc lý tưởng đóng tức thì nên đỉnh = ΔV / R_on, chưa có điện cảm vòng và thời gian bật MOSFET. Xung do điện dung tấm xả qua công tắc (không phải dòng tấm cấp, dòng xác lập vẫn ≤ I_sc), năng lượng nhỏ (≤ 1,8 mJ mỗi lần, `transient_simulink.csv`). Photovoltaic driver vốn bật chậm nên nhiều khả năng **không cần mạch đóng chậm riêng**. Khi chọn MOSFET và driver: so I_DM và SOA xung trong datasheet với xung ước lượng lại theo thời gian bật thật. Với 4 công tắc, mọi tổ hợp trung gian đều là trạng thái hợp lệ, nên thứ tự đóng không ảnh hưởng an toàn.
- [ ] Vẽ schematic và layout, rà soát chéo, xuất BOM và file gia công, rồi đặt gia công.
- [ ] Sau khi chọn MOSFET: cập nhật `cfg.tr.Rsw` trong `pvreconfig-sim/simulink/sl_config.m` và thời gian chuyển mạch trong `algo/run_arr05.m`.
