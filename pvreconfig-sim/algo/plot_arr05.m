function plot_arr05()
%PLOT_ARR05  Hình cho mức 2: bức xạ 9 tấm và công suất theo thời gian của các thuật toán chính.
%   Đọc results/arr05_traces.mat, ghi results/fig/arr05_<kịch bản>_<bộ sạc>.png.
root = setup_path();
figdir = fullfile(root, 'results', 'fig');
if ~exist(figdir, 'dir'), mkdir(figdir); end
s = load(fullfile(root, 'results', 'arr05_traces.mat'));
tr = s.traces;
show = {'cố định SP', 'cố định TCT', 'oracle (16 trạng thái)', 'quét 16, 5 s, MOSFET', ...
        'leo đồi 4 lân cận, 5 s', 'DES oracle (3025 cách)', 'DES EI min 3025, 2 s'};
scn = unique({tr.scenario}, 'stable');
chg = unique({tr.charger}, 'stable');
for i = 1:numel(scn)
    g = s.G.(strrep(scn{i}, '-', '_'));
    for j = 1:numel(chg)
        f = fig_new();
        subplot(2, 1, 1);
        plot(g.t, reshape(g.G, 9, []).', 'LineWidth', 1);
        grid on;  ylabel('G (W/m^2)');  title(sprintf('%s - bức xạ 9 tấm', scn{i}));
        subplot(2, 1, 2);  hold on;  leg = {};
        for a = 1:numel(show)
            q = find(strcmp({tr.scenario}, scn{i}) & strcmp({tr.charger}, chg{j}) & strcmp({tr.alg}, show{a}), 1);
            if isempty(q), continue; end
            x = tr(q).trace;
            plot(x.t, movmean_(x.p, 5), 'LineWidth', 1.2);  leg{end+1} = show{a}; %#ok<AGROW>
        end
        grid on;  box on;  xlabel('t (s)');  ylabel('P (W)');
        title(sprintf('Công suất, bộ sạc %s', chg{j}));
        legend(leg, 'Location', 'southwest', 'FontSize', 7);
        print(f, fullfile(figdir, sprintf('arr05_%s_%s.png', scn{i}, chg{j})), '-dpng', '-r110');
        close(f);
    end
end
fprintf('Đã ghi hình mức 2 vào results/fig/\n');
end

function y = movmean_(x, n)
% trung bình trượt (không phụ thuộc movmean, cho Octave cũ)
k = ones(n, 1) / n;
y = conv(x(:), k, 'same');
y(1:floor(n/2)) = x(1:floor(n/2));
y(end-floor(n/2)+1:end) = x(end-floor(n/2)+1:end);
end
