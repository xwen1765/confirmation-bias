function [weights, errors, expfit, fig] = plotSamplingPK(trials, frames, params, pk_hprs)
%PLOTSAMPLINGPK(trials, frames, params, [recompute]) run (or load) sampling
%model and plot PK for the given params.

savedir = fullfile('+Model', 'figures');
if ~exist(savedir, 'dir'), mkdir(savedir); end

[data, prefix] = Model.genDataWithParams(trials, frames, params);

string_id = Model.getModelStringID(prefix, params);

[results, data] = Model.loadOrRunSamplingModel(data, prefix, params);
[weights, errors, expfit, pk_id] = Model.loadOrRunModelPK(string_id, data, results, pk_hprs);
weights = weights(1:end-1);
errors = errors(1:end-1);

xs = linspace(0, length(weights));
fit = expfit(1) + expfit(2) * exp(-xs / expfit(3));

savefile = fullfile(savedir, [pk_id '.fig']);

fig = figure(); hold on;
plot(xs, fit, '--r', 'LineWidth', 2);
errorbar(weights, errors);
legend('fit', 'weights');
xlabel('time');
ylabel('weight');
ylim(1.1*[-abs(max(weights)+max(errors)) abs(max(weights) + max(errors))]);
title(['PK ' strrep(pk_id, '_', ' ')]);
saveas(fig, savefile);

end