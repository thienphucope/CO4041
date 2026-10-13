# Code dựng và chạy model Simulink (mức 1, 3, 4)

**Trạng thái:** code viết 12/10/2026; **đã chạy và sửa trên R2026b ngày 13/10/2026** → [done/10](10-chay-simulink.md)
**Code:** `pvreconfig-sim/simulink/`

## Đã viết

| File | Việc |
|---|---|
| `sl_build_model.m` | Dựng bằng code cả 4 model: `pv1` (1 tấm), `pv3x3` (dàn + S1–S4), `pv3x3_tr` (quá độ), `pv3x3_des` (DES 54 công tắc) |
| `sl_calibrate_ports.m` | Dựng vài mạch thử nhỏ để biết cổng nào của Solar Cell, Diode, Switch, CVS là +, −, hay cổng tín hiệu (`PortHandles` không cho biết); kết quả lưu `models/portmap.mat` |
| `sl_set.m` | Đặt tham số block theo chữ trên hộp thoại (regex), vì tên biến nội bộ đổi giữa các phiên bản; báo lỗi kèm danh sách ô có sẵn |
| `sl_conf_solar.m`, `sl_conf_diode.m`, `sl_pv_values.m` | Tham số Solar Cell (theo 1 cell hoặc gộp cả tấm) và diode bypass |
| `sl_make_pv.m`, `sl_add_sweep.m` | Subsystem 1 tấm; nguồn quét Ramp → CVS, đo bằng Simscape log |
| `sl_sweep_batch.m`, `sl_post_extract.m` | Chạy hàng loạt (parsim nếu có), rút V, I, dòng/áp công tắc, điện áp từng tấm ngay sau mỗi lần chạy rồi bỏ log |
| `sl_module_tests.m` | PV-01..04 so với tham chiếu, ngưỡng 0,5 % |
| `sl_run_compare.m`, `sl_compare.m` | ARR-01..04 và ứng suất công tắc; đối chiếu với tham chiếu, ngưỡng 1 % |
| `sl_build_transient.m`, `sl_transient_tests.m` | Mức 3: tụ tấm, dây, pin 13 V, công tắc đổi theo Step; 7 ca (đóng cùng lúc / lần lượt, TCT→SP, Cpv 1/5/10 µF…) |
| `sl_build_des.m`, `sl_des_check.m` | Mức 4: ma trận DES 54 công tắc, so với mô hình DES tham chiếu |
| `sl_run_all.m`, `../run_all.m` | Chạy toàn bộ |

## Rủi ro đã biết khi chạy lần đầu (13/10: đã gặp 4/5 mục, xem bảng sửa trong done/10)

- Chữ trên hộp thoại block (regex trong `sl_set`) có thể khác với phiên bản MATLAB cài trên máy.
- Đường dẫn thư viện block (`sl_config.m`, mục `cfg.lib`).
- Tên biến trong Simscape log (`CVS.v`, `CVS.i`, `SC.v`, `S1.i`).
- Cách `PostSimFcn` trả dữ liệu về trong `parsim`.
- Bộ dò cổng có tìm đúng cách nối hay không.
