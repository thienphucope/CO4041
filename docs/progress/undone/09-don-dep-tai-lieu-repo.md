# Dọn dẹp tài liệu và repo

**Ưu tiên:** trung bình · **Phụ trách:** biên tập (Hoàng Ngô Thiên Phúc) hoặc ai rảnh

## Tài liệu lỗi thời

- [ ] [`docs/info/huong-dan-simulink-pv3x3.md`](../../info/huong-dan-simulink-pv3x3.md): còn bộ 7 ca che có `rand`, khác bộ 9 ca của bảng tham chiếu. Nên sửa theo file bàn giao, hoặc chỉ giữ một file.
- [ ] [`docs/plan/proposal.md`](../../plan/proposal.md): còn kế hoạch theo phương án BMS/Proteus. Cần ghi chú "lịch sử" hoặc viết lại theo phạm vi PV reconfiguration.
- [ ] [`docs/output/proposal.md`](../../output/proposal.md), [`docs/output/simulation-guide.md`](../../output/simulation-guide.md): bản Markdown của phương án cũ. Cân nhắc chuyển vào `docs/archives/`.
- [ ] [`docs/info/core-pv-reconfig.md`](../../info/core-pv-reconfig.md): bổ sung kết quả DES và mức 2 khi đã chạy.
- [ ] `proteus-sim/`: dự án Proteus của phương án cũ. Quyết định giữ, chuyển vào archives, hay xóa.

## Repo

- [x] Commit `pvreconfig-sim/`, `docs/info/*simulink*`, `docs/info/cai-dat-matlab.md`, `docs/progress/`, `pv3x3-3d.html`, `.gitignore`, `docs/info/info.md` (13/10/2026). Còn `proteus-sim/` chưa commit, chờ quyết định ở mục trên.
- [x] `docs/references/Đồ án KTMT.mov` nặng **1,6 GB**: đã thêm `docs/references/*.mov` vào `.gitignore` (13/10).
- [x] `pvreconfig-sim/models/` (sinh ra từ code, ~1,4 MB) để trong `.gitignore`; `results/` (CSV, hình, log) có commit. Đổi lại nếu nhóm muốn lưu `.slx`.
- [ ] `docs/progress/`: mỗi khi xong một task, chuyển file từ `undone/` sang `done/` và cập nhật [README](../README.md).
