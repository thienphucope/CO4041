# Báo cáo tiến độ: Thiết kế và phát triển hệ thống microgrid sử dụng năng lượng mặt trời với chi phí tối ưu kết hợp nền tảng IoT

**Mã đề tài:** HK261-DAGD1-133

**Học phần:** CO4041, Đồ án chuyên ngành/Đồ án môn học Kỹ thuật Máy tính, HK261

**Giảng viên hướng dẫn:** ThS. Phạm Công Thái, TS. Lê Trọng Nhân

**Sinh viên thực hiện:** Lê Thanh Phú (2212581), Phan Trần Nguyên Phúc (2212643), Hoàng Ngô Thiên Phúc (2212612)

**Mốc báo cáo:** Proposal, báo cáo tiến độ hai tuần đầu

**Ngày cập nhật:** 10/09/2026

## Tóm tắt

Đề tài hướng đến xây dựng mô hình microgrid quy mô nhỏ gồm nguồn quang điện, bộ điều khiển sạc, pin lưu trữ, bộ quản lý pin, inverter, tải và giao diện IoT. Báo cáo này tổng hợp cơ sở lý thuyết từ tài liệu tham khảo, đề xuất phương pháp thiết kế BMS 12 V và mô phỏng BMS cùng tấm pin trên Proteus, đồng thời trình bày thuật toán cấu hình lại dàn pin khi bức xạ không đồng đều. Nhóm xây dựng kế hoạch cho toàn bộ học phần, từ khảo sát, mô phỏng đến chế tạo, tích hợp IoT và đánh giá chi phí.

Tại thời điểm báo cáo, nhóm mới tổng hợp tài liệu và xây dựng phương án thực hiện. Các sơ đồ khối và phương pháp dưới đây là đề xuất; nhóm chưa dựng schematic, chưa chạy mô phỏng Proteus và chưa chế tạo phần cứng. Báo cáo chưa có kết quả đo hoặc đồ thị mô phỏng do nhóm thực hiện.

## Mục lục

1. Giới thiệu và mục tiêu
2. Phạm vi và trạng thái thực hiện
3. Khảo sát tài liệu và hướng tiếp cận
4. Cơ sở lý thuyết
5. Phương pháp thiết kế BMS 12 V trên Proteus
6. Kế hoạch mô phỏng trên Proteus
7. Tìm hiểu thuật toán PV array configuration
8. Kiến trúc và phương án triển khai toàn hệ thống
9. Kế hoạch thực hiện và phân chia nhiệm vụ
10. Các thông số cần xác định và rủi ro thực hiện
11. Sản phẩm dự kiến và phương pháp đánh giá
12. Tài liệu tham khảo

## 1. Giới thiệu và mục tiêu

### 1.1. Bài toán

Theo mô tả đề tài, nhóm cần xây dựng một hệ thống năng lượng mặt trời có lưu trữ, hỗ trợ giám sát và điều khiển qua mobile hoặc PC, với chi phí phù hợp cho mô hình năng lượng độc lập [8]. Khi triển khai, nhóm phải xử lý đồng thời ba vấn đề: công suất PV phụ thuộc điều kiện môi trường; pin lưu trữ cần được giám sát và bảo vệ; các khối nguồn, tải và giao diện điều khiển cần phối hợp theo trạng thái hệ thống.

Bức xạ và nhiệt độ làm thay đổi đặc tuyến của tấm pin [1]. Khi một phần dàn pin bị che, sự không đồng đều giữa các module còn gây tổn hao do không tương hợp và có thể tạo nhiều cực đại trên đường công suất [3]. Vì vậy, nhóm cần hiểu mô hình PV và các phương pháp cấu hình dàn pin trước khi lựa chọn phương án phần cứng.

Đối với pin lưu trữ, điện áp toàn bộ bộ pin chưa đủ để xác định trạng thái từng cell. BMS cần theo dõi điện áp cell, dòng điện, nhiệt độ và trạng thái sạc, kết hợp cân bằng cell với bảo vệ sạc/xả. Kiến trúc BMS tích hợp IoT trong [2] là tài liệu tham khảo cho luồng đo lường, xử lý và hiển thị thông tin của đề tài.

### 1.2. Mục tiêu tại mốc proposal

Theo trao đổi với giảng viên [9], báo cáo tập trung vào:

1. Đề xuất phương pháp thiết kế BMS 12 V với bốn chức năng: ước lượng SoC, giám sát nhiệt độ, cân bằng cell và mạch bảo vệ.
2. Xác định cách mô phỏng chức năng BMS trên Proteus trước khi thực hiện phần cứng.
3. Xác định mô hình và quy trình mô phỏng tấm pin PV trên Proteus.
4. Tổng hợp lý thuyết về thuật toán PV array configuration từ tài liệu tham khảo.
5. Lập kế hoạch và phân chia nhiệm vụ cho ba thành viên.

### 1.3. Mục tiêu của toàn bộ đồ án CO4041

Nhóm dự kiến phát triển mô hình có đường cấp năng lượng từ PV đến tải và pin lưu trữ; tích hợp bộ điều khiển sạc, BMS, inverter và chức năng chuyển nguồn; thu thập dữ liệu điện áp, dòng điện, công suất, nhiệt độ và SoC; xây dựng giao diện giám sát, điều khiển và lưu lịch sử. Sau khi tích hợp, nhóm sẽ thử nghiệm với các mức tải và điều kiện nguồn khác nhau, đánh giá khả năng vận hành và lập bảng chi phí [8].

Trong báo cáo, “chi phí tối ưu” được cụ thể hóa thành việc lựa chọn phương án có chi phí phù hợp trong số các phương án đáp ứng yêu cầu chức năng đã xác định. Nhóm sẽ so sánh trên cùng quy mô công suất và dung lượng, chưa đặt mục tiêu chứng minh một nghiệm tối ưu toàn cục.

## 2. Phạm vi và trạng thái thực hiện

### 2.1. Phân biệt mốc proposal và phần triển khai sau

Giai đoạn 1 là toàn bộ học phần CO4041. Mốc proposal chỉ là lần báo cáo tiến độ đầu tiên của học phần. Các công việc chế tạo, inverter, bộ điều khiển sạc và IoT thực hiện sau proposal vẫn thuộc CO4041. Đồ án tốt nghiệp ở giai đoạn 2 nằm ngoài kế hoạch của báo cáo này.

| Nội dung | Tại mốc proposal | Sau mốc proposal, trong CO4041 |
|---|---|---|
| Cơ sở lý thuyết | Tổng hợp PV, BMS, cấu hình dàn pin và kiến trúc IoT | Bổ sung datasheet, hiệu chỉnh mô hình và thiết kế |
| BMS 12 V | Trình bày khối chức năng, nguyên lý và phương pháp kiểm thử | Dựng schematic, lập trình và mô phỏng trên Proteus; sau đó triển khai phần cứng |
| Tấm pin PV | Trình bày mô hình single-diode và kế hoạch khảo sát | Dựng mô hình Proteus, lấy I–V/P–V và đối chiếu tài liệu |
| PV array configuration | Tìm hiểu TCT, DES và thuật toán cân bằng bức xạ theo [3] | Cân nhắc mở rộng khi đã hoàn thành các chức năng chính |
| Điều khiển sạc, inverter, chuyển nguồn, tải | Nêu kiến trúc và công việc cần làm | Chọn thông số, khảo sát chức năng bằng Proteus, tích hợp phần cứng |
| IoT và giao diện | Nêu dữ liệu, chức năng giám sát/điều khiển và luồng thông tin | Triển khai trên thiết bị, kết nối mạng và thử nghiệm giao diện |
| Đánh giá chi phí | Xác định cách lập BOM và tiêu chí so sánh | Thu thập giá, chi phí thực tế và số liệu vận hành |

Toàn bộ phần thiết kế mạch phục vụ mô phỏng trong kế hoạch sử dụng Proteus. Việc biên dịch chương trình cho MCU là bước chuẩn bị đầu vào cho mô phỏng, chưa thực hiện ở mốc này. Mô phỏng Wi-Fi, cloud và ứng dụng hoàn chỉnh không phải điều kiện để kiểm thử BMS: trước mắt nhóm sẽ kiểm tra giao tiếp bằng dữ liệu nối tiếp trong Proteus, rồi kiểm tra kết nối IoT trên thiết bị ở mốc tích hợp.

### 2.2. Trạng thái và hình thức nộp

Nhóm đã có nội dung khảo sát tài liệu và phương án tổng quan trong báo cáo. Phần thiết kế chi tiết, schematic Proteus, firmware, kết quả mô phỏng, BOM có giá và phần cứng đều chưa thực hiện.

Sản phẩm của mốc hai tuần là báo cáo tiến độ nộp trên LMS; không yêu cầu slide hoặc thuyết trình [9]. Nhóm sẽ kiểm tra ngày nộp và tiêu chí chấm trên LMS trước khi chốt bản nộp. Những thông số chưa xác định được giữ ở dạng tham số hoặc đề xuất, không xem là yêu cầu đã được giảng viên phê duyệt.

## 3. Khảo sát tài liệu và hướng tiếp cận

### 3.1. Ba tài liệu do giảng viên cung cấp

| Tài liệu | Nội dung đã tìm hiểu | Cách sử dụng trong đề tài |
|---|---|---|
| Yaqoob và cộng sự [1] | Mô hình một diode cho PV; các khối phương trình trong Proteus; khảo sát bức xạ và nhiệt độ; đối chiếu SM55 và KC200GT | Làm cơ sở xây dựng mô hình PV trên Proteus, chọn bộ tham số tham khảo và cách kiểm tra I–V/P–V |
| Kulkarni và cộng sự [2] | BMS kết hợp nguồn lai, đo điện áp và nhiệt độ; mô phỏng trước phần cứng; truyền dữ liệu qua bộ điều khiển, ESP32 và ThingSpeak | Tham khảo kiến trúc đo lường, bảo vệ và giám sát IoT |
| Ngô Ngọc Thành và Nguyễn Phùng Quang [3] | Cấu hình TCT, ma trận chuyển mạch DES, chỉ số cân bằng bức xạ và thuật toán lai DP–SC | Trình bày cơ sở lý thuyết của PV array configuration và giới hạn áp dụng |

Nghiên cứu [1] giải quyết mô hình tấm pin trong các điều kiện môi trường; nhóm không dùng kết quả của bài để khẳng định đã mô phỏng dàn pin bị che. Nghiên cứu [2] cung cấp kiến trúc tham khảo, nhưng nhóm cần bổ sung phương pháp SoC và thiết kế cân bằng phù hợp với bộ pin dự kiến. Nghiên cứu [3] sử dụng MATLAB–Simulink; trong đề tài hiện tại, nhóm sử dụng bài này cho phần tìm hiểu lý thuyết, chưa lập nhiệm vụ xây dựng mô phỏng reconfiguration.

### 3.2. Tài liệu bổ sung

Để đáp ứng yêu cầu tự tìm thêm tài liệu [9], nhóm bổ sung nguồn PVPMC của Sandia/NIST về mô hình một diode [4], tài liệu TI về phương pháp ước lượng dung lượng [5], cân bằng cell [6] và datasheet LM35 [7]. Các nguồn này phục vụ kiểm tra công thức và lựa chọn phương pháp; việc trích dẫn tài liệu về một IC không đồng nghĩa nhóm đã chọn IC đó cho phần cứng.

### 3.3. Hướng tiếp cận của nhóm

Nhóm đề xuất phát triển hệ thống theo từng khối và kiểm thử trước khi tích hợp. Với BMS, hướng khảo sát là đo dòng để tính SoC, giám sát nhiệt độ, cân bằng thụ động và điều khiển ngắt sạc/xả. Với PV, nhóm dự kiến tái dựng mô hình tham khảo trên Proteus trước khi thay bằng thông số tấm pin thực tế.

Đối với IoT, nhóm dự kiến xây dựng cả luồng giám sát và lệnh điều khiển tải, có kiểm tra điều kiện tại bộ điều khiển. Việc đánh giá cuối cùng sẽ dựa trên dữ liệu đo, hồ sơ kiểm thử và chi phí thực hiện. Những nội dung này là phương án triển khai của nhóm, chưa phải kết quả hoặc đóng góp mới đã được kiểm chứng.

## 4. Cơ sở lý thuyết

### 4.1. Thành phần của mô hình microgrid

Theo phạm vi đề tài [8], mô hình gồm nguồn PV, bộ điều khiển sạc, pin lưu trữ, BMS, inverter và tải. PV cung cấp điện một chiều; bộ điều khiển sạc điều chỉnh quá trình nạp theo bộ pin; BMS theo dõi trạng thái pin và cho phép hoặc ngắt các đường sạc/xả. Inverter chuyển điện DC thành AC cho tải phù hợp. Lớp IoT thu thập dữ liệu, hiển thị và tiếp nhận lệnh của người dùng.

Bộ điều khiển sạc và BMS có vai trò riêng: nhóm cần thiết kế hoặc chọn bộ sạc có đặc tuyến phù hợp, đồng thời dùng BMS để giám sát và bảo vệ bộ pin. Chức năng ngắt quá áp của BMS không thay thế việc điều khiển điện áp và dòng sạc.

### 4.2. Đặc tính tấm pin quang điện

Đường I–V biểu diễn quan hệ dòng điện và điện áp đầu ra; đường P–V được xác định từ:

$$
P(V)=V I(V).
$$

Các điểm đặc trưng gồm dòng ngắn mạch \(I_{\mathrm{SC}}\), điện áp hở mạch \(V_{\mathrm{OC}}\), điện áp và dòng tại điểm công suất cực đại \(V_{\mathrm{MPP}}, I_{\mathrm{MPP}}\). Công suất cực đại là:

$$
P_{\mathrm{MPP}}=V_{\mathrm{MPP}}I_{\mathrm{MPP}}.
$$

Nghiên cứu [1] sử dụng điều kiện tham chiếu \(G_{\mathrm{ref}}=1000\ \mathrm{W/m^2}\) và nhiệt độ cell \(T_{\mathrm{ref}}=25^\circ\mathrm{C}\). Khi giữ nhiệt độ cố định, dòng quang sinh tăng gần tỷ lệ với bức xạ. Với các tấm silicon khảo sát trong bài, tăng nhiệt độ làm điện áp hở mạch giảm và công suất cực đại giảm. Nhiệt độ cell trong mô hình không được đồng nhất với nhiệt độ không khí xung quanh.

MPPT (Maximum Power Point Tracking) là quá trình điều chỉnh điểm làm việc để tìm công suất lớn. Khi có nhiều đỉnh trên đường P–V do che bóng, một phương pháp tìm kiếm cục bộ có thể dừng ở đỉnh chưa phải lớn nhất; vấn đề này liên quan đến việc tìm hiểu cấu hình dàn pin [3].

### 4.3. Mô hình một diode

Theo [1] và [4], mô hình gồm nguồn dòng quang sinh, diode, điện trở song song và điện trở nối tiếp. Với các tham số quy đổi ở cấp module, phương trình dòng đầu ra là:

$$
I=I_{\mathrm{ph}}
-I_0\left[\exp\left(\frac{V+IR_s}{nN_sV_T}\right)-1\right]
-\frac{V+IR_s}{R_{\mathrm{sh}}},
\qquad
V_T=\frac{kT_K}{q}.
$$

Trong đó \(I_{\mathrm{ph}}\) là dòng quang sinh; \(I_0\) là dòng bão hòa diode; \(R_s\) và \(R_{\mathrm{sh}}\) là điện trở nối tiếp và song song; \(n\) là hệ số lý tưởng diode; \(N_s\) là số cell nối tiếp; \(k\) là hằng số Boltzmann; \(q\) là điện tích nguyên tố; \(T_K\) là nhiệt độ tuyệt đối.

Nhóm sẽ kiểm tra cách quy đổi tham số trước khi dựng mô hình. Nếu đã dùng \(R_s,R_{\mathrm{sh}}\) ở cấp module thì không nhân thêm số cell vào hai điện trở này. Tương tự, khi gộp \(nN_sV_T\) thành một hệ số, nhóm phải tránh đưa \(N_s\) vào hai lần [4].

Trong [1], tác giả biểu diễn các thành phần dòng bằng khối toán học và nguồn phụ thuộc trong Proteus. Nhóm dự kiến sử dụng bộ tham số công bố của SM55 để kiểm tra mô hình ban đầu, sau đó cập nhật theo tấm pin được lựa chọn. Các hệ số phụ thuộc nhiệt độ sẽ được đối chiếu với công thức, bảng tham số và chiều biến thiên trong tài liệu trước khi chạy.

### 4.4. Che bóng một phần và tổn hao do không tương hợp

Các module nối tiếp có cùng dòng nhánh, còn các module song song có cùng điện áp đầu cực. Khi bức xạ không đồng đều, đặc tuyến các module khác nhau nên điểm làm việc chung có thể khiến dàn pin mất công suất so với trường hợp từng module làm việc tại điểm tối ưu [3].

Cell bị che có thể chịu phân cực ngược và tiêu tán công suất, gây điểm nóng. Diode bypass tạo đường dòng đi vòng qua phần được bảo vệ, giúp hạn chế tác động này nhưng không khôi phục năng lượng mặt trời đã bị che. Cấu hình lại dàn pin hướng đến giảm phần tổn hao do không tương hợp thông qua thay đổi kết nối [3].

### 4.5. Pin lưu trữ và trạng thái sạc

Dung lượng điện của pin thường biểu diễn bằng Ah. Với điện áp danh định \(V_{\mathrm{nom}}\) và dung lượng \(Q_{\mathrm{Ah}}\), năng lượng danh định được ước lượng:

$$
E_{\mathrm{nom}}\approx V_{\mathrm{nom}}Q_{\mathrm{Ah}}\quad [\mathrm{Wh}].
$$

Đây là giá trị danh định; năng lượng cấp được cho tải còn phụ thuộc chế độ xả và tổn hao của hệ thống. C-rate biểu diễn dòng sạc/xả theo dung lượng, chẳng hạn \(1C\) tương ứng dòng có giá trị bằng dung lượng Ah chia cho một giờ [2].

SoC (State of Charge) biểu diễn tỷ lệ dung lượng còn lại. Tra điện áp hở mạch cần bảng đặc tính phù hợp và điều kiện nghỉ; coulomb counting tích phân dòng vào/ra, cần biết trạng thái ban đầu và dung lượng tham chiếu [5]. Nhóm đề xuất dùng coulomb counting cho mô hình chức năng, với quy ước dòng pack dương khi xả:

$$
z_{k+1}=\operatorname{clip}_{[0,1]}
\left(z_k-\frac{I_{\mathrm{bat},k}\Delta t}{3600Q_{\mathrm{Ah}}}\right),
\qquad
\mathrm{SoC}_k=100z_k.
$$

Ở công thức này, \(\Delta t\) tính bằng giây; mô hình ban đầu giả thiết hiệu suất coulomb bằng 1. Khi dòng đổi sang chiều sạc, \(I_{\mathrm{bat}}<0\) và SoC tăng. Sai số dòng và giá trị khởi tạo có thể gây sai số tích lũy. Việc hiệu chỉnh bằng OCV chỉ được bổ sung khi có bảng OCV–SoC và điều kiện nghỉ phù hợp [5]; nhóm chưa có dữ liệu để khẳng định độ chính xác trên pin thật.

### 4.6. Cân bằng cell, nhiệt độ và bảo vệ

Các cell nối tiếp có thể lệch trạng thái sạc. Cell chạm giới hạn trước sẽ hạn chế khả năng sử dụng của bộ pin. Cân bằng thụ động tạo nhánh xả qua điện trở ở cell được chọn; năng lượng dư chuyển thành nhiệt. Khi áp dụng, cần xét điều kiện cho phép cân bằng, công suất tản và ảnh hưởng đến phép đo [6].

Nhóm dự kiến giám sát nhiệt độ bằng LM35 hoặc mô hình tín hiệu tương đương. Theo datasheet [7], hệ số chuyển đổi là \(10\ \mathrm{mV}/^\circ\mathrm{C}\):

$$
T[^\circ\mathrm{C}]=\frac{V_{\mathrm{LM35}}[\mathrm{V}]}{0.01}.
$$

BMS cần phản ứng khi điện áp, dòng hoặc nhiệt độ vượt phạm vi cho phép. Các mức giới hạn phụ thuộc cell, bộ sạc và phần tử công suất được chọn. Nhóm không áp dụng trực tiếp ngưỡng của bộ pin trong [2] cho một loại pin khác.

### 4.7. Giám sát và điều khiển qua IoT

Trong [2], bộ điều khiển thu thập dữ liệu cảm biến, hiển thị tại chỗ và chuyển dữ liệu qua ESP32 đến ThingSpeak. Nhóm sử dụng kiến trúc này làm cơ sở cho luồng giám sát. Các chức năng điều khiển tải, xác nhận lệnh và lưu trạng thái sự cố là phần nhóm đề xuất thêm cho hệ thống của mình.

Dữ liệu dự kiến gồm điện áp cell và pack, dòng pin, điện áp/dòng PV, công suất, nhiệt độ, SoC, trạng thái tải, nguồn đang sử dụng và mã lỗi. Thuật toán bảo vệ sẽ chạy tại bộ điều khiển cục bộ để việc ngắt mạch không phụ thuộc vào kết nối mạng.

## 5. Phương pháp thiết kế BMS 12 V trên Proteus

### 5.1. Cấu hình dự kiến và giới hạn thiết kế

Nhóm đề xuất khảo sát bộ pin LiFePO4 4S, gồm bốn cell nối tiếp, với điện áp danh định khoảng 12,8 V để đại diện cho hệ lưu trữ lớp 12 V. Đây là phương án làm việc cho mô hình, chưa phải quyết định mua pin. Dung lượng khoảng 15 Ah trong định hướng ban đầu cũng chưa chốt và sẽ được xác định lại từ tải, thời gian sử dụng và ngân sách.

Phương án 4S cho phép khảo sát đủ chức năng cân bằng cell. Nếu cân nhắc ắc-quy SLA nguyên khối, nhóm vẫn phải giữ bài mô phỏng nhiều cell để đáp ứng yêu cầu tìm hiểu và thiết kế cân bằng; không loại bỏ chức năng này chỉ vì đổi phương án pin.

Nhóm sẽ thực hiện thiết kế schematic BMS trong Proteus, kiểm tra từng khối rồi ghép thành mô hình hoàn chỉnh. Phần này hiện mới dừng ở phương pháp và sơ đồ khối.

### 5.2. Các khối chức năng và giao tiếp

Luồng xử lý dự kiến:

> Bộ pin → đo điện áp, dòng, nhiệt độ → bộ điều khiển → ước lượng SoC, kiểm tra lỗi và cân bằng cell → điều khiển ngắt sạc/xả, hiển thị và xuất dữ liệu.

| Khối | Đầu vào | Chức năng và đầu ra dự kiến |
|---|---|---|
| Mô hình bộ pin | Điều kiện ban đầu, nguồn sạc, tải | Điện áp các cell và dòng pack phục vụ kiểm thử |
| Đo lường | Điện áp các nút, tín hiệu dòng và nhiệt độ | Giá trị điện áp cell/pack, dòng có dấu, nhiệt độ và cờ dữ liệu hợp lệ |
| Ước lượng SoC | Dòng pack, khoảng lấy mẫu, dung lượng và SoC ban đầu | SoC ước lượng theo thời gian |
| Cân bằng cell | Điện áp cell, chế độ vận hành, nhiệt độ | Lệnh cho nhánh xả cân bằng của từng cell |
| Bảo vệ | Điện áp, dòng, nhiệt độ, lỗi cảm biến | Quyền cho phép sạc/xả và mã nguyên nhân ngắt |
| Hiển thị/giao tiếp | Dữ liệu đo, SoC, trạng thái | LCD hoặc terminal trong Proteus; dữ liệu cho khối IoT khi tích hợp |

MCU dùng trong mô phỏng sẽ được chọn sau khi kiểm tra thư viện và khả năng nạp chương trình của phiên bản Proteus đang sử dụng. Nhóm chưa giả định mô hình ESP32 hoặc IC BMS chuyên dụng có sẵn và chạy được trên máy.

### 5.3. Phương pháp đo lường

Với bốn cell nối tiếp, gọi \(U_i\) là điện áp nút thứ \(i\) so với cực âm chung, \(U_0=0\). Điện áp cell thứ \(i\) là:

$$
V_{\mathrm{cell},i}=U_i-U_{i-1}.
$$

Nếu đọc các nút qua cầu phân áp, nhóm sẽ chọn tỷ lệ riêng cho từng kênh theo điện áp nút lớn nhất, sau đó quy đổi về \(U_i\) trước khi lấy hiệu. Nhóm sẽ kiểm tra dải ADC, sai số phân áp và độ phân giải trước khi chọn ngưỡng cân bằng.

Khối dòng phải phân biệt được chiều sạc và xả. Nhóm dự kiến dùng mô hình cảm biến dòng hai chiều hoặc shunt kết hợp mạch điều hòa có điểm giữa phù hợp với ADC. Khối nhiệt độ sử dụng LM35 nếu có mô hình khả dụng, hoặc nguồn áp tương đương đặc tuyến cảm biến để kiểm thử chức năng.

### 5.4. Phương pháp ước lượng SoC

Nhóm sẽ kiểm thử thuật toán ở mục 4.5 bằng dòng đầu vào có giá trị và thời gian xác định. SoC ban đầu được đặt trong cấu hình ca thử, không mặc định luôn bằng 100%. Trước tiên, nhóm kiểm tra chiều biến thiên, đơn vị thời gian và sai số so với điện tích tính trực tiếp.

Ở bước này, SoC là kết quả của mô hình tính toán. Một tụ điện dùng để minh họa sạc/xả không cung cấp đường OCV–SoC của pin thật. Nhóm chỉ triển khai hiệu chỉnh OCV sau khi xác định loại cell, bảng tra và điều kiện nghỉ; kết quả ước lượng của pack cũng không thay thế bảo vệ theo từng cell.

### 5.5. Phương pháp cân bằng cell

Nhóm dự kiến khảo sát cân bằng thụ động: mỗi cell có nhánh điện trở nối tiếp phần tử đóng cắt, mắc song song với cell đó. Bộ điều khiển sẽ bật nhánh phù hợp khi điện áp cell vượt mức cho phép cân bằng và chênh lệch với cell thấp nhất vượt ngưỡng đặt. Nhóm sẽ thêm điều kiện nhiệt độ, trạng thái lỗi và ngưỡng nhả để tránh đóng/cắt liên tục.

Với mô hình lý tưởng, nhóm dùng \(I_{\mathrm{bal}}\approx V_{\mathrm{cell}}/R_{\mathrm{bal}}\) và \(P_{\mathrm{bal}}\approx V_{\mathrm{cell}}^2/R_{\mathrm{bal}}\) để ước lượng dòng xả và công suất điện trở. Giá trị cụ thể sẽ được tính sau khi chọn dòng cân bằng. Trong Proteus, bước đầu có thể dùng công tắc điều khiển lý tưởng; khi thay bằng MOSFET, nhóm phải thiết kế mạch kích theo điện thế của từng cell.

### 5.6. Phương pháp bảo vệ và điều phối trạng thái

| Chức năng | Đại lượng kiểm tra | Phản ứng dự kiến |
|---|---|---|
| Quá áp cell, OV | Điện áp cell lớn nhất | Ngắt quyền sạc; chỉ cho phép hoạt động khác nếu các điều kiện tương ứng vẫn hợp lệ |
| Thấp áp cell, UV | Điện áp cell nhỏ nhất | Ngắt quyền xả |
| Quá dòng sạc/xả, OC | Dòng pack có dấu và giới hạn theo từng chiều | Ngắt đường liên quan; ghi nhận nguyên nhân |
| Ngắn mạch, SC | Điều kiện dòng sự cố trong mô hình | Ngắt đầu ra; khóa khôi phục cho đến khi lỗi được xử lý |
| Nhiệt độ ngoài giới hạn | Nhiệt độ và chế độ sạc/xả | Ngắt các đường không được phép; dừng cân bằng |
| Lỗi đo lường | Tín hiệu ngoài dải hoặc không hợp lệ | Chuyển sang trạng thái khóa sạc/xả |

Nhóm đề xuất các trạng thái khởi tạo, chờ, sạc, xả và lỗi. Sau khởi tạo, hệ thống chỉ cấp quyền sạc/xả khi dữ liệu đầu vào hợp lệ. Quyết định bảo vệ có ưu tiên cao hơn lệnh vận hành, cân bằng và lệnh IoT.

Trong mô hình chức năng ban đầu, nhóm sẽ tách ca sạc và ca xả để kiểm tra logic. Khi tích hợp microgrid, tải có thể nhận năng lượng trực tiếp từ PV trong lúc pin nhận phần công suất dư; vì vậy, không áp dụng quy tắc “đang sạc thì cấm toàn bộ tải” như một yêu cầu chung của hệ thống.

Các tham số cần xác định gồm ngưỡng tác động, ngưỡng khôi phục, thời gian xác nhận lỗi và chế độ tự phục hồi hoặc khóa lỗi. Nhóm sẽ chọn chúng từ datasheet và yêu cầu vận hành, rồi ghi thành bảng cấu hình dùng chung giữa mô hình và hồ sơ kiểm thử. Bảo vệ ngắn mạch của phần cứng cần được đánh giá riêng; mô phỏng logic MCU chưa chứng minh tốc độ cắt và khả năng chịu dòng của mạch thật.

## 6. Kế hoạch mô phỏng trên Proteus

### 6.1. Trình tự và phạm vi

Nhóm dự kiến tạo hai dự án Proteus riêng cho PV và BMS. Sau khi mỗi mô hình đáp ứng các ca kiểm tra, nhóm sẽ khảo sát ghép nối qua khối điều khiển sạc và đường tải. Việc mô phỏng đi trước chế tạo phần cứng như yêu cầu trong [9].

Đối với BMS, nhóm sẽ bắt đầu bằng một kênh đo và bảo vệ, sau đó mở rộng lên nhiều cell để kiểm tra cân bằng. Bài thử một cell chỉ là bước kiểm tra ban đầu, chưa đủ đại diện cho BMS 12 V hoàn chỉnh.

### 6.2. Mô phỏng tấm pin

Nhóm dự kiến thực hiện các bước sau theo phương pháp trong [1]:

1. Lập bảng tham số của một tấm pin tham khảo. Ban đầu sử dụng SM55 trong [1], gồm thông số danh định và các tham số mô hình đã được tác giả công bố.
2. Dựng các thành phần \(I_{\mathrm{ph}}, I_D, I_{\mathrm{sh}}\) bằng khối toán và nguồn phụ thuộc trong Proteus; tạo đầu vào điều chỉnh bức xạ và nhiệt độ.
3. Quét điểm làm việc từ gần ngắn mạch đến gần hở mạch để thu các cặp \(V,I\), sau đó tính \(P=VI\).
4. Kiểm tra \(I_{\mathrm{SC}},V_{\mathrm{OC}},V_{\mathrm{MPP}},I_{\mathrm{MPP}},P_{\mathrm{MPP}}\) tại điều kiện tham chiếu.
5. Thay đổi riêng bức xạ và nhiệt độ để kiểm tra xu hướng và so sánh các đường cong trong tài liệu.

| Mã ca thử | Điều kiện dự kiến | Dữ liệu cần thu | Cách đánh giá |
|---|---|---|---|
| PV-01 | \(G=1000\ \mathrm{W/m^2}\), \(T=25^\circ\mathrm{C}\) | I–V, P–V và các điểm đặc trưng | Đối chiếu bộ thông số SM55 trong [1] |
| PV-02 | \(G=400,700,1000\ \mathrm{W/m^2}\), giữ \(T=25^\circ\mathrm{C}\) | Họ đường I–V/P–V | Kiểm tra tác động của bức xạ ở cùng nhiệt độ |
| PV-03 | \(T=25,45,60^\circ\mathrm{C}\), giữ \(G=1000\ \mathrm{W/m^2}\) | Họ đường I–V/P–V | Kiểm tra tác động của nhiệt độ ở cùng bức xạ |

Đây là các điểm khảo sát do nhóm đề xuất, chưa phải điều kiện thử đã thực hiện. Nhóm sẽ ghi sai lệch của từng thông số so với tham chiếu; chỉ so sánh định lượng khi cùng điều kiện và cùng bộ tham số. Bộ tham số SM55 phục vụ kiểm tra mô hình, không phải quyết định mua tấm pin SM55.

### 6.3. Mô phỏng BMS

Nhóm sẽ kiểm tra phần đo trước khi dùng dữ liệu đó cho bảo vệ hoặc SoC. Sau đó, nhóm thử từng chức năng độc lập và thử lỗi kết hợp.

| Mã ca thử | Nội dung | Kết quả cần quan sát khi triển khai |
|---|---|---|
| BMS-01 | Đặt các điện áp cell, dòng hai chiều và nhiệt độ đã biết | Giá trị đọc đúng kênh, đúng dấu, đúng đơn vị; ghi sai số |
| BMS-02 | Cho dòng sạc/xả đã biết trong thời gian xác định | SoC tăng/giảm phù hợp điện tích; không vượt phạm vi 0–100% |
| BMS-03 | Tăng một cell vượt ngưỡng OV | Đường sạc ngắt; mã lỗi xác định đúng cell/điều kiện |
| BMS-04 | Giảm một cell dưới ngưỡng UV | Đường xả ngắt |
| BMS-05 | Vượt giới hạn dòng ở từng chiều | Đường tương ứng ngắt; có thời điểm tác động |
| BMS-06 | Tạo sự cố ngắn mạch trong mô hình đã giới hạn dòng | Đầu ra bị khóa; không tự bật lại khi lỗi còn tồn tại |
| BMS-07 | Đưa nhiệt độ qua ngưỡng tác động và khôi phục | Cảnh báo/ngắt và phục hồi theo đúng cấu hình |
| BMS-08 | Đặt các cell lệch điện áp | Nhánh cân bằng chọn đúng cell; theo dõi dòng xả và độ lệch theo thời gian |
| BMS-09 | Dao động quanh ngưỡng, lỗi cảm biến hoặc khởi động lại | Tránh rung đóng/cắt; đầu ra khởi động ở trạng thái khóa |
| BMS-10 | Có nhiều lỗi đồng thời hoặc lệnh bật tải khi đang lỗi | Giữ ưu tiên bảo vệ; chỉ phục hồi khi các điều kiện cho phép đều thỏa |

Trong mô hình kích thích bằng nguồn áp lý tưởng, nhóm có thể kiểm tra việc chọn nhánh cân bằng nhưng điện áp nguồn không tự giảm. Để đánh giá diễn biến chênh lệch cell, nhóm cần mô hình lưu trữ có động học, chẳng hạn mô hình tụ dùng cho minh họa hoặc mạch tương đương pin được xác định tham số. Kết quả từ mô hình tụ chỉ thể hiện hành vi mạch, không dùng để công bố thời gian cân bằng hoặc thời gian sử dụng pin thật.

### 6.4. Hồ sơ và giới hạn kết luận

Mỗi lần chạy dự kiến lưu phiên bản mô hình, tham số đầu vào, chương trình MCU nếu có, đồ thị/dữ liệu và kết luận cho từng ca thử. Ảnh chụp chỉ được đưa vào báo cáo kết quả sau khi nhóm chạy mô hình, kèm điều kiện và mã ca thử.

Mô phỏng điện áp/tín hiệu nhiệt cho phép kiểm tra phản ứng của BMS, chưa mô tả đầy đủ điện hóa, lão hóa, sinh nhiệt hay khả năng chịu sự cố của linh kiện. Nhóm sẽ kiểm tra lại các yếu tố liên quan trên phần cứng ở mốc thực nghiệm. Quy trình thao tác dự kiến được tách trong tài liệu hỗ trợ [Hướng dẫn mô phỏng](simulation-guide.md).

## 7. Tìm hiểu thuật toán PV array configuration

### 7.1. Cấu hình tĩnh và cấu hình lại dàn pin

PV array configuration mô tả cách nối các module thành dàn pin. Các cấu hình được trình bày trong [3] gồm nối tiếp, song song, nối tiếp–song song, Total-Cross-Tied (TCT), Bridge-Link và Honey-Comb. Reconfiguration là việc thay đổi kết nối trong quá trình vận hành để thích ứng với phân bố bức xạ.

Trong cấu hình TCT được xét ở [3], các module trong một hàng mắc song song và các hàng liên kết nối tiếp. Khi tổng khả năng cấp dòng của các hàng không đồng đều, điểm làm việc của dàn bị ảnh hưởng. Ý tưởng của reconfiguration là phân bố lại các module giữa các hàng để giảm sự chênh lệch này.

Diode bypass và reconfiguration có vai trò khác nhau. Bypass tạo đường dòng đi vòng qua phần được bảo vệ; reconfiguration thay đổi cách ghép các module. Việc chia nhóm module và bố trí bypass có thể được cân nhắc khi làm phần cứng, nhưng không thay thế nội dung tìm hiểu thuật toán trong báo cáo.

### 7.2. Cân bằng bức xạ và chỉ số EI

Theo [3], hệ thống sử dụng thông tin điện áp, dòng điện cùng mô hình module để ước lượng bức xạ. Ký hiệu \(G_{ij}\) là bức xạ của module thứ \(j\) trong hàng \(i\), \(n_i\) là số module ở hàng đó và \(m\) là số hàng. Tổng bức xạ quy ước của hàng là:

$$
G_i=\sum_{j=1}^{n_i}G_{ij}.
$$

Với số hàng cố định, mức phân bố đều tương ứng:

$$
\overline{G}=\frac{1}{m}\sum_{i=1}^{m}G_i.
$$

Chỉ số cân bằng được định nghĩa:

$$
EI=\max_i(G_i)-\min_i(G_i).
$$

Các tổng \(G_i\) phục vụ so sánh khả năng cấp dòng giữa các hàng theo giả thiết mô hình, không phải phép đo năng lượng của hàng. Khi EI giảm, mức chênh lệch giữa các hàng giảm. Nghiên cứu [3] sử dụng mục tiêu này để tìm cấu hình phù hợp, đồng thời ràng buộc số hàng theo dải điện áp đầu vào inverter.

### 7.3. Thuật toán lai DP–SC

Tài liệu [3] mô tả cách kết hợp Dynamic Programming (DP, quy hoạch động) và Smart Choice (SC). DP được dùng cho bài toán chọn tập con module sao cho tổng bức xạ của các hàng gần cân bằng, liên quan đến bài toán Subset Sum. SC bổ sung cách lựa chọn cho những trường hợp mà phương pháp DP trong nghiên cứu chưa cho phân bố tốt.

Có thể diễn giải luồng xử lý tổng quát của phương pháp trong [3] như sau:

1. Thu nhận hoặc ước lượng bức xạ của từng module và ghi nhận cấu hình hiện tại.
2. Xác định số hàng cùng các điều kiện kết nối cho phép.
3. Dùng phương pháp lai DP–SC để phân nhóm module theo mục tiêu cân bằng bức xạ.
4. Tính EI và lựa chọn cấu hình theo tiêu chí của thuật toán.
5. Chuyển kết quả phân nhóm thành lệnh cho ma trận DES.
6. Khảo sát đặc tuyến và công suất sau khi đổi cấu hình.

Đây là phần diễn giải lý thuyết từ tài liệu, chưa phải thuật toán do nhóm lập trình hoặc chạy thử.

### 7.4. Ma trận chuyển mạch DES

Dynamic Electrical Scheme (DES) là phần mạch thực hiện thay đổi kết nối. Đầu ra thuật toán xác định module thuộc hàng nào; bộ điều khiển dùng thông tin này để điều khiển các công tắc tương ứng. Trong mô hình chín module của [3], ma trận cho phép phân bố module vào tối đa ba hàng.

Khi xét khả năng làm phần cứng, nhóm cần đánh giá số lượng công tắc, tổn hao dẫn, trình tự chuyển mạch và chi phí điều khiển. EI là chỉ tiêu trong mô hình khảo sát, chưa đủ để khẳng định mọi cấu hình EI thấp hơn đều có lợi hơn khi tính cả tổn hao và thời gian chuyển mạch.

### 7.5. Phạm vi áp dụng vào đồ án

Nhóm sử dụng [3] để giải thích cơ chế giảm tổn hao do không tương hợp, các thành phần của hệ reconfiguration và mối liên hệ với điều kiện bức xạ. Các kết quả mô phỏng công bố trong bài thuộc nghiên cứu của tác giả, không phải kết quả của nhóm; báo cáo này không đặt tỷ lệ tăng công suất cụ thể cho mô hình chưa triển khai.

Nhiệm vụ hiện tại hoàn thành ở mức tìm hiểu lý thuyết. Nhóm chưa đưa mô phỏng hoặc chế tạo DES vào các đầu ra bắt buộc của project. Nếu mở rộng sau khi hoàn thành PV, BMS và hệ thống chính, nhóm sẽ lập kế hoạch riêng về quy mô và cách đánh giá. MATLAB–Simulink chỉ được nhắc đến như môi trường của nghiên cứu [3]; các mô phỏng đã lập kế hoạch trong báo cáo đều dùng Proteus.

## 8. Kiến trúc và phương án triển khai toàn hệ thống

### 8.1. Kiến trúc năng lượng và dữ liệu

Nhóm đề xuất các đường năng lượng sau:

> PV → bộ điều khiển sạc → bus DC được quản lý → tải DC hoặc inverter → tải AC.
>
> Pin lưu trữ ↔ đường sạc/xả do BMS quản lý ↔ bus DC.
>
> Nguồn DC phụ trợ → khối chọn nguồn và chống cấp ngược → nhánh cấp nguồn phù hợp.

Nguồn phụ trợ dự kiến là nguồn DC đã cách ly hoặc nguồn phòng thí nghiệm phù hợp. Cách ghép nguồn phụ vào bus hay đầu vào bộ sạc sẽ được xác định khi chọn bộ điều khiển nguồn. Mô hình dự kiến vận hành độc lập; chức năng chuyển nguồn không đồng nghĩa với hòa lưới.

Luồng dữ liệu và điều khiển:

> Cảm biến → bộ điều khiển cục bộ/BMS → khối kết nối IoT → dịch vụ lưu trữ → giao diện mobile/PC.
>
> Lệnh người dùng → bộ điều khiển kiểm tra điều kiện → cơ cấu chấp hành → phản hồi trạng thái thực tế.

Đây là sơ đồ khối chức năng. Nhóm chưa xác định cách nối chân, vị trí phần tử công suất hoặc triển khai mạch thực tế.

### 8.2. Phương án cho từng thành phần

| Thành phần | Công việc dự kiến |
|---|---|
| PV | Chọn quy mô công suất theo tải; kiểm tra dải điện áp và dòng phù hợp bộ điều khiển sạc |
| Bộ điều khiển sạc | So sánh phương án PWM/MPPT theo yêu cầu công suất và chi phí; xác định đặc tuyến sạc theo loại pin |
| Pin và BMS | Chốt cấu hình cell, dung lượng, bảo vệ và cân bằng; hoàn thành mô phỏng trước thử nghiệm |
| Inverter | Chọn mô-đun hoặc phương án triển khai phù hợp bus và tải; kiểm tra công suất liên tục, khởi động và hiệu suất |
| Chuyển nguồn | Xác định điều kiện chọn nguồn, ngắt trước khi đóng nguồn khác khi cần, tránh cấp ngược và ghi nhận trạng thái |
| Tải | Chọn tải DC và tải AC đại diện, có các mức công suất để kiểm tra thay đổi tải |
| Đo lường | Đo dòng/áp tại PV, pin và tải ở mức cần thiết cho điều khiển và đánh giá |
| IoT/giao diện | Hiển thị hiện tại, đồ thị lịch sử, năng lượng, trạng thái nguồn/tải, cảnh báo và lệnh điều khiển |

Nhóm ưu tiên tích hợp các mô-đun công suất phù hợp nếu việc tự thiết kế toàn bộ bộ sạc hoặc inverter vượt quá nguồn lực. Công việc thiết kế và đánh giá BMS, đo lường, điều phối nguồn và IoT vẫn được giữ trong phạm vi đề tài. Quyết định dùng mô-đun hay tự thiết kế sẽ được ghi rõ trong báo cáo và BOM.

### 8.3. Xác định quy mô và chi phí

Trước khi chọn phần cứng, nhóm sẽ lập danh sách tải gồm công suất và thời gian sử dụng. Nhu cầu năng lượng tải được ước lượng:

$$
E_{\mathrm{load}}=\sum_j P_jt_j.
$$

Nhóm sẽ từ nhu cầu này xác định dung lượng lưu trữ, công suất PV và công suất các khối chuyển đổi, có xét tổn hao, mức dung lượng pin cho phép sử dụng và dự phòng. Các giá trị chưa có dữ liệu hiện vẫn để mở.

BOM dự kiến gồm PV, cell, bộ sạc, inverter, BMS, vi điều khiển, cảm biến, thiết bị chuyển mạch, dây nối, đầu nối, phần cơ khí và chi phí gia công. Khi so sánh phương án, nhóm sẽ ghi nguồn giá, ngày lấy giá, phần có sẵn và phần phải mua; không so trực tiếp hai phương án khác công suất hoặc thiếu chức năng.

### 8.4. Kế hoạch IoT và điều khiển

Nhóm dự kiến đánh giá ESP32 cho kết nối mạng và ThingSpeak theo kiến trúc trong [2]. Nền tảng cuối cùng sẽ được chọn sau khi kiểm tra khả năng lưu dữ liệu, hiển thị và nhận lệnh. Giao diện cần:

- Hiển thị điện áp, dòng, công suất, năng lượng, nhiệt độ, SoC và trạng thái tải/nguồn.
- Tra cứu lịch sử và thời điểm xảy ra lỗi.
- Gửi lệnh bật/tắt tải hoặc chọn chế độ trong phạm vi cho phép.
- Hiển thị kết quả thực thi và trạng thái kết nối.

Mỗi bản ghi sẽ có mốc thời gian và trạng thái chất lượng dữ liệu. Khi mất kết nối, bộ điều khiển tiếp tục bảo vệ cục bộ; giao diện phải phân biệt dữ liệu mới với dữ liệu cũ. Lệnh bật tải không được vô hiệu hóa điều kiện ngắt của BMS. Nhóm sẽ thử giao tiếp bằng terminal trên Proteus trước, sau đó kiểm tra đường truyền và ứng dụng trên thiết bị.

## 9. Kế hoạch thực hiện và phân chia nhiệm vụ

### 9.1. Tiến độ dự kiến cho toàn project

Nhóm đề xuất khung 12 tuần tính từ thời điểm bắt đầu đồ án. Đây là kế hoạch làm việc, không phải lịch học phần đã được công bố. Mốc proposal tương ứng hai tuần đầu; các ngày cụ thể và thời lượng còn lại sẽ được điều chỉnh theo LMS và phản hồi giảng viên.

| Mốc | Tuần dự kiến | Công việc | Đầu ra và điều kiện chuyển bước |
|---|---|---|---|
| M1: Proposal | 1–2 | Tổng hợp tài liệu; xác định phương pháp BMS/PV; tìm hiểu reconfiguration; lập kế hoạch | Báo cáo có đủ nội dung yêu cầu, nguồn trích dẫn và phân công; nộp LMS đúng hạn |
| M2: Mô hình và đầu vào | 3–4 | Kiểm tra Proteus; dựng PV; kiểm tra đo áp, dòng, nhiệt; xác định tải, pin và bảng tham số dự kiến | PV có dữ liệu đối chiếu; khối đo đọc đúng tín hiệu; bộ thông số đủ để lập mô hình BMS |
| M3: BMS hoàn chỉnh trong mô phỏng | 5–6 | Mở rộng nhiều cell; thêm SoC, cân bằng, bảo vệ và thử lỗi kết hợp | Dự án Proteus, chương trình, cấu hình và kết quả PV-01–03, BMS-01–10; xử lý lỗi ảnh hưởng chức năng |
| M4: Thiết kế tích hợp | 7 | Chọn bộ sạc, inverter, tải và chuyển nguồn; khảo sát ghép khối trên Proteus; chốt BOM và giao tiếp | Sơ đồ kết nối, dải điện áp/dòng phù hợp, danh mục vật tư và kế hoạch thử phần cứng |
| M5: Phần cứng và IoT | 8–9 | Triển khai mạch đo/BMS, tích hợp từng khối nguồn ở mức phù hợp; phát triển firmware và giao diện | Các khối chạy riêng; hiệu chuẩn ban đầu; dữ liệu và lệnh được truyền có phản hồi |
| M6: Tích hợp và thực nghiệm | 10–11 | Ghép hệ thống; thử tải, điều kiện nguồn, chuyển nguồn, mất mạng và bảo vệ; thu số liệu chi phí/hiệu suất | Nhật ký thử nghiệm và dữ liệu; danh sách lỗi đã xử lý hoặc giới hạn còn lại |
| M7: Hoàn thiện và bàn giao | 12 | Dự phòng sửa lỗi, kiểm tra lại ca bị ảnh hưởng, hoàn thiện báo cáo và hồ sơ | Mô hình minh họa, mã nguồn, schematic, kết quả, BOM và báo cáo cuối theo yêu cầu học phần |

Việc mua linh kiện chỉ triển khai sau khi đã xác định thông số và khả năng tương thích của khối liên quan. Khảo sát nhà cung cấp có thể làm trong M2–M3 để ước lượng thời gian cung ứng. Phần giao diện có thể phát triển với dữ liệu giả lập ở M5, nhưng đánh giá IoT hoàn chỉnh phải dùng dữ liệu từ thiết bị ở M6.

### 9.2. Phân chia nhiệm vụ

Phân công dưới đây kế thừa hướng phụ trách trong bản kế hoạch ban đầu và mở rộng cho toàn bộ project.

| Thành viên | Tại mốc proposal | Sau proposal | Sản phẩm phụ trách |
|---|---|---|---|
| Lê Thanh Phú (2212581) | Tổng hợp BMS, SoC, nhiệt độ, cân bằng và bảo vệ; xây dựng phương pháp mô phỏng BMS | Dựng BMS trong Proteus; phát triển logic cục bộ; triển khai BMS phần cứng; phối hợp thử lỗi | Mô hình BMS, cấu hình bảo vệ, chương trình và hồ sơ kiểm thử BMS |
| Phan Trần Nguyên Phúc (2212643) | Tổng hợp PV, shading, TCT/DES và thuật toán DP–SC; lập kế hoạch mô phỏng PV | Dựng PV; chủ trì bộ sạc, inverter, tải và chuyển nguồn; theo dõi BOM khối công suất | Mô hình PV, dữ liệu I–V/P–V, phương án cấp nguồn và kết quả thử năng lượng |
| Hoàng Ngô Thiên Phúc (2212612) | Tổng hợp đo lường, kiến trúc IoT, kế hoạch và biên tập báo cáo | Chủ trì cảm biến/hiệu chuẩn, giao tiếp, IoT và giao diện; tổ chức lưu dữ liệu; tổng hợp chi phí | Hồ sơ đo lường, giao diện, nhật ký dữ liệu và bản báo cáo hợp nhất |

Ba thành viên cùng thống nhất thông số đầu vào, lắp ghép và đánh giá toàn hệ thống. Với phần cứng BMS, Lê Thanh Phú phối hợp Hoàng Ngô Thiên Phúc về đo lường; với đường công suất, Phan Trần Nguyên Phúc phối hợp Lê Thanh Phú về quyền sạc/xả. Mỗi phần trước khi tích hợp cần một thành viên khác kiểm tra chéo.

### 9.3. Phối hợp và quản lý thay đổi

Nhóm dự kiến rà tiến độ mỗi tuần, cập nhật công việc đã hoàn thành, vướng mắc và đầu ra tuần kế tiếp. Nhóm sẽ dùng chung bảng thông số gồm quy ước dòng, đơn vị, cấu hình pin, dải đo, ngưỡng và giao tiếp giữa các khối.

Khi thay loại pin, số cell, dải công suất hoặc cách chuyển nguồn, nhóm phải cập nhật mô hình, firmware, BOM và ca kiểm thử liên quan trước khi tiếp tục tích hợp. Mỗi mốc bàn giao sẽ lưu phiên bản tài liệu và mô hình tương ứng để truy lại dữ liệu.

## 10. Các thông số cần xác định và rủi ro thực hiện

### 10.1. Các quyết định còn mở

| Nội dung | Trạng thái hiện tại | Thời điểm cần xác định |
|---|---|---|
| Hạn nộp proposal, tiêu chí chấm và lịch các mốc cuối | Chưa có thông tin xác nhận trong tài liệu | Kiểm tra LMS trước khi nộp; cập nhật lịch sau đó |
| Công suất tải và thời gian hoạt động | Chưa xác định | M2, trước khi chốt quy mô nguồn và pin |
| Loại cell, số cell và dung lượng | Đề xuất khảo sát LiFePO4 4S; 15 Ah chỉ là giả định ban đầu | M2, trước thiết kế BMS chi tiết và mua pin |
| Ngưỡng điện áp/dòng/nhiệt, trễ và khôi phục | Chưa có bảng datasheet của pin được chọn | M2–M3, trước khi kết luận các ca bảo vệ |
| Dải đo và sai số cho phép | Chưa xác định từ phần cứng | M2; kiểm tra lại sau hiệu chuẩn ở M5 |
| Tham số PV thực tế | SM55 chỉ là bộ tham số tham khảo | M4, khi chọn tấm pin triển khai |
| MCU, cảm biến, thư viện và giấy phép Proteus | Chưa kiểm tra khả năng mô phỏng trên máy | Đầu M2 |
| Bộ sạc, inverter, nguồn phụ và ngân sách | Chưa chọn linh kiện hoặc mô-đun | M4 |
| Nền tảng IoT và giao thức điều khiển | ESP32/ThingSpeak là phương án khảo sát | M4–M5 |
| Thực hiện reconfiguration ngoài phần lý thuyết | Chưa đưa vào đầu ra bắt buộc | Xem xét sau khi hoàn thành các phần chính |

### 10.2. Rủi ro và cách xử lý dự kiến

| Rủi ro | Ảnh hưởng | Cách xử lý |
|---|---|---|
| Thiếu mô hình MCU/cảm biến hoặc không nạp/lưu được dự án Proteus | Không chạy được một phần mô phỏng | Kiểm tra ngay đầu M2; dùng nguồn tín hiệu và khối cơ bản cho phần đo; giải quyết môi trường MCU trước kiểm thử SoC |
| Mô hình cell quá đơn giản | Dễ diễn giải sai thời gian sạc/xả hoặc cân bằng | Tách kiểm thử logic và kiểm thử động học; ghi rõ giới hạn của từng mô hình |
| Sai số đo lớn so với ngưỡng cân bằng | Bật sai nhánh hoặc rung đóng/cắt | Lập ngân sách sai số, hiệu chuẩn, điều chỉnh dải đo và ngưỡng |
| Mạch công suất không tương thích | Khó tích hợp hoặc vượt khả năng linh kiện | Rà điện áp, dòng, chiều cấp nguồn và điều kiện bảo vệ ở M4 |
| Linh kiện giao chậm hoặc phạm vi quá rộng | Thiếu thời gian thực nghiệm | Khảo sát cung ứng sớm; ưu tiên đầu ra cốt lõi, giữ tuần dự phòng và dùng mô-đun phù hợp khi cần |
| Mất mạng hoặc lệnh từ xa xung đột với bảo vệ | Hiển thị sai trạng thái hoặc điều khiển không phù hợp | Bảo vệ cục bộ, đánh dấu dữ liệu cũ, xác nhận lệnh và thử lỗi mạng |

## 11. Sản phẩm dự kiến và phương pháp đánh giá

### 11.1. Sản phẩm tại mốc proposal

Sản phẩm nộp ở mốc này là báo cáo tổng quan gồm cơ sở lý thuyết, phương pháp thiết kế BMS 12 V, kế hoạch mô phỏng BMS/PV trên Proteus, phần tìm hiểu PV array configuration, kiến trúc hệ thống và kế hoạch phân công. Các nội dung tương ứng yêu cầu trong [9] như sau:

| Yêu cầu | Nội dung đáp ứng trong báo cáo |
|---|---|
| BMS 12 V: SoC, nhiệt độ, cân bằng cell, bảo vệ | Mục 4.5–4.6 và mục 5 |
| Mô phỏng chức năng trên Proteus trước phần cứng | Mục 6 và thứ tự M2–M5 trong mục 9 |
| Mô phỏng tấm pin | Mục 4.2–4.3 và 6.2 |
| Tìm hiểu PV array configuration | Mục 7 |
| Phương pháp tổng quan, kế hoạch, phân nhiệm vụ | Mục 5–6 và 8–9 |
| Đọc tài liệu được cung cấp và tự tìm thêm | Mục 3 và 12 |
| Báo cáo tiến độ trên LMS, hạn theo LMS | Mục 2.2 và 10.1 |

Nhóm chưa có ảnh hoặc số liệu mô phỏng để báo cáo kết quả. Các bảng ca thử thể hiện việc sẽ làm sau proposal, không được xem là các bài thử đã đạt.

### 11.2. Sản phẩm sau triển khai

Các đầu ra dự kiến của toàn project gồm mô hình Proteus PV và BMS; cấu hình và chương trình điều khiển; mô hình microgrid phần cứng với bộ sạc, pin, inverter, tải và chuyển nguồn; hệ thống IoT/giao diện; hồ sơ đo lường, thực nghiệm, BOM và báo cáo tổng kết.

Đối với các thành phần dùng mô-đun có sẵn, nhóm sẽ nêu mã sản phẩm, chức năng, cách tích hợp và phạm vi thử nghiệm. Phần tự phát triển cần có tài liệu đủ để tái lập mô hình và kiểm tra kết quả.

### 11.3. Các chỉ tiêu sẽ đánh giá

| Đối tượng | Chỉ tiêu và dữ liệu cần có |
|---|---|
| PV mô phỏng | Sai lệch các điểm đặc trưng so với nguồn tham chiếu; chiều biến thiên khi thay đổi \(G,T\) |
| Đo lường BMS | Sai số điện áp, dòng, nhiệt; đúng dấu dòng và đúng điện áp từng cell |
| SoC | Sai số so với điện tích tham chiếu trong ca thử có điều kiện ban đầu xác định; độ trôi khi có sai số dòng |
| Cân bằng | Chọn đúng nhánh, dòng cân bằng, chênh lệch cell trước/sau và thời gian theo mô hình được sử dụng |
| Bảo vệ | Điều kiện và thời gian tác động; dòng còn lại sau ngắt; điều kiện khôi phục; phản ứng với lỗi kết hợp |
| Nguồn và tải | Điện áp bus, khả năng cấp tải, quá trình chuyển nguồn và ảnh hưởng đến tải |
| IoT | Tính đúng của dữ liệu, độ trễ cập nhật/lệnh, phản hồi thực thi và hành vi khi mất mạng |
| Chi phí | Tổng BOM và chi phí thực hiện; so sánh các phương án đáp ứng cùng yêu cầu |

Nhóm sẽ xác định mức chấp nhận cho từng chỉ tiêu trước khi chạy bộ thử chính thức, dựa trên yêu cầu tải, độ phân giải đo và linh kiện đã chọn. Báo cáo hiện tại chưa đặt các mức đó thành tiêu chí đã được giảng viên xác nhận.

Với giá trị tham chiếu khác 0, sai lệch tương đối được tính:

$$
\varepsilon_X=
\frac{|X_{\mathrm{thu}}-X_{\mathrm{ref}}|}{|X_{\mathrm{ref}}|}\times100\%.
$$

Đối với giá trị gần 0, nhóm sẽ báo cáo sai số tuyệt đối để tránh tỷ lệ không có ý nghĩa. Năng lượng ở một nhánh đo được tích phân từ công suất:

$$
E=\sum_k P_k\frac{\Delta t_k}{3600}\quad[\mathrm{Wh}],
$$

với công suất tính bằng W và thời gian bằng giây. Khi đánh giá hiệu suất, nhóm sẽ ghi rõ ranh giới khối và khoảng đo. Với hệ có pin, nhóm phải tính phần năng lượng lưu trữ thay đổi hoặc so sánh ở trạng thái pin đầu/cuối tương đương; không lấy điện năng tải chia cho điện năng PV trong một khoảng pin đang xả rồi kết luận đó là hiệu suất hệ thống.

Các thử nghiệm cuối dự kiến gồm thay đổi mức tải, thay đổi mức nguồn PV hoặc điều kiện chiếu sáng ghi nhận được, chuyển nguồn phụ, mất kết nối và phục hồi sau lỗi. Nếu không đo được bức xạ, nhóm sẽ mô tả điều kiện thử thực tế, không gán tùy ý giá trị \(\mathrm{W/m^2}\) cho thời tiết.

## 12. Tài liệu tham khảo

### 12.1. Tài liệu nghiên cứu và kỹ thuật

[1] S. J. Yaqoob, S. Motahhir và E. B. Agyekum, “A new model for a photovoltaic panel using Proteus software tool under arbitrary environmental conditions,” *Journal of Cleaner Production*, tập 333, bài 130074, 2022. [DOI: 10.1016/j.jclepro.2021.130074](https://doi.org/10.1016/j.jclepro.2021.130074). Tài liệu do giảng viên cung cấp.

[2] P. Kulkarni, L. S. Paragond và S. Hiremath, “Hybrid battery management system using the internet of things,” *Majlesi Journal of Electrical Engineering*, tập 19, số 2, bài 192531, tr. 1–8, 2025. [DOI: 10.57647/j.mjee.2025.1902.31](https://doi.org/10.57647/j.mjee.2025.1902.31). Tài liệu do giảng viên cung cấp.

[3] Ngô Ngọc Thành và Nguyễn Phùng Quang, “Simulation of reconfiguration system using MATLAB–Simulink environment,” *Journal of Computer Science and Cybernetics*, tập 34, số 2, tr. 127–143, 2018. [DOI: 10.15625/1813-9663/34/2/9194](https://doi.org/10.15625/1813-9663/34/2/9194). Tài liệu do giảng viên cung cấp.

[4] M. Boyd và C. Hansen, “Single Diode Equivalent Circuit Models,” *PV Performance Modeling Collaborative*, Sandia National Laboratories; nội dung đóng góp bởi NIST và Sandia. [Trang tài liệu](https://pvpmc.sandia.gov/modeling-guide/2-dc-module-iv/single-diode-equivalent-circuit-models/). Truy cập ngày 10/09/2026.

[5] N. Richards, *Battery Gauging Algorithm Comparison*, Texas Instruments, Application Note SLUAAR3, 12/2023. [Tài liệu kỹ thuật](https://www.ti.com/lit/an/sluaar3/sluaar3.pdf). Truy cập ngày 10/09/2026.

[6] M. Sunna, *Cell Balancing With BQ769x2 Battery Monitors*, Texas Instruments, Application Note SLUAA81A, bản sửa đổi 02/2022. [Tài liệu kỹ thuật](https://www.ti.com/lit/sluaa81). Truy cập ngày 10/09/2026.

[7] Texas Instruments, *LM35 Precision Centigrade Temperature Sensors*, datasheet SNIS159H, bản sửa đổi 12/2017. [Datasheet LM35](https://www.ti.com/lit/ds/symlink/lm35.pdf). Truy cập ngày 10/09/2026.

### 12.2. Tài liệu xác định yêu cầu

[8] *Chi tiết đề tài HK261-DAGD1-133: Thiết kế và phát triển hệ thống microgrid sử dụng năng lượng mặt trời với chi phí tối ưu kết hợp nền tảng IoT*, mô tả và yêu cầu học phần HK261. [Bản lưu nội bộ](../specifications/specs.md).

[9] *Q&A với giảng viên, vòng 1 về proposal GĐ1*, trao đổi ngày 28/08/2026. [Bản lưu nội bộ](../info/qa1.md).
