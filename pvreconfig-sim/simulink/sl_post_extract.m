function s = sl_post_extract(out, sw, panels)
%SL_POST_EXTRACT  PostSimFcn: rút dữ liệu cần từ Simscape log rồi bỏ log (đỡ tốn bộ nhớ khi parsim).
%   s.ext.V, s.ext.I : điện áp, dòng của nguồn quét CVS (chưa chuẩn hóa dấu)
%   s.ext.swi{k}, s.ext.swv{k} : dòng, áp của công tắc tên sw{k}
%   s.ext.vp{r,c}    : điện áp Solar Cell tấm PVrc (nếu panels = true)
e = struct('V', [], 'I', [], 'swi', {{}}, 'swv', {{}}, 'vp', {{}}, 'err', '');
try
    lg = out.simlog;
    e.V = lg.CVS.v.series.values('V');
    e.I = lg.CVS.i.series.values('A');
    for k = 1:numel(sw)
        e.swi{k} = lg.(sw{k}).i.series.values('A');
        e.swv{k} = sl_log_v(lg.(sw{k}));
    end
    if panels
        e.vp = cell(3);
        for r = 1:3
            for c = 1:3
                e.vp{r, c} = sl_log_v(lg.(sprintf('PV%d%d', r, c)).SC);
            end
        end
    end
catch err
    e.err = err.message;
end
s.ext = e;
end
