function root = setup_path()
%SETUP_PATH  Thêm các thư mục con của pvreconfig-sim vào path. Mọi script run_* gọi hàm này trước.
%   reference/  mô hình vật lý tham chiếu (chạy cả Octave)
%   algo/       thuật toán chọn cấu hình theo thời gian, DES (chạy cả Octave)
%   simulink/   dựng và chạy model Simulink/Simscape (chỉ MATLAB)
root = fileparts(mfilename('fullpath'));
addpath(root, fullfile(root, 'reference'), fullfile(root, 'algo'));
if ~is_octave()
    addpath(fullfile(root, 'simulink'), fullfile(root, 'models'));
end
if ~exist(fullfile(root, 'results'), 'dir'), mkdir(fullfile(root, 'results')); end
end

function t = is_octave()
t = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end
