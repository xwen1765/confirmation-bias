if exist('psignifit', 'file')~=2, addpath('psignifit-master'); end
if exist('smoothn', 'file')~=2, addpath('smoothn'); end
if exist('fadecolors', 'file')~=2, addpath('tools'); end
if exist('boundedline', 'file')~=2
    D = dir(fullfile('tools', 'boundedline-pkg'));
    for i=1:length(D)
        if D(i).isdir
            addpath(fullfile('tools', 'boundedline-pkg', D(i).name));
        end
    end
end

%% Create useful workspace variables for analysis

ratioSubjects = arrayfun(@(i) sprintf('bpgFinaltest-subject%02d', i), 2:11, 'UniformOutput', false);
noiseSubjects = arrayfun(@(i) sprintf('bpgFinaltest-subject%02d', i), [2:6 8:14], 'UniformOutput', false);

% informed is the opposite of naive
informedSubjects = arrayfun(@(i) sprintf('bpgFinaltest-subject%02d', i), [7 8 9], 'UniformOutput', false);

naiveRatioSubjects = setdiff(ratioSubjects, informedSubjects);
naiveNoiseSubjects = setdiff(noiseSubjects, informedSubjects);
naiveBothSubjects = intersect(naiveRatioSubjects, naiveNoiseSubjects);