# Tài liệu tham khảo — PV array reconfiguration

Đề tài HK261-DAGD1-133. Theo [ghi nhận buổi họp 23/09/2026](../info/qa2.md), trọng tâm GĐ1 là dàn PV **3 × 3**, PCB chuyển cấu hình, mô phỏng trên MATLAB và đo so sánh công suất giữa các cấu hình. BMS và bộ sạc dùng sản phẩm có sẵn. Các ghi chú trước buổi họp còn mô tả BMS là trọng tâm hoặc reconfiguration chỉ là phần mở rộng; dùng ghi nhận mới này khi xác định phạm vi.

Các PDF mới bên dưới đã được lưu trong thư mục này. Bản `extracted/` là **text thô theo từng trang** để tìm kiếm; sơ đồ, bảng và công thức phải đối chiếu PDF gốc. [Chắt lọc ba PDF thầy cung cấp](refs-extract.md) vẫn là tài liệu lịch sử cho giai đoạn proposal.

## Đọc trước: chọn đúng loại reconfiguration

| Loại | Hệ làm gì? | Phần cứng / thuật toán | Tài liệu tiêu biểu |
|---|---|---|---|
| **Nối dây cố định để tản bóng che** | Hoán đổi thứ tự kết nối lúc lắp đặt, sau đó giữ nguyên | Không cần PCB chuyển mạch khi vận hành; kết quả phụ thuộc kiểu bóng che giả định | Etarhouni et al. 2019, R2 |
| **Chuyển giữa vài topology** | Chọn SP, TCT hoặc vài mode khác | PCB ít công tắc hơn, thuật toán chọn mode đơn giản; phải kiểm tra dải áp/dòng đầu ra | Pachauri et al. 2019, R5; Ng & Ertugrul 2025, R4 |
| **Đổi nhóm các module khi vận hành** | Đo/ước lượng tình trạng từng module, gán lại chúng vào hàng/nhánh | Thuật toán có nhiều lựa chọn hơn, nhưng ma trận chuyển mạch, cảm biến và trình tự đổi nối phức tạp hơn | Ngô & Nguyễn 2018, R0; Vicente et al. 2015, R1; Alwar et al. 2022, R3 |

**Điểm cần chốt trước khi thiết kế PCB:** PCB cho phép **những cạnh nối nào** và **bao nhiêu cấu hình hợp lệ**? Không thể chọn thuật toán “hoán vị bất kỳ” nếu mạch chỉ hỗ trợ hai topology. Với 9 tấm, việc duyệt các cách chia nhóm có thể nhẹ; đo đúng trạng thái từng tấm và hiện thực cấu hình trên mạch mới là giới hạn thực tế. Đây là suy luận thiết kế từ R0–R4, không phải kết luận định lượng chung cho mọi dàn PV.

## PDF gốc và bản trích xuất

| ID | Nguồn, bản lưu | Dùng để trả lời điều gì? | Giới hạn khi áp dụng |
|---|---|---|---|
| **R0 — thầy cung cấp** | Ngô Ngọc Thành & Nguyễn Phùng Quang (2018), *Simulation of Reconfiguration System Using MATLAB–Simulink Environment*, [DOI](https://doi.org/10.15625/1813-9663/34/2/9194). [PDF](SIMULATION%20OF%20RECONFIGURATION%20SYSTEM%20USING%20MATLAB%20-%20SIMULINK%20ENVIRONMENT.pdf) · [extract](extracted/03-pv-reconfig/03-pv-reconfig.md) | Mô hình 9 module TCT: cân bằng bức xạ giữa các hàng bằng DP + Smart Choice, sau đó điều khiển ma trận DES. Là mốc để dựng mô phỏng MATLAB. | Kết quả tăng công suất là **mô phỏng theo các ca của bài**; chưa chứng minh PCB 3 × 3 của nhóm có cùng hiệu quả. EI thấp là tiêu chí thay thế, cần kiểm bằng đường P–V/GMPP và tổn hao mạch. |
| **R1 — điều khiển động, phần cứng thật** | Vicente, Pimenta & Ribeiro (2015), *Photovoltaic Array Reconfiguration Strategy for Maximization of Energy Production*, [DOI/nhà xuất bản](https://doi.org/10.1155/2015/592383). [PDF](pv-reconfig-vicente-2015.pdf) · [extract](extracted/04-vicente-2015/04-vicente-2015.md) | Chỉ ra nhiều hoán vị là tương đương điện: dàn 2 × 2 có 24 cách xếp nhưng chỉ 3 cấu hình đáng xét. Dùng quy tắc Rough Sets, đo dòng ngắn mạch theo chu kỳ, relay và thử nghiệm dàn nhỏ. Xem PDF tr. 3, 8–10. | Để đo từng tấm, tác giả mở các switch trong thời gian đo; đây là gián đoạn cần tính vào năng lượng ròng. Thí nghiệm chính 2 × 2, không thể bê nguyên số switch sang 3 × 3. |
| **R2 — thuật toán cho 3 × 3 nhưng nối cố định** | Etarhouni, Chong & Zhang (2019), *A PV Array Reconfiguration Algorithm for Minimising Partial Shading Effects*, IREC/IEEE, [DOI](https://doi.org/10.1109/IREC.2019.8754602), [bản tác giả tại White Rose](https://eprints.whiterose.ac.uk/id/eprint/142555/). [PDF](pv-reconfig-irec-2019-3x3.pdf) · [extract](extracted/05-irec-2019-3x3/05-irec-2019-3x3.md) | Magic-square phân tán bóng che, mô phỏng 3 × 3 với các mẫu bóng ngắn/hẹp, ngắn/rộng, dài/hẹp, dài/rộng; so P–V/GMPP với TCT. Dùng các mẫu này làm ca thử. Xem PDF tr. 4–7. | **Bài nói rõ dây được định lại trước khi vận hành và giữ nguyên**. Không dùng bài này làm bằng chứng cho thuật toán tự chuyển theo bóng che đang di chuyển hoặc cho PCB ma trận động. |
| **R3 — ma trận switch và bộ ca bóng che** | Alwar et al. (2022), *Performance Analysis of Thermal Image Processing-Based Photovoltaic Fault Detection and PV Array Reconfiguration—A Detailed Experimentation*, *Energies* 15, 8450, [DOI](https://doi.org/10.3390/en15228450). [PDF](pv-reconfig-thermal-pairing-2022.pdf) · [extract](extracted/06-thermal-pairing-2022/06-thermal-pairing-2022.md) | Thực nghiệm dàn 4 × 5, có ảnh mạch switch, đo dòng ngắn mạch, bảo vệ và 8 dạng che: hàng, cột, chéo, ngẫu nhiên, ngắn/hẹp, ngắn/rộng, dài/hẹp, dài/rộng. Xem PDF tr. 8–10, 19–21. | Topology chia “male/female” riêng của bài cần 32 switch cho 4 hàng, **không phải BOM áp thẳng cho 3 × 3**. Camera nhiệt là một cách nhận biết bóng che, không phải yêu cầu bắt buộc của nhóm. |
| **R4 — mạch ít công tắc, đo không cần cảm biến bức xạ** | Ng & Ertugrul (2025), *Real-Time Reconfiguration of PV Arrays and Control Strategy Using Minimum Number of Sensors and Switches*, *Energies* 18, 5866, [DOI](https://doi.org/10.3390/en18225866). [PDF](pv-reconfig-ng-ertugrul-2025.pdf) · [extract](extracted/07-ng-ertugrul-2025/07-ng-ertugrul-2025.md) | MOSFET + diode, cảm biến áp từng module và một cảm biến dòng chung. Có phân tích **điện áp chịu đựng theo vị trí switch** và quét I–V để lấy MPP; thí nghiệm 3 module. Xem PDF tr. 5–6, 13–15. | Mạch chỉ cho phép nối song song các module **kề nhau**, không hỗ trợ hoán đổi tùy ý giữa ba hàng TCT. Rất hữu ích để so đánh đổi giữa độ linh hoạt và số linh kiện, không phải bản thiết kế DES 3 × 3 hoàn chỉnh. |

**R5 — đọc online, chưa lưu PDF:** Pachauri et al. (2019), *Experimental analysis to extract maximum power from PV array reconfiguration under partial shading conditions*, *Engineering Science and Technology* 22, 109–130, [bài gốc](https://doi.org/10.1016/j.jestch.2017.11.013). Thử dàn **3 × 3**, chuyển **SP ↔ TCT bằng bốn relay**, đối chiếu MATLAB và thực nghiệm qua GMPP, tổn hao, fill factor. Trong mô tả hệ thực nghiệm, **người vận hành quyết định chuyển qua nút bấm** sau khi xem áp/dòng; đây là đối chứng tốt cho PCB vài topology, chưa phải thuật toán tự tìm cấu hình. Trang nhà xuất bản mở toàn văn nhưng endpoint PDF chặn tải tự động tại thời điểm kiểm tra.

## Manh mối cho câu hỏi “khó ở đâu?”

1. **Không gian cấu hình phụ thuộc PCB.** Cần vẽ đồ thị các mối nối cho phép và bảng trạng thái switch trước khi chọn thuật toán. R1 cho thấy phải loại các hoán vị tương đương; R4 cho thấy giảm linh kiện sẽ giảm độ linh hoạt.
2. **Quan sát bóng che có chi phí.** R0 ước lượng bức xạ từng module; R1/R3 đo dòng ngắn mạch và phải dành thời gian cho phép đo; R4 suy ra từ áp từng module và dòng chung. Nhóm cần chọn một cách đo khả thi trên PCB của mình.
3. **Mục tiêu phải là điện thu được tại đầu ra hợp lệ.** Chỉ số cân bằng bức xạ EI trong R0 giúp sàng lọc, nhưng cần kiểm bằng GMPP hoặc điện năng theo thời gian, tính cả tổn hao dẫn, thời gian đo và chuyển mạch. R2/R4 đo hoặc mô phỏng đường P–V cho từng cấu hình.
4. **Bóng che đô thị cần bộ thử có hình dạng và thời gian.** R2/R3 gợi ý mẫu che hàng/cột, chéo, ngắn/dài, hẹp/rộng; thêm kịch bản mép bóng di chuyển qua dàn 3 × 3. Một cấu hình tốt với bóng cố định chưa chắc tốt khi bóng đổi liên tục. Bài R2 là ví dụ điển hình của giới hạn này.
5. **Kiểm tra điện áp/dòng của mọi trạng thái chuyển.** R4 phân tích switch ở các vị trí khác nhau chịu điện áp khác nhau; R3 có cách ly và bảo vệ cho hệ thử. Trước PCB phải chốt thông số tấm, dải vào bộ sạc/inverter, linh kiện đóng cắt và trình tự chuyển hợp lệ.

**Câu hỏi cần mang đến buổi chốt thiết kế:** Thầy muốn PCB **SP/TCT vài mode** (tham chiếu R5) hay **ma trận đổi nhóm từng tấm trong TCT** (tham chiếu R0)? Nếu chọn hướng sau, cần quyết định đo trạng thái tấm bằng cách nào, rồi mới có thể xác định số switch và thuật toán tương ứng.

## Tài liệu nền khác trong repo

- PV model trên Proteus: [PDF thầy cung cấp](A%20new%20model%20for%20a%20photovoltaic%20panel%20using%20Proteus%20software%20tool%20under_arbitrary%20environmental%20conditions.pdf) · [extract](extracted/01-pv-proteus/01-pv-proteus.md). Dùng để hiểu I–V/P–V; bài chỉ mô hình tấm PV, không dựng dàn bị che và ma trận switch.
- BMS + IoT: [PDF thầy cung cấp](Hybrid%20battery%20management%20system%20using%20the%20internet%20of_things.pdf) · [extract](extracted/02-bms-iot/02-bms-iot.md). Giữ để tham khảo tích hợp; BMS tự thiết kế không còn là trọng tâm GĐ1 theo [ghi chú mới](../info/qa2.md).
- [Sandia PVPMC — mismatch losses](https://pvpmc.sandia.gov/modeling-guide/3-dc-array-iv/mismatch-losses/): nguyên lý dòng chung của phần nối tiếp và áp chung của phần song song, nền cho việc hiểu tổn hao dưới bức xạ không đều.

*Cập nhật: 23/09/2026. Bốn PDF R1–R4 đã tải và trích xuất; R5 có trang bài gốc để đọc online.*
