function sl_simlog_on(mdl)
%SL_SIMLOG_ON  Bật Simscape log (simlog) cho model.
%   Tham số SimscapeLog* chỉ có sau khi model đã chứa block Simscape
%   (model mới tạo bằng new_system chưa có), nên gọi sau khi thêm block, trước sim/lưu.
set_param(mdl, 'SimscapeLogType', 'all', 'SimscapeLogName', 'simlog');
end
