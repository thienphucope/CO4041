%SL_RUN_ALL  Toàn bộ phần Simulink (mức 1, 3, 4):
%   dựng model -> PV-01..04 -> quét 16 x 9 + ứng suất công tắc -> đối chiếu -> quá độ -> DES.
%   Lần đầu: dò thứ tự cổng (vài chục giây). Đổi phiên bản MATLAB thì chạy sl_build_model(true).
%   Mức 2 với bảng công suất lấy từ Simulink (lâu):  run_arr05(struct('source', 'simulink'))
setup_path();
sl_build_model();
sl_module_tests();
sl_run_compare();
sl_compare();
sl_transient_tests();
sl_des_check();
