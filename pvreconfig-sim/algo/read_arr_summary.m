function A = read_arr_summary(file)
%READ_ARR_SUMMARY  Đọc results/arr_summary*.csv (chạy cả Octave, không cần readtable).
%   A.case (cell), A.state, A.label (cell), A.Pmax, A.Vmpp, A.npk, A.Pbat (cột vector)
fid = fopen(file, 'r');
if fid < 0, error('read_arr_summary: không mở được %s', file); end
fgetl(fid);
c = textscan(fid, '%s %f %f %f %f %f %s %f %f %f %f %f', 'Delimiter', ',');
fclose(fid);
A.case = c{1};  A.state = c{2};  A.label = c{7};
A.Pmax = c{8};  A.Vmpp = c{9};  A.npk = c{10};  A.Pbat = c{11};
end
