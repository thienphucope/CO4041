# Hoàn thiện phần Simulink (việc còn lại sau lần chạy 13/10)

**Ưu tiên:** trung bình · **Phụ trách:** mô phỏng · **Chờ:** —
**Kết quả lần chạy đầu:** [done/10](../done/10-chay-simulink.md)

## Việc cần làm

- [x] Tìm nguyên nhân DES `mot-tam` chia hàng 4-4-1 lệch P@13 V 1,5 % (79,15 so với 80,36 W), 30/10/2026: do model DES có R công tắc đóng 1 mΩ (`cfg.R_closed`) còn tham chiếu coi lý tưởng. Mỗi tấm đi qua 2 công tắc; ở 13 V tấm sáng sát Voc nên vài mV đổi dòng nhiều. Tính lại tham chiếu với 1 mΩ: 79,19 W (Simulink 79,15), hang-1 chia theo hàng 63,33 W (trùng). Không phải lỗi.
- [ ] Thêm R công tắc vào mô hình DES tham chiếu (`pv_des_subsets`). Với R_on thật khoảng 20 mΩ, chia lệch tầng 4-4-1 tụt Pmax 113,8 → 107,9 W (thấp hơn TCT), nên chọn cách chia phải tính R_on.
- [x] Chạy lại phần tham chiếu trên MATLAB (30/10/2026, `matlab -batch "run_all"`): trùng số cũ.
- [ ] Chụp ảnh model (toàn dàn, subsystem `PV`, hộp tham số Solar Cell) cho báo cáo.
- [ ] (Tùy chọn) Độ nhạy theo điện trở công tắc thật: chạy lại mức 1 và DES với `cfg.R_closed = 0.02` (MOSFET back-to-back) để biết tổn hao do dòng ngang trên thanh N1, N2 / S1–S4.

## Tiêu chí xong

`sl_des_check` báo "ĐẠT", hoặc ghi rõ nguyên nhân lệch và vì sao chấp nhận được.
