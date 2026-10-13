# Báo cáo proposal (mốc M1)

**Trạng thái:** xong · **Thời gian:** 10/09 – 05/10/2026

## Đã làm

1. **Bản đầu theo phương án BMS 12 V + Proteus**, nộp LMS: [`report/proposal/proposal-submission-133.pdf`](../../../report/proposal/proposal-submission-133.pdf), ngày 18/09/2026. Các commit liên quan: `8536e72`, `062ee09`, `ee1eb04`, `46dc1a5`.
2. **Bản cập nhật sau buổi họp 23/09**, chuyển trọng tâm sang PV reconfiguration dàn 3 × 3 (commit `ecfc096`, 05/10/2026). Bản PDF: [`report/proposal/report.pdf`](../../../report/proposal/report.pdf).
   - Chương 05: thông số dàn, các cấu hình nhóm A/B, phương án 4 công tắc nối chéo.
   - Chương 06: kế hoạch mô phỏng, gồm ca thử PV-01..04, ARR-01..05 và tiêu chí so sánh.
   - Chương 07: TCT, EI, DP–SC, DES theo Ref 3.
   - Chương 08: kiến trúc hệ thống.
   - Chương 09: kế hoạch M1–M7 và phân công 3 thành viên.

## Phân công đã ghi trong báo cáo (chương 09)

| Thành viên | Phụ trách |
|---|---|
| Lê Thanh Phú (2212581) | PCB: linh kiện đóng cắt, mạch kích, bảo vệ, layout, gia công |
| Phan Trần Nguyên Phúc (2212643) | Mô phỏng MATLAB: PV-01..04, ARR-01..05, DP–SC |
| Hoàng Ngô Thiên Phúc (2212612) | Đo lường, firmware, thực nghiệm, biên tập báo cáo |

## Sản phẩm phụ

- `proteus-sim/functional.pdsprj` (14/09/2026): dự án Proteus khởi đầu theo phương án cũ. Chưa rà nội dung, không còn trong phạm vi hiện tại.
- Build LaTeX: MiKTeX portable trong `.miktex/`, chạy `pdflatex` 3 lần.
