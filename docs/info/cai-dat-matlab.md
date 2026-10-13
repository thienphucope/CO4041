# Cài đặt MATLAB cho mô phỏng dàn PV 3 × 3

Dùng cho toàn bộ code trong `pvreconfig-sim/`. Cập nhật 13/10/2026.

## Gói cần cài

**Bắt buộc (4 gói):**

| Gói | Dùng làm gì |
|---|---|
| **MATLAB** | Nền, chạy script |
| **Simulink** | Sơ đồ khối, chạy mô phỏng |
| **Simscape** | Mạch điện: Switch, nguồn áp điều khiển, điện trở, tụ, cuộn cảm, Solver Configuration, Electrical Reference |
| **Simscape Electrical** | Block **Solar Cell** (tấm PV) và **Diode** (diode bypass) |

Simscape Electrical cần Simscape; Simscape cần Simulink. Installer thường tự chọn các gói phụ thuộc này.

**Tùy chọn (nên cài):**

| Gói | Dùng làm gì |
|---|---|
| **Parallel Computing Toolbox** | Chạy song song (`parsim`) cho các lần quét nhiều mô phỏng: 144 lần ở mức 1, gần 1000 lần nếu dựng bảng mức 2 từ Simulink. Không có thì script tự chạy tuần tự (chậm hơn) |
| **Stateflow** | Chỉ cần nếu muốn vẽ thuật toán chọn cấu hình dạng máy trạng thái trong Simulink. Code hiện tại **không** dùng |

**Không cần:**
- Các gói Simscape khác: Fluids, Multibody, Driveline, Battery. Mô phỏng không có mô hình pin; pin chỉ là điện áp cố định 13 V.
- Control System Toolbox, Optimization Toolbox.

## Kiểm tra sau khi cài

```matlab
ver                 % phải có đủ: MATLAB, Simulink, Simscape, Simscape Electrical
ssc_new             % mở được model trống có sẵn Solver Configuration là Simscape chạy được
```

## Chạy

```matlab
cd D:\Documents\261\4041\pvreconfig-sim
run_all             % mọi mức mô phỏng
```

Chi tiết các mức và kết quả: [`pvreconfig-sim/README.md`](../../pvreconfig-sim/README.md). Kết quả chạy lần đầu (R2026b, 13/10/2026) và các chỗ đã sửa: [`docs/progress/done/10-chay-simulink.md`](../progress/done/10-chay-simulink.md).

> Không dùng GNU Octave cho dự án nữa (từ 12/10/2026): Octave không có Simulink/Simscape.
