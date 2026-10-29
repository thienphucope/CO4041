# Xác nhận thông số bộ sạc ST-S1230 và tấm PV

**Ưu tiên:** cao (quyết định cách đọc kết quả mô phỏng) · **Phụ trách:** cả nhóm, chủ yếu đo lường (Hoàng Ngô Thiên Phúc)

## Vì sao cần

- **Đã xác nhận 29/10/2026: ST-S1230 là PWM** (ảnh mặt trước, [`docs/info/charger.jpg`](../../info/charger.jpg)). Dàn bị kéo về điện áp pin, nên chỉ tiêu chính là **P(V_pin)**, Pmax chỉ để tham khảo.
- **Pin:** ắc quy axit-chì 12 V 20 Ah XUPAI SUPER-30 (6-DZF-20) ([`docs/info/pin.jpg`](../../info/pin.jpg)); dùng axit-chì vì không cần cân bằng cell. Đặt bộ sạc ở **B01 (14,3 V)**. Trong lúc sạc, áp pin đi từ khoảng 12,5 V lên 14,3 V.
- Mô phỏng đang cố định V_pin = 13 V. Ca `mot-tam` có SP tốt nhất ở 13 V, nhưng từ 14 V trở lên TCT đã hơn (mô hình tham chiếu), nên cấu hình tốt nhất có thể đổi khi áp pin tăng trong lúc sạc. Cần tính P trên cả dải 12,5–14,3 V; kết luận này còn rất nhạy với V_oc/V_mp thật.
- Mọi kết quả mô phỏng hiện dùng **thông số tấm giả thiết** (V_oc = 1,2·V_mp, I_sc = 1,1·I_mp).

## Việc cần làm

- [x] Kiểu bộ sạc: **PWM**; ngưỡng sạc B01 axit-chì 14,3 V, B02 Li-ion 12,7 V, B03 LiFePO4 14,6 V (29/10/2026).
- [x] Thông số ST-S1230 theo trang bán hàng (chưa có datasheet hãng, 29/10/2026): 12/24 V tự nhận, **30 A**, **áp PV tối đa 50 V** (dàn 3 × 3 V_oc ≈ 21,6 V, an toàn), tự tiêu thụ ≤ 10 mA, USB 5 V/2 A. Axit-chì B01: sạc 14,3 V, float 13,7 V, ngắt tải 10,7 V, đóng lại 12,6 V. Nguồn: [hub360](https://hub360.cc/product/super-st-s1230-pwm-solar-charge-controller/), [acquyhaiphong](https://acquyhaiphong.vn/san-pham/bo-dieu-khien-sac-nang-luong-mat-troi-12v-24v-30a-suoer-st-s1230). Đối chiếu nhãn mặt sau khi có thể.
- [ ] Mô phỏng: thay V_pin cố định 13 V bằng dải 12,5–14,3 V (Pbat ở nhiều mức áp) cho mức 1, 2, 4.
- [ ] Lấy datasheet tấm TEKI 6 V/15 W, hoặc đo từng tấm ngoài nắng: V_oc, I_sc, và đường I–V (bằng tải điện tử hoặc biến trở).
- [ ] Kiểm tra mỗi tấm đã có diode bypass sẵn chưa.
- [ ] Sửa `pvreconfig-sim/pv_module_params.m` (hàm `default_datasheet()`), rồi chạy lại mọi mức: `run_all`.
- [ ] Cập nhật bảng số trong [`docs/info/simulink-handoff-pv3x3.md`](../../info/simulink-handoff-pv3x3.md), README và các file `done/`.
- [ ] Đo hoặc ước lượng điện dung tấm (Cpv) cho mô phỏng quá độ ở mức 3.
- [ ] Chốt công suất tải (tải tĩnh).
