# Glossary — Thuật ngữ trong dự án

> Chỉ gồm thuật ngữ **thực sự dùng** trong đề tài *Microgrid PV + BMS + IoT* (HK261-DAGD1-133) — nguồn: [`../specifications/specs.md`](../specifications/specs.md), [`../info/qa1.md`](../info/qa1.md), [`../plan/proposal.md`](../plan/proposal.md) và 3 ref thầy cấp ([`../references/refs-extract.md`](../references/refs-extract.md)).

---

## Tấm pin mặt trời (PV) & bóng râm

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **PV** | Photovoltaic | Tấm pin (quang điện) mặt trời, biến ánh sáng → điện DC. |
| **G / Irradiance** | Bức xạ mặt trời [W/m²] | Cường độ nắng lên tấm pin; G tăng → dòng tăng gần tuyến tính. |
| **STC** | Standard Test Conditions | Điều kiện chuẩn để so sánh: **G = 1000 W/m², T = 25 °C**. |
| **I–V curve** | Current–Voltage | Đường đặc tính dòng theo áp của tấm pin. |
| **P–V curve** | Power–Voltage | Đường công suất theo áp; có 1 đỉnh = điểm công suất cực đại. |
| **MPP** | Maximum Power Point | Điểm công suất cực đại trên đường P–V (P = V_MPP × I_MPP). |
| **Single-diode model** | Mô hình 1 diode | Mạch tương đương tấm pin: `I = I_PH − I_D − I_RSH` — dùng để mô phỏng PV (Ref 1). |
| **Shading / Partial shading** | Bóng râm (che một phần) | Che một phần dàn pin → tụt công suất **phi tuyến**. |
| **Hotspot** | Điểm nóng | Cell bị che nóng lên bất thường → hỏng cell; lý do phải chống shading. |
| **Bypass diode** | — | Diode song song nhóm cell, cho dòng "đi vòng" phần bị che → giảm tổn hao & tránh hotspot. |
| **Blocking diode** | — | Diode chặn dòng chảy ngược vào tấm pin (vd pin xả ngược ban đêm). |
| **Series / Parallel** | Nối tiếp / Song song | Nối tiếp tăng áp, song song tăng dòng; ảnh hưởng tổn hao khi bị che. |
| **PV array (re)configuration** | Cấu hình / đổi nối dàn pin | Sắp xếp/đổi nối các tấm để giảm tổn hao khi bị che — **thuật toán thầy dặn tìm hiểu** (Ref 3). |
| **TCT** | Total-Cross-Tied | Một kiểu nối dàn pin (bài Ref 3 tập trung), nền cho reconfiguration. |
| **DES switching matrix** | Dynamic Electrical Scheme | Ma trận chuyển mạch đổi vị trí tấm pin giữa các hàng để reconfigure (Ref 3). |
| **Irradiance equalization / EI** | Cân bằng bức xạ / chỉ số EI | Cân bằng tổng bức xạ mỗi hàng; **EI = max(Gᵢ)−min(Gᵢ)**, EI nhỏ nhất = cấu hình tối ưu. |

## Sạc pin từ PV

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **Charge controller** | Bộ điều khiển sạc | Điều tiết dòng từ PV sạc vào pin, chống quá sạc. |
| **MPPT** | Maximum Power Point Tracking | Thuật toán bám MPP của PV (hiệu suất cao). |
| **PWM** | Pulse Width Modulation | Kiểu điều khiển sạc đơn giản/rẻ hơn MPPT, hiệu suất thấp hơn. |

## Pin lưu trữ & BMS

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **BMS** | Battery Management System | Hệ thống giám sát + bảo vệ + cân bằng pin. (⚠️ không phải "battery meter system") |
| **SoC** | State of Charge | % pin còn lại. |
| **SoH** | State of Health | Sức khỏe / độ chai của pin (so với lúc mới). |
| **Cell balancing** | Cân bằng cell | Kéo các cell nối tiếp về cùng mức áp → bền pin. |
| **C-rate** | — | Tốc độ sạc/xả theo dung lượng: **I = C × Capacity** (quyết định dòng sạc/xả). |
| **SLA** | Sealed Lead Acid | Ắc-quy chì kín khí — rẻ, nặng, tuổi thọ thấp hơn. |
| **LiFePO4** | Lithium Iron Phosphate | Pin lithium sắt phốt phát — nhẹ, bền, an toàn hơn Li-ion thường, đắt hơn SLA. |
| **Ah** | Ampere-hour | Dung lượng pin. Pin nhóm: **12V–15Ah**. |
| **Wh** | Watt-hour | Năng lượng = V × Ah. 12V×15Ah ≈ **180Wh**. |

## Đo lường & cảm biến

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **V / I / P** | Voltage / Current / Power | Điện áp / dòng điện / công suất — thông số đo & giám sát. |
| **ADC** | Analog-to-Digital Converter | Chuyển tín hiệu tương tự (áp) → số để MCU đọc. |
| **Voltage divider** | Cầu phân áp | Mạch chia áp để đo điện áp cao bằng ADC. |
| **Shunt** | Điện trở shunt | Điện trở nhỏ đo dòng qua sụt áp trên nó. |
| **Hall sensor** | Cảm biến Hall | Đo dòng qua từ trường (không tiếp xúc mạch chính). |
| **INA226 / INA219** | — | IC đo V–I–P sẵn qua I²C — chuẩn cho phần đo của dự án. |
| **LM35** | — | Cảm biến nhiệt độ (dùng đo nhiệt pack trong Ref 2). |

## Microgrid & IoT

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **Microgrid** | Lưới điện siêu nhỏ | Lưới điện cục bộ tự vận hành (PV + pin + tải), có thể độc lập. |
| **Inverter** | Bộ nghịch lưu | Biến DC (pin) → AC cho tải xoay chiều. |
| **DPDT** | Double-Pole Double-Throw | Công tắc đảo 2 cực — chọn nguồn PV / điện lưới (Ref 2). |
| **IoT** | Internet of Things | Kết nối thiết bị lên mạng để giám sát/điều khiển từ xa. |
| **ESP32** | — | Vi điều khiển có WiFi/Bluetooth, thu thập dữ liệu + gửi IoT. |
| **MCU** | Microcontroller Unit | Vi điều khiển (ESP32 là một MCU). |
| **I²C** | Inter-Integrated Circuit | Bus 2 dây nối MCU với cảm biến/LCD/IC đo (INA226, LCD…). |
| **UART** | — | Giao tiếp nối tiếp (Tx/Rx) — vd nối controller ↔ ESP32 (Ref 2). |
| **MQTT** | Message Queuing Telemetry Transport | Giao thức nhắn tin nhẹ, phổ biến cho IoT. |
| **HTTP** | HyperText Transfer Protocol | Giao thức web, cách khác để gửi dữ liệu lên server. |
| **ThingSpeak** | — | Nền tảng IoT/dashboard hiển thị & lưu dữ liệu pin (dùng trong Ref 2). |

## Mô phỏng & thiết kế mạch (phần mềm)

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **Proteus** | — | Phần mềm **mô phỏng mạch** (thầy chốt) — mô phỏng chức năng BMS + tấm pin trước khi làm phần cứng. |
| **AVCVS / AVCCS** | Arbitrary Voltage-Controlled Voltage/Current Source | Linh kiện trong Proteus để dựng phương trình PV (Ref 1). |
| **EDA** | Electronic Design Automation | Phần mềm thiết kế mạch điện tử (Altium, KiCad…). |
| **Altium** | Altium Designer | Phần mềm EDA chuyên nghiệp (có phí) — vẽ schematic + PCB. |
| **KiCad** | — | Phần mềm EDA mã nguồn mở, miễn phí — làm tương tự Altium. |
| **Schematic** | Sơ đồ nguyên lý | Bản vẽ linh kiện + nối dây logic (chưa phải mạch thật). |
| **Block diagram** | Sơ đồ khối | Sơ đồ các khối chức năng & luồng — mức cao hơn schematic. |
| **PCB** | Printed Circuit Board | Bảng mạch in thật (bước sau schematic; làm sau mốc proposal). |
| **Routing** | Đi dây | Vẽ đường đồng nối chân linh kiện trên PCB. |

## Quản lý dự án & tài liệu

| Viết tắt / Từ | Đầy đủ | Nghĩa ngắn |
|---|---|---|
| **Proposal** | Đề cương | Tài liệu định hướng đề tài (mục tiêu, phạm vi, phương pháp, kế hoạch…). |
| **BOM** | Bill of Materials | Bảng kê linh kiện + số lượng + giá → ước tính chi phí. |
| **Gantt** | Gantt chart | Biểu đồ thanh thể hiện timeline/tiến độ theo thời gian. |
| **Deliverable** | Sản phẩm nộp | Thứ phải nộp cuối mốc (ở mốc proposal = báo cáo tiến độ LMS). |

## Hành chính / học vụ

| Viết tắt | Đầy đủ | Ghi chú |
|---|---|---|
| **LMS** | Learning Management System | Hệ thống của trường — nơi nộp báo cáo tiến độ & xem hạn. |
| **HK261** | Học kỳ 261 | Mã học kỳ. |
| **GĐ1 / GĐ2** | Giai đoạn 1 / 2 (2 môn đồ án) | **GĐ1 = môn 4041 = TOÀN BỘ đồ án hiện tại** (BMS, PV, charge controller, inverter, IoT/app…). **GĐ2 = đồ án tốt nghiệp**, phát triển tiếp từ 4041 — **ngoài scope hiện tại**. |
| **Mốc proposal** | — | Thời điểm hiện tại *trong* GĐ1: báo cáo tiến độ nộp LMS, chỉ tổng quan. (≠ một giai đoạn riêng.) |
| **GVHD** | Giảng viên hướng dẫn | ThS. Phạm Công Thái, TS. Lê Trọng Nhân. |
| **KTMT** | Kỹ thuật Máy tính | Ngành / tổ chuyên môn. |
| **ĐACN** | Đồ án chuyên ngành | Loại đồ án. |
| **ĐAMH** | Đồ án môn học | Loại đồ án (ĐAMH KTMT). |
| **DAGD1** | — | Mã đợt đồ án GĐ1 (trong HK261-DAGD1-133). |

---

*Cập nhật: 2026-09-06 — lọc còn thuật ngữ dùng thật, bổ sung term chuyên môn từ 3 ref (STC, MPP, single-diode, TCT, DES, EI, C-rate, AVCVS/AVCCS, I²C, ThingSpeak…), bỏ WBS (không dùng).*
