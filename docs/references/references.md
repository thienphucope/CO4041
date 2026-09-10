# Tài liệu tham khảo — Microgrid PV + BMS + IoT

Đề tài: **Microgrid năng lượng mặt trời chi phí tối ưu + IoT** (HK261-DAGD1-133)
Trọng tâm GĐ1: **BMS** + **mô phỏng chia/sắp xếp tấm pin tránh bóng râm (shading)**

> ⭐ = sát trọng tâm GĐ1, nên đọc/làm trước.
> Xem thêm việc cần làm ở [`../plan/proposal.md`](../plan/proposal.md) · Q&A với thầy: [`../info/qa1.md`](../info/qa1.md).

---

## 0. Tài liệu thầy cung cấp (⭐ bắt buộc đọc — file PDF trong thư mục này)

> 📄 **Bản chắt lọc nội dung 3 PDF này:** [`refs-extract.md`](refs-extract.md) — đọc cái này trước để nắm ý chính nhanh.
> 📂 **Bản extract thô (text + ảnh gốc):** [`extracted/`](extracted/) — mỗi PDF 1 folder, gồm file `.md` (toàn bộ text theo trang) + ảnh/hình trong bài.

| Tài liệu | File | Dùng cho phần nào |
|---|---|---|
| ⭐ **A new model for a photovoltaic panel using Proteus** (under arbitrary environmental conditions) | `A new model for a photovoltaic panel using Proteus software tool under_arbitrary environmental conditions.pdf` | **Mô phỏng tấm pin (PV) trên Proteus** — công cụ thầy chốt. |
| ⭐ **Hybrid battery management system using the Internet of Things** | `Hybrid battery management system using the internet of_things.pdf` | **BMS + IoT** — kiến trúc giám sát pin. |
| ⭐ **Simulation of Reconfiguration System using MATLAB–Simulink** | `SIMULATION OF RECONFIGURATION SYSTEM USING MATLAB - SIMULINK ENVIRONMENT.pdf` | **PV array configuration / reconfiguration** — thuật toán sắp xếp dàn pin tránh shading. |

> ⚠️ Ngoài 3 tài liệu trên, nhóm **phải tự tìm thêm** cho proposal (thầy yêu cầu). Xem các mục ⭐ bên dưới.

## 1. Đặc tính pin mặt trời + bóng râm (shading) — ⭐ ưu tiên
| Nguồn | Link | Đọc cho phần nào |
|---|---|---|
| ⭐ **PVEducation.org** | pveducation.org | Đường I–V / P–V, ảnh hưởng nhiệt độ & bức xạ, **partial shading**, **bypass diode**. Đọc TRƯỚC khi mô phỏng. |
| **NREL** | nrel.gov | Tài liệu chuẩn về PV; có phần mềm **SAM (System Advisor Model)** miễn phí. |
| **Bypass/Blocking diode app note** | Search "bypass diode application note" (Vishay / onsemi) | Vì sao chia/nhóm tấm pin giảm tổn hao khi bị che. |

## 2. Công cụ mô phỏng — ⭐ Proteus là công cụ thầy chốt
> Thầy yêu cầu **mô phỏng chức năng trên Proteus** (cả BMS lẫn tấm pin) trước khi làm phần cứng — xem ref mục 0.1. Các công cụ dưới đây để **tham khảo phần thuật toán reconfiguration / phân tích shading**, không thay Proteus.
| Công cụ | Link | Ghi chú |
|---|---|---|
| ⭐ **MATLAB/Simulink – Simscape Electrical** | mathworks.com (search "Simulink partial shading PV array example") | Có block **PV Array** mô phỏng partial shading. Hay dùng trong báo cáo học thuật → dễ trích dẫn. |
| ⭐ **pvlib-python** | pvlib-python.readthedocs.io | Thư viện Python (Sandia) mô hình PV + tổn hao do che. Miễn phí, code được. |
| **PVsyst** | pvsyst.com | Phần mềm chuyên nghiệp, phân tích shading trực quan (có bản dùng thử). |

## 3. BMS + pin 12V 15Ah — ⭐ ưu tiên
| Nguồn | Link | Đọc cho phần nào |
|---|---|---|
| ⭐ **Battery University** | batteryuniversity.com | Nền tảng: SoC/SoH, sạc/xả, chì-axit vs Li-ion/LiFePO4, cân bằng cell. |
| ⭐ **TI – BMS reference designs & app notes** | ti.com (dòng **BQ**: fuel gauge, cell balancing, protection) | Kiến trúc BMS thật, chọn IC. |
| **Datasheet pin cụ thể** | (theo pin mua) | Chốt ngưỡng áp/dòng bảo vệ, dung lượng, nhiệt độ. |

## 4. Đo lường + IoT (nhiệt độ, %pin/SoC, V/I/P)
| Nguồn | Link | Ghi chú |
|---|---|---|
| ⭐ **Cảm biến đo lường** | — | **INA226 / INA219** (I²C, đo V–I–P sẵn, chuẩn cho dự án), **ACS712** (dòng), **ADS1115** (ADC 16-bit), **DS18B20 / NTC** (nhiệt độ). |
| **Random Nerd Tutorials** | randomnerdtutorials.com | Hướng dẫn ESP32 đo năng lượng + gửi dashboard, rất thực chiến. |
| **Espressif docs** | docs.espressif.com | Tài liệu ESP32 chính chủ. |
| **Dashboard** | — | **ThingSpeak / Blynk** (nhanh) hoặc **Node-RED + InfluxDB + Grafana** (mạnh hơn). |

## 5. MPPT / Charge controller
| Nguồn | Link | Ghi chú |
|---|---|---|
| **Thuật toán MPPT** | Google Scholar | **Perturb & Observe** và **Incremental Conductance** — 2 thuật toán kinh điển. |
| **App note MPPT** | ti.com / microchip.com | Cách triển khai charge controller MPPT. |

## 6. Công cụ EDA (Altium / KiCad — dùng ở GĐ sau)
| Công cụ | Link | Ghi chú |
|---|---|---|
| **KiCad docs** | docs.kicad.org | Miễn phí, đầy đủ. |
| **Altium docs** | Search "Altium Designer documentation" + YouTube chính chủ | Đã tải ✅; làm quen nhanh. |

## 7. Microgrid (scope tổng thể / GĐ2 — đọc lướt)
| Nguồn | Ghi chú |
|---|---|
| **IEEE Std 1547** | Kết nối nguồn phân tán vào lưới (tham khảo khái niệm). |
| Google Scholar: "solar microgrid IoT monitoring" | Tìm paper nền cho phần khảo sát. |

---

## Việc nên làm tiếp (chưa làm)
- [ ] Search web lấy **link cụ thể + paper IEEE/Scholar** về *"PV array partial shading reconfiguration"* (đúng ý chia/sắp xếp tấm pin) cho phần cơ sở lý thuyết proposal.
- [ ] Chốt loại pin 12V 15Ah (**SLA** hay **LiFePO4/Li-ion**) → ảnh hưởng thiết kế BMS + tài liệu cần đọc.

---

*Cập nhật lần cuối: 2026-08-28 — thêm mục 0 (tài liệu thầy cung cấp), chốt công cụ Proteus.*
