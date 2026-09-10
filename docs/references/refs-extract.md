# Chắt lọc 3 tài liệu thầy cung cấp

> Bản rút gọn nội dung 3 PDF ở thư mục này — chỉ giữ phần **cần cho dự án** (Microgrid PV + BMS + IoT, HK261-DAGD1-133).
> Danh mục link/tài liệu tự tìm thêm: [`references.md`](references.md) · Việc cần làm: [`../plan/proposal.md`](../plan/proposal.md) · Q&A thầy: [`../info/qa1.md`](../info/qa1.md).
> Ký hiệu: 🎯 = trực tiếp dùng cho GĐ1.

---

## Ref 1 — Mô phỏng tấm pin (PV) trên Proteus 🎯

**Nguồn:** Yaqoob, Motahhir, Agyekum (2022). *A new model for a photovoltaic panel using Proteus software tool under arbitrary environmental conditions.* Journal of Cleaner Production 333, 130074.

**Ý chính:** Xây một **mô hình tấm pin trong Proteus** cho phép thay đổi **cả bức xạ (G) lẫn nhiệt độ (T)** ngay khi mô phỏng — khắc phục các mô hình Proteus trước đó chỉ đổi được bức xạ, nhiệt độ kẹt ở 25 °C.

**Điểm kỹ thuật cần nhớ:**
- Dùng **mô hình 1 diode (single-diode)**: `I = I_PH − I_D − I_RSH` (dòng quang điện − dòng diode Shockley − dòng qua điện trở shunt).
- Mô hình hóa 3 phương trình trên trong Proteus bằng **"Laplace Primitives"** (cộng/trừ/nhân/chia) + **AVCVS / AVCCS** (nguồn áp/dòng điều khiển tùy ý) trong mục **Pick Devices**.
- **Tham số ẩn** của tấm pin (R_S, R_SH, I_O ở STC, hệ số lý tưởng diode) **trích từ datasheet** bằng **PV Array tool của MATLAB/Simulink**, rồi nhập vào Proteus.
- **STC** = G 1000 W/m², T 25 °C. Ảnh hưởng: G tăng → dòng tăng (gần tuyến tính); T tăng → áp giảm (mạnh), dòng tăng nhẹ → công suất giảm.
- Kiểm chứng trên 2 tấm: **SM55** (mono, 55 W) và **KC200GT** (poly, 200 W); so với datasheet + PVsyst + tác giả khác → sai số nhỏ.

**Quy trình dựng trong Proteus (tóm tắt các bước):** Component Mode → Pick Devices → thêm Laplace add/sub/mul/div + AVCVS/AVCCS → đặt giá trị datasheet & tham số ước lượng bằng **DC Generator** → nối đầu ra PV qua **bypass diode** + **tải trở biến thiên** → dùng **DC SWEEP ANALYSIS** để vẽ **đường I–V và P–V**.

**Dùng cho dự án:** Đây là **khuôn mẫu trực tiếp** cho phần "mô phỏng tấm pin trên Proteus" thầy chốt — có sẵn phương trình, cách dựng trong Proteus, tham số datasheet mẫu.
**Lưu ý:** Tác giả liệt kê **nghiên cứu shading trên Proteus là hướng tương lai** (chưa làm trong bài) → mô hình này mô phỏng **1 tấm**; phần bóng râm/chia dàn pin phải mở rộng thêm (xem Ref 3).

---

## Ref 2 — BMS lai (hybrid) tích hợp IoT 🎯

**Nguồn:** Kulkarni, Paragond, Hiremath (2025). *Hybrid battery management system using the internet of things.* Majlesi Journal of Electrical Engineering 19(2).

**Ý chính:** BMS cho pin, cấp nguồn **lai (solar + điện lưới)**, dùng **IoT giám sát áp + nhiệt độ từng cell** từ xa. **Mô phỏng chức năng trên Proteus trước**, rồi mới làm phần cứng.

**Kiến trúc (luồng dữ liệu):**
`PV + nguồn lưới → công tắc DPDT (chọn nguồn) → mạch BMS → battery pack`
`cảm biến (áp, nhiệt) → controller (Arduino Nano/Uno) → ESP32 (WiFi) → server ThingSpeak → dashboard mobile + LCD tại chỗ`

**Điểm kỹ thuật cần nhớ:**
- **Đo:** điện áp từng cell (voltage divider / cảm biến áp), nhiệt độ pack (**LM35**), **SoC**.
- **Bảo vệ/an toàn:** đặt ngưỡng sạc/xả; **interlock** (đang sạc thì khóa xả); ngắt khỏi nguồn khi đầy; **cooling** khi nhiệt vượt ngưỡng.
- Pin ví dụ: **Li-ion 12.6 V** (3 cell × 4.2 V). Vùng an toàn cell Li-ion **2.5–4.2 V**. Nhiệt dao động 7–8 °C khi sạc/xả.
- **C-rate:** `I = C × Capacity` (bội của dung lượng, quyết định dòng sạc/xả).
- Truyền lên ThingSpeak qua **token** xác thực; giao tiếp controller↔LCD bằng **I²C**, controller↔ESP32 bằng **UART (Tx/Rx)**.

**Dùng cho dự án:** Khuôn mẫu cho **BMS + phần IoT/app** — xác nhận đúng quy trình **Proteus-trước-phần-cứng** (khớp thầy) và đúng thông số nhóm muốn giám sát (**nhiệt độ + % pin/SoC** + V/I/P). Kiến trúc cảm biến→controller→ESP32→cloud→dashboard dùng gần như nguyên cho GĐ sau.

---

## Ref 3 — Mô phỏng reconfiguration dàn pin (MATLAB–Simulink) 🎯

**Nguồn:** Ngô Ngọc Thành, Nguyễn Phùng Quang (2018). *Simulation of reconfiguration system using MATLAB–Simulink environment.* Journal of Computer Science and Cybernetics 34(2), 127–143.

**Ý chính:** Khi dàn pin bị **bức xạ không đồng đều (bóng râm)**, **đổi cách nối các tấm (reconfiguration)** để **cân bằng bức xạ giữa các hàng** → giảm tổn hao, tăng công suất. Mô phỏng toàn bộ hệ trong **MATLAB–Simulink**.

**Điểm kỹ thuật cần nhớ:**
- Bóng râm gây **tổn hao phi tuyến** + hiện tượng **hotspot** (điểm nóng làm hỏng cell). **Bypass diode** chặn hotspot nhưng vẫn mất một phần công suất.
- **Topology nối dàn pin:** Series, Parallel, Series–Parallel (SP), **Total-Cross-Tied (TCT)**, Bridge-Link (BL), Honey-Comb (HC). Bài tập trung **TCT**.
- **Reconfiguration System (RS)** = **thuật toán cân bằng bức xạ (irradiance equalization)** + **ma trận chuyển mạch DES** (Dynamic Electrical Scheme) để đổi vị trí tấm pin giữa các hàng.
- **Chỉ số cân bằng EI** = `max(Gᵢ) − min(Gᵢ)` giữa các hàng; **EI nhỏ nhất → cấu hình tối ưu** (công suất lớn nhất).
- Thuật toán tối ưu: **lai DP + SC** — Dynamic Programming (bài toán Subset-Sum/Knapsack) kết hợp Smart Choice.
- **Kết quả:** RS tăng hiệu năng dàn pin **10–50 %** (ví dụ 791 W → 1079 W, +29 %).

**Dùng cho dự án:** Đây là **"thuật toán PV array configuration" thầy dặn tìm hiểu**. Cung cấp đúng thuật ngữ + phương pháp cho phần chống bóng râm.
**Lưu ý:** Bài này mô phỏng bằng **MATLAB–Simulink** (không phải Proteus) và **không** tự mô phỏng tấm pin (mượn ví dụ "partial shading of a PV module" của MathWorks) → nếu nhóm muốn **chạy** reconfiguration thì công cụ tự nhiên là MATLAB–Simulink, còn Proteus giữ cho BMS + tấm pin (Ref 1).

---

## Rút ra cho dự án (3 ref ghép lại)

| Phần GĐ1 | Ref dựa vào | Công cụ | Ghi chú |
|---|---|---|---|
| Mô phỏng **tấm pin (I–V, P–V)** | Ref 1 | **Proteus** (thầy chốt) | Single-diode; trích tham số từ datasheet bằng PV Array tool MATLAB. |
| Thiết kế + mô phỏng **BMS 12V** | Ref 2 | **Proteus** (thầy chốt) | SoC, nhiệt độ, cân bằng cell, bảo vệ; Proteus trước phần cứng. |
| **PV array configuration** (chống shading) | Ref 3 | MATLAB–Simulink *(nếu mô phỏng)* | TCT + DES + irradiance equalization; thầy chỉ dặn **tìm hiểu**. |
| **IoT / app** (GĐ sau) | Ref 2 | ESP32 + ThingSpeak | Luồng cảm biến→controller→ESP32→cloud→dashboard. |

- **Proteus = xương sống mô phỏng GĐ1** (BMS + tấm pin) — cả Ref 1 và Ref 2 đều dùng đúng cách này.
- **Reconfiguration là phần lý thuyết** (Ref 3) thầy yêu cầu **tìm hiểu**; mô phỏng chạy reconfiguration (MATLAB) là **mức mở rộng**, không bắt buộc ở báo cáo 2 tuần.
- 3 ref **chưa đủ** cho proposal → còn phải **tự tìm thêm** (thầy yêu cầu); gợi ý chủ đề ở [`references.md`](references.md).

*Tạo: 2026-09-06 — chắt lọc từ 3 PDF thầy cung cấp.*
