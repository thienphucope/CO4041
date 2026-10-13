# Mô hình tham chiếu và mô phỏng tĩnh (mức 1)

**Trạng thái:** xong (đã chạy và kiểm chứng) · **Thời gian:** 05 – 06/10/2026
**Code:** `pvreconfig-sim/reference/` và các file dùng chung ở `pvreconfig-sim/`

## Đã làm

- **Mô hình một tấm:** một diode, có diode bypass.
  - `pv_module_params.m` trích Iph, I0, Rs, Rsh từ 4 điều kiện datasheet.
  - `pv_module_current.m` tính dòng theo điện áp, bức xạ và nhiệt độ.
- **Mô hình dàn 3 × 3 + S1–S4:** `pv_array_iv.m` giải KCL tại các nút bằng Newton. Công tắc đóng coi là lý tưởng (gộp nút).
- **Kiểm tra độc lập:** `verify_sp.m` dựng SP và TCT bằng cách ghép nối tiếp/song song trực tiếp, kết quả trùng với solver.
- **Ca thử:**
  - PV-01..04 cho một tấm (`run_module_tests.m`).
  - ARR-01..04: quét 16 trạng thái × 9 ca che bóng (`run_compare.m`, ghi `results/arr_summary.csv`).
- Chạy cả bộ: `reference/run_reference.m`.

## Kết quả chính (thông số tấm giả thiết, 25 °C)

**Một tấm:**

| Ca | Kết quả |
|---|---|
| PV-01 | Isc 2,750 A, Voc 7,200 V, Pmax 15,000 W: khớp đúng datasheet giả thiết |
| PV-02 (400 / 700 W/m²) | Pmax 5,416 / 10,153 W |
| PV-03 (45 / 60 °C) | Pmax 13,764 / 12,823 W |
| PV-04 | Tấm bị che, ép dòng 2,5 A: kẹp ở −0,552 V (diode bypass dẫn) |

**Cả dàn (W):**

| Ca | SP | TCT | Tốt nhất | so với SP | P@13V SP / TCT |
|---|---|---|---|---|---|
| deu | 135,00 | 135,00 | mọi trạng thái | 0 % | 104,71 / 104,71 |
| mot-tam | 103,84 | 111,09 | TCT | +7,0 % | **91,06** / 82,22 |
| hai-tam | 88,64 | 105,48 | 1011 | +19,0 % | 77,41 / 80,40 |
| hang-1 | 85,87 | 85,87 | mọi trạng thái | 0 % | 63,76 / 63,76 |
| cot-1 | 100,98 | 100,98 | mọi trạng thái | 0 % | 79,69 / 79,69 |
| cheo | 85,87 | 100,98 | BL | +17,6 % | 63,76 / 79,69 |
| goc-2x2 | 70,53 | 72,19 | 0011 | +2,4 % | 55,23 / 55,47 |
| bong-dai | 81,78 | 81,78 | mọi trạng thái | 0 % | 65,40 / 65,40 |
| ngau-nhien | 56,33 | 78,72 | TCT | +39,8 % | 42,95 / 61,21 |

**Nhận xét:**
- Che nguyên hàng, nguyên cột, hoặc bóng dài theo cột: nối chéo không giúp gì.
- Che lệch giữa hàng và cột: nối chéo tăng 17–40 %.
- Ca `cheo`: một số trạng thái nối chéo một phần còn kém hơn SP.
- Ca `mot-tam`: TCT có Pmax cao nhất, nhưng tại 13 V thì SP hơn. Vì vậy cấu hình tốt nhất phụ thuộc bộ sạc là PWM hay MPPT.

## Hạn chế

- Thông số tấm là giả thiết. Khi có datasheet hoặc số đo thì sửa `default_datasheet()` và chạy lại.
- Bộ kết quả trên được chạy bằng Octave trước ngày 12/10/2026. Từ đó dự án chỉ dùng MATLAB, nên khi có MATLAB cần chạy lại `run_reference` để xác nhận.
