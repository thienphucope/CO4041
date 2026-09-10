# Kế hoạch và hướng dẫn triển khai mô phỏng Proteus: PV và BMS 12 V

**Đề tài:** HK261-DAGD1-133

**Báo cáo liên quan:** [proposal.md](proposal.md)

**Yêu cầu gốc:** [Q&A với giảng viên](../info/qa1.md)

**Ngày cập nhật:** 10/09/2026

## 1. Trạng thái và mục đích

Tài liệu này hướng dẫn công việc dự kiến sau mốc proposal. Nhóm chưa dựng schematic, chưa biên dịch chương trình cho mô hình và chưa chạy các ca thử dưới đây. Tên tệp, tham số ví dụ và đầu ra trong tài liệu là quy ước để triển khai, không phải các sản phẩm đã có.

Mốc proposal chỉ trình bày phương pháp và kế hoạch. Các mốc tiếp theo phải hoàn thành mô phỏng BMS và tấm pin trên Proteus trước khi làm phần cứng. PV array reconfiguration hiện là phần tìm hiểu lý thuyết từ tài liệu [3], chưa có bài mô phỏng riêng trong kế hoạch.

Nhóm dự kiến tạo:

| Dự án | Nội dung | Mốc trong proposal |
|---|---|---|
| pv-model.pdsprj | Mô hình một diode, đầu vào bức xạ/nhiệt độ, đồ thị I–V/P–V | M2–M3 |
| bms-sim.pdsprj | Đo lường, SoC, nhiệt độ, cân bằng và bảo vệ | M2–M3 |
| system-integration.pdsprj | Khảo sát chức năng ghép nguồn sạc, BMS, bus và tải sau khi hai mô hình trên đạt yêu cầu | M4 |

Phần MCU có thể cần chương trình biên dịch bằng bộ công cụ ngoài Proteus rồi nạp vào mô hình. Các kết quả mô phỏng mạch vẫn được tạo và quan sát trong Proteus. Kết nối IoT thực được kiểm tra ở mốc phần cứng; trong Proteus trước mắt dùng terminal nối tiếp để kiểm tra dữ liệu và lệnh.

## 2. Chuẩn bị trước khi dựng

### 2.1. Kiểm tra môi trường

1. Ghi phiên bản Proteus, module mô phỏng khả dụng và khả năng lưu/mở lại dự án.
2. Tạo một mạch thử nhỏ để xác nhận mô phỏng analog và đồ thị hoạt động.
3. Kiểm tra mô hình MCU có thể chạy chương trình của nhóm. Có thể khảo sát dòng AVR/Arduino hoặc MCU khác phù hợp; sự xuất hiện của ký hiệu linh kiện trong thư viện chưa chứng minh linh kiện đó có mô hình mô phỏng.
4. Kiểm tra khối toán, nguồn phụ thuộc, LM35, ADC, thiết bị hiển thị và terminal cần dùng. Lưu nguồn và phiên bản nếu sử dụng thư viện bổ sung.
5. Lưu rồi mở lại mạch thử trước khi dựng mô hình lớn.

Nếu môi trường chưa chạy được MCU, nhóm vẫn có thể dựng PV và kiểm tra một số khối analog/bảo vệ bằng comparator. Phần đó chỉ là kiểm thử thành phần; chưa thay thế việc kiểm thử SoC, cân bằng và điều phối BMS bằng chương trình. Nhóm cần xử lý hạn chế môi trường trước khi xác nhận hoàn thành M3.

### 2.2. Lập bảng tham số dùng chung

| Nhóm tham số | Nội dung cần ghi | Nguồn |
|---|---|---|
| PV | Thông số danh định, tham số mô hình, quy luật theo nhiệt độ/bức xạ | [1], [4] và sau này là datasheet tấm pin được chọn |
| Pin | Loại cell, số cell, dung lượng tham chiếu, trạng thái ban đầu, loại mô hình cell | Phương án nhóm; datasheet khi chọn cell |
| Đo lường | Dải điện áp, tỷ lệ phân áp, dải dòng, điểm giữa, hệ số khuếch đại, tham chiếu ADC | Tính toán của nhóm và mô hình cảm biến |
| Bảo vệ | Ngưỡng tác động/nhả theo từng chiều, thời gian xác nhận, loại lỗi cần khóa | Datasheet và yêu cầu vận hành |
| Cân bằng | Điều kiện cho phép, chênh lệch bật/tắt, dòng nhánh, giới hạn nhiệt | Phương án nhóm, tham khảo [6] |
| SoC | Quy ước dấu dòng, dung lượng, SoC ban đầu, chu kỳ lấy mẫu, hiệu suất giả thiết | Phương pháp ở proposal mục 4.5 |
| Nhật ký | Mã ca thử, phiên bản mạch/chương trình, bước thời gian, thời gian chạy | Quy ước chung của nhóm |

Không lấy ngưỡng của bộ pin trong bài báo để áp dụng trực tiếp cho LiFePO4 hoặc SLA. Nếu cần thử logic trước khi chốt cell, đặt một bộ ngưỡng giả định, ghi rõ “tham số kiểm thử chức năng” và không dùng bộ ngưỡng đó để vận hành pin thật.

## 3. Mô hình PV

### 3.1. Bộ tham số tham khảo ban đầu

Dùng bộ thông số SM55 ở Bảng 1 và 2 của [1] để có cơ sở đối chiếu. Đây là dữ liệu của tài liệu, không phải kết quả đo của nhóm hoặc lựa chọn mua phần cứng.

| Tham số | Giá trị SM55 trong [1] |
|---|---|
| Công suất danh định | 55 W |
| \(V_{\mathrm{MPP}}\), \(I_{\mathrm{MPP}}\) | 17,4 V; 3,15 A |
| \(V_{\mathrm{OC}}\), \(I_{\mathrm{SC}}\) | 21,7 V; 3,45 A |
| Số cell nối tiếp \(N_s\) | 36 |
| Hệ số nhiệt điện áp \(K_V\) | −0,077 V/°C |
| Hệ số nhiệt dòng \(K_I\) | 0,0012 A/°C |
| Điện trở mô hình \(R_s\), \(R_{\mathrm{sh}}\) | 0,528 Ω; 134,64 Ω |
| Hệ số lý tưởng \(n\) | 0,9645 |
| Dòng bão hòa tại tham chiếu \(I_{0,\mathrm{ref}}\) | \(9,0072\times10^{-11}\) A |
| Điều kiện tham chiếu | \(G=1000\ \mathrm{W/m^2}\), \(T=25^\circ\mathrm{C}\) |

Công suất 55 W là giá trị danh định làm tròn trong tài liệu; tích của cặp \(17,4\ \mathrm{V}\) và \(3,15\ \mathrm{A}\) là 54,81 W. Khi tính sai lệch, ghi rõ đang dùng đại lượng tham chiếu nào.

### 3.2. Phương trình và khối cần dựng

Theo [1], dựng ba dòng rồi lấy hiệu:

$$
I=I_{\mathrm{ph}}-I_D-I_{\mathrm{sh}},
$$

$$
I_D=I_0(T)\left[\exp\left(\frac{V+IR_s}{nN_skT_K/q}\right)-1\right],
\qquad
I_{\mathrm{sh}}=\frac{V+IR_s}{R_{\mathrm{sh}}}.
$$

Dùng nguồn phụ thuộc và khối toán tương ứng trong Proteus, theo các khối AVCVS/AVCCS và Laplace primitives trình bày trong [1]. Kiểm tra tên và cách khai báo biểu thức theo phiên bản đang sử dụng.

Đầu vào nhiệt độ có thể nhập theo °C để dễ đọc, nhưng phải chuyển \(T_K=T_C+273,15\) trước khi dùng trong số mũ. Hệ số dòng nên được định nghĩa rõ là đạo hàm có dấu \(\alpha_I=dI_{\mathrm{SC}}/dT\); khi dùng quy ước này, thành phần gần đúng là:

$$
I_{\mathrm{ph}}(G,T)\approx
\left[I_{\mathrm{SC,ref}}+\alpha_I(T_C-T_{\mathrm{ref}})\right]
\frac{G}{G_{\mathrm{ref}}}.
$$

Đối chiếu cách định nghĩa hệ số trong [1] trước khi nhập: bản trích công thức dòng quang sinh có dấu cần kiểm tra với hệ số nhiệt dương ở bảng tham số. Không ghép dấu của một công thức với hệ số định nghĩa theo quy ước khác. Quy luật \(I_0(T)\) phải được nhập và kiểm tra theo mô hình tham khảo; chỉ thay đổi \(I_{\mathrm{ph}}\) không đủ để khảo sát ảnh hưởng nhiệt độ.

Dùng \(R_s,R_{\mathrm{sh}}\) ở cấp module như bộ tham số trên; không nhân thêm \(N_s\) vào các điện trở đã quy đổi. Giữ đủ thành phần “−1” trong dòng diode. Tại STC, kiểm tra mô hình với \(I_{0,\mathrm{ref}}\) trước khi thêm biến thiên nhiệt độ.

### 3.3. Trình tự dựng và kiểm tra

1. Dựng khối tham số và khối chuyển đổi đơn vị.
2. Dựng từng thành phần dòng, đặt đầu đo tại đầu ra các khối để kiểm tra giá trị.
3. Ghép dòng PV vào nguồn dòng phụ thuộc, tạo hai cực ra PV+ và PV−.
4. Đặt nguồn áp quét giữa hai cực PV để ấn định điểm làm việc. Nguồn này đóng vai trò tải điện tử của bài kiểm tra; không phải nguồn phát thay cho PV.
5. Quét điện áp từ 0 đến gần \(V_{\mathrm{OC}}\); đo dòng đi ra cực dương. Nếu dụng cụ báo dòng âm do quy ước chiều, đổi hướng đầu đo hoặc biểu thức hiển thị trước khi tính công suất.
6. Vẽ I–V và \(P=VI\) trên đồ thị Proteus; giảm bước quét quanh vùng đỉnh khi cần.
7. Lưu dữ liệu các điểm đặc trưng và sai lệch so với tham chiếu.
8. Bổ sung biến thiên bức xạ/nhiệt độ rồi chạy PV-02 và PV-03.

Trong mô hình một tấm ở điều kiện bức xạ đồng đều, không cần thêm bypass để tạo đường I–V cơ bản. Nếu khảo sát diode bypass, mắc nó song song ngược cực với phần được bảo vệ, bình thường ở trạng thái khóa. Diode nối tiếp để chặn dòng ngược có chức năng khác.

### 3.4. Ca thử PV

| Mã | Thiết lập | Đầu ra cần lưu |
|---|---|---|
| PV-01 | 1000 W/m²; 25 °C | I–V, P–V; \(I_{\mathrm{SC}},V_{\mathrm{OC}},V_{\mathrm{MPP}},I_{\mathrm{MPP}},P_{\mathrm{MPP}}\); bảng đối chiếu |
| PV-02 | 400, 700, 1000 W/m²; cùng 25 °C | Đồ thị so sánh ảnh hưởng bức xạ |
| PV-03 | 25, 45, 60 °C; cùng 1000 W/m² | Đồ thị so sánh ảnh hưởng nhiệt độ |

Các con số trên là đầu vào dự kiến. Không ghi “đạt” chỉ vì đồ thị có hình dạng giống tài liệu: cần kiểm tra đơn vị, chiều dòng, điểm đặc trưng và sai lệch. Nếu mô hình không hội tụ, kiểm tra vòng phụ thuộc dòng–áp, điểm khởi tạo, hệ số biểu thức và bước quét trước khi sửa tham số vật lý.

## 4. Mô hình BMS

### 4.1. Chọn cách biểu diễn cell theo mục đích thử

| Cách biểu diễn | Kiểm tra được | Giới hạn |
|---|---|---|
| Nguồn áp độc lập cho từng cell; tín hiệu dòng/nhiệt đặt trước | Đọc đúng kênh, tính SoC theo dòng cho trước, logic ngưỡng và lệnh cân bằng | Nguồn áp lý tưởng không tự giảm áp khi xả; không thể đánh giá thời gian cân bằng |
| Tụ có điện áp ban đầu, điện trở nội và nhánh nạp/xả | Diễn biến điện áp và tác động nhánh cân bằng trong mạch điện minh họa | Quan hệ điện tích–điện áp của tụ không phải của pin hóa học |
| Mạch tương đương pin có bảng OCV–SoC và tham số xác định | Khảo sát liên hệ SoC, điện áp và tải theo mô hình | Cần nguồn tham số và kiểm chứng trước khi so với pin thật |

Triển khai kiểm thử tín hiệu trước, rồi bổ sung mô hình động để chạy ca cân bằng. Không cần khẳng định Proteus luôn có hoặc không có mô hình pin phù hợp; phải kiểm tra thư viện và khả năng của mô hình cụ thể.

Nếu dùng tụ, đặt điện áp ban đầu và điện dung đủ để quan sát trong thời gian mô phỏng. Quan hệ \(\Delta V=I\Delta t/C\) chỉ dùng ước lượng thời gian của mô hình tụ. Không đổi tùy ý điện dung nhỏ thành pin 15 Ah rồi dùng tốc độ giảm điện áp đó làm kết quả thời gian sử dụng pin.

### 4.2. Từ một cell đến bộ pin nhiều cell

Bắt đầu bằng một cell để kiểm tra đo áp, tín hiệu nhiệt và ngắt bảo vệ. Sau đó chuyển sang bốn cell nối tiếp theo cấu hình khảo sát của proposal, thêm đo dòng có dấu và các nhánh cân bằng.

Đặt tên các nút B0, B1, B2, B3, B4; B0 là cực âm chung. Điện áp từng cell là hiệu hai nút liên tiếp, còn điện áp pack là \(U_4-U_0\). Không nối các cực âm của bốn cell về chung mass vì sẽ làm sai cấu hình nối tiếp.

Một cell không kiểm chứng được chức năng cân bằng. Mô hình đầy đủ phải có ít nhất hai cell lệch nhau; cấu hình mục tiêu đang khảo sát là 4S.

### 4.3. Khối đo điện áp

Với kênh nút thứ \(i\), đặt tỷ lệ phân áp:

$$
r_i=\frac{R_{\mathrm{bot},i}}{R_{\mathrm{top},i}+R_{\mathrm{bot},i}},
\qquad
V_{\mathrm{ADC},i}=r_iU_i.
$$

Chọn \(r_iU_{i,\max}\) nằm trong dải ADC có dự phòng, kể cả lúc tạo lỗi quá áp. Phần xử lý khôi phục \(U_i\), rồi tính \(V_{\mathrm{cell},i}=U_i-U_{i-1}\).

Không dùng hệ số chia đôi cho mọi nút mà chưa kiểm tra điện áp nút cao nhất. Với ADC \(b\) bit, bước lượng tử quy về nút xấp xỉ:

$$
\Delta U_i=\frac{V_{\mathrm{ref}}}{(2^b-1)r_i}.
$$

Sai số điện áp cell còn gồm sai số của hai kênh lấy hiệu. Nếu sai số này cùng cỡ ngưỡng cân bằng dự kiến, cần điều chỉnh độ phân giải, mạch đo hoặc ngưỡng trước khi tiếp tục.

### 4.4. Khối dòng hai chiều và nhiệt độ

Quy ước thống nhất: \(I_{\mathrm{bat}}>0\) khi pin xả, \(I_{\mathrm{bat}}<0\) khi pin sạc.

Nếu dùng shunt và ADC một cực, cần mạch đo có điểm giữa \(V_{\mathrm{mid}}\). Với hệ số khuếch đại \(A\):

$$
V_{\mathrm{ADC},I}=V_{\mathrm{mid}}+A R_{\mathrm{shunt}}I_{\mathrm{bat}},
\qquad
I_{\mathrm{bat}}=
\frac{V_{\mathrm{ADC},I}-V_{\mathrm{mid}}}{A R_{\mathrm{shunt}}}.
$$

Kiểm tra toàn bộ dải dòng, giới hạn common-mode, dải đầu ra bộ khuếch đại và công suất \(I_{\max}^2R_{\mathrm{shunt}}\). Không chọn điện trở shunt và gain độc lập với dòng lớn nhất. Thử ba điểm âm, 0 và dương trước khi dùng kết quả cho SoC.

Với nhiệt độ, dùng LM35 nếu mô hình hoạt động, hoặc nguồn áp theo đặc tuyến \(10\ \mathrm{mV}/^\circ\mathrm{C}\) [7]. Kiểm tra đọc giá trị biết trước và kiểm tra tín hiệu lỗi. Nếu thử nhiệt độ âm, phải thiết kế đường tín hiệu phù hợp; không giả định ADC một cực đọc được điện áp âm từ mạch cảm biến cơ bản.

### 4.5. Đường bảo vệ và cân bằng

Bước đầu dùng công tắc điều khiển lý tưởng và nguồn/tải có giới hạn để kiểm tra đường dòng sạc, xả và ngắt. Với mỗi ca lỗi, quan sát dòng thực tế qua nhánh sau ngắt; LED hoặc cờ lỗi chưa đủ để chứng minh mạch đã cắt.

Khi thay công tắc bằng MOSFET, cần kiểm tra cấu hình cặp FET, chiều diode thân, điện áp kích cổng theo cực source và đường dòng ở cả hai chiều. Không nối trực tiếp mọi gate vào chân MCU nếu source của các FET ở những điện thế khác nhau.

Mỗi nhánh cân bằng gồm điện trở nối tiếp công tắc, mắc qua đúng hai cực cell. Bước đầu có thể dùng công tắc điều khiển lý tưởng để tách kiểm tra thuật toán khỏi mạch kích. Khi mở rộng sang MOSFET, phải kiểm tra lại dòng nhánh và công suất tản; cách bố trí thực tế tham khảo [6].

## 5. Thuật toán điều khiển dự kiến

### 5.1. Luồng xử lý

Luồng dưới đây là mã giả cho thiết kế; chưa phải firmware đã biên dịch hoặc chạy thử:

    Khi khởi tạo:
        Khóa quyền sạc, khóa quyền xả, tắt toàn bộ nhánh cân bằng.
        Nạp cấu hình ca thử, SoC ban đầu và quy ước dấu dòng.
        Kiểm tra dữ liệu đo trước khi cho phép vận hành.

    Mỗi chu kỳ:
        Đọc điện áp nút, dòng và nhiệt độ.
        Kiểm tra dữ liệu hợp lệ; tính điện áp từng cell.
        Cập nhật điều kiện lỗi, thời gian xác nhận và trạng thái khóa lỗi.

        Nếu dữ liệu dòng và thời gian hợp lệ:
            Cập nhật SoC theo dòng có dấu và thời gian mô phỏng.

        Tính lại quyền sạc và quyền xả từ toàn bộ điều kiện hiện tại.
        Áp dụng trạng thái khóa lỗi và yêu cầu vận hành.
        Nếu dữ liệu không hợp lệ: khóa cả sạc và xả.

        Nếu có lỗi hoặc ngoài điều kiện cân bằng:
            Tắt toàn bộ nhánh cân bằng.
        Nếu đủ điều kiện:
            Chọn nhánh theo điện áp cell và ngưỡng bật/nhả.

        Xuất lệnh đóng/cắt, hiển thị và dữ liệu trạng thái.

Không giữ nguyên lệnh từ vòng trước mà bỏ qua việc đánh giá lại các điều kiện. Khi có OV và UV ở hai cell khác nhau, mô hình phải khóa cả sạc và xả. Lệnh phục hồi chỉ có tác dụng nếu điều kiện lỗi đã được xử lý và quy tắc phục hồi cho phép.

Các giá trị thời gian xác nhận lỗi, khoảng lấy mẫu, hysteresis và ngưỡng phục hồi cần điền vào bảng cấu hình trước khi thử. Khi có firmware, thời gian dùng cho coulomb counting phải là thời gian trong mô hình MCU, không phải số giây chờ trên máy tính người dùng.

### 5.2. Kiểm tra SoC bằng phép tính độc lập

Để kiểm tra số học trước khi chọn pin thật, có thể dùng ca thử nhân tạo:

- Dung lượng tham chiếu \(Q=1\ \mathrm{Ah}\), SoC ban đầu 50%.
- Dòng xả \(I=+1\ \mathrm{A}\), thời gian 36 giây, hiệu suất giả thiết bằng 1.
- Điện tích ra là 0,01 Ah, nên SoC tham chiếu cuối ca là 49%.
- Đổi dấu dòng sang −1 A trong cùng điều kiện ban đầu, SoC tham chiếu cuối ca là 51%.

Đây là kết quả tính toán của ca thử, chưa phải đầu ra Proteus. Ca này kiểm tra dấu và đơn vị, không chứng minh độ chính xác của thuật toán trên pin thật.

Không suy OCV–SoC bằng một đường thẳng giữa ngưỡng UV và OV. Nhóm chưa có bảng đặc tính cell để triển khai hiệu chỉnh OCV. Khi thêm cân bằng, dòng pack đo ở shunt có thể không bao gồm toàn bộ dòng xả cục bộ qua từng điện trở; nếu cần ước lượng SoC từng cell, phải tính thêm các nhánh này. Ca SoC cơ bản nên tắt cân bằng để có giá trị tham chiếu rõ.

## 6. Bộ kiểm thử BMS

Mã ca thử thống nhất với proposal mục 6.3. Cột trạng thái của nhật ký để “chưa chạy” cho đến khi có bằng chứng.

| Mã | Cách kích thích | Đại lượng phải kiểm tra |
|---|---|---|
| BMS-01 | Đặt riêng từng điện áp cell, dòng âm/0/dương, nhiệt độ | Sai số từng kênh, dấu dòng, tổng áp cell và áp pack |
| BMS-02 | Dòng và thời gian biết trước; tắt cân bằng | SoC so với điện tích tham chiếu, kiểm tra cả sạc/xả và giới hạn 0–100% |
| BMS-03 | Một cell vượt OV | Quyền sạc, dòng nhánh sạc sau ngắt, mã lỗi và điều kiện nhả |
| BMS-04 | Một cell dưới UV | Quyền xả, dòng tải sau ngắt và điều kiện nhả |
| BMS-05 | Dòng sạc và xả lần lượt vượt giới hạn | Tác động đúng chiều; thời gian xác nhận/ngắt |
| BMS-06 | Sự cố trở tải rất nhỏ trong mô hình có giới hạn dòng | Khóa đầu ra; dòng sau ngắt; không tự khởi động lại khi sự cố còn |
| BMS-07 | Nhiệt độ đi qua ngưỡng tác động/khôi phục | Ngắt đúng chế độ, dừng cân bằng, kiểm tra ngưỡng nhả |
| BMS-08 | Đặt chênh lệch cell, so sánh bật/tắt cân bằng | Đúng nhánh, dòng điện trở; với mô hình động, ghi \(\Delta V(t)\) trong cùng điều kiện đầu |
| BMS-09 | Tín hiệu quanh ngưỡng, ngoài dải, khởi động lại | Hysteresis, dữ liệu hợp lệ, trạng thái đầu ra khi khởi tạo |
| BMS-10 | OV và UV đồng thời; quá nhiệt khi cân bằng; lệnh bật tải khi lỗi | Ưu tiên bảo vệ, tắt nhánh phù hợp và giữ khóa lỗi |

Đối với BMS-08 dùng nguồn áp lý tưởng, chỉ kết luận về chọn nhánh và dòng cân bằng. Chỉ báo cáo giảm chênh lệch theo thời gian khi đã dùng mô hình có động học. Dừng kiểm thử và sửa phần đo nếu BMS-01 chưa đáp ứng yêu cầu; không dùng số đo sai để đánh giá thuật toán.

Mức sai số và thời gian chấp nhận cần được ghi trước khi chạy bộ thử, dựa trên cấu hình đã chọn. Không gán một tỷ lệ chung cho PV, SoC, điện áp và thời gian bảo vệ.

## 7. Ghép hệ thống sau mô phỏng riêng

Sau M3, thực hiện M4 theo thứ tự:

1. Xác định tải, dải bus, pin, bộ sạc, inverter và cách dùng nguồn phụ.
2. Tạo mô hình chức năng của các khối nguồn/công suất trong Proteus ở mức cần cho việc kiểm tra giao tiếp. Nếu dùng khối lý tưởng, ghi rõ chưa đánh giá tổn hao chuyển mạch.
3. Nối PV qua bộ điều khiển sạc phù hợp, không nối trực tiếp PV vào pin rồi xem BMS là bộ sạc.
4. Kiểm tra các chế độ PV cấp tải, PV cấp tải đồng thời nạp phần dư cho pin, pin cấp tải khi thiếu PV và nguồn phụ cấp theo logic chọn nguồn.
5. Kiểm tra tránh cấp ngược và tránh chồng nguồn không chủ định; theo dõi điện áp bus, dòng pin và quyền sạc/xả.
6. Xuất dữ liệu qua terminal; thử nhận lệnh tải và trả trạng thái thực thi.
7. Chỉ chuyển sang triển khai phần cứng của khối khi các lỗi mô phỏng liên quan đã được xử lý và thông số vật tư đã được rà.

Kết nối ESP32, cloud và giao diện thực nằm ở M5–M6. Hệ thống bảo vệ cục bộ phải tiếp tục hoạt động khi đường giao tiếp IoT mất kết nối.

## 8. Lưu bằng chứng và đưa vào báo cáo

Mỗi ca thử cần lưu:

- Mã thử, mục tiêu, ngày chạy và người thực hiện.
- Phiên bản Proteus, dự án, chương trình và thư viện phụ thuộc.
- Loại mô hình pin, tham số, điều kiện ban đầu và trình tự kích thích.
- Thời gian mô phỏng, dữ liệu/đồ thị và ảnh có tên tín hiệu, đơn vị.
- Giá trị tham chiếu, sai số hoặc thời gian tác động, kết luận và vấn đề còn lại.

Đặt tên đầu ra theo mã ca thử, chẳng hạn PV-01-iv, BMS-03-overvoltage hoặc BMS-08-balancing. Giữ dự án và chương trình đi kèm ảnh để người khác có thể mở và kiểm tra lại.

Khi có kết quả, cập nhật proposal hoặc báo cáo mốc tiếp theo bằng dữ liệu thật, mô tả đúng mô hình và giới hạn. Ảnh lấy từ tài liệu tham khảo phải ghi nguồn, số hình và vai trò minh họa lý thuyết. Không ghi ảnh tài liệu hoặc schematic chưa chạy là kết quả mô phỏng của nhóm.

## 9. Nguồn tham chiếu

Các số [1]–[7] dùng cùng danh mục trong proposal:

1. [Mô hình PV trên Proteus, Yaqoob và cộng sự](https://doi.org/10.1016/j.jclepro.2021.130074); [bản trích nội bộ](../references/extracted/01-pv-proteus/01-pv-proteus.md).
2. [BMS tích hợp IoT, Kulkarni và cộng sự](https://doi.org/10.57647/j.mjee.2025.1902.31); [bản trích nội bộ](../references/extracted/02-bms-iot/02-bms-iot.md).
3. [PV reconfiguration, Ngô Ngọc Thành và Nguyễn Phùng Quang](https://doi.org/10.15625/1813-9663/34/2/9194); [bản trích nội bộ](../references/extracted/03-pv-reconfig/03-pv-reconfig.md).
4. [PVPMC: Single Diode Equivalent Circuit Models](https://pvpmc.sandia.gov/modeling-guide/2-dc-module-iv/single-diode-equivalent-circuit-models/).
5. [TI: Battery Gauging Algorithm Comparison](https://www.ti.com/lit/an/sluaar3/sluaar3.pdf).
6. [TI: Cell Balancing With BQ769x2 Battery Monitors](https://www.ti.com/lit/sluaa81).
7. [TI: LM35 datasheet](https://www.ti.com/lit/ds/symlink/lm35.pdf).
