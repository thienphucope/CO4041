function name = sl_set(blk, promptRe, value, unit, optional)
%SL_SET  Đặt tham số block theo chữ hiển thị trên hộp thoại (prompt).
%   name = sl_set(blk, promptRe, value)              popup: value là regex chọn mục
%   name = sl_set(blk, promptRe, value, unit)        kèm đơn vị (vd 'W/m^2', 'degC')
%   name = sl_set(blk, promptRe, value, unit, true)  không báo lỗi nếu block không có ô này
%   Tên biến nội bộ của block Simscape đổi giữa các phiên bản, còn prompt thì ổn định hơn,
%   nên tìm ô theo prompt. Trả về tên biến nội bộ ('' nếu không có).

if nargin < 4, unit = ''; end
if nargin < 5, optional = false; end

dp = get_param(blk, 'DialogParameters');
f = fieldnames(dp);
name = '';
for k = 1:numel(f)
    if endsWith(f{k}, '_unit') || endsWith(f{k}, '_conf'), continue; end
    if ~isempty(regexpi(dp.(f{k}).Prompt, promptRe, 'once'))
        name = f{k};
        break;
    end
end
if isempty(name)
    if optional, return; end
    error('sl_set:noParam', 'Block "%s" không có ô nào khớp /%s/.\nCác ô hiện có:\n%s', ...
        blk, promptRe, list_prompts(dp));
end

% R2026b+: ô popup của block Simscape có Type 'string', giá trị là tên enum đầy đủ
% (vd 'ee.enum.sources.solar_cell_prm.datasheet') -> chọn theo tên thành viên enum.
cur = get_param(blk, name);
if ~strcmp(dp.(name).Type, 'enum') && ischar(cur) && contains(cur, '.enum.') && ~isnumeric(value)
    cls = regexprep(cur, '\.[^.]*$', '');
    [~, mem] = enumeration(cls);
    j = find(~cellfun(@isempty, regexpi(mem, value, 'once')), 1);
    if isempty(j)
        error('sl_set:noOption', 'Ô "%s" của "%s" không có lựa chọn khớp /%s/. Lựa chọn: %s', ...
            dp.(name).Prompt, blk, value, strjoin(mem', ' | '));
    end
    set_param(blk, name, [cls '.' mem{j}]);
    return;
end

if strcmp(dp.(name).Type, 'enum')
    opts = dp.(name).Enum;
    j = find(~cellfun(@isempty, regexpi(opts, value, 'once')), 1);
    if isempty(j)
        error('sl_set:noOption', 'Ô "%s" của "%s" không có lựa chọn khớp /%s/. Lựa chọn: %s', ...
            dp.(name).Prompt, blk, value, strjoin(opts, ' | '));
    end
    set_param(blk, name, opts{j});
    return;
end

if isnumeric(value), value = num2str(value, '%.10g'); end
set_param(blk, name, value);
if ~isempty(unit)
    try
        set_param(blk, [name '_unit'], unit);
    catch
        warning('sl_set:unit', 'Không đặt được đơn vị "%s" cho ô "%s" của "%s"; kiểm tra tay.', ...
            unit, dp.(name).Prompt, blk);
    end
end
end

function s = list_prompts(dp)
f = fieldnames(dp);
s = '';
for k = 1:numel(f)
    s = sprintf('%s  %-22s %s\n', s, f{k}, dp.(f{k}).Prompt);
end
end
