clear all
clc

% Configuration
numUsers = 10;
numFeatures = 131;

for userID = 1:numUsers
    trainData = [];
    testData = [];

    for u = 1:numUsers
        % Construct file names
        fdayFile = sprintf('U%02d_Acc_TimeD_FreqD_FDay.mat', u);
        mdayFile = sprintf('U%02d_Acc_TimeD_FreqD_MDay.mat', u);

        % Load data
        fdayStruct = load(fdayFile);
        mdayStruct = load(mdayFile);

        % Extract feature matrices
        fData = fdayStruct.Acc_TDFD_Feat_Vec(1:36, 1:numFeatures);
        mData = mdayStruct.Acc_TDFD_Feat_Vec(1:36, 1:numFeatures);

        if u == userID
            % Positive samples (label = 1)
            trainData = [trainData; [fData, ones(36, 1)]];
            testData  = [testData;  [mData, ones(36, 1)]];
        else
            % Imposter samples (label = 0)
            trainData = [trainData; [fData(1:20, :), zeros(20, 1)]];
            testData  = [testData;  [mData(1:20, :), zeros(20, 1)]];
        end
    end

    % Save templates for this user
    trainFileName = sprintf('User%02d_TDFD_train_Template.mat', userID);
    testFileName  = sprintf('User%02d_TDFD_test_Template.mat', userID);
    save(trainFileName, 'trainData');
    save(testFileName, 'testData');

    fprintf('Saved Time-Freq Domain train and test templates for User %02d\n', userID);
end
