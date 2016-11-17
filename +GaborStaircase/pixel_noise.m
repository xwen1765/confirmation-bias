function GaborData = pixel_noise(GaborData)
%PIXEL_NOISE updates staircase-able parameters (contrast, ratio, and
%pixel_noise) in GaborData for the current trial based on the results of
%the previous trial. Only pixel_noise may change to alter the difficulty.
%Requires the following are already set appropriately:
%
% GaborData.contrast(trial-1)
% GaborData.ratio(trial-1)
% GaborData.pixel_noise(trial-1)
% GaborData.step_size(trial-1)
% GaborData.streak(trial)
% GaborData.reversal_counter(trial)
%
%Computes and sets the following:
%
% GaborData.contrast(trial)
% GaborData.ratio(trial)
% GaborData.pixel_noise(trial)
% GaborData.step_size(trial)

trial = GaborData.current_trial;

%% Copy over params - contrast may be overwritten below
GaborData.contrast(trial) = GaborData.contrast(trial-1);
GaborData.ratio(trial) = GaborData.ratio(trial-1);
GaborData.pixel_noise(trial) = GaborData.pixel_noise(trial-1);

%% Reduce step size after 10 reversals
if GaborData.reversal_counter(trial) > 0 && mod(GaborData.reversal_counter(trial), 10) == 0
    % Decay the step size half way towards 0
    GaborData.step_size(trial) = GaborData.step_size(trial-1) / 2;
else
    % Same step size as last trial
    GaborData.step_size(trial) = GaborData.step_size(trial-1);
end

%% Apply staircase logic
if GaborData.streak(trial) == 0
    % Got it wrong - make things easier
    GaborData.pixel_noise(trial) = ...
        GaborData.step_size(trial) + GaborData.pixel_noise(trial-1);
elseif mod(GaborData.streak(trial), 2) == 0
    % Got 2 right in a row - make things harder
    GaborData.pixel_noise(trial) = ...
        GaborData.step_size(trial) - GaborData.pixel_noise(trial-1);
end

% Apply bounds
GaborData.pixel_noise(trial) = ...
    max(GaborData.pixel_noise(trial), GaborData.stair_bounds(1));
GaborData.pixel_noise(trial) = ...
    min(GaborData.pixel_noise(trial), GaborData.stair_bounds(2));

end