%RUN_REFERENCE  Mô hình tham chiếu (script thuần, chạy trên Octave/MATLAB lõi):
%   kiểm tra 1 tấm, kiểm tra solver, so sánh cấu hình -> ../results/arr_summary.csv
here = fileparts(mfilename('fullpath'));
addpath(here);
addpath(fullfile(here, '..'));           % các hàm dùng chung (tham số tấm, ca che, chỉ tiêu)
run_module_tests();
fprintf('\n');
run(fullfile(here, 'verify_sp.m'));
fprintf('\n');
run_compare();
