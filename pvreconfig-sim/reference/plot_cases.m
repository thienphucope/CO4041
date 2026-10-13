function plot_cases()
%PLOT_CASES  Hình P-V cho từng ca che bóng: SP, TCT, BL, trạng thái 4 công tắc tốt nhất, DES tốt nhất.
%   Vạch đứng tại Vbat = 13 V (bộ sạc PWM). Ghi results/fig/pv_<ca>.png.
root = setup_path();
figdir = fullfile(root, 'results', 'fig');
if ~exist(figdir, 'dir'), mkdir(figdir); end
p = pv_module_params();
cases = pv_shading_cases();
[states, labels] = pv_states();
A = read_arr_summary(fullfile(root, 'results', 'arr_summary.csv'));
D = des_partitions();
V = (0:0.1:22)';
for k = 1:numel(cases)
    G = cases(k).G;
    ia = find(strcmp(A.case, cases(k).name));
    [~, ib] = max(A.Pmax(ia));
    sel = unique([1, 16, bin2dec('1001') + 1, ib]);
    [Pm, ~] = pv_des_eval(pv_des_subsets(G, p), D.M, 13);
    [~, id] = max(Pm);
    f = fig_new();
    hold on;  leg = {};
    for s = sel
        I = pv_array_iv(V, G, states(s, :), p);
        plot(V, V .* I, 'LineWidth', 1.4);  leg{end+1} = labels{s}; %#ok<AGROW>
    end
    I = pv_des_curve(G, D.M(id, :), p, 25, V);
    plot(V, V .* I, 'k--', 'LineWidth', 1.4);  leg{end+1} = 'DES tốt nhất';
    yl = ylim;  plot([13 13], [0 yl(2)], ':', 'Color', [0.5 0.5 0.5]);
    ylim([0 yl(2)]);  grid on;  box on;
    xlabel('V (V)');  ylabel('P (W)');
    title(sprintf('%s - %s', cases(k).name, cases(k).desc));
    legend(leg, 'Location', 'northwest');
    print(f, fullfile(figdir, sprintf('pv_%s.png', cases(k).name)), '-dpng', '-r110');
    close(f);
end
fprintf('Đã ghi %d hình P-V vào results/fig/\n', numel(cases));
end
