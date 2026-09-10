# Core — Cân bằng cell (cell balancing)

> **Cái gì:** kéo các cell nối tiếp về **cùng mức** (áp/SoC). Không cân bằng → cell yếu nhất giới hạn cả pack, chai nhanh, dễ quá/thấp áp.
> **Tại sao quan trọng với đồ án:** 1 trong 4 khối BMS thầy chốt ([`qa1.md`](qa1.md) §A1).
> **Nguồn:** Ref 2 — Kulkarni 2025 ([`../references/extracted/02-bms-iot/02-bms-iot.md`](../references/extracted/02-bms-iot/02-bms-iot.md)) + kiến thức nền BMS.
> Liên quan: [[core-soc]] · [[core-protection]] · [[core-thermal]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **Cell** | — | Đơn vị pin nhỏ nhất (vd Li-ion 3.7 V). Nhiều cell nối tiếp = pack. |
| **Pack / Module** | — | Cụm cell nối tiếp/song song cho điện áp mong muốn. |
| **Balancing** | — | Làm đều áp/SoC giữa các cell nối tiếp. |
| **Passive balancing** | Cân bằng thụ động | Xả cell cao qua **điện trở** (tản nhiệt). Rẻ, đơn giản. |
| **Active balancing** | Cân bằng chủ động | **Chuyển** năng lượng cell cao → cell thấp (tụ/cuộn cảm/biến áp). Hiệu quả, phức tạp. |
| **Top balancing** | — | Cân bằng ở **cuối sạc** (gần đầy) — phổ biến nhất. |
| **OVP / UVP** | Over/Under-Voltage Protection | Ngưỡng bảo vệ liên quan (xem [[core-protection]]). |

---

## 2. Tại sao phải cân bằng
Cell nối tiếp dùng **cùng một dòng** nhưng dung lượng/nội trở lệch nhau → theo thời gian **SoC phân kỳ**:
- Khi **sạc**: cell cao chạm ngưỡng quá áp trước → phải dừng sạc → các cell khác chưa đầy.
- Khi **xả**: cell thấp chạm ngưỡng thấp áp trước → phải dừng xả → pack chưa cạn.
→ Dung lượng khả dụng bị **cell yếu nhất** giới hạn; cell bị ép quá ngưỡng lặp lại → **chai/hỏng**.

## 3. Hai họ phương pháp

### Passive (thụ động) — khuyến nghị cho đồ án
- Mỗi cell có 1 **điện trở xả + MOSFET/relay**. Cell nào cao hơn ngưỡng → đóng để **xả bớt** qua điện trở (biến thành nhiệt).
- Cân bằng ở **top-of-charge**.
- ✅ Đơn giản, rẻ, dễ mô phỏng Proteus. ❌ Lãng phí năng lượng, toả nhiệt.

### Active (chủ động)
- Dùng tụ/cuộn cảm/biến áp **chuyển** điện tích cell cao → cell thấp. Hiệu suất cao, ít nhiệt.
- ❌ Mạch phức tạp, đắt, điều khiển khó → **quá tầm mốc proposal**.

## 4. Ref 2 làm gì (đối chiếu)
- Ref 2 đo **áp từng cell** (C1–C3) + hiển thị, nhưng **không mô tả mạch cân bằng chủ động/thụ động cụ thể** — chủ yếu monitoring.
- Có mạch **relay cân bằng** trong đồ án nhóm khoá trước (cùng 2 thầy) — ⚠️ xem cảnh báo trùng lặp ở [`../plan/proposal.md`](../plan/proposal.md) B6 (ảnh [`../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg`](../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg)).
👉 **Được tham khảo bố trí, không bê nguyên, phải trích nguồn.**

## 5. Áp dụng vào đồ án
- **Ở proposal (mức concept):** chọn **passive balancing** (điện trở xả + MOSFET điều khiển theo áp cell), ngưỡng kích hoạt ở cuối sạc. Nêu phương pháp + sơ đồ khối; mô phỏng Proteus ở mức chức năng.
- Liên kết với [[core-soc]] (biết cell nào cao) và [[core-protection]] (ngưỡng OVP/UVP).

## 6. Còn mở
- Số cell nối tiếp phụ thuộc **loại pin chưa chốt** ([`../plan/proposal.md`](../plan/proposal.md) B3): 12 V LiFePO4 ≈ 4S; SLA 12 V là 6 "cell" 2 V (thường không balance từng cell) → **ảnh hưởng lớn tới việc có cần balancing hay không**.
- Ngưỡng & dòng xả điện trở — chốt khi có thông số pin.

*Cập nhật: 2026-09-10.*
