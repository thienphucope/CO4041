function sl_line(sys, h1, h2)
%SL_LINE  Nối hai cổng (handle) trong hệ `sys`.
add_line(sys, h1, h2, 'autorouting', 'on');
end
