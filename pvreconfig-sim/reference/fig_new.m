function f = fig_new()
%FIG_NEW  Tạo figure ẩn để in ra file PNG.
%   Chạy được trên MATLAB và Octave có giao diện (qt). octave-cli dùng fltk không in được
%   figure ẩn -> báo lỗi rõ ràng để run_all bỏ qua bước vẽ.
if exist('OCTAVE_VERSION', 'builtin') ~= 0 && strcmp(graphics_toolkit(), 'fltk')
    error('fig_new:headless', ['octave-cli không in được hình ẩn (fltk). ' ...
        'Mở Octave có giao diện (octave.vbs) hoặc MATLAB rồi chạy lại hàm vẽ.']);
end
f = figure('Visible', 'off');
end
