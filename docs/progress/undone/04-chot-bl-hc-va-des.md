# Chốt mẫu BL/HC và quyết định có làm DES trong GĐ1

**Ưu tiên:** trung bình · **Phụ trách:** cả nhóm; cần hỏi giảng viên

## Việc cần làm

- [ ] Đối chiếu Fig. 4 của Ref 3 (`docs/references/extracted/03-pv-reconfig/images/p06-img01-x157.png`) để chốt mẫu công tắc của **BL** và **HC** với dàn 3 cột.
  - Hiện đang gán BL = `1001`; HC = `0110` là tạm, chưa xác nhận.
  - Vì mô phỏng đã quét đủ 16 trạng thái, đổi nhãn chỉ cần sửa `pvreconfig-sim/pv_states.m`.
- [ ] Hỏi giảng viên: GĐ1 có làm **DES** (đổi nhóm từng tấm, 54 công tắc) hay chỉ dừng ở 4 công tắc nối chéo?
  - Số liệu để trình bày: [done/06](../done/06-des-tinh-muc-4.md). DES giúp được ca che nguyên hàng (+18 %) và ca `goc-2x2` (+24 % khi cho hàng không đều).
  - Đổi lại, DES cần nhiều công tắc và kênh đo hơn hẳn, và tại 13 V có ca vẫn thua SP.
  - Tổn hao ước lượng khi nắng đủ: 18 công tắc đóng × 2,5² × 20 mΩ ≈ 2,25 W, cộng mạch kích ≈ 0,6 W (18 photovoltaic driver × 10 mA × 3,3 V), tổng ≈ 3 W ≈ 2 % của 135 W. Số R_on và dòng LED là giả thiết.
  - Điều khiển: 54 tín hiệu vượt số GPIO của ESP32. Mã hóa 2 bit mỗi tấm (18 bit) qua thanh ghi dịch, rồi bộ giải mã 1-trong-3 cho mỗi tấm. Bộ giải mã đồng thời là khóa phần cứng: một tấm không thể nối vào hai hàng cùng lúc.
- [ ] Nếu làm DES: chốt có cho phép các hàng có số tấm khác nhau không. Chuyện này ảnh hưởng số công tắc và cách khóa an toàn của PCB.
- [ ] Ghi quyết định vào [`docs/info/qa2.md`](../../info/qa2.md) hoặc một file Q&A mới.
