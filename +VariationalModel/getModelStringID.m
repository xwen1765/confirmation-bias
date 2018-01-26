function name = getModelStringID(params)
name = sprintf('%dx%d_cinfo%.3f_sinfo%.3f_vs%.2f_vx%.2f_pm%.2f_pC%.2f_u%d_gam%.2f', ...
    params.trials, params.frames, params.category_info, params.sensory_info, params.var_s, ...
    params.var_x, params.p_match, params.prior_C, params.updates, params.gamma);
end