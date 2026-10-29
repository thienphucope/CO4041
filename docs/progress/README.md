# Tiến độ dự án — HK261-DAGD1-133

GĐ1 (môn CO4041): **PCB mạch chuyển cấu hình dàn PV 3 × 3 + mô phỏng thuật toán trên MATLAB** (chốt 05/10/2026, xem [`docs/info/qa2.md`](../info/qa2.md)).

**Cập nhật:** 30/10/2026 (chạy đủ mức 2; bộ sạc xác nhận PWM; dọn repo) · **Cài MATLAB:** [`docs/info/cai-dat-matlab.md`](../info/cai-dat-matlab.md)

**Quy ước:**
- Mỗi task là một file Markdown. `done/` chứa việc đã xong, `undone/` chứa việc còn lại.
- Xong một task thì chuyển file từ `undone/` sang `done/`, ghi kết quả và ngày làm, rồi cập nhật bảng dưới.

## Đã làm — [`done/`](done/)

| # | Task | Trạng thái |
|---|---|---|
| 01 | [Tài liệu đề tài, Q&A giảng viên, lý thuyết](done/01-tai-lieu-va-ly-thuyet.md) | Xong |
| 02 | [Báo cáo proposal (bản BMS 18/09, bản PV reconfig 05/10)](done/02-bao-cao-proposal.md) | Xong |
| 03 | [Chốt phạm vi GĐ1 và tập cấu hình 3 × 3, phương án 4 công tắc](done/03-chot-pham-vi-va-cau-hinh.md) | Xong |
| 04 | [Mô hình tham chiếu + mô phỏng tĩnh mức 1 (PV-01..04, ARR-01..04)](done/04-mo-hinh-tham-chieu-muc-1.md) | Xong, đã kiểm chứng |
| 05 | [Ứng suất công tắc nối chéo: dòng max 3,55 A, áp max 7,77 V](done/05-ung-suat-cong-tac.md) | Xong |
| 06 | [DES dạng tĩnh (mức 4): 3025 cách chia hàng, chọn theo EI / tham lam](done/06-des-tinh-muc-4.md) | Xong, đã kiểm chứng |
| 07 | [Tài liệu bàn giao Simulink + danh sách gói cần cài](done/07-tai-lieu-ban-giao-simulink.md) | Xong |
| 08 | [Code dựng và chạy model Simulink (mức 1, 3, 4)](done/08-code-simulink.md) | Xong, đã chạy 13/10 (xem 10) |
| 09 | [Code mức 2: bóng di chuyển + thuật toán (ARR-05)](done/09-code-muc-2-arr05.md) | Code xong; chạy đủ 30/10 ở 13 V, xem [undone/02](undone/02-chay-muc-2-day-du.md) |
| 10 | [Chạy Simulink lần đầu trên R2026b: PV-01..04, mức 1, 1b, 3 đạt; DES 9/10](done/10-chay-simulink.md) | Xong 13/10, còn việc phụ ở undone/01 |

## Chưa làm — [`undone/`](undone/)

| # | Task | Ưu tiên | Chờ | Phụ trách |
|---|---|---|---|---|
| 01 | [Hoàn thiện Simulink: ca DES lệch, chạy lại tham chiếu, ảnh model](undone/01-hoan-thien-simulink.md) | Trung bình | — | Mô phỏng |
| 02 | [Chạy đầy đủ mức 2 (ARR-05) và phân tích](undone/02-chay-muc-2-day-du.md) | Cao | — (MATLAB đã có) | Mô phỏng |
| 03 | [Xác nhận thông số ST-S1230 (PWM/MPPT) và tấm PV](undone/03-xac-nhan-thong-so.md) | Cao | Thiết bị thật | Đo lường |
| 04 | [Chốt mẫu BL/HC; quyết định có làm DES trong GĐ1](undone/04-chot-bl-hc-va-des.md) | Trung bình | Hỏi giảng viên | Cả nhóm |
| 05 | [Thiết kế PCB (M4)](undone/05-thiet-ke-pcb.md) | Cao | Chọn linh kiện | PCB |
| 06 | [Firmware ESP32 (M5)](undone/06-firmware-esp32.md) | Trung bình | PCB | Firmware |
| 07 | [Thực nghiệm và đối chiếu mô phỏng (M6)](undone/07-thuc-nghiem.md) | Trung bình | PCB + firmware | Cả nhóm |
| 08 | [Phần mô phỏng còn thiếu / mở rộng](undone/08-mo-phong-mo-rong.md) | Thấp – TB | Thông số, linh kiện | Mô phỏng |
| 09 | [Dọn dẹp tài liệu và repo](undone/09-don-dep-tai-lieu-repo.md) | Trung bình | — | Biên tập |
| 10 | [Đưa kết quả vào báo cáo](undone/10-bao-cao-ket-qua.md) | Trung bình | Kết quả MATLAB | Biên tập + mô phỏng |

## Đường găng

```
MATLAB ✓ ──> Simulink ✓ (done/10) ──> undone/02 mức 2 ──────┐
                                                             ├──> undone/10 báo cáo
undone/03 thông số ──> chạy lại mọi mức ─────────────────────┘
undone/05 PCB ──> undone/06 firmware ──> undone/07 thực nghiệm ──> undone/10
```

PCB không phải chờ mô phỏng. Phương án 4 công tắc không phụ thuộc vào kết quả xếp hạng cấu hình, và ứng suất công tắc đã có số ([done/05](done/05-ung-suat-cong-tac.md)).
