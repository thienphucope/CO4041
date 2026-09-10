# Core — PV array reconfiguration (TCT + DES + irradiance equalization)

> **Cái gì:** thuật toán **đổi nối dàn pin** lúc vận hành để cân bằng bức xạ giữa các hàng → giảm tổn hao do bóng râm → tăng công suất.
> **Tại sao quan trọng với đồ án:** chính là **"thuật toán PV array configuration"** thầy dặn **tìm hiểu** ([`qa1.md`](qa1.md) §A1, §B.1). Ở mốc proposal chỉ cần *tìm hiểu* (lý thuyết + tóm tắt), chưa bắt buộc mô phỏng ([`../plan/proposal.md`](../plan/proposal.md) A1.4, B2).
> **Nguồn chính:** Ref 3 — Ngo & Nguyen 2018 ([`../references/extracted/03-pv-reconfig/03-pv-reconfig.md`](../references/extracted/03-pv-reconfig/03-pv-reconfig.md)).
> Liên quan: [[core-partial-shading]] · [[core-pv-model]]

---

## 1. Viết tắt

| Ký hiệu | Đầy đủ | Nghĩa |
|---|---|---|
| **RS** | Reconfiguration System | Hệ đổi cấu hình = thuật toán cân bằng bức xạ + ma trận chuyển mạch. |
| **TCT** | Total-Cross-Tied | Kiểu nối dàn pin mà Ref 3 tập trung (nền cho reconfiguration). |
| **SP / BL / HC** | Series-Parallel / Bridge-Link / Honey-Comb | Các kiểu nối dàn pin khác (Ref 3, Fig. 4). |
| **DES** | Dynamic Electrical Scheme (switching matrix) | Ma trận chuyển mạch đổi vị trí tấm pin giữa các hàng. |
| **EI** | Equalization Index | **EI = max(Gᵢ) − min(Gᵢ)**; EI nhỏ nhất = cấu hình tối ưu. |
| **G_ij / G_i / G** | Irradiance của tấm (i,j) / hàng i / tổng | Bức xạ ước lượng từ I,V đo được. |
| **DP** | Dynamic Programming | Quy hoạch động (bài toán Subset-Sum / Knapsack) tìm cấu hình. |
| **SC** | Smart Choice | Thuật toán bổ trợ khắc phục ca đặc biệt của DP. |
| **Hybrid algorithm** | DP + SC | Thuật toán lai Ref 3 dùng để tìm cấu hình tối ưu. |
| **MPP / MPPT** | Maximum Power Point (Tracking) | (xem [[core-pv-model]]). |

---

## 2. Vấn đề & ý tưởng (Ref 3, Abstract + §1)
Dưới bức xạ **không đồng đều** (non-homogeneous), mỗi module nhận G khác nhau → tổn hao + hotspot. **Reconfiguration = sắp xếp lại kết nối** các module để **cân bằng bức xạ** (irradiance equalization) giữa các hàng → tăng công suất & bảo vệ thiết bị.
- Hiệu quả công bố: **tăng 10–50%** hiệu năng dàn pin (Ref 3, Abstract). Ví dụ thực nghiệm mô phỏng: **+29%** (791.1 W → 1079 W).

## 3. Các kiểu nối dàn pin (Ref 3 §2.4, Fig. 4)
Series (a), Parallel (b), Series-Parallel/SP (c), **Total-Cross-Tied/TCT (d)**, Bridge-Link/BL (e), Honey-Comb/HC (f).
→ Fig. 4: [`../references/extracted/03-pv-reconfig/images/p06-img01-x157.png`](../references/extracted/03-pv-reconfig/images/p06-img01-x157.png)
TCT là nền vì nó gồm nhiều **hàng song song**, mỗi hàng là các tấm nối cross-tied → đổi tấm giữa các hàng là cân bằng được bức xạ hàng.

## 4. Thuật toán cân bằng bức xạ (Ref 3 §3)

**Ước lượng bức xạ mỗi tấm** từ dòng–áp đo được (Eq 1):
```
G_ij = α · ( I_ij + I_0·( e^(V_ij / (n·V_T)) − 1 ) )
```
(α, I_0, n·V_T suy từ I_SC, V_OC, MPP trong datasheet.)

**Tổng hợp theo hàng & toàn dàn:**
```
G_i = Σ_j G_ij        (Eq 2)  — bức xạ hàng i
G   = Σ_i G_i         (Eq 3)  — tổng bức xạ
N   = Σ_i n_i         (Eq 4)  — tổng số module
avg = G / n           (Eq 5)  — mức trung bình mỗi hàng cần đạt
```

**Chỉ số cân bằng (Eq 6):**
```
EI = max_i(G_i) − min_i(G_i)
```
→ Cấu hình có **EI nhỏ nhất** (các hàng bức xạ gần bằng nhau, gần `avg`) = **tối ưu**, cho công suất lớn nhất.
⚠️ Số hàng **m phải tương thích dải áp vào của inverter**.

**Ví dụ trực quan (Ref 3, Trang 7):** 4 module TCT, G = {100, 100, 800, 1000} W/m². Cấu hình ban đầu P_max = **79.60 W**; chuyển module 3 từ hàng 2 → hàng 1 → P_max = **368.6 W**.

**Tìm cấu hình tối ưu = thuật toán lai (hybrid):**
- **DP (Dynamic Programming):** giải như bài Subset-Sum trong Knapsack — gán mỗi tấm vào hàng sao cho tổng bức xạ hàng cân bằng. Tốt gần như mọi ca.
- **SC (Smart Choice):** xử lý các ca đặc biệt DP làm chưa tốt.
- **Hybrid = DP + SC** → kết quả tốt hơn các phương pháp trước.
→ Sơ đồ thuật toán lai Fig. 7: [`../references/extracted/03-pv-reconfig/images/p09-img01-x189.png`](../references/extracted/03-pv-reconfig/images/p09-img01-x189.png)

## 5. Ma trận chuyển mạch DES (Ref 3 §4.3)
Mỗi module nối vào **3 hàng qua các switch**. Đổi module từ hàng x → y: **mở** switch hàng x, **đóng** switch hàng y. Qua đóng/mở, dàn pin chuyển từ TCT ban đầu sang **bất kỳ** TCT đến 3 hàng.
→ Kết quả trước/sau reconfiguration (9 module) Fig. 14: [`../references/extracted/03-pv-reconfig/images/p13-img01-x262.png`](../references/extracted/03-pv-reconfig/images/p13-img01-x262.png)

## 6. Công cụ mô phỏng
Ref 3 mô phỏng bằng **MATLAB–Simulink** (input data + PV modules + hybrid algorithm + DES switching matrix). ⚠️ **Khác Proteus** (công cụ thầy chốt cho BMS + PV model). Reconfiguration là **ngoại lệ** dùng MATLAB (Ref 3 dùng), chỉ làm nếu chọn hướng này + còn thời gian ([`../plan/proposal.md`](../plan/proposal.md) B2 — *stretch, không bắt buộc*).

## 7. Áp dụng vào đồ án
- **Ở proposal (bắt buộc):** **tóm tắt** Ref 3 trong báo cáo — TCT, DES switching, irradiance equalization (EI), hybrid DP+SC. Chỉ *tìm hiểu*, **không cần chạy mô phỏng**.
- *Stretch:* nếu chọn PA1 ([[core-partial-shading]] §3) + còn thời gian → thử mô phỏng reconfiguration trên MATLAB–Simulink, lấy số liệu trước/sau ([`../plan/proposal.md`](../plan/proposal.md) B7 stretch).

## 8. Còn mở
- Chọn PA1 (reconfiguration) hay PA2 (chia nhỏ tấm + bypass) — **chưa quyết** ([`../plan/proposal.md`](../plan/proposal.md) B1).
- Nếu làm thật: DES cần nhiều switch (relay/MOSFET) → phức tạp phần cứng; cân nhắc vs lợi ích.

*Cập nhật: 2026-09-10.*
