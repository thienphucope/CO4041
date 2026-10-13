function cfg = sl_config()
%SL_CONFIG  Cấu hình chung cho phần mô phỏng Simulink/Simscape.
%   Cần: MATLAB, Simulink, Simscape, Simscape Electrical.
%   Tùy chọn: Parallel Computing Toolbox (parsim).

cfg.here     = fileparts(fileparts(mfilename('fullpath')));   % thư mục gốc pvreconfig-sim
cfg.modeldir = fullfile(cfg.here, 'models');
cfg.resdir   = fullfile(cfg.here, 'results');
cfg.portmap  = fullfile(cfg.modeldir, 'portmap.mat');

cfg.mdl_array     = 'pv3x3';      % dàn 3x3 + 4 công tắc + nguồn quét (mức 1)
cfg.mdl_module    = 'pv1';        % 1 tấm + nguồn quét (PV-01..04)
cfg.mdl_transient = 'pv3x3_tr';   % dàn + tụ tấm + đường dây + pin, công tắc đổi theo thời gian (mức 3)
cfg.mdl_des       = 'pv3x3_des';  % ma trận DES 54 công tắc + nguồn quét (mức 4)

cfg.Vmax_array = 24;         % V, > Voc dàn (21,6 V)
cfg.Vmax_module = 8;         % V, > Voc tấm (7,2 V)
cfg.Vbat  = 13.0;            % V, điểm làm việc nếu ST-S1230 là PWM
cfg.T     = 25;              % °C
cfg.dV    = 0.05;            % V, lưới đều để tính chỉ tiêu

cfg.R_closed = 1e-3;         % Ohm, công tắc đóng (mô hình tham chiếu coi là lý tưởng)
cfg.G_open   = 1e-8;         % 1/Ohm, công tắc mở

cfg.solver   = {'daessc', 'ode23t'};   % thử lần lượt (daessc có từ R2021a)
cfg.maxstep  = 1e-3;         % s; ramp 0 -> Vmax trong 1 s => >= 1000 điểm trên đường I-V
cfg.reltol   = 1e-4;
cfg.parallel = false;        % true: dùng parsim (mỗi worker là 1 MATLAB, tốn RAM; 6 worker làm treo máy 13/10)

% Thư viện block (thử lần lượt, tên đường dẫn khác nhau giữa các bản)
cfg.lib.solar = {'ee_lib/Sources/Solar Cell', 'elec_lib/Sources/Solar Cell'};
cfg.lib.diode = {'ee_lib/Semiconductors & Converters/Diode', 'elec_lib/Semiconductor Devices/Diode'};
cfg.lib.sw    = {'fl_lib/Electrical/Electrical Elements/Switch'};
cfg.lib.cvs   = {'fl_lib/Electrical/Electrical Sources/Controlled Voltage Source'};
cfg.lib.res   = {'fl_lib/Electrical/Electrical Elements/Resistor'};
cfg.lib.gnd   = {'fl_lib/Electrical/Electrical Elements/Electrical Reference'};
cfg.lib.solvercfg = {'nesl_utility/Solver Configuration'};
cfg.lib.sps   = {'nesl_utility/Simulink-PS Converter'};
cfg.lib.psconst = {'fl_lib/Physical Signals/Sources/PS Constant'};
cfg.lib.connport = {'nesl_utility/Connection Port'};
cfg.lib.cap   = {'fl_lib/Electrical/Electrical Elements/Capacitor'};
cfg.lib.ind   = {'fl_lib/Electrical/Electrical Elements/Inductor'};

% Mức 3 (quá độ đóng cắt) - giả thiết, sửa khi có linh kiện thật
cfg.tr.Rsw   = 0.02;     % Ohm, 2 x R_DS(on) 10 mOhm (MOSFET đấu ngược)
cfg.tr.Cpv   = 5e-6;     % F, điện dung tương đương mỗi tấm (chưa đo; quét 1..10 uF)
cfg.tr.Rline = 0.05;     % Ohm, dây từ dàn tới bộ sạc
cfg.tr.Lline = 1e-6;     % H
cfg.tr.tend  = 0.03;     % s
cfg.tr.maxstep = 1e-5;   % s
end
