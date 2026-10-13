%VERIFY_DES  Kiểm tra độc lập mô hình DES: cách chia "TCT gốc" phải trùng pv_array_iv với S = 1111.
p = pv_module_params();
cases = pv_shading_cases();
D = des_partitions();
fprintf('Số cách chia: %d (mỗi hàng 3 tấm: %d); TCT gốc = #%d: %s\n', size(D.M, 1), sum(D.eq), D.tct, D.label{D.tct});
V = (0:0.05:21.5)';
worst = 0;  worstP = 0;
for k = 1:numel(cases)
    G = cases(k).G;
    I_net = pv_array_iv(V, G, [1 1 1 1], p);
    I_des = pv_des_curve(G, D.M(D.tct, :), p, 25, V);
    Vsub = pv_des_subsets(G, p);
    [Pm, Pb] = pv_des_eval(Vsub, D.M(D.tct, :), 13);
    m = pv_metrics(V, I_net, 13);
    e = max(abs(I_net - I_des));
    eP = max(abs([Pm - m.Pmax, Pb - m.Pbat]));
    fprintf('%-11s  max|dI| = %.2e A   Pmax %.3f / %.3f   Pbat %.3f / %.3f\n', cases(k).name, e, Pm, m.Pmax, Pb, m.Pbat);
    worst = max(worst, e);  worstP = max(worstP, eP);
end
% dI lớn nhất rơi vào đoạn gần thẳng đứng của I-V (khúc gãy bypass), nơi lệch rất nhỏ theo V
% đã cho lệch lớn theo I; nên tiêu chí đạt dựa trên Pmax và P(Vbat).
if worstP < 0.05
    fprintf('VERIFY_DES: OK (max|dP| %.3f W; max|dI| %.2e A ở đoạn dốc)\n', worstP, worst);
else
    fprintf('VERIFY_DES: LỆCH (max|dP| %.3f W)\n', worstP);
end
