# pvreconfig-sim — mô phỏng dàn PV 3 × 3 chuyển cấu hình

Thư mục làm việc của toàn bộ phần mô phỏng. Trong MATLAB, `cd` vào đây rồi:

```matlab
run_all        % mọi mức; phần Simulink tự bỏ qua nếu thiếu toolbox
```

Cần: MATLAB + Simulink + Simscape + Simscape Electrical. Tùy chọn: Parallel Computing Toolbox (`parsim`), Stateflow. Danh sách đầy đủ và cách kiểm tra: [`docs/info/cai-dat-matlab.md`](../docs/info/cai-dat-matlab.md). Đặc tả thông số và số liệu tham chiếu: [`docs/info/simulink-handoff-pv3x3.md`](../docs/info/simulink-handoff-pv3x3.md).

> **Trạng thái (13/10/2026):** đã chạy `sl_run_all` trên MATLAB R2026b (log: `results/matlab_log2.txt`).
> - Mức 1 tĩnh, ứng suất công tắc, DES tĩnh: kiểm chứng bằng mô hình tham chiếu, số liệu ở `results/`.
> - Simulink PV-01..04: **ĐẠT** (Pmax lệch 0,00 %, bypass −0,552 V).
> - Simulink mức 1 (16 trạng thái × 9 ca): **ĐẠT**, lệch Pmax/Pbat ≤ 0,04 %. Ứng suất công tắc: 2,51 A / 7,58 V, khớp tham chiếu.
> - Simulink mức 3 (quá độ): đã chạy, xem `transient_simulink.csv`, `fig/`.
> - Simulink DES: 9/10 cấu hình đạt; `mot-tam` chia hàng 4-4-1 lệch Pbat 1,5 % (79,15 so với 80,36 W), chưa rõ nguyên nhân.
> - Mức 2: mới chạy thử luồng code, chưa có kết quả đầy đủ.
> - Sửa cho R2026b: Solar Cell dùng mô hình 8 tham số (mô hình 5 tham số bỏ qua Rp); Diode chuyển sang biến thể `physical`; ô popup dạng enum chuỗi (`sl_set`); Simscape log bật sau khi có block (`sl_simlog_on`); điện áp Solar Cell lấy từ p.v − n.v (`sl_log_v`); tắt `parsim` mặc định (`cfg.parallel`).

## Các mức mô phỏng

| Mức | Câu hỏi trả lời | Lệnh | Kết quả |
|---|---|---|---|
| **1. Tĩnh** | Mỗi dạng che bóng: trạng thái 4 công tắc nào cho công suất lớn nhất, hơn SP bao nhiêu (Pmax và P tại 13 V) | `run_reference` (tham chiếu), `sl_run_compare` (Simulink) | `arr_summary.csv`, `arr_summary_simulink.csv` |
| **1b. Ứng suất công tắc** | Dòng lớn nhất qua công tắc đóng, điện áp lớn nhất trên công tắc mở → chọn MOSFET | `run_stress`, `sl_run_compare` | `switch_stress.csv`, `switch_stress_simulink.csv` |
| **2. Thuật toán theo thời gian** | Bóng di chuyển: thuật toán quét/leo đồi thu được bao nhiêu điện năng so với cận trên (oracle), mất bao nhiêu do quét; ảnh hưởng của bộ sạc PWM / MPPT / P&O | `run_arr05` | `arr05_summary.csv`, `arr05_traces.mat` |
| **3. Quá độ đóng/cắt** | Xung dòng khi đổi cấu hình, đóng cùng lúc hay lần lượt, ảnh hưởng điện dung tấm | `sl_transient_tests` (chỉ Simulink) | `transient_simulink.csv`, `fig/transient_*.png` |
| **4. DES** | Đổi nhóm từng tấm giữa 3 hàng TCT (Ref 3): tăng thêm bao nhiêu so với 4 công tắc; chọn theo EI có tốt không | `run_des`, `run_arr05` (phần DES), `sl_des_check` | `des_summary.csv`, `des_check_simulink.csv` |

Chưa làm (cần thông tin chưa có): mạch kích cổng MOSFET và đặc tính chuyển mạch thật (chưa chọn linh kiện), mô hình bộ biến đổi bên trong ST-S1230 (chưa biết PWM hay MPPT), firmware ESP32.

## Kết quả đã có (mô hình tham chiếu, thông số tấm giả thiết, 25 °C)

**Mức 1 — Pmax (W):**

| Ca | SP | TCT | BL | Tốt nhất | so với SP | P@13V SP | P@13V TCT |
|---|---|---|---|---|---|---|---|
| deu | 135,00 | 135,00 | 135,00 | 135,00 (mọi trạng thái) | 0 % | 104,71 | 104,71 |
| mot-tam | 103,84 | 111,09 | 107,94 | 111,09 (TCT) | +7,0 % | 91,06 | 82,22 |
| hai-tam | 88,64 | 105,48 | 104,27 | 105,48 (1011) | +19,0 % | 77,41 | 80,40 |
| hang-1 | 85,87 | 85,87 | 85,87 | 85,87 | 0 % | 63,76 | 63,76 |
| cot-1 | 100,98 | 100,98 | 100,98 | 100,98 | 0 % | 79,69 | 79,69 |
| cheo | 85,87 | 100,98 | 100,98 | 100,98 (BL) | +17,6 % | 63,76 | 79,69 |
| goc-2x2 | 70,53 | 72,19 | 72,02 | 72,19 (0011) | +2,4 % | 55,23 | 55,47 |
| bong-dai | 81,78 | 81,78 | 81,78 | 81,78 | 0 % | 65,40 | 65,40 |
| ngau-nhien | 56,33 | 78,72 | 62,27 | 78,72 (TCT) | +39,8 % | 42,95 | 61,21 |

**Mức 1b — ứng suất công tắc nối chéo:** quét 16 trạng thái × 26 ca (9 ca trên + 17 ca cực đoan có tấm tối hẳn), toàn dải 0..V_oc.
- Dòng lớn nhất qua công tắc đóng: **3,55 A** (S2, S3).
- Điện áp lớn nhất trên công tắc mở: **7,77 V**.
- Tại 13 V: 3,31 A / 7,76 V.

Từ đó, MOSFET cho mỗi nửa công tắc cần V_DS ≥ 20 V (dư cho V_oc lúc lạnh) và chịu dòng liên tục ≥ 5 A.

**Mức 4 — DES (W):**

| Ca | Chỉ tiêu | 4 công tắc tốt nhất | DES, mỗi hàng 3 tấm | DES, cho hàng không đều | Chọn theo EI (3025 cách) | Tham lam |
|---|---|---|---|---|---|---|
| hang-1 | Pmax | 85,87 | 100,99 | 100,99 | 100,99 | 100,99 |
| goc-2x2 | Pmax | 72,19 | 75,63 | **89,78** | 89,78 | 75,63 |
| ngau-nhien | Pmax | 78,72 | 82,88 | 82,88 | 82,88 | 82,88 |
| mot-tam | Pmax | 111,09 | 111,10 | 113,83 | 111,10 | 111,10 |
| mot-tam | P@13V | **91,06** (SP) | 82,23 | 82,23 | 82,23 | 82,23 |

- DES giúp được cả ca che nguyên hàng, là ca mà 4 công tắc nối chéo bó tay.
- Cho phép các hàng có số tấm khác nhau thì ca `goc-2x2` hơn 4 công tắc 24 % (89,78 so với 72,19 W).
- Nhưng DES thuộc họ TCT nên tại 13 V (bộ sạc PWM) có ca vẫn thua SP.
- Chọn theo EI không phải lúc nào cũng trùng với cấu hình cho công suất lớn nhất.

Bảng đầy đủ: `results/des_summary.csv`.

## Cấu trúc

| Thư mục / file | Nội dung |
|---|---|
| `run_all.m`, `setup_path.m` | Chạy tất cả; thêm path |
| `pv_module_params.m` | Tham số tấm. **Sửa thông số ở `default_datasheet()`** rồi chạy lại |
| `pv_shading_cases.m`, `pv_states.m`, `pv_metrics.m` | 9 ca che, 16 trạng thái, chỉ tiêu (dùng chung) |
| `reference/` | Mô hình vật lý tham chiếu (MATLAB thuần): `pv_module_current`, `pv_array_iv` (4 công tắc, giải KCL), `pv_des_*` (DES), `pv_switch_stress`; `run_reference`, `verify_sp`, `verify_des`, `run_stress`, `plot_cases` |
| `algo/` | Mức 2 và DES: `shadow_profiles` (4 kịch bản bóng), `arr05_table`, `simulate_algo` (bộ mô phỏng thời gian), `run_arr05`, `des_partitions`, `des_assign`, `run_des`, `plot_arr05` |
| `simulink/` | Dựng model bằng code + chạy: `sl_build_model` (dựng `pv1`, `pv3x3`, `pv3x3_tr`, `pv3x3_des`), `sl_calibrate_ports`, `sl_module_tests`, `sl_run_compare`, `sl_compare`, `sl_transient_tests`, `sl_des_check`, `sl_sweep_batch`, `sl_run_all` |
| `models/` | Các `.slx` được tạo ra (+ `portmap.mat`) |
| `results/` | CSV, MAT, `fig/` |

## Mức 2 — giả thiết của bộ mô phỏng thời gian

- **Kịch bản bóng (60 s):**
  - `canh-ngang`: mép bóng thẳng đứng đi ngang.
  - `canh-cheo`: mép bóng chéo.
  - `cot-dien`: dải bóng hẹp quét qua.
  - `dam-may`: đám mây tròn.

  Bức xạ tấm tính theo tỉ lệ diện tích bị bóng. Giả thiết này lạc quan: tấm bị phủ một phần thực tế còn giảm công suất mạnh hơn.
- **Thuật toán 4 công tắc:**
  - Cố định SP hoặc TCT.
  - Oracle: cận trên, không tốn thời gian quét.
  - Quét đủ 16 trạng thái mỗi 2/5/10/30 s.
  - Quét khi công suất đổi quá 5 %.
  - Leo đồi: mỗi lần chỉ thử đảo 1 công tắc.
- **Thời gian:** MOSFET chuyển 5 ms và đo 20 ms mỗi trạng thái; relay 20 ms và 100 ms. Trong lúc chuyển, công suất lấy bằng giá trị nhỏ hơn của cấu hình cũ và mới.
- **Bộ sạc:**
  - `pwm`: dàn bị kẹp ở 13 V.
  - `mppt`: MPPT lý tưởng, luôn ở điểm công suất cực đại toàn cục.
  - `po`: MPPT kiểu P&O, mỗi 0,1 s nhích 0,2 V, có thể kẹt ở đỉnh cục bộ.
- **DES:** mỗi 2 s ước lượng bức xạ từng tấm (có thể thêm sai số 5 %), rồi chia hàng theo một trong các cách: EI nhỏ nhất trong 3025 cách, EI nhỏ nhất trong 280 cách, tham lam, hoặc dùng mô hình để chọn.

## Mức 3 — giả thiết model quá độ (`sl_config.m`, mục `cfg.tr`)

| Thông số | Giá trị |
|---|---|
| Điện trở mỗi công tắc khi đóng (Rsw) | 20 mΩ (= 2 × R_DS(on) 10 mΩ) |
| Điện dung tương đương mỗi tấm (Cpv) | 5 µF (chưa đo, quét 1–10 µF) |
| Dây ra bộ sạc | 50 mΩ, 1 µH |
| Phía bộ sạc | Pin 13 V (bộ sạc PWM đang đóng) |

Công tắc đổi trạng thái tức thời, nên xung dòng tính được là trường hợp xấu nhất.

## Model Simulink được dựng thế nào

- Mỗi tấm `PVrc` là một subsystem gồm Solar Cell (tham số mạch tương đương, khớp mô hình tham chiếu) và Diode mũ mắc ngược song song.
- Công tắc dùng block Switch (Foundation).
- Nguồn quét là Ramp đưa vào Controlled Voltage Source. V và I đọc từ Simscape log, không dùng sensor.
- Biến điều khiển nằm trong model workspace (`G`, `S`/`R`, `T`, `Vmin`, `Vmax`…). Script đặt lại biến bằng `SimulationInput.setVariable(..., 'Workspace', mdl)`.
- Lần chạy đầu, `sl_calibrate_ports` dựng vài mạch thử nhỏ để biết cổng nào của block là +, −, hay cổng tín hiệu, rồi lưu vào `models/portmap.mat`. Đổi phiên bản MATLAB thì chạy `sl_build_model(true)`.
