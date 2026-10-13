# Chốt phạm vi GĐ1 và tập cấu hình dàn 3 × 3

**Trạng thái:** xong · **Thời gian:** 23/09 – 05/10/2026 · **Nguồn:** [`docs/info/qa2.md`](../../info/qa2.md)

## Đã chốt

- **GĐ1 = PCB mạch chuyển cấu hình cho dàn PV 3 × 3 + mô phỏng thuật toán trên MATLAB.** Không làm BMS, không làm cân bằng cell.
- **Bộ sạc Suoer ST-S1230** (hệ 12 V) lo sạc và bảo vệ pin.
- **Tấm PV:** 9 tấm mono 6 V/15 W (TEKI 35 × 35 cm), I_mp ≈ 2,5 A. V_oc ≈ 7,2 V và I_sc ≈ 2,75 A là **giả thiết**, chưa có datasheet.
- **Tải:** tải tĩnh, công suất cố định (chưa có số).

## Tập cấu hình

- **Nhóm A, sạc được:** SP (3S3P), TCT, BL, HC. Tất cả cho ≈ 18 V, 21,6 V hở mạch, 135 W ở STC. Các cấu hình này chỉ khác nhau khi có che bóng.
- **Nhóm B, bị loại:**
  - 9P: áp quá thấp.
  - 9S: V_oc ≈ 64,8 V, vượt giới hạn ~50 V của bộ sạc.
  - 3 chuỗi độc lập: cần nhiều đầu vào sạc.
- **Phương án PCB:** 3 tấm nối tiếp mỗi cột được đấu cứng, cộng **4 công tắc nối chéo S1–S4** giữa các nút cùng mức. Như vậy có 2⁴ = 16 trạng thái, trong đó `0000` = SP, `1111` = TCT, `1001` = BL, còn HC tạm gán `0110`. Vì phần nối tiếp đấu cứng, mạch **không thể** tạo ra 9S hay 9P: đây là khóa an toàn ở mức phần cứng.

## Còn mở (chuyển sang undone)

- ST-S1230 là PWM hay MPPT; giới hạn V_oc và dòng PV: [undone/03](../undone/03-xac-nhan-thong-so.md).
- Mẫu công tắc chính xác của BL/HC với dàn 3 cột; có làm DES trong GĐ1 hay không: [undone/04](../undone/04-chot-bl-hc-va-des.md).
