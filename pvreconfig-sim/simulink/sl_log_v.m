function v = sl_log_v(node)
%SL_LOG_V  Điện áp hai cực của một block từ Simscape log.
%   Dùng biến v nếu block có (Switch, CVS...); nếu không (Solar Cell trên R2026b chỉ
%   log điện thế nút p, n) thì lấy p.v - n.v.
if any(strcmp(node.childIds, 'v'))
    v = node.v.series.values('V');
else
    v = node.p.v.series.values('V') - node.n.v.series.values('V');
end
end
