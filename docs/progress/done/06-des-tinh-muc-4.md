# DES dạng tĩnh: đổi nhóm từng tấm giữa 3 hàng (mức 4)

**Trạng thái:** xong (đã chạy và kiểm chứng) · **Thời gian:** 12/10/2026
**Code:** `pvreconfig-sim/reference/pv_des_*.m`, `verify_des.m`; `pvreconfig-sim/algo/des_partitions.m`, `des_assign.m`, `run_des.m` · **Kết quả:** `pvreconfig-sim/results/des_summary.csv`

## Đã làm

- **Mô hình DES theo Ref 3:** mỗi tấm nối được vào 1 trong 3 hàng, các hàng nối tiếp với nhau, nên dàn luôn ≈ 21,6 V V_oc (hợp với ST-S1230).
- **Liệt kê cách chia hàng:** 3025 cách chia 9 tấm vào 3 hàng khác rỗng, trong đó 280 cách có mỗi hàng đúng 3 tấm.
- **Cách tính nhanh:** tính sẵn đường v(I) của cả 511 nhóm tấm mắc song song có thể có. Điện áp dàn = tổng điện áp 3 hàng tại cùng một dòng, nên duyệt được cả 3025 cách trong vài giây.
- **Kiểm chứng:** cách chia "TCT gốc" so với solver Newton (S = 1111) lệch Pmax và P(13 V) ≤ 0,003 W trên cả 9 ca.
- **Thuật toán chọn cách chia từ bức xạ ước lượng:**
  - EI nhỏ nhất trong 3025 cách (mục tiêu của DP trong Ref 3).
  - EI nhỏ nhất trong 280 cách.
  - Tham lam: xếp tấm theo G giảm dần, tấm nào cũng vào hàng có tổng nhỏ nhất còn chỗ.

## Kết quả nổi bật (W)

| Ca | 4 công tắc tốt nhất | DES 280 | DES 3025 | EI (3025) | Tham lam |
|---|---|---|---|---|---|
| hang-1 Pmax | 85,87 | 100,99 | 100,99 | 100,99 | 100,99 |
| goc-2x2 Pmax | 72,19 | 75,63 | **89,78** | 89,78 | 75,63 |
| ngau-nhien Pmax | 78,72 | 82,88 | 82,88 | 82,88 | 82,88 |
| mot-tam Pmax | 111,09 | 111,10 | 113,83 | 111,10 | 111,10 |
| mot-tam P@13V | **91,06** (SP) | 82,23 | 82,23 | 82,23 | 82,23 |

**Nhận xét:**
- DES xử lý được ca che nguyên hàng, là ca mà 4 công tắc không giúp được.
- Cho phép các hàng có số tấm khác nhau thì ca `goc-2x2` tăng thêm 24 % so với 4 công tắc.
- DES thuộc họ TCT nên tại 13 V (bộ sạc PWM) có ca vẫn thua SP.
- Chọn theo EI không phải lúc nào cũng trùng cấu hình cho công suất lớn nhất (ví dụ `mot-tam`: EI chọn 111,10 W, trong khi tốt nhất là 113,83 W).

## Hạn chế

- Chưa hiện thực đúng DP + Smart Choice của Ref 3. EI nhỏ nhất trên 3025 cách là cận tốt nhất mà DP hướng tới.
- Phần cứng DES cần 54 công tắc (6 công tắc mỗi tấm), so với 4 công tắc của phương án hiện tại.
- Việc ước lượng bức xạ từ I, V từng tấm (Eq 1 của Ref 3) mới được thay bằng giả lập sai số 5 %.
