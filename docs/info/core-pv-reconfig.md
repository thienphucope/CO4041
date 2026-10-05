# Core — PV array reconfiguration (TCT + DES + irradiance equalization)

> **Cập nhật phạm vi 23/09/2026:** Thầy đã chốt PV reconfiguration là trọng tâm GĐ1: dàn 3 × 3, PCB chuyển cấu hình và mô phỏng MATLAB. Các đoạn dưới mô tả kế hoạch proposal cũ; xem [ghi nhận buổi họp](qa2.md) và [hub tài liệu PV mới](../references/references.md) để thiết kế tiếp.

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
| **EI** | Equalization Index | **EI = max(Gᵢ) − min(Gᵢ)**; dùng để sàng lọc cấu hình có bức xạ hàng cân bằng. |
| **G_ij / G_i / G** | Irradiance của tấm (i,j) / hàng i / tổng | Bức xạ ước lượng từ I,V đo được. |
| **DP** | Dynamic Programming | Quy hoạch động (bài toán Subset-Sum / Knapsack) tìm cấu hình. |
| **SC** | Smart Choice | Thuật toán bổ trợ khắc phục ca đặc biệt của DP. |
| **Hybrid algorithm** | DP + SC | Thuật toán lai Ref 3 dùng để tìm cấu hình tối ưu. |
| **MPP / MPPT** | Maximum Power Point (Tracking) | (xem [[core-pv-model]]). |

---

## 2. Vấn đề & ý tưởng (Ref 3, Abstract + §1)
Dưới bức xạ **không đồng đều** (non-homogeneous), mỗi module nhận G khác nhau → tổn hao + hotspot. **Reconfiguration = sắp xếp lại kết nối** các module để **cân bằng bức xạ** (irradiance equalization) giữa các hàng → tăng công suất & bảo vệ thiết bị.
- Hiệu quả **mô phỏng trong các ca của Ref 3**: tăng 10–50% công suất theo bài; một ca từ 791.1 W lên 1079 W. Không xem đây là mức tăng dự báo cho PCB của nhóm.

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
avg = G / m           — mức trung bình mỗi hàng khi có m hàng
```

**Chỉ số cân bằng (Eq 6):**
```
EI = max_i(G_i) − min_i(G_i)
```
→ EI nhỏ nghĩa là các hàng có tổng bức xạ gần nhau; đây là **tiêu chí của Ref 3**, không tự chứng minh công suất thực lớn nhất khi tính đường P–V, tổn hao switch và dải hoạt động của bộ sạc. Công thức (5) trong bản PDF ghi `G/n` dù đoạn trước ký hiệu số hàng là `m`; ở đây dùng `G/m` theo định nghĩa trung bình trên `m` hàng.
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
Ref 3 mô phỏng bằng **MATLAB–Simulink** (input data + PV modules + hybrid algorithm + DES switching matrix). Theo buổi họp 23/09/2026, mô phỏng thuật toán trên MATLAB là **sản phẩm GĐ1**, đi cùng PCB chuyển cấu hình.

## 7. Áp dụng vào đồ án
- **GĐ1 hiện tại:** xác định những cấu hình PCB 3 × 3 thực hiện được; dựng mô hình MATLAB cho đúng các trạng thái đó; so công suất dưới các dạng bóng che; sau đó đối chiếu phép đo thực nghiệm. [Hub tài liệu](../references/references.md) tách rõ cách nối dây cố định, đổi vài topology và đổi nhóm từng tấm.

- **Ràng buộc từ bộ sạc ST-S1230 (05/10/2026):** chỉ các cấu hình 3 tấm nối tiếp × 3 nhánh (SP, TCT, BL, HC; 18 V, 135 W ở STC) sạc được; 9P (6 V) và 9S (V_oc ≈ 64,8 V) bị loại. Bảng chi tiết ở [qa2](qa2.md#các-cấu-hình-3--3-khả-thi-với-st-s1230).

## 8. Còn mở
- Chưa chốt PCB chuyển **vài topology** (SP/TCT/BL/HC) hay cho phép **đổi nhóm từng module** (TCT + DES); hai hướng cần số switch và thuật toán khác nhau.
- ST-S1230 là PWM hay MPPT — quyết định cách so công suất giữa các cấu hình (tại V_pin hay tại MPP).
- Chưa chốt cách đo tình trạng từng tấm, trình tự chuyển mạch và bộ ca bóng che.

*Cập nhật: 2026-10-05.*
