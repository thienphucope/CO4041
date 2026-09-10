# TODO — Báo cáo tiến độ GĐ1 (2 tuần)

Đề tài: **Microgrid năng lượng mặt trời chi phí tối ưu + IoT** (HK261-DAGD1-133)

> 📌 File này chia làm 2 phần rõ ràng:
> **PHẦN A = thầy chốt cứng (bắt buộc)** · **PHẦN B = đề xuất/suy diễn của nhóm (chưa chốt)**.
> Nguồn chốt: [`../info/qa1.md`](../info/qa1.md) (Q&A thầy 2026-08-28) · Tài liệu: [`../references/refs-extract.md`](../references/refs-extract.md) · [`../references/references.md`](../references/references.md)
> 📤 **Bản nộp:** [`../output/proposal.md`](../output/proposal.md) · 🔧 **Hướng dẫn dựng mô phỏng:** [`../output/simulation-guide.md`](../output/simulation-guide.md) · 📚 **Lý thuyết từng core:** [`../info/info.md`](../info/info.md)

---

## 🎯 Trọng tâm hiện tại & bàn giao (ĐỌC TRƯỚC)

**Khung 2 môn:** **GĐ1 = chính môn 4041 này** (toàn đồ án: BMS, PV, charge controller, inverter, IoT/app…). **GĐ2 = đồ án tốt nghiệp** (môn sau, phát triển tiếp) — **ngoài scope**. → [`../info/glossary.md`](../info/glossary.md).

**Hiện tại = mốc *proposal* của GĐ1:** nộp **báo cáo tiến độ** trên LMS, **chỉ tổng quan** (phương pháp + kế hoạch + phân việc). **Trọng tâm = 4 việc thầy chốt ở PHẦN A.** Charge controller / inverter / IoT-app **vẫn thuộc 4041**, chỉ **làm sau mốc proposal** — ở report chỉ nêu tổng quan, đừng nhầm là "giai đoạn 2".

### Trạng thái
**✅ Đã có (bản nháp — cần rà, chưa phải bản cuối):**
- 📤 [Báo cáo nộp](../output/proposal.md) — đủ 12 mục, mức tổng quan.
- 🔧 [Hướng dẫn mô phỏng Proteus](../output/simulation-guide.md) — PV + BMS từng bước + firmware khung.
- 📚 [8 core lý thuyết](../info/info.md) — đầy đủ công thức + viết tắt, bám 3 ref.
- [glossary](../info/glossary.md) · [qa1 (Q&A thầy)](../info/qa1.md) · [refs-extract](../references/refs-extract.md).

**🔲 Còn làm (actionable):**
1. Xem **hạn chót + tiêu chí chấm** trên LMS.
2. **Chốt loại pin** (LiFePO4 4S khuyến nghị vs SLA) → ảnh hưởng ngưỡng / balancing / BOM. *(B3)*
3. **Chốt hướng shading** (reconfiguration TCT/DES vs chia nhỏ + bypass) — sau khi đọc [`core-pv-reconfig`](../info/core-pv-reconfig.md). *(B1)*
4. **Tự tìm thêm tài liệu** (ngoài 3 ref thầy).
5. *(bonus)* Dựng **Proteus tối thiểu** (PV vài đường I–V + BMS 1 cell có bảo vệ OT) → chụp bỏ report.

### Bản đồ tài liệu cho astra (đọc theo thứ tự)
| # | File | Là gì | Dùng để |
|---|---|---|---|
| 1 | [qa1.md](../info/qa1.md) | Q&A thầy — ràng buộc cứng | Biết thầy **chốt** gì, không được lệch |
| 2 | File này (plan) | TODO + scope + phân việc | Biết làm gì, ranh giới PHẦN A/B |
| 3 | [info.md → core-*.md](../info/info.md) | Lý thuyết 8 core | Viết "cơ sở lý thuyết" + thiết kế, có số/công thức |
| 4 | [refs-extract.md](../references/refs-extract.md) | 3 ref chắt lọc | Trích dẫn, bám nguồn |
| 5 | [output/proposal.md](../output/proposal.md) | Bản nộp nháp | **Sửa/hoàn thiện trên đây** |
| 6 | [output/simulation-guide.md](../output/simulation-guide.md) | Hướng dẫn Proteus | Khi dựng / chụp mô phỏng |

### 🤝 Việc giao cho astra
- **Mục tiêu:** hoàn thiện [`output/proposal.md`](../output/proposal.md) sẵn sàng nộp LMS (và, nếu làm, dựng mô phỏng tối thiểu theo [simulation-guide](../output/simulation-guide.md)).
- **Input:** toàn bộ bản đồ tài liệu trên. **Output:** report tổng quan hoàn chỉnh + (tuỳ) ảnh mô phỏng.
- **RÀNG BUỘC (đừng phá):**
  - Giữ **mức tổng quan** — KHÔNG đi sâu chi tiết linh kiện / PCB / firmware đầy đủ (thầy dặn proposal chưa chi tiết).
  - Bám đúng **PHẦN A**; nội dung **PHẦN B** phải ghi rõ là **đề xuất của nhóm, chưa chốt**.
  - **Không bịa số liệu**; cái gì chưa có (hạn, tiêu chí, thông số pin) để **"còn mở"**.
  - **Không bê nguyên** mạch tham khảo nhóm khoá trước — xem **B6**; **phải trích nguồn**.
  - Dùng đúng nhãn: **"mốc proposal"** vs **"phần sau của 4041"**; chỉ gọi **GĐ2 = đồ án tốt nghiệp**.

---

# 🔒 PHẦN A — THẦY CHỐT CỨNG (bắt buộc phải làm)

> Nguyên văn từ [`../info/qa1.md`](../info/qa1.md). Không suy diễn thêm ở phần này.

### A1. Nội dung proposal GĐ1 (chỉ **tổng quan**, chưa đi vào chi tiết)
1. **Thiết kế BMS 12V** — nêu khối chức năng: **SoC**, **nhiệt độ**, **cân bằng cell**, **mạch bảo vệ**.
2. **Mô phỏng chức năng trên Proteus** — cho **BMS + tấm pin**, làm **trước khi** làm phần cứng (nêu phương pháp).
3. **Mô phỏng tấm pin (PV)** — trên Proteus.
4. **Tìm hiểu thuật toán PV array configuration** — *chỉ tìm hiểu* (lý thuyết + tóm tắt), chưa yêu cầu mô phỏng.
5. **Phương pháp tổng quan + kế hoạch + phân chia nhiệm vụ** (3 người).

### A2. Deliverable & nộp
- **Hình thức:** báo cáo tiến độ. **Không** slide / thuyết trình.
- **Nơi nộp:** **LMS** (1 bản/nhóm). **Hạn:** xem trên LMS.

### A3. Tài liệu
- 3 ref thầy cấp (đã chắt lọc ở [`refs-extract.md`](../references/refs-extract.md)) + **tự tìm thêm** (thầy yêu cầu).

### A4. Công cụ mô phỏng
- **Proteus** (thầy chốt) — dùng cho **cả BMS lẫn tấm pin**.

---

# ✅ Việc cần làm cho báo cáo (checklist, bám PHẦN A)

1. **Chốt phạm vi (scope)** — mốc proposal làm gì, phần nào của 4041 để làm sau *(ranh giới xem PHẦN B)*.
2. **Cơ sở lý thuyết** — đọc 3 ref (`refs-extract.md`) + tự tìm thêm; ghi nguồn để trích dẫn.
   - Đặc tính PV (I–V, P–V, STC), partial shading/hotspot, PV array configuration, BMS, IoT.
3. **Thiết kế BMS 12V (mức concept)** — khối: đo SoC, nhiệt độ, cân bằng cell, bảo vệ (quá/thấp áp, quá dòng, quá nhiệt).
4. **Kế hoạch mô phỏng Proteus** — nêu phương pháp mô phỏng BMS + tấm pin (Ref 1 = khuôn mẫu PV single-diode trên Proteus; Ref 2 = khuôn mẫu BMS trên Proteus). Chưa cần chạy xong.
5. **Tìm hiểu thuật toán PV array configuration** — tóm tắt Ref 3 (TCT, DES switching, irradiance equalization/EI).
6. **Kế hoạch & phân chia nhiệm vụ 3 người** — timeline, mốc proposal + các mốc sau trong 4041.
7. **Kết quả mong đợi + tài liệu tham khảo** của GĐ1.
8. **Ráp báo cáo + review chéo → nộp LMS.**

> ⚠️ **Mô phỏng Proteus vẫn phải vẽ schematic mô phỏng** (chọn linh kiện, nối mạch, đặt giá trị để chạy) — việc này của GĐ1. Nhưng **ở báo cáo 2 tuần chỉ cần phương pháp + kế hoạch**, chưa cần schematic Proteus hoàn chỉnh.
> ❌ CHƯA làm ở mốc này: schematic sản xuất Altium + PCB layout/routing, firmware chi tiết, làm mạch thật.

---

# 💡 PHẦN B — ĐỀ XUẤT / SUY DIỄN CỦA NHÓM (chưa chốt — chỉ để tham khảo)

> Đây là phần **nhóm tự suy ra**, **chưa** được thầy chốt. Giữ tách khỏi PHẦN A. Sẽ quyết sau khi đọc ref / hỏi thêm.

### B1. Hướng "chống bóng râm" — ❓ CHƯA QUYẾT (nhóm chưa đọc ref)
Thầy chỉ nói **"tìm hiểu thuật toán PV array configuration"**. Cách cụ thể hóa để cân nhắc sau:
- **PA1 — Reconfiguration (TCT + DES switching):** đúng thuật ngữ thầy nói, theo Ref 3; đổi nối dàn pin cân bằng bức xạ. Học thuật, dễ trích dẫn. → nếu mô phỏng thì bằng **MATLAB–Simulink** (Ref 3 dùng cái này, không phải Proteus).
- **PA2 — Chia nhỏ tấm pin + bypass diode:** chia 1 tấm lớn thành nhiều tấm nhỏ để giảm tổn hao khi bị che. Đơn giản, sát phần cứng.
- 👉 **Việc cần làm:** đọc Ref 3 + PVEducation trước, rồi mới chọn PA.

### B2. Mức độ phần PV array configuration
- Báo cáo 2 tuần: **chỉ cần "tìm hiểu"** (theo PHẦN A).
- *Stretch (nếu còn thời gian):* thử **mô phỏng reconfiguration** trên MATLAB–Simulink theo Ref 3 — **không bắt buộc**.

### B3. Thông số pin — ❓ ĐỂ MỞ, chốt sau
- Giả định đang dùng: **12V – ~15Ah (≈180Wh)** — con số nhóm tự đặt, **chưa chốt**.
- **Loại pin (SLA / LiFePO4 / Li-ion): chưa chốt.** Đề tài nhấn "chi phí tối ưu" → cân nhắc SLA (rẻ) vs LiFePO4 (bền/an toàn). Ảnh hưởng thiết kế BMS + BOM.

### B4. Scope tổng thể 4041 — phần làm sau mốc proposal (suy từ specs, chưa phải mốc này)
- Làm sau proposal (vẫn trong 4041, nhóm dự kiến): **charge controller/MPPT**, **inverter**, **tải**, **IoT/app** (dashboard ThingSpeak, giám sát nhiệt độ + %SoC + V/I/P — kiến trúc theo Ref 2).
- **Sơ đồ khối** đề xuất: PV → charge controller → battery + BMS → tải; nhánh cảm biến (V/I/P) → ESP32 → IoT/app.

### B5. Việc nhóm tự thêm (thầy không yêu cầu ở mốc này)
- **BOM / ước tính chi phí** sơ bộ — nên có vì đề tài nhấn "chi phí tối ưu", nhưng *chưa bắt buộc*.
- **Công cụ EDA:** Altium (đã tải ✅) + KiCad — cho schematic sản xuất/PCB ở **sau mốc proposal**, chưa dùng ở mốc này.

### B6. ⚠️ Mạch Proteus BMS tham khảo — CẨN THẬN trùng lặp
- Có mạch BMS 3 cell đầy đủ (INA219 ×3, relay cân bằng, MOSFET+opto điều khiển tải, LCD): ảnh [`../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg`](../archives/extracted/solar-microgrid-project/images/p15-img01-x208.jpeg).
- **Nguồn gốc:** trong đồ án **nhóm khoá trước, CÙNG 2 thầy hướng dẫn** ([`../archives/extracted/solar-microgrid-project/solar-microgrid-project.md`](../archives/extracted/solar-microgrid-project/solar-microgrid-project.md)); mạch lại có watermark **TheEngineeringProjects.com** → **thầy đã thấy mạch này rồi.**
- 👉 **Được** tham khảo cách bố trí; **không** bê nguyên (sẽ bị nhận ra, mất điểm khác biệt); **phải trích nguồn**.
- **Mạch đó THIẾU:** cảm biến **nhiệt độ (LM35)** (dù thầy yêu cầu đo nhiệt) · **SoC** chỉ suy từ áp · chỉ Arduino+LCD, **không có IoT/ESP32**. → đây chính là chỗ nhóm thêm vào để khác biệt (B7).

### B7. 💡 Điểm khác biệt / ăn điểm (đưa vào bản nộp — xem [`../output/proposal.md`](../output/proposal.md) §3)
Đề tài KTMT → điểm nằm ở **thuật toán + firmware + IoT**, không phải phần cứng mua sẵn. 4 hướng:
1. **⚙️ SoC bằng coulomb counting + hiệu chỉnh OCV** (thay vì đọc áp) — GĐ1, đúng chất KTMT.
2. **⚙️ Thêm cảm biến nhiệt (LM35) + bảo vệ quá nhiệt** — GĐ1, lấp đúng lỗ hổng mạch tham khảo.
3. **🔜 IoT hai chiều** (điều khiển ngược + cảnh báo, không chỉ dashboard xem) — sau mốc proposal.
4. **🔜 Định lượng "chi phí tối ưu"** (BOM + so sánh số liệu) — bám đúng tên đề tài, ít nhóm làm.
- *Stretch:* mô phỏng **reconfiguration chống shading chạy thật** (MATLAB–Simulink, Ref 3) + số liệu trước/sau.

### B8. Mức độ mô phỏng cần cho mốc này (tham khảo [`../output/simulation-guide.md`](../output/simulation-guide.md))
| Mức | Nội dung | Mốc 2 tuần? |
|---|---|---|
| 0. Chữ | Viết "sẽ mô phỏng gì, bằng gì" (Ref 1 & 2) | ✅ Bắt buộc |
| 1. Ảnh tham khảo | Dán mạch tham khảo + ghi "sẽ cải biên" | ✅ Nên có |
| 2. Dựng thử tối giản | 1 cell + LM35 → Arduino → LCD (chạy được) + vài đường I–V | 💡 Bonus, gây ấn tượng |
| 3. Mạch đầy đủ 4 cell | balancing + tải + bảo vệ đầy đủ | ❌ sau mốc proposal |

---

# 📚 Ôn lại bài — phần nào nên đọc lại

### Ưu tiên cao (đúng trọng tâm GĐ1)
- **Đặc tính PV:** đường **I–V / P–V**, **STC**, ảnh hưởng bức xạ (G) & nhiệt độ (T), **MPP**.
- **Shading / partial shading:** bóng râm che một phần, **hotspot**, **bypass diode**, **blocking diode**, vì sao phải chia/nhóm tấm pin.
- **Cấu hình nối tấm pin:** **series vs parallel**, TCT; ảnh hưởng áp/dòng & tổn hao khi bị che.
- **BMS:** **SoC/SoH**, cân bằng cell, bảo vệ quá/thấp áp – quá dòng – quá nhiệt, đo V/I, **C-rate**.

### Ưu tiên trung bình
- **Charge controller:** **PWM vs MPPT**, nguyên lý MPPT.
- **Cảm biến đo:** voltage divider (đo áp), shunt / Hall / **INA226** (đo dòng–công suất), **LM35** (nhiệt).
- **ESP32:** đọc ADC, giao tiếp I²C/UART, gửi dữ liệu (WiFi/MQTT/HTTP) → ThingSpeak.

### Đọc lướt (scope tổng thể 4041, làm sau proposal)
- **Microgrid:** khái niệm, chế độ vận hành, chuyển nguồn (DPDT).
- **Inverter:** DC→AC, các loại cơ bản.
- **IoT platform / dashboard:** hiển thị & lưu dữ liệu.

---

# 🔎 Còn mở / cần tự làm

**Đã chốt (khỏi hỏi lại):** deliverable = báo cáo tiến độ trên LMS (không slide) · công cụ mô phỏng = Proteus · proposal chỉ tổng quan + kế hoạch + phân việc · nộp 1 bản/nhóm.

**Còn mở:**
- [ ] Xem **hạn chót chính xác trên LMS**.
- [ ] **Tiêu chí chấm** (thầy chưa nêu) — hỏi thêm nếu cần.
- [ ] Đọc 3 ref → **chọn hướng shading** (B1: reconfiguration hay chia nhỏ).
- [ ] **Chốt thông số + loại pin** (B3).
- [ ] **Tự tìm thêm tài liệu** cho proposal (ngoài 3 ref thầy đưa).

---

*Cập nhật: 2026-09-10 — thêm khối "Trọng tâm hiện tại & bàn giao" (trạng thái + bản đồ tài liệu + việc giao astra), trỏ tới 8 core [`../info/info.md`](../info/info.md); sửa nhãn GĐ1/GĐ2 (GĐ1 = cả môn 4041; GĐ2 = đồ án tốt nghiệp; "mốc proposal" vs "sau proposal"). (2026-09-08: thêm B6 mạch tham khảo — cảnh báo trùng, B7 4 điểm khác biệt, B8 mức mô phỏng; trỏ bản nộp + sim-guide. 2026-09-06: tách PHẦN A/B; shading & loại pin để mở.)*
