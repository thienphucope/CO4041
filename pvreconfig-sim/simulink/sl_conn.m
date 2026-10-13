function h = sl_conn(blk)
%SL_CONN  Mọi cổng vật lý (Simscape) của block, theo thứ tự [LConn RConn].
%   Thứ tự này không cho biết cổng nào là +, -, hay tín hiệu; phần đó do
%   sl_calibrate_ports dò và lưu trong models/portmap.mat.
ph = get_param(blk, 'PortHandles');
h = [ph.LConn(:); ph.RConn(:)].';
end
