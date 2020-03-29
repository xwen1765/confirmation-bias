function [floor, thresh, fit_result] = getThresholdWindow(SubjectData, phase, perf_lo, perf_hi, memodir)
%GABORANALYSIS.GETTHRESHOLDWINDOW return [low_signal, high_signal] range of signal values
%corresponding to the given performance levels. (Think of this function as inverting the
%psychometric curve).

if ~exist('memodir', 'var'), memodir = fullfile(pwd, '..', 'Precomputed'); end
if ~exist(memodir, 'dir'), mkdir(memodir); end

if phase == 0
    stair_var = 'contrast';
elseif phase == 1
    stair_var = 'true_ratio';
elseif phase == 2
    stair_var = 'noise';
else
    error('Expected phase 0 for Contrast or 1 for Ratio or 2 for Noise');
end

% Use PM fit to get floor and threshold
[fit_result, ~, ~, ~] = LoadOrRun(@GaborPsychometric, ...
    {SubjectData, phase}, ...
    fullfile(memodir, ['PM-' stair_var '-' SubjectData.subjectID '.mat']));
try
    floor = getThreshold(fit_result, perf_lo, false);
catch
    warning('Subject performance never went below %.2f - using min for floor', perf_lo);
    floor = min(SubjectData.(stair_var));
end
try
    thresh = getThreshold(fit_result, perf_hi, false);
catch
    warning('Subject performance never went below %.2f - using max for threshold', perf_hi);
    thresh = max(SubjectData.(stair_var));
end

% Adjust from '#clicks' to threshold
if phase == 1
    floor = 1 - thresh;
end
end