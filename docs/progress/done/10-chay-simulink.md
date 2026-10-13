# Chạy và sửa model Simulink lần đầu (mức 1, 3, 4)

**Trạng thái:** xong phần chính, còn 1 ca DES lệch và vài việc phụ (chuyển sang [undone/01](../undone/01-hoan-thien-simulink.md)) · **Ngày:** 13/10/2026
**Phụ trách:** mô phỏng · **Máy:** MATLAB R2026b (trial) + Simulink, Simscape, Simscape Electrical, Parallel Computing, Stateflow
**Code:** `pvreconfig-sim/simulink/` · **Log:** `pvreconfig-sim/results/matlab_log2.txt` · **Chi tiết:** [`simulink-handoff-pv3x3.md` mục 10.1](../../info/simulink-handoff-pv3x3.md)

## Kết quả

| Bước | Kết quả | File trong `pvreconfig-sim/results/` |
|---|---|---|
| `sl_build_model` (dò cổng + dựng 4 model) | Chạy được sau khi sửa (xem dưới) | `../models/*.slx`, `portmap.mat` |
| `sl_module_tests` PV-01..04 | **Đạt**: Pmax lệch 0,00 %; PV-04 kẹp −0,552 V (tham chiếu −0,552 V) | `pv_module_simulink.csv` |
| `sl_run_compare` + `sl_compare` (16 trạng thái × 9 ca) | **TẤT CẢ ĐẠT**: lệch Pmax, P@13 V ≤ 0,04 %, số đỉnh khớp. 144 lần chạy tuần tự, ~13 phút | `arr_summary_simulink.csv`, `compare_simulink_vs_ref.csv`, `sl_results.mat` |
| Ứng suất công tắc (9 ca) | 2,51 A / 7,58 V, khớp tham chiếu trên cùng 9 ca (3,55 A / 7,77 V là của 26 ca, gồm ca cực đoan) | `switch_stress_simulink.csv` |
| `sl_transient_tests` (mức 3) | Chạy đủ 7 ca, có hình. Đóng 4 công tắc cùng lúc: đỉnh 123 A (`mot-tam`) đến 368 A (`cheo`) = ΔV / Rsw, không phụ thuộc Cpv vì model chưa có điện cảm vòng và thời gian chuyển mạch → trường hợp xấu nhất. Đóng lần lượt 1 ms không giảm đỉnh. Dòng xác lập khớp tham chiếu | `transient_simulink.csv`, `.mat`, `fig/transient_1..7.png` |
| `sl_des_check` (mức 4) | 9/10 cấu hình đạt (≤ 1 %). **Lệch:** `mot-tam` chia hàng 4-4-1: Pmax 113,53 so với 113,83 W (0,26 %), P@13 V 79,15 so với 80,36 W (1,5 %) | `des_check_simulink.csv` |

## Đã phải sửa để chạy trên R2026b

| File | Lỗi | Sửa |
|---|---|---|
| `sl_new_model.m`, `sl_save_model.m`, `sl_calibrate_ports.m`, **`sl_simlog_on.m`** (mới) | Model mới tạo bằng `new_system` chưa có tham số `SimscapeLogType` | Bật Simscape log sau khi đã thêm block (lúc lưu, trước `sim`) |
| `sl_set.m` | Ô popup của block Simscape giờ có Type `string`, giá trị là tên enum đầy đủ (`ee.enum.sources.solar_cell_prm.datasheet`) | Nhận dạng giá trị `.enum.`, chọn theo tên thành viên của lớp enum |
| `sl_conf_solar.m` | Mô hình **5 parameter bỏ qua Rp** (Rp = ∞) → Pmax cao hơn tham chiếu 3–9 %, Isc/Voc vẫn khớp | Dùng **8 parameter**, Is2 = 0; nhập gộp cả tấm (N_series = 1) |
| `sl_conf_diode.m` | Diode (ee_lib) có 3 biến thể; mặc định là *ideal* (chỉ PWL/tabulated); regex "Parameterization" khớp nhầm ô nhiệt | `SourceFile = ee.semiconductors.diodes.physical`, `ModelTypePhysical = exponential`, `prmExp = useIsN` đặt trực tiếp |
| `sl_post_extract.m`, `sl_calibrate_ports.m`, **`sl_log_v.m`** (mới) | Solar Cell không log biến `v` (chỉ có nút `p`, `n`) → lần quét đầu ra toàn NaN | Lấy điện áp = `p.v − n.v` |
| `sl_config.m`, `sl_sweep_batch.m` | `parsim` mở 6 worker → máy treo, mất kết nối | `cfg.parallel = false` (mặc định chạy tuần tự) |

Các file dò lỗi (danh sách tham số block, enum, nút log) để ở `results/_debug_r2026b/`.

## Checklist ban đầu

- [x] Kiểm tra cài đặt: `ver` có đủ MATLAB, Simulink, Simscape, Simscape Electrical (+ Parallel, Stateflow).
- [x] `setup_path`, `sl_build_model`: bộ dò cổng tìm được cách nối Solar Cell + diode và cổng điều khiển Switch, CVS.
- [x] `sl_module_tests`: PV-01..04 lệch ≤ 0,5 %, PV-04 ≈ −0,55 V.
- [x] `sl_run_compare` + `sl_compare`: "TẤT CẢ ĐẠT", trạng thái tốt nhất mỗi ca trùng (trong 0,2 W).
- [x] So ứng suất công tắc Simulink với tham chiếu trên 9 ca.
- [x] `sl_transient_tests`: chạy không lỗi, có hình trong `results/fig/`.
- [ ] `sl_des_check`: còn 1 cấu hình lệch → [undone/01](../undone/01-hoan-thien-simulink.md).
- [ ] Chạy lại phần tham chiếu trên MATLAB (trước đây chạy bằng Octave) → undone/01.
- [ ] Chụp ảnh model cho báo cáo → undone/01.
- [x] Cập nhật `pvreconfig-sim/README.md` và tài liệu bàn giao với kết quả thật.

## Sản phẩm phụ

- Trang 3D tương tác `pv3x3-3d.html` (thư mục gốc repo): dàn 3 × 3 với 4 công tắc và DES 54 công tắc, dòng điện chạy trên dây, P–V tính bằng mô hình tham chiếu (khớp `des_summary.csv`). Dùng để giải thích cấu hình trong báo cáo / thuyết trình.
