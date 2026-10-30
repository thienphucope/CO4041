# Xác nhận thông số bộ sạc ST-S1230 và tấm PV

**Ưu tiên:** cao (quyết định cách đọc kết quả mô phỏng) · **Phụ trách:** cả nhóm, chủ yếu đo lường (Hoàng Ngô Thiên Phúc)

## Vì sao cần

- **Đã xác nhận 29/10/2026: ST-S1230 là PWM** (ảnh mặt trước, [`docs/info/charger.jpg`](../../info/charger.jpg)). Dàn bị kéo về điện áp pin, nên chỉ tiêu chính là **P(V_pin)**, Pmax chỉ để tham khảo.
- **Pin:** ắc quy axit-chì 12 V 20 Ah XUPAI SUPER-30 (6-DZF-20) ([`docs/info/pin.jpg`](../../info/pin.jpg)); dùng axit-chì vì không cần cân bằng cell. Đặt bộ sạc ở **B01 (14,3 V)**. Trong lúc sạc, áp pin đi từ khoảng 12,5 V lên 14,3 V.
- Mô phỏng đang cố định V_pin = 13 V. Ca `mot-tam` có SP tốt nhất ở 13 V, nhưng từ 14 V trở lên TCT đã hơn (mô hình tham chiếu), nên cấu hình tốt nhất có thể đổi khi áp pin tăng trong lúc sạc. Cần tính P trên cả dải 12,5–14,3 V; kết luận này còn rất nhạy với V_oc/V_mp thật.
- Mọi kết quả mô phỏng hiện dùng **thông số tấm giả thiết** (V_oc = 1,2·V_mp, I_sc = 1,1·I_mp).

## PWM mất công suất do áp, không phải do dòng

- PWM nối thẳng dàn vào pin nên dàn chạy ở áp pin (~13 V) thay vì V_mp = 18 V. Dòng gần như không đổi.
- Nắng đều (`deu`, `results/arr_summary.csv`): 13 V × 8,05 A = **104,7 W**, so với Pmax 18 V × 7,5 A = **135 W** → PWM lấy được 78 %. Bộ sạc MPPT sẽ tăng khoảng 29 %, nhiều hơn mọi phương án đổi cấu hình; nhưng bộ sạc đã chốt nên ngoài phạm vi.
- Dòng dàn tối đa ≈ 3 × I_sc = 8,25 A, mới dùng ~27 % định mức 30 A của bộ sạc (dư, không sao).
- Lúc sạc chính PWM không giới hạn dòng: pin 20 Ah nhận tới ~8 A ≈ 0,4C. Axit-chì thường khuyên ≤ 0,25–0,3C (5–6 A); trang bán pin không ghi, cần xem nhãn trên bình.

## Mở bộ sạc Suoer để đo gì (30/10/2026)

Ghi chép buổi họp 23/09 ([`qa2.md`](../../info/qa2.md), dòng 20): "về sau có thể mở mạch sản phẩm để gắn đầu đo (probe), lấy thông tin đưa lên IoT". Đây là việc tùy chọn, làm sau, không bắt buộc trong GĐ1.

| Thông tin | Đo ở dây ngoài được không |
|---|---|
| V, I phía PV (để chọn cấu hình) | Được: shunt trên dây + (trên bo hoặc shunt rời trên dây) |
| Áp pin, dòng sạc vào pin | Được: thêm 1 shunt trên dây pin |
| PV− và BAT− có thông nhau không | Được: đo thông mạch bằng đồng hồ, không cần mở |
| Bộ sạc đang ở giai đoạn nào (sạc mạnh, giữ áp, ngắt) | Không, phải lấy từ bên trong |
| Thời điểm bộ sạc đóng ngắt PWM | Không, phải gắn đầu đo vào cực G MOSFET bên trong |
| Số liệu MCU của bộ sạc đã đo | Không, phải tìm chân UART hoặc điểm đo trên mạch |

Thông tin có ích nhất cho đề tài là thời điểm đóng ngắt PWM: đó là thứ làm nhiễu số đo khi quét cấu hình. Biết thời điểm này thì ESP32 chỉ đo khi bộ sạc đang dẫn. GĐ1 (chọn cấu hình) chỉ cần V, I phía PV, đo ở dây là đủ.

## Voc và nhiệt độ tấm quyết định kết luận ở 13 V (30/10/2026)

Ở 13 V, cột SP có 1 tấm bị che chỉ chạy được dòng đầy khi 2 tấm sáng gánh đủ 13 V + 0,52 V sụt trên diode bypass, tức 6,76 V mỗi tấm. Voc giả thiết là 7,2 V nên chỉ dư khoảng 0,4 V:

- Tấm nóng (Voc giảm khoảng 0,34 %/°C): từ khoảng 35 °C, TCT thắng SP ở ca 1 tấm. Ngoài trời 30 °C thì tấm nắng khoảng 61 °C, tấm che khoảng 39 °C (NOCT 45 °C). Khi đó SP không thắng ca nào. Ca che cả hàng và ca chéo, SP tụt từ 63,8 W xuống 32,0 W; DES vẫn 80 W.
- Voc thật cao hơn (quét 7,2–8,1 V, `run_sensitivity`): ở 25 °C SP thắng thêm ca 2 tấm. Ở nhiệt độ ngoài trời, SP vẫn không thắng ca nào.

Số liệu: `results/*_noct.csv`, `results/sensitivity_voc.csv`; slide "nhiệt độ tấm" và "13 V khi tấm nóng".

## Việc cần làm

- [ ] Hỏi thầy phạm vi đo khi mở bộ sạc: chỉ phía PV, thêm phía pin, hay cả trạng thái bên trong (giai đoạn sạc, lúc đóng ngắt PWM). Đã đưa vào câu 3 slide câu hỏi.

- [x] Kiểu bộ sạc: **PWM**; ngưỡng sạc B01 axit-chì 14,3 V, B02 Li-ion 12,7 V, B03 LiFePO4 14,6 V (29/10/2026).
- [x] Thông số ST-S1230 theo trang bán hàng (chưa có datasheet hãng, 29/10/2026): 12/24 V tự nhận, **30 A**, **áp PV tối đa 50 V** (dàn 3 × 3 V_oc ≈ 21,6 V, an toàn), tự tiêu thụ ≤ 10 mA, USB 5 V/2 A. Axit-chì B01: sạc 14,3 V, float 13,7 V, ngắt tải 10,7 V, đóng lại 12,6 V. Nguồn: [hub360](https://hub360.cc/product/super-st-s1230-pwm-solar-charge-controller/), [acquyhaiphong](https://acquyhaiphong.vn/san-pham/bo-dieu-khien-sac-nang-luong-mat-troi-12v-24v-30a-suoer-st-s1230). Đối chiếu nhãn mặt sau khi có thể.
- [ ] Mô phỏng: thay V_pin cố định 13 V bằng dải 12,5–14,3 V (Pbat ở nhiều mức áp) cho mức 1, 2, 4.
- [ ] Lấy datasheet tấm TEKI 6 V/15 W, hoặc đo từng tấm ngoài nắng: V_oc, I_sc, và đường I–V (bằng tải điện tử hoặc biến trở). **Quan trọng nhất là V_oc**: kết luận SP/TCT ở 13 V phụ thuộc trực tiếp vào nó (xem mục trên). Ghi kèm nhiệt độ mặt sau tấm và bức xạ lúc đo để quy về 25 °C.
- [ ] Đo nhiệt độ tấm khi nắng (nhiệt kế hồng ngoại hoặc NTC dán mặt sau) để chốt NOCT thay cho giả thiết 45 °C trong `pv_thermal.m`.
- [ ] Kiểm tra mỗi tấm đã có diode bypass sẵn chưa.
- [ ] Xem nhãn pin XUPAI 6-DZF-20: dòng sạc tối đa, so với ~8 A dàn có thể đẩy vào qua PWM.
- [ ] Sửa `pvreconfig-sim/pv_module_params.m` (hàm `default_datasheet()`), rồi chạy lại mọi mức: `run_all`.
- [ ] Cập nhật bảng số trong [`docs/info/simulink-handoff-pv3x3.md`](../../info/simulink-handoff-pv3x3.md), README và các file `done/`.
- [ ] Đo hoặc ước lượng điện dung tấm (Cpv) cho mô phỏng quá độ ở mức 3.
- [ ] Chốt công suất tải (tải tĩnh).
