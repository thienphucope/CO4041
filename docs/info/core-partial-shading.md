# Core — Bóng râm một phần (partial shading), hotspot & diode bảo vệ

> **Cái gì:** khi một phần dàn pin bị che, công suất tụt **phi tuyến** và cell bị che có thể **nóng cháy (hotspot)**. Đây là *vấn đề* mà bypass/blocking diode và reconfiguration dùng để *giải*.
> **Tại sao quan trọng với đồ án:** là nền lý thuyết cho hướng "chống bóng râm / PV array configuration" thầy dặn tìm hiểu ([`qa1.md`](qa1.md) §B.1; [`../plan/proposal.md`](../plan/proposal.md) B1).
> **Nguồn chính:** Ref 3 §1–2 — Ngo & Nguyen 2018 ([`../references/extracted/03-pv-reconfig/03-pv-reconfig.md`](../references/extracted/03-pv-reconfig/03-pv-reconfig.md)); bổ sung kiến thức nền PV.
> Liên quan: [[core-pv-model]] · [[core-pv-reconfig]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **Partial shading** | — | Che **một phần** dàn/tấm pin (mây, cây, cột, nhà). |
| **Hotspot** | — | Cell bị che trở thành **tải tiêu thụ** → nóng cục bộ → hỏng cell. |
| **Bypass diode** | — | Diode // một nhóm cell, cho dòng "đi vòng" qua phần bị che. |
| **Blocking diode** | — | Diode nối tiếp chuỗi, chặn **dòng chảy ngược** vào tấm pin. |
| **MPP / GMPP / LMPP** | (Global/Local) Maximum Power Point | Khi shading, đường P–V có **nhiều đỉnh** → 1 đỉnh toàn cục + nhiều đỉnh cục bộ. |
| **I_SC / V_OC** | Short-circuit current / Open-circuit voltage | (xem [[core-pv-model]]). |
| **STC** | Standard Test Conditions | G = 1000 W/m², T = 25 °C. |
| **Recoverable / irrecoverable losses** | Tổn hao (có/không) thu hồi được | Ref 3 chia tổn hao shading làm 2 loại. |

---

## 2. Tại sao shading gây tụt công suất phi tuyến

**Luật chuỗi nối tiếp:** dòng của chuỗi nối tiếp = **dòng của cell yếu nhất** (cell bị che). Một cell bị che làm **cả chuỗi** tụt dòng → mất công suất **nhiều hơn** tỉ lệ diện tích bị che (Ref 3, Trang 5).
- Nối tiếp: dòng = nhỏ nhất, áp = tổng. Song song: áp = nhỏ nhất, dòng = tổng.

**Hotspot (Ref 3 §1, Trang 2):** cell bị che không phát điện mà bị các cell khác "ép" dòng ngược → tiêu tán công suất dưới dạng nhiệt → **nhiệt độ tăng cao → hỏng trực tiếp cell**.

**Misleading / nhiều đỉnh:** shading làm đường P–V có nhiều điểm công suất cực đại → thuật toán MPPT thường **bám nhầm đỉnh cục bộ** (Ref 3, Trang 2).

**Ảnh hưởng bức xạ & nhiệt (Ref 3 §2.1–2.2):**
- I_SC tỉ lệ **tuyến tính** với G; V_OC tăng **theo hàm mũ** (rất nhẹ) theo G.
- T tăng trên 25 °C: I_SC tăng nhẹ, **V_OC giảm mạnh** → công suất giảm.
→ Đường I–V theo G: Fig. 1 ([`../references/extracted/03-pv-reconfig/images/p03-img01-x116.png`](../references/extracted/03-pv-reconfig/images/p03-img01-x116.png)); theo T: Fig. 2 ([`.../p04-img01-x118.png`](../references/extracted/03-pv-reconfig/images/p04-img01-x118.png)).

---

## 3. Các cách giảm tổn hao shading

Ref 3 (Trang 2) chia kỹ thuật thu hồi tổn hao làm **3 nhóm**:
1. **Distributed MPPT** (mỗi module/substring có MPPT riêng).
2. **Multilevel inverters**.
3. **PV array reconfiguration** ← hướng Ref 3 đi sâu → [[core-pv-reconfig]].

### Bypass diode vs Blocking diode (kiến thức nền, quan trọng cho phần cứng)
- **Bypass diode:** mắc **song song** ngược cực với một nhóm cell. Bình thường khoá; khi nhóm bị che → dẫn, cho dòng chuỗi đi vòng → **tránh hotspot** và giữ phần còn lại vẫn phát. **Đánh đổi:** Ref 3 lưu bypass diode tuy chặn hotspot nhưng vẫn gây **tổn hao một phần** và mất công suất đầu ra (Trang 2).
- **Blocking diode:** mắc **nối tiếp** chuỗi, chặn dòng chảy ngược (vd ban đêm pin xả ngược, hoặc chuỗi yếu bị chuỗi mạnh nạp ngược).

### Hai hướng cụ thể hoá cho đồ án (chưa chốt — [`../plan/proposal.md`](../plan/proposal.md) B1)
- **PA1 — Reconfiguration (TCT + DES):** đúng thuật ngữ thầy nói, theo Ref 3 → [[core-pv-reconfig]]. Nếu mô phỏng thì **MATLAB–Simulink** (không phải Proteus).
- **PA2 — Chia nhỏ tấm + bypass diode:** đơn giản, sát phần cứng.
👉 **Cần đọc Ref 3 + PVEducation rồi mới chọn PA.**

---

## 4. Áp dụng vào đồ án
- **Ở proposal:** chỉ cần **hiểu + tóm tắt** hiện tượng (shading → hotspot → tại sao phải chia/nhóm tấm). Không bắt buộc mô phỏng ([`../plan/proposal.md`](../plan/proposal.md) A1.4).
- Là phần "Cơ sở lý thuyết" của báo cáo (checklist 2): đặc tính PV, partial shading/hotspot, bypass diode.
- Nối với [[core-pv-model]] (đường I–V/P–V) và [[core-pv-reconfig]] (giải pháp thuật toán).

## 5. Còn mở / cần tự tìm thêm
- Số cell/nhóm cho 1 bypass diode, vị trí blocking diode — phụ thuộc thiết kế tấm pin thực tế nhóm dùng.
- PVEducation (pveducation.org) cho hình I–V khi shading + giải thích hotspot trực quan — **tài liệu tự tìm thêm** thầy yêu cầu.

*Cập nhật: 2026-09-10.*
