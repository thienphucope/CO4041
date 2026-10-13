function blk = sl_add(cfg, kind, blk, pos)
%SL_ADD  Thêm block loại `kind` (khóa trong cfg.lib) vào đường dẫn `blk`.
%   Thử lần lượt các đường dẫn thư viện trong cfg.lib.(kind).
cands = cfg.lib.(kind);
msg = '';
for k = 1:numel(cands)
    try
        add_block(cands{k}, blk, 'Position', pos);
        return;
    catch err
        msg = sprintf('%s\n  %s: %s', msg, cands{k}, err.message);
    end
end
error('sl_add:noLib', 'Không thêm được block "%s". Đã thử:%s', kind, msg);
end
