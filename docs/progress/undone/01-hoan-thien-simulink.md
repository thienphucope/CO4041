# Hoàn thiện phần Simulink (việc còn lại sau lần chạy 13/10)

**Ưu tiên:** trung bình · **Phụ trách:** mô phỏng · **Chờ:** —
**Kết quả lần chạy đầu:** [done/10](../done/10-chay-simulink.md)

## Việc cần làm

- [ ] Tìm nguyên nhân DES `mot-tam` chia hàng 4-4-1 lệch P@13 V 1,5 % (79,15 so với 80,36 W). Gợi ý: hàng chỉ có 1 tấm (PV22, 300 W/m²) chạy sâu trong vùng bypass ở 13 V → so điện áp tấm và dòng diode bypass giữa Simulink và `pv_module_current`; thử bước giải nhỏ hơn (`cfg.maxstep`) và R_closed = 0.
- [ ] Chạy lại phần tham chiếu trên MATLAB: `run(fullfile('reference','run_reference.m'))`, `run_stress`, `verify_des`, `run_des` (xác nhận số trước đây chạy bằng Octave).
- [ ] Chụp ảnh model (toàn dàn, subsystem `PV`, hộp tham số Solar Cell) cho báo cáo.
- [ ] (Tùy chọn) Độ nhạy theo điện trở công tắc thật: chạy lại mức 1 và DES với `cfg.R_closed = 0.02` (MOSFET back-to-back) để biết tổn hao do dòng ngang trên thanh N1, N2 / S1–S4.

## Tiêu chí xong

`sl_des_check` báo "ĐẠT", hoặc ghi rõ nguyên nhân lệch và vì sao chấp nhận được.
