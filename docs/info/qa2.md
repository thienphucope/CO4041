# Câu hỏi kỹ thuật

1. Bộ pin 12 V dùng loại pin nào; điện áp, dòng sạc/xả tối đa, dung lượng và số lượng pin/cell là bao nhiêu; cấu hình nối tiếp/song song như thế nào?
2. Mỗi tấm PV có điện áp, dòng điện và công suất bao nhiêu; hệ thống dùng bao nhiêu tấm và cấu hình nối tiếp/song song như thế nào?
3. BMS cần thiết kế theo hướng dùng MCU, mạch analog/IC bảo vệ cứng hay kết hợp cả hai?
4. Tải gồm những thiết bị AC/DC nào; công suất định mức, công suất cực đại hoặc khởi động và thời gian sử dụng là bao nhiêu?
5. BMS cần hỗ trợ các chức năng bảo vệ nào và ngưỡng tác động tương ứng: quá áp, thấp áp, quá dòng sạc/xả, ngắn mạch và quá nhiệt?
6. BMS cần cân bằng chủ động hay thụ động; dòng cân bằng yêu cầu là bao nhiêu?
7. BMS có bắt buộc ước lượng SoC và giao tiếp giám sát không; nếu có thì yêu cầu độ chính xác và giao thức là gì?
8. Sản phẩm BMS cuối kỳ cần đạt mức nào: mô phỏng Proteus, schematic, PCB hay mạch thực nghiệm hoàn chỉnh?
9. Phạm vi hiện tại có tập trung vào thiết kế BMS, còn PV, bộ sạc, inverter và tải chỉ dùng làm đầu vào và kiểm thử không?

## Ghi nhận trả lời trong buổi họp ngày 23/09/2026

Tóm tắt theo ghi nhớ sau buổi họp, không phải lời thầy trích nguyên văn:

- **Trọng tâm đề tài:** PV array reconfiguration. Mức cơ bản cần thực hiện là chuyển cấu hình rồi đo và so sánh hiệu suất giữa các cấu hình/phương án. Các thuật toán chuyển cấu hình nâng cao sẽ nghiên cứu thêm sau.
- **Sản phẩm giai đoạn 1:** PCB cho mạch chuyển cấu hình dàn PV và mô phỏng thuật toán chuyển cấu hình trên MATLAB.
- **Dàn PV:** 3 × 3, tổng cộng 9 tấm pin mặt trời. Chưa chốt thông số từng tấm và cách đấu nối cụ thể cho mỗi cấu hình.
- **BMS:** ~~dùng sản phẩm BMS có sẵn~~ → *cập nhật 05/10/2026:* phần sạc/bảo vệ pin do bộ điều khiển sạc Suoer đảm nhận; nhóm **không** làm BMS và **không** làm cân bằng cell. Về sau có thể mở mạch sản phẩm để gắn đầu đo (probe), lấy thông tin đưa lên IoT.
- **Bộ sạc:** dùng bộ sạc Suoer; chưa ghi nhận mã sản phẩm hoặc thông số cụ thể.
- **Pin lưu trữ:** dự kiến dùng 1 hoặc 2 bình/khối pin, không cần thiết kế theo yêu cầu cân bằng cell của BMS tự làm. Cần đủ mức điện áp 12 V, có dung lượng lớn và tương thích với bộ sạc Suoer cùng BMS được chọn. Loại pin chưa chốt; trong họp có nhắc đến pin chì hoặc pin lithium nhưng cần xác nhận trước khi lựa chọn.

Các câu hỏi về công suất tải, thông số tấm PV, dung lượng pin cụ thể, mã BMS vẫn chưa có câu trả lời chắc chắn trong ghi chép này.


Bộ sạc: https://shopee.vn/search?keyword=b%E1%BB%99%20%C4%91i%E1%BB%81u%20khi%E1%BB%83n%20s%E1%BA%A1c%20suoer

Pin: mặt trời: https://shopee.vn/T%E1%BA%A4M-N%C4%82NG-L%C6%AF%E1%BB%A2NG-M%E1%BA%B6T-TR%E1%BB%9CI-MONO-6V-15W-35x35cm-TEKI-i.1029550180.20894545104?extraParams=%7B%22display_model_id%22%3A204674876487%2C%22model_selection_logic%22%3A3%7D

Tải sẽ là tải tĩnh tức không thay đổi công suất

Thay đổi theo shading, dùng mosfet để quét nhanh hoặc chiến thuật khác

## Cập nhật 05/10/2026 — chốt phạm vi

- **Mục tiêu GĐ1:** PCB mạch chuyển cấu hình (PV reconfiguration) cho dàn PV 3 × 3 + mô phỏng thuật toán trên MATLAB. Ngoài ra không làm gì thêm ở phía pin.
- **Bộ sạc:** Suoer **ST-S1230** (hệ 12 V). Bộ này lo sạc và bảo vệ pin → không có khối BMS tự thiết kế, không cân bằng cell.
- **Tấm PV:** 9 tấm mono 6 V / 15 W, I_mp ≈ 2,5 A (TEKI 35 × 35 cm, link ở trên).

### Các cấu hình 3 × 3 khả thi với ST-S1230

Nguồn: ảnh chụp kết quả hỏi AI (`Screenshot 2026-10-05 231654.png`, `…231845.png`), chưa kiểm chứng bằng datasheet. Giả thiết mỗi tấm: V_mp = 6 V, V_oc ≈ 7,2 V, I_mp = 2,5 A, I_sc ≈ 2,75 A. Cột V là V_mp của dàn, P là P_mp khi bức xạ đều (STC).

**Nhóm A — sạc được qua ST-S1230** (V ≈ 18 V, V_oc ≈ 21,6 V, đúng hệ 12 V):

| Cấu hình | V | I_sc | P | Ghi chú |
|---|---|---|---|---|
| 3S3P (SP) | 18 V | 8,25 A | 135 W | Baseline |
| TCT 3 × 3 | 18 V | 8,25 A | 135 W | Chống bóng che tốt nhất |
| BL 3 × 3 | 18 V | 8,25 A | 135 W | Ít dây nối chéo hơn TCT |
| HC 3 × 3 | 18 V | 8,25 A | 135 W | Trung gian giữa TCT và BL |
| 3 chuỗi 3S độc lập | 18 V/nhánh | 2,75 A/nhánh | 45 W/nhánh | Cần nhiều bus/nhiều bộ sạc — không hợp với một ST-S1230 |

Khi bức xạ đều, bốn cấu hình nhóm A cho cùng 135 W; chúng chỉ khác nhau khi có bóng che → đây là chỗ cần đo/mô phỏng.

**Nhóm B — không sạc được qua ST-S1230**:

| Cấu hình | V | I_sc | P | Vấn đề |
|---|---|---|---|---|
| 9P (toàn song song) | 6 V | 24,75 A | 135 W | Áp quá thấp, không sạc được pin 12 V |
| 9S (toàn nối tiếp) | 54 V | 2,75 A | 135 W | V_oc ≈ 64,8 V vượt giới hạn vào PV của bộ sạc (ảnh ghi 50 V max) → cấm |

### Cần kiểm tra
- Datasheet ST-S1230: là **PWM hay MPPT**, giới hạn V_oc đầu vào PV, dòng PV tối đa. Chưa tìm được datasheet trên mạng; cần đọc nhãn/hướng dẫn kèm thiết bị.
- Nếu là PWM: dàn PV bị kéo về điện áp pin (≈ 12,5–14,4 V) chứ không chạy ở 18 V → công suất thực thấp hơn 135 W, và khi so các cấu hình dưới bóng che phải tính công suất **tại V_pin**, không chỉ tại điểm MPP toàn cục. Mô hình MATLAB nên xuất cả hai.
- PCB phải chặn cứng (bằng phần cứng/logic khóa) mọi tổ hợp switch tạo ra 9S hoặc chuỗi > 3 tấm, vì V_oc khi đó vượt giới hạn bộ sạc.
- Tải: tải tĩnh, công suất cố định (chưa có số).

