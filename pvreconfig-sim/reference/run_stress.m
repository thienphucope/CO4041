function R = run_stress()
%RUN_STRESS  Ứng suất công tắc nối chéo để chọn linh kiện (MOSFET đấu ngược / relay).
%   Quét 16 trạng thái x (9 ca che bóng + 17 ca cực đoan: tấm tối hẳn G = 0, hàng/cột tối, bàn cờ)
%   trên toàn dải V = 0 .. Voc dàn. Lấy:
%     Imax(k) : |dòng| lớn nhất qua Sk khi đóng
%     Umax(k) : |điện áp| lớn nhất trên Sk khi mở (quyết định V_DS của MOSFET)
%     và các giá trị tại V = Vbat (13 V, khi ST-S1230 là PWM).
%   Ghi results/switch_stress.csv. Công tắc lý tưởng; tổn hao dẫn = I^2 * R_on tính sau từ Imax.
root = setup_path();
p = pv_module_params();
[states, labels] = pv_states();
cs = pv_shading_cases();
F = 1000;
ext = struct('name', {}, 'desc', {}, 'G', {});
for j = 1:9
    G = F * ones(3);  G(j) = 0;
    [r, c] = ind2sub([3 3], j);
    ext(end+1) = struct('name', sprintf('toi-%d%d', r, c), 'desc', 'một tấm tối hẳn', 'G', G); %#ok<AGROW>
end
for r = 1:3
    G = F * ones(3);  G(r, :) = 0;
    ext(end+1) = struct('name', sprintf('toi-hang%d', r), 'desc', 'hàng tối', 'G', G); %#ok<AGROW>
end
for c = 1:3
    G = F * ones(3);  G(:, c) = 0;
    ext(end+1) = struct('name', sprintf('toi-cot%d', c), 'desc', 'cột tối', 'G', G); %#ok<AGROW>
end
ext(end+1) = struct('name', 'ban-co', 'desc', 'bàn cờ', 'G', F * [1 0 1; 0 1 0; 1 0 1]);
ext(end+1) = struct('name', 'cheo-phu', 'desc', 'chéo phụ tối', 'G', F * (1 - fliplr(eye(3))));
allc = [rmfield(cs, 'desc'), rmfield(ext, 'desc')];

V = (0:0.1:23.5)';
Vbat = 13;
nC = numel(allc);  nS = 16;
Imax = nan(nC, nS, 4);  Umax = Imax;  Ibat = Imax;  Ubat = Imax;
t0 = tic;
for k = 1:nC
    for s = 1:nS
        st = pv_switch_stress(V, allc(k).G, states(s, :), p);
        gen = st.Iarr >= 0;                       % vùng dàn phát điện: 0 .. Voc
        [~, ib] = min(abs(V - Vbat));
        Imax(k, s, :) = max(abs(st.I(gen, :)), [], 1);
        Umax(k, s, :) = max(abs(st.U(gen, :)), [], 1);
        Ibat(k, s, :) = abs(st.I(ib, :));
        Ubat(k, s, :) = abs(st.U(ib, :));
    end
end
fprintf('Đã quét %d ca x %d trạng thái trong %.0f s\n', nC, nS, toc(t0));

fid = fopen(fullfile(root, 'results', 'switch_stress.csv'), 'w');
fprintf(fid, 'case,state,label,Imax_S1,Imax_S2,Imax_S3,Imax_S4,Umax_S1,Umax_S2,Umax_S3,Umax_S4,Ibat_S1,Ibat_S2,Ibat_S3,Ibat_S4,Ubat_S1,Ubat_S2,Ubat_S3,Ubat_S4\n');
for k = 1:nC
    for s = 1:nS
        fprintf(fid, '%s,%d,%s', allc(k).name, s - 1, labels{s});
        fprintf(fid, ',%.4f', squeeze(Imax(k, s, :)), squeeze(Umax(k, s, :)), squeeze(Ibat(k, s, :)), squeeze(Ubat(k, s, :)));
        fprintf(fid, '\n');
    end
end
fclose(fid);

fprintf('\n== Ứng suất lớn nhất mỗi công tắc (mọi ca, mọi trạng thái, V = 0 .. Voc)\n');
fprintf('%-4s %9s  %-24s %9s  %-24s\n', 'Sk', '|I| max', '(ca, trạng thái)', '|U| max', '(ca, trạng thái)');
for q = 1:4
    [im, ii] = max(reshape(Imax(:, :, q), [], 1));  [ki, si] = ind2sub([nC nS], ii);
    [um, iu] = max(reshape(Umax(:, :, q), [], 1));  [ku, su] = ind2sub([nC nS], iu);
    fprintf('S%-3d %7.2f A  %-24s %7.2f V  %-24s\n', q, im, [allc(ki).name ', ' labels{si}], ...
        um, [allc(ku).name ', ' labels{su}]);
end
fprintf('Tại Vbat = %.0f V: |I| max = %.2f A, |U| max = %.2f V\n', Vbat, max(Ibat(:)), max(Ubat(:)));
fprintf('Đã ghi results/switch_stress.csv\n');
R = struct('cases', {{allc.name}}, 'Imax', Imax, 'Umax', Umax, 'Ibat', Ibat, 'Ubat', Ubat);
end
