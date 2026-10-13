function sl_save_model(cfg, mdl)
%SL_SAVE_MODEL  Lưu model vào models/.
if ~exist(cfg.modeldir, 'dir'), mkdir(cfg.modeldir); end
sl_simlog_on(mdl);
save_system(mdl, fullfile(cfg.modeldir, [mdl '.slx']));
end
