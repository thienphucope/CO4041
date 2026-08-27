# TODO — Proposal (2 tuần) + Ôn bài

Đề tài: **Microgrid năng lượng mặt trời chi phí tối ưu + IoT** (HK261-DAGD1-133)
Trọng tâm GĐ1: **BMS** + **mô phỏng sắp xếp/chia tấm pin tránh bóng râm (shading)**

---

## A. Việc phải làm cho Proposal (theo thứ tự)

1. **Chốt phạm vi (scope)** — thống nhất GĐ1 làm gì / GĐ2 làm gì.
   - GĐ1: BMS + mô phỏng chia tấm pin tránh shading.
   - GĐ2 (để scope tổng thể): inverter, tải, IoT/app.
2. **Khảo sát + cơ sở lý thuyết** — gom tài liệu, ghi nguồn để trích dẫn.
   - Microgrid, đặc tính pin mặt trời, BMS, MPPT, IoT.
3. **Vẽ sơ đồ khối hệ thống (block diagram)** — *bắt buộc*.
   - PV → charge controller → battery + BMS → inverter → tải.
   - Nhánh ESP32 → cảm biến (V/I/P) → IoT/app.
4. **Danh sách module** — liệt kê khối/linh kiện chính.
   - Panel 60W (chia nhỏ), MCU (ESP32), cảm biến dòng/áp, module lưu trữ, charge controller...
5. **Phương pháp / hướng tiếp cận** — nói rõ cách làm 2 việc trọng tâm GĐ1:
   - Cách mô phỏng shading + tiêu chí "chia tấm pin".
   - Cách thiết kế/đo BMS (đo V/I, bảo vệ, cân bằng cell).
6. **BOM sơ bộ + ước tính chi phí** — vì đề tài nhấn mạnh "chi phí tối ưu".
7. **Kế hoạch & milestone (timeline)** — chia việc 3 người, mốc GĐ1/GĐ2.
8. **Kết quả mong đợi + tài liệu tham khảo** — deliverable của GĐ1.
9. **(Nếu thầy yêu cầu) schematic sơ bộ** — mức nguyên lý high-level, *chưa cần* chi tiết từng chân.
10. **Ráp bản proposal + review chéo** — đọc lại, thống nhất, gửi thầy Thái / thầy Nhân.

> ❌ CHƯA làm ở giai đoạn này: **PCB layout + đi dây (routing)**, firmware chi tiết, đóng phần cứng thật.
> 🛠️ Công cụ vẽ schematic/PCB (dùng ở GĐ sau): **Altium** (đã tải ✅) + **KiCad**.
> ❓ Hỏi thầy: có cần schematic nguyên lý trong proposal không (mục 9)?

---

## B. Ôn lại bài — phần nào nên đọc lại

### Ưu tiên cao (đúng trọng tâm GĐ1)
- **Đặc tính tấm pin mặt trời**: đường **I–V** và **P–V**, ảnh hưởng của bức xạ/nhiệt độ.
- **Shading / partial shading**: hiệu ứng bóng râm che một phần, **bypass diode**, **blocking diode**, tại sao phải chia/nhóm tấm pin — cốt lõi cho phần "chia tấm pin tránh shading".
- **Cấu hình nối tấm pin**: **series vs parallel**, ảnh hưởng tới điện áp/dòng và tổn hao khi bị che.
- **BMS**: **SoC/SoH**, cân bằng cell (cell balancing), bảo vệ quá áp/thấp áp/quá dòng/nhiệt, đo V/I.

### Ưu tiên trung bình
- **Charge controller**: **PWM vs MPPT**, nguyên lý **MPPT** (bám điểm công suất cực đại).
- **Cảm biến đo lường**: đo điện áp (voltage divider), đo dòng (shunt / cảm biến Hall), tính công suất.
- **ESP32 cơ bản**: đọc ADC, giao tiếp, gửi dữ liệu (WiFi/MQTT/HTTP) — nền cho phần IoT.

### Đọc lướt (dành cho scope tổng thể / GĐ2)
- **Microgrid**: khái niệm, chế độ vận hành, chuyển nguồn.
- **Inverter**: DC→AC, các loại cơ bản.
- **IoT platform / dashboard**: cách hiển thị & lưu dữ liệu.

---

---

## C. Ghi chú / thông số đã chốt

- **Công cụ EDA**: **Altium** (đã tải ✅) + **KiCad** — dùng cho schematic/PCB ở GĐ sau, chưa dùng cho proposal.
- **Pin lưu trữ**: **12V – 15Ah** (≈ 180Wh). Dùng thông số này cho BMS + ước tính chi phí + tính thời gian cấp tải.
- **Thông số giám sát (IoT)**: **nhiệt độ**, **% pin (SoC)** — cộng thêm V/I/P như specs.
- **Ý tưởng chống bóng râm**: **chia ra nhiều tấm pin nhỏ** (thay vì 1 tấm 60W lớn) để giảm tổn hao khi bị che một phần → cần mô phỏng cách chia/nhóm tối ưu (gắn với bypass diode + cấu hình series/parallel ở phần B).

---

*Cập nhật lần cuối: 2026-08-27*
