# Ứng suất công tắc nối chéo (mức 1b)

**Trạng thái:** xong (đã chạy) · **Thời gian:** 12/10/2026
**Code:** `pvreconfig-sim/reference/pv_switch_stress.m`, `run_stress.m` · **Kết quả:** `pvreconfig-sim/results/switch_stress.csv`

## Đã làm

- Tính dòng qua từng công tắc đang đóng (suy từ KCL tại nút ở cột ngoài cùng) và điện áp trên từng công tắc đang mở. Dải tính là toàn bộ vùng dàn phát điện, V = 0 .. V_oc.
- Quét 16 trạng thái × 26 ca:
  - 9 ca che chuẩn.
  - 17 ca cực đoan: từng tấm tối hẳn (G = 0), từng hàng tối, từng cột tối, bàn cờ, chéo phụ.

## Kết quả

| Công tắc | Dòng max khi đóng | Ca | Áp max khi mở | Ca |
|---|---|---|---|---|
| S1 | 2,75 A | bàn cờ, 1011 | 7,63 V | bàn cờ, 0010 |
| S2 | 3,55 A | chéo phụ, 1101 | 7,77 V | chéo phụ, 0010 |
| S3 | 3,55 A | chéo phụ, 1011 | 7,77 V | chéo phụ, 0100 |
| S4 | 2,75 A | bàn cờ, 1101 | 7,63 V | bàn cờ, 0100 |

Tại V = 13 V: dòng max 3,31 A, áp max 7,76 V.

**Ý nghĩa cho PCB:**
- Mỗi công tắc là 2 MOSFET đấu ngược, vì dòng qua mối nối chéo đi được cả hai chiều.
- Chọn MOSFET có V_DS ≥ 20 V (dư cho V_oc lúc trời lạnh) và dòng liên tục ≥ 5 A.
- Tổn hao dẫn ≈ I² · 2 R_DS(on). Với 3,55 A và 2 × 10 mΩ thì khoảng 0,25 W mỗi công tắc trong trường hợp xấu nhất.

## Hạn chế

- Công tắc lý tưởng, thông số tấm giả thiết, 25 °C.
- Chưa xét quá độ lúc đóng/cắt. Phần đó thuộc mức 3: [done/10](../done/10-chay-simulink.md).
