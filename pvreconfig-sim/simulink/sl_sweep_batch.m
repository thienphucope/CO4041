function B = sl_sweep_batch(which, vars, Vg, opts)
%SL_SWEEP_BATCH  Chạy hàng loạt model có nguồn quét, trả về đường I-V trên lưới Vg.
%   B = sl_sweep_batch(which, vars, Vg, opts)
%   which : 'array' (pv3x3) | 'des' (pv3x3_des) | 'module' (pv1)
%   vars  : mảng struct, mỗi phần tử là các biến đặt cho một lần chạy (vd G, S hoặc G, R)
%   opts.switches : tên block công tắc cần lấy ứng suất (vd {'S1','S2','S3','S4'})
%   opts.panels   : true -> lấy điện áp từng tấm theo Vg
%   opts.closed   : N x nsw, công tắc nào đang đóng ở mỗi lần chạy (không có thì đoán theo |áp| < 10 mV)
%   B.I (nV x N, NaN ngoài vùng quét), B.err (cell), B.Imax/B.Umax (N x nsw, |dòng| khi đóng /
%   |áp| khi mở, trên vùng dàn phát 0..Voc), B.Ibat/B.Ubat (tại Vbat), B.Vp (3x3xnVxN)
if nargin < 4, opts = struct(); end
if ~isfield(opts, 'switches'), opts.switches = {}; end
if ~isfield(opts, 'panels'), opts.panels = false; end
cfg = sl_config();
mdl = cfg.(['mdl_' which]);
addpath(cfg.modeldir);
load_system(fullfile(cfg.modeldir, [mdl '.slx']));
N = numel(vars);
f = fieldnames(vars);
sw = opts.switches;  pan = opts.panels;
for j = N:-1:1
    in(j) = Simulink.SimulationInput(mdl);
    for q = 1:numel(f)
        in(j) = in(j).setVariable(f{q}, vars(j).(f{q}), 'Workspace', mdl);
    end
    in(j) = in(j).setPostSimFcn(@(o) sl_post_extract(o, sw, pan));
end
if cfg.parallel && ~isempty(ver('parallel')) && license('test', 'Distrib_Computing_Toolbox') && N > 4
    md = cfg.modeldir;  sd = fileparts(mfilename('fullpath'));
    out = parsim(in, 'ShowProgress', 'on', 'TransferBaseWorkspaceVariables', 'off', ...
        'SetupFcn', @() addpath(md, sd));
else
    out = sim(in, 'ShowProgress', 'on');
end

Vg = Vg(:);  nV = numel(Vg);  ns = numel(sw);
B.I = nan(nV, N);  B.err = cell(N, 1);
B.Imax = nan(N, ns);  B.Umax = B.Imax;  B.Ibat = B.Imax;  B.Ubat = B.Imax;
if pan, B.Vp = nan(3, 3, nV, N); end
for j = 1:N
    o = out(j);
    if ~isempty(o.ErrorMessage), B.err{j} = o.ErrorMessage; continue; end
    try
        e = o.ext;
    catch
        e = sl_post_extract(o, sw, pan);  e = e.ext;      % PostSimFcn không được áp dụng
    end
    if ~isempty(e.err), B.err{j} = e.err; continue; end
    V = e.V(:);  I = e.I(:);
    [~, i0] = min(abs(V));
    if I(i0) < 0, I = -I; end
    [Vu, iu] = unique(V);
    B.I(:, j) = interp1(Vu, I(iu), Vg, 'linear', NaN);
    gen = I >= 0;
    [~, ib] = min(abs(V - cfg.Vbat));
    for k = 1:ns
        si = abs(e.swi{k}(:));  sv = abs(e.swv{k}(:));
        if isfield(opts, 'closed')
            closed = repmat(logical(opts.closed(j, k)), size(sv));
        else
            closed = sv < 0.01;                % đóng: áp chỉ còn I * R_closed (vài mV)
        end
        if any(closed & gen),  B.Imax(j, k) = max(si(closed & gen));  end
        if any(~closed & gen), B.Umax(j, k) = max(sv(~closed & gen)); end
        if closed(ib), B.Ibat(j, k) = si(ib); else, B.Ubat(j, k) = sv(ib); end
    end
    if pan
        for r = 1:3
            for c = 1:3
                v = e.vp{r, c}(:);
                B.Vp(r, c, :, j) = interp1(Vu, v(iu), Vg, 'linear', NaN);
            end
        end
    end
end
end
