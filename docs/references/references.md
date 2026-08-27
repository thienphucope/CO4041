# Tài liệu tham khảo — Microgrid PV + BMS + IoT

Đề tài: **Microgrid năng lượng mặt trời chi phí tối ưu + IoT** (HK261-DAGD1-133)
Trọng tâm GĐ1: **BMS** + **mô phỏng chia/sắp xếp tấm pin tránh bóng râm (shading)**

> ⭐ = sát trọng tâm GĐ1, nên đọc/làm trước.
> Xem thêm việc cần làm ở [`todo.md`](todo.md).

---

## 1. Đặc tính pin mặt trời + bóng râm (shading) — ⭐ ưu tiên
| Nguồn | Link | Đọc cho phần nào |
|---|---|---|
| ⭐ **PVEducation.org** | pveducation.org | Đường I–V / P–V, ảnh hưởng nhiệt độ & bức xạ, **partial shading**, **bypass diode**. Đọc TRƯỚC khi mô phỏng. |
| **NREL** | nrel.gov | Tài liệu chuẩn về PV; có phần mềm **SAM (System Advisor Model)** miễn phí. |
| **Bypass/Blocking diode app note** | Search "bypass diode application note" (Vishay / onsemi) | Vì sao chia/nhóm tấm pin giảm tổn hao khi bị che. |

## 2. Công cụ mô phỏng shading — ⭐ chọn 1 để làm
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

*Cập nhật lần cuối: 2026-08-27*
