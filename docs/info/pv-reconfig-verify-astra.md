# PV reconfiguration 3 × 3 — giả thuyết cần Astra kiểm chứng

**Bối cảnh:** Dàn 9 tấm, che bóng không đều trong đô thị; nhóm dự kiến làm PCB chuyển cấu hình và mô phỏng thuật toán trên MATLAB. Các mode cụ thể chưa được cung cấp. Vì thế chưa thể kết luận số switch hoặc thuật toán cần dùng.

## Ba nút thắt đang nhận định

1. **Quan sát:** Làm sao bộ điều khiển biết tấm nào đang yếu do che bóng và mức độ ra sao? Có thể đo bức xạ trực tiếp hoặc suy từ điện áp/dòng/đặc tuyến; phải xét độ tin cậy, số cảm biến và việc phép đo có cần tạm ngắt dàn hay không. “Mắt thấy bóng” chưa phải tín hiệu đầu vào của mạch.
2. **Thực hiện:** PCB cho phép những cách nối nào? Software chỉ được chọn trong tập cấu hình mạch thực hiện được. Cần kiểm switch chịu áp/dòng ở mọi cấu hình và trạng thái chuyển tiếp; trình tự đổi nối không được tạo đường nối tắt ngoài ý muốn.
3. **Lợi ích ròng:** Với **cùng mức và hình dạng bóng che**, so công suất cực đại toàn cục trên đường P–V (`P_GMPP`) của cấu hình được chọn với các cấu hình khả thi khác và một baseline cố định (ví dụ TCT/SP). Với bóng che biến đổi theo thời gian, so **điện năng đầu ra (Wh)** trên cùng khoảng thời gian, tính tác động của thời gian đo, thời gian chuyển và điện tự tiêu thụ. Không lấy công suất khi không che ở STC làm mức cực đại phải đạt trong điều kiện đang che. Nếu dùng tổng MPP riêng của 9 tấm làm cận trên lý thuyết, phải ghi rõ đó không nhất thiết là mức dàn ghép thụ động đạt được.

**Nhận định sơ bộ:** Với 9 tấm, việc duyệt các cách chia hàng hợp lệ có thể không nặng tính toán. Khó chính có thể là **đồng thiết kế cách đo + ma trận switch + mục tiêu tối ưu theo điện năng thực**. Nếu PCB chỉ có vài mode cố định, thuật toán chọn mode có thể rất đơn giản. Đây là giả thuyết, cần kiểm lại sau khi có sơ đồ mode và thông số tấm/bộ sạc.

## Nhờ Astra phản biện

1. Ba nút thắt trên đã đúng bản chất của **dynamic electrical reconfiguration** cho dàn 3 × 3 chưa? Có điểm kỹ thuật quan trọng nào bị bỏ sót?
2. Nếu muốn từng tấm có thể đổi hàng trong TCT, cấu trúc switch và lượng phép đo tối thiểu khả thi là gì? Cấu hình nào thực sự tương đương điện để bỏ khỏi không gian tìm kiếm?
3. Chỉ số cân bằng bức xạ `EI` có đủ để chọn cấu hình không; khi nào cần đánh giá trực tiếp `P_GMPP`? Nên dùng baseline, thước đo và quy trình thí nghiệm nào để chứng minh **lợi ích ròng** dưới bóng che cố định và bóng che di chuyển?

## Tài liệu để đối chiếu

- [Hub nghiên cứu PV reconfiguration](../references/references.md), gồm PDF và bản extract theo trang.
- [Ngô & Nguyễn 2018](../references/extracted/03-pv-reconfig/03-pv-reconfig.md): TCT 9 module, EI, thuật toán DP–SC, ma trận DES trong MATLAB.
- [Vicente et al. 2015](../references/extracted/04-vicente-2015/04-vicente-2015.md): phép đo dòng ngắn mạch có khoảng ngắt, các hoán vị tương đương điện, relay thực nghiệm.
- [Ng & Ertugrul 2025](../references/extracted/07-ng-ertugrul-2025/07-ng-ertugrul-2025.md): đánh đổi số switch/cảm biến với độ linh hoạt, điện áp chịu đựng của switch, đo đường P–V.

*Ghi chú để kiểm chứng độc lập, 23/09/2026.*
