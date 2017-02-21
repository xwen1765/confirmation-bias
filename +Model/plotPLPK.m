function plotPLPK(trials, frames, prior, likelihood, params, ideal_observer, pk_hprs, fit_pk, optimize, optim_grid_size, pk_colormap)

savedir = fullfile('+Model', 'figures');
if ~exist(savedir, 'dir'), mkdir(savedir); end
if nargin < 8, fit_pk = false; end
if nargin < 9, optimize = {}; end
if nargin < 10, optim_grid_size = 11; end

optim_prefix = Model.getOptimPrefix(optimize, optim_grid_size);

% Keep in sync with plotPLSpace
if ~ideal_observer
    figname = sprintf('PLSpace_%dx%d_%s_vx%.2f_pD%.2f_gam%.2f_ns%d_b%d.fig', ...
        trials, frames, optim_prefix, params.var_x, params.prior_D, ...
        params.gamma, params.samples, params.batch);
else
    figname = sprintf('PLSpace_%dx%d_vx%.2f_ideal.fig', trials, frames, params.var_x);
end

if ~exist(fullfile(savedir, figname), 'file')
    Model.plotPriorLikelihoodSpace(trials, frames, prior, likelihood, params, ideal_observer, false, optimize, optim_grid_size);
    close all;
end

pl_fig = openfig(fullfile(savedir, figname));
img_ax = findobj(pl_fig, 'Type', 'axes');
hold(img_ax, 'on');

[x, y] = getpts(img_ax);
npts = length(x);

like_pts = round(100*interp1(1:length(likelihood), likelihood, x, 'linear', 'extrap'))/100;
pri_pts = round(100*interp1(1:length(prior), prior, y, 'linear', 'extrap'))/100;

% 'snap' selected points to the given 'prior' and 'likelihood' grids.
like_pts = arrayfun(@(l) closest(likelihood, l), like_pts);
pri_pts = arrayfun(@(l) closest(prior, l), pri_pts);

pk_fig = figure;
pk_ax = axes(pk_fig);

if nargin < 11
    % create pk_colormap that is dark blue -> dark red
    fade = linspace(0, 1, npts)';
    colors = [fade*170/255, zeros(size(fade)), (1-fade)*170/255];
else
    colors = pk_colormap(npts);
end

xs = 1:frames;
for i=1:length(like_pts)
    l = like_pts(i);
    p = pri_pts(i);
    [~, il] = min(abs(likelihood-l));
    [~, ip] = min(abs(prior - p));
    scatter(img_ax, il, ip, 50, colors(i,:), 'filled');
    
    params.p_match = p;
    params.var_e = Model.getEvidenceVariance(l);
    [weights, errors, expfit, tmp_fig] = Model.plotSamplingPK(trials, frames, params, pk_hprs, ideal_observer, optimize, optim_grid_size);
    close(tmp_fig);
    hold(pk_ax, 'on');
    if fit_pk
        weights = expfit(1)+expfit(2)*exp(-xs/expfit(3));
        plot(pk_ax, xs, weights / max(weights), '-', 'Color', colors(i,:));
    else
        errorbar(weights, errors, 'Color', colors(i,:), 'LineWidth', 2);
    end
end

ylim(pk_ax, [0 inf]);

end