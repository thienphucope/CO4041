# Dọn dẹp tài liệu và repo

**Ưu tiên:** trung bình · **Phụ trách:** biên tập (Hoàng Ngô Thiên Phúc) hoặc ai rảnh

## Tài liệu lỗi thời

- [ ] [`docs/info/huong-dan-simulink-pv3x3.md`](../../info/huong-dan-simulink-pv3x3.md): còn bộ 7 ca che có `rand`, khác bộ 9 ca của bảng tham chiếu. Nên sửa theo file bàn giao, hoặc chỉ giữ một file.
- [x] `docs/plan/proposal.md` (kế hoạch BMS/Proteus): đã xoá 30/10/2026; các link tới nó trong `docs/info/`, `docs/references/refs-extract.md`, `docs/archives/info-bms/` đã đổi thành ghi chú.
- [x] `docs/output/proposal.md`, `docs/output/simulation-guide.md` (phương án cũ): đã chuyển vào [`docs/archives/output-bms/`](../../archives/output-bms/) (30/10/2026).
- [ ] [`docs/info/core-pv-reconfig.md`](../../info/core-pv-reconfig.md): bổ sung kết quả DES và mức 2 ([undone/02](02-chay-muc-2-day-du.md)).
- [x] `proteus-sim/`, `tmp/`: đã xoá 30/10/2026.
- [x] `.octave/` (Octave portable, không dùng từ 12/10): đã xoá 30/10/2026, bỏ khỏi `.gitignore`, sửa mục 8 của `docs/info/huong-dan-simulink-pv3x3.md`.
- [ ] `report/proposal/graphics/`: chỉ `hcmut.png` đang được dùng; các ảnh còn lại giữ lại theo yêu cầu nhóm.

## Repo

- [x] Commit `pvreconfig-sim/`, `docs/info/*simulink*`, `docs/info/cai-dat-matlab.md`, `docs/progress/`, `pv3x3-3d.html`, `.gitignore`, `docs/info/info.md` (13/10/2026). `proteus-sim/` không commit, đã xoá.
- [x] `docs/references/Đồ án KTMT.mov` nặng **1,6 GB**: đã thêm `docs/references/*.mov` vào `.gitignore` (13/10).
- [x] `pvreconfig-sim/models/` (sinh ra từ code, ~1,4 MB) để trong `.gitignore`; `results/` (CSV, hình, log) có commit. Đổi lại nếu nhóm muốn lưu `.slx`.
- [ ] `docs/progress/`: mỗi khi xong một task, chuyển file từ `undone/` sang `done/` và cập nhật [README](../README.md).
