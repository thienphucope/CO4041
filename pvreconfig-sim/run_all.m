%RUN_ALL  Chạy mọi mức mô phỏng (MATLAB).
%   Mức 1  tĩnh: 16 trạng thái 4 công tắc x 9 ca che     (tham chiếu + Simulink)
%          ứng suất công tắc để chọn linh kiện              (tham chiếu + Simulink)
%   Mức 2  bóng di chuyển + thuật toán chọn cấu hình       (algo/, bảng công suất từ tham chiếu)
%   Mức 3  quá độ khi đóng/cắt                              (Simulink)
%   Mức 4  DES: đổi nhóm từng tấm giữa 3 hàng              (tham chiếu + kiểm tra Simulink)
%   Phần Simulink tự bỏ qua nếu thiếu Simulink / Simscape / Simscape Electrical.
root = setup_path();
t0 = tic;
fprintf('\n######## Mức 1 - tham chiếu\n');
run(fullfile(root, 'reference', 'run_reference.m'));
run_stress();
fprintf('\n######## Mức 4 - DES (tĩnh)\n');
verify_des;
run_des();
fprintf('\n######## Mức 2 - thuật toán theo thời gian\n');
run_arr05();
fprintf('\n######## Hình cho báo cáo\n');
try
    plot_cases();
    plot_arr05();
catch err
    fprintf('Bỏ qua bước vẽ: %s\n', err.message);
end
if license('test', 'Simulink') && license('test', 'Simscape') && exist('ee_lib', 'file') == 4
    fprintf('\n######## Simulink (mức 1, 3, 4)\n');
    run(fullfile(root, 'simulink', 'sl_run_all.m'));
else
    fprintf('\n(Bỏ qua phần Simulink: cần Simulink + Simscape + Simscape Electrical)\n');
end
fprintf('\nXong sau %.1f phút. Kết quả trong results/\n', toc(t0) / 60);
