function sl_new_model(name, cfg, vars)
%SL_NEW_MODEL  Tạo model trống với cấu hình solver dùng chung.
%   vars: struct các biến mặc định, ghi vào model workspace
%   (khi chạy, ghi đè bằng SimulationInput.setVariable(..., 'Workspace', name)).
if bdIsLoaded(name), close_system(name, 0); end
new_system(name);
set_param(name, 'StopTime', '1', 'MaxStep', num2str(cfg.maxstep), ...
    'RelTol', num2str(cfg.reltol), 'ReturnWorkspaceOutputs', 'on');
try, sl_simlog_on(name); catch, end   % chưa có block Simscape thì đặt lại lúc lưu / trước sim
set_param(name, 'SolverType', 'Variable-step');
for k = 1:numel(cfg.solver)
    try
        set_param(name, 'Solver', cfg.solver{k});
        break;
    catch
    end
end
if nargin > 2
    hws = get_param(name, 'ModelWorkspace');
    f = fieldnames(vars);
    for k = 1:numel(f), assignin(hws, f{k}, vars.(f{k})); end
end
end
