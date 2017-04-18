function [M, L, U] = BootstrapWeightsGabor(Test_Data, bootstrapsteps)

% TODO - different kernel widths each trial? allow 'ideal' arg to flag
% whether to use ideal_frame_signals?

[trials, frames] = size(Test_Data.frame_categories);
num_weights = frames + 1;
weight_matrix = zeros(bootstrapsteps, num_weights);

parfor i=1:bootstrapsteps
    % Randomly resample trials with replacement
    index = randi([1 trials], 1, trials);
    boot_choices = Test_Data.choice(index) == +1;
    boot_signals = Test_Data.ideal_frame_signals(index, :);
   
    % Temporal PK regression
    weights = CustomRegression.PsychophysicalKernel(boot_signals, boot_choices, 1, 0, 10);
    weight_matrix(i,:) = weights; 
end

[ M, L, U ] = meanci(weight_matrix, .68);

end