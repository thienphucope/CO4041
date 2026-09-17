# Q&A vòng 2: đầu vào, phạm vi triển khai và các quyết định còn mở

Ngày soạn: 17/09/2026. Trạng thái: **bản nháp câu hỏi, chưa gửi, chưa có trả lời của giảng viên**.

Nguồn hiện có: [specs](../specifications/specs.md), [qa0](qa0.md), [qa1](qa1.md). Bản report đang chỉnh: [report.tex](../../report/proposal/report.tex). Các đề xuất dưới đây là phương án của nhóm, chưa phải yêu cầu thầy đã xác nhận.

## 1. Proposal có cần chốt thiết bị không?

Trong qa1, thầy yêu cầu: “Proposal chưa đi vào chi tiết, chỉ nêu phương pháp tổng quan, kế hoạch, phân chia nhiệm vụ”. Theo hướng dẫn này, nhóm có thể trình bày khối chức năng, phương pháp, tiêu chí lựa chọn và mốc chọn thiết bị; chưa có căn cứ để xem mã cell, MCU, cảm biến, bộ sạc hoặc inverter là nội dung bắt buộc phải chốt ngay tại proposal.

Đây là cách nhóm áp dụng hướng dẫn hiện có. Nếu mẫu nộp hoặc rubric trên LMS có yêu cầu thêm danh mục thiết bị/BOM, nhóm đối chiếu trước rồi hỏi thầy về phần còn thiếu. Không cần hỏi lại toàn bộ yêu cầu proposal đã trả lời ở qa1.

Thông tin đầu vào hiện có là **pin 12 V, 15 Ah**. Chưa biết loại hóa học, số cell, pin có sẵn hay phải mua, khả năng tiếp cận từng cell, công suất tải, thời gian cấp tải và ngân sách. LiFePO4 4S chỉ là ví dụ khảo sát cho mô hình nhiều cell; SM55 là bộ tham số tham khảo cho mô phỏng PV. Cả hai đều chưa phải lựa chọn phần cứng.

## 2. Câu hỏi dự kiến gửi thầy

> Dạ thầy, nhóm em đang hoàn thiện proposal và kế hoạch triển khai trong một học kỳ. Hiện nhóm mới có thông tin pin 12 V–15 Ah. Nhóm dự kiến dùng mô-đun sạc và inverter có sẵn, tập trung phần tự phát triển vào BMS, đo lường, firmware, điều phối nguồn và IoT. Nhóm xin làm rõ các đầu vào sau:
>
> 1. **Pin lưu trữ:** pin 12 V–15 Ah là thiết bị có sẵn hay nhóm tự chọn/mua ạ? Có yêu cầu loại pin hoặc mã pin cụ thể không? Nếu có sẵn, thầy cho nhóm xin thông số/datasheet và thông tin các đầu nối đo từng cell để thiết kế cân bằng phù hợp.
> 2. **Tải và chuyển nguồn:** mô hình cần cấp tải AC/DC loại nào, công suất và thời gian hoạt động tối thiểu bao nhiêu? Chuyển nguồn có yêu cầu duy trì tải không gián đoạn không ạ? Nếu chưa có mức cụ thể, nhóm xin đề xuất quy mô và tiêu chí thử theo pin 12 V–15 Ah và ngân sách để thầy góp ý.
> 3. **Mức tự thiết kế và sản phẩm cuối kỳ:** hướng dùng mô-đun sạc/inverter, tự phát triển BMS và phần điều khiển/IoT có đáp ứng yêu cầu học phần không ạ? Phần BMS cần tự thiết kế mạch/PCB tới mức nào, và chức năng cân bằng cần thể hiện trên phần cứng hay có thể đánh giá trên mô hình riêng? Nhóm dự kiến khảo sát IC giám sát/bảo vệ để tích hợp vào thiết kế BMS.
> 4. **Nguồn lực thực nghiệm:** nhóm có thể sử dụng sẵn tấm PV, pin, nguồn DC, tải và dụng cụ đo nào? Có kinh phí hỗ trợ hoặc giới hạn thiết bị/địa điểm thử nghiệm nào cần biết trước khi lập BOM không ạ?
>
> Nhóm sẽ kiểm tra lịch và tiêu chí nộp trên LMS. Nếu chưa có hướng dẫn về sản phẩm cuối kỳ hoặc các mốc kiểm tra, nhóm xin thầy bổ sung để điều chỉnh tiến độ. Em cảm ơn thầy ạ.

Phần “không gián đoạn” là câu hỏi về yêu cầu tải, không phải cam kết của nhóm. Hướng nguồn phụ DC cách ly và vận hành độc lập là đề xuất; nhóm chưa đặt nhiệm vụ hòa lưới.

## 3. Việc nào hỏi thầy, việc nào nhóm quyết?

| Nội dung còn mở | Ai xử lý / cần thông tin từ đâu | Thời điểm và cách chốt |
|---|---|---|
| Loại và tình trạng pin 12 V–15 Ah; có thiết bị được chỉ định không | Hỏi thầy về đầu vào; nếu được tự chọn, nhóm so sánh và đề xuất | Đầu giai đoạn xây dựng mô hình và xác định đầu vào, trước khi ấn định số cell và ngưỡng |
| Loại tải, công suất, thời lượng minh họa, mức gián đoạn cho phép | Hỏi thầy có yêu cầu tối thiểu không; nhóm đề xuất nếu chưa có | giai đoạn xây dựng mô hình và xác định đầu vào; đối chiếu năng lượng pin và ngân sách |
| Mức tự thiết kế BMS, PCB bắt buộc, cách thể hiện cân bằng ngoài phần cứng | Hỏi thầy về tiêu chí học phần và đầu ra cần chứng minh | giai đoạn xây dựng mô hình và xác định đầu vào, trước thiết kế chi tiết/mua pin |
| Hướng dùng mô-đun sạc và inverter | Nhóm đã chọn hướng tích hợp; trình thầy xác nhận mức đáp ứng học phần | Ghi trong proposal, xác nhận trước triển khai |
| Thiết bị có sẵn, dụng cụ đo, nơi thử, kinh phí hỗ trợ | Hỏi thầy/phòng thí nghiệm; ngân sách tự chi do nhóm thống nhất | giai đoạn xây dựng mô hình và xác định đầu vào |
| Hạn nộp, lịch kiểm tra, rubric và bộ hồ sơ cuối kỳ | Xem LMS trước; hỏi thầy khi chưa có thông tin | Trước mỗi mốc liên quan |
| Cấu hình cell, công suất PV, công suất sạc/inverter, dòng thiết kế | Nhóm tính toán từ pin, tải, điều kiện thử và datasheet | Khảo sát giai đoạn xây dựng mô hình và xác định đầu vào; chốt giai đoạn thiết kế tích hợp trước mua và tích hợp |
| MCU, cảm biến, IC giám sát/bảo vệ, linh kiện cân bằng | Nhóm chọn theo chức năng, sai số, giá, khả năng mua và mô phỏng | Kiểm tra MCU mô phỏng đầu giai đoạn xây dựng mô hình và xác định đầu vào; chốt phần cứng liên quan trong giai đoạn thiết kế tích hợp |
| Mạch bảo vệ tự chủ và phân công giữa phần cứng/firmware | Nhóm thiết kế; đối chiếu datasheet và phạm vi BMS đã thống nhất | giai đoạn mô phỏng chức năng và thiết kế tích hợp, trước thử pin thật |
| Ngưỡng áp/dòng/nhiệt, trễ, khôi phục, dòng cân bằng | Nhóm xác định từ datasheet cell/linh kiện và điều kiện tải | giai đoạn xác định đầu vào và thiết kế tích hợp; không tự đặt ngưỡng an toàn khi chưa biết pin |
| Dải đo, sai số cho phép, cách hiệu chuẩn | Nhóm lập ngân sách sai số và chọn thiết bị tham chiếu | giai đoạn xác định đầu vào và thiết kế tích hợp; kiểm tra bằng đo ở giai đoạn triển khai phần cứng và IoT |
| SoC ban đầu, dung lượng tham chiếu, điều kiện hiệu chỉnh OCV | Nhóm chọn phương pháp phù hợp hóa học pin và dữ liệu có được | giai đoạn mô phỏng chức năng; kiểm chứng trong giai đoạn triển khai phần cứng và thực nghiệm |
| Đường nguồn phụ, bộ sạc tương thích và dải bus DC | Nhóm chọn kiến trúc sau khi rõ yêu cầu chuyển nguồn | Khảo sát giai đoạn xây dựng mô hình và xác định đầu vào; chốt giai đoạn thiết kế tích hợp |
| Nền tảng IoT, giao thức, chu kỳ cập nhật, cơ chế phản hồi lệnh | Nhóm quyết; ưu tiên công cụ có sẵn và một giao diện dùng được trên PC/mobile | Thử dữ liệu giả giai đoạn mô phỏng chức năng, chốt giai đoạn thiết kế tích hợp |
| Tiêu chí thử PV/BMS/IoT và hiệu suất | Nhóm đề xuất cách đo, giới hạn và dữ liệu tham chiếu; đối chiếu rubric/thầy | Chốt trước chạy bộ thử chính thức; không đổi để hợp kết quả |
| “Chi phí tối ưu” | Nhóm so sánh các phương án cùng yêu cầu; hỏi thầy nếu có mức trần/rubric riêng | Dự toán giai đoạn xác định đầu vào và thiết kế tích hợp, cập nhật BOM thực tế giai đoạn tích hợp và thực nghiệm |
| Tiến độ, phân công và quản lý mã nguồn/tài liệu | Nhóm tự lập theo lịch học phần | Khung 14 tuần là giả định lập kế hoạch, cập nhật sau khi biết thời gian thực tế |
| Mô phỏng/chế tạo PV reconfiguration | Giữ phần lý thuyết theo qa1; nhóm chỉ đề xuất mở rộng khi còn thời gian | Sau khi hoàn thành các đầu ra chính; không cần hỏi lại để làm phần lý thuyết |

## 4. Trong lúc chờ trả lời

- Hoàn thiện phương pháp BMS, mô hình PV tham khảo, tiêu chí thử và phân công.
- Kiểm tra Proteus với một kênh đo và MCU có mô hình chạy được; giữ cấu hình pin và ngưỡng trong bảng tham số để cập nhật.
- Khảo sát datasheet, thời gian cung ứng và khả năng mượn thiết bị; dựng giao diện bằng dữ liệu giả.
- Chọn pin, thiết bị công suất và lập phương án thử pin thật sau khi đã có các đầu vào liên quan. Nếu chọn pack kín không tiếp cận từng cell, làm rõ cách đáp ứng yêu cầu cân bằng trước khi mua.

## 5. Ghi nhận trả lời

Chưa có trả lời. Sau trao đổi, ghi ngày, câu hỏi và câu trả lời nguyên văn; phần nhóm diễn giải để cập nhật kế hoạch đặt riêng bên dưới. Không chuyển các phương án trong bản nháp này thành thông tin “thầy đã chốt”.
