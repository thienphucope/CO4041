# Xác nhận thông số bộ sạc ST-S1230 và tấm PV

**Ưu tiên:** cao (quyết định cách đọc kết quả mô phỏng) · **Phụ trách:** cả nhóm, chủ yếu đo lường (Hoàng Ngô Thiên Phúc)

## Vì sao cần

- Nếu ST-S1230 là **PWM**: dàn bị kéo về điện áp pin (12,5–14,4 V), nên phải so các cấu hình theo **P(13 V)**. Khi đó ca `mot-tam` có SP là tốt nhất.
- Nếu là **MPPT**: so theo **Pmax**. Khi đó TCT tốt nhất.
- Mọi kết quả mô phỏng hiện dùng **thông số tấm giả thiết** (V_oc = 1,2·V_mp, I_sc = 1,1·I_mp).

## Việc cần làm

- [ ] Đọc nhãn và hướng dẫn kèm ST-S1230: kiểu PWM hay MPPT, V_oc PV tối đa (thông tin sơ bộ ~50 V), dòng PV tối đa, ngưỡng sạc.
- [ ] Lấy datasheet tấm TEKI 6 V/15 W, hoặc đo từng tấm ngoài nắng: V_oc, I_sc, và đường I–V (bằng tải điện tử hoặc biến trở).
- [ ] Kiểm tra mỗi tấm đã có diode bypass sẵn chưa.
- [ ] Sửa `pvreconfig-sim/pv_module_params.m` (hàm `default_datasheet()`), rồi chạy lại mọi mức: `run_all`.
- [ ] Cập nhật bảng số trong [`docs/info/simulink-handoff-pv3x3.md`](../../info/simulink-handoff-pv3x3.md), README và các file `done/`.
- [ ] Đo hoặc ước lượng điện dung tấm (Cpv) cho mô phỏng quá độ ở mức 3.
- [ ] Chốt công suất tải (tải tĩnh).
