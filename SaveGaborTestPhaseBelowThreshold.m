function [Test_Data, image_collection_test] = SaveGaborTestPhaseBelowThreshold(subjectID, phase, threshold, directory)

cd(fullfile(directory, 'Code'));
savedir = fullfile(directory, 'RawData');
if ~exist(savedir, 'dir'), mkdir(savedir); end

if phase == 0
    postfix = '-GaborDataContrast.mat';
    postfix_test = '-GaborTestContrast.mat';
    stair_param = 'contrast';
elseif phase == 1
    postfix = '-GaborDataRatio.mat';
    postfix_test = '-GaborTestRatio.mat';
    stair_param = 'ratio';
end

filename = fullfile(directory, 'RawData', [subjectID postfix]);
if ~exist(filename, 'file')
    disp(strcat('ERROR! Missing File: ', filename));  % Return an error message for missing file
    disp(strcat('Maybe the Preliminary phase is saved under a different name?'));
    return;
else
    contents = load(filename); % Load Preliminary_Data and image_collection
end

Data = contents.Preliminary_Data;
image_collection = contents.image_collection;

test_trials = Data.(stair_param) < threshold;
elements = sum(test_trials);

%% Copy from image_collection to image_collection_test

image_collection_test = image_collection(test_trials, :, :, :);

%% Copy from Data to Test_Data

Test_Data.move_on = Data.move_on(test_trials);
Test_Data.step_size = Data.step_size(test_trials);
Test_Data.reversal_counter = Data.reversal_counter(test_trials);
Test_Data.contrast = Data.contrast(test_trials);
Test_Data.ratio = Data.ratio(test_trials);
Test_Data.correct_answer = Data.correct_answer(test_trials);
Test_Data.staircase_answer = Data.staircase_answer(test_trials);
Test_Data.reaction_time = Data.reaction_time(test_trials);
Test_Data.choice = Data.choice(test_trials);
Test_Data.accuracy = Data.accuracy(test_trials);
Test_Data.order_of_orientations = Data.order_of_orientations(test_trials, :);
Test_Data.log_odds = Data.log_odds(test_trials);
Test_Data.average_orientations = Data.average_orientations(:, test_trials);
Test_Data.image_template1 = Data.image_template1(test_trials, :);
Test_Data.image_template2 = Data.image_template2(test_trials, :);
Test_Data.image_template_difference = Data.image_template_difference(test_trials, :);
%Test_Data.eye_tracker_points = Data.eye_tracker_points(test_trials);

Test_Data.current_trial = elements;
Test_Data.screen_frame = Data.screen_frame;
Test_Data.screen_resolution = Data.screen_resolution;
Test_Data.image_length_x = Data.image_length_x;
Test_Data.image_length_y = Data.image_length_y;
Test_Data.left_template = Data.left_template;
Test_Data.right_template = Data.right_template;
Test_Data.number_of_images = Data.number_of_images;

%% Save Test_Data and image_collection_test

savefile = fullfile(savedir, [subjectID postfix_test]);
save(savefile, 'Test_Data', 'image_collection_test');

end