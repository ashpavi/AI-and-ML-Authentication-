clear; clc;

numUsers = 10;
numFeatures = 43;  % Frequency domain features

% Initialize performance metric lists
accuracyList = zeros(1, numUsers);
farList = zeros(1, numUsers);
frrList = zeros(1, numUsers);
eerList = zeros(1, numUsers);

for user = 1:numUsers
    % Load user-specific training and testing data
    trainData = load(sprintf('User%02d_FreqD_train_Template.mat', user)).trainData;
    testData  = load(sprintf('User%02d_FreqD_test_Template.mat', user)).testData;

    % Separate features and labels
    X_train = trainData(:, 1:numFeatures)';
    targets_train = trainData(:, end)';
    X_test  = testData(:, 1:numFeatures)';
    targets_test  = testData(:, end)';

    % Normalize training and testing data
    [X_train, ps] = mapminmax(X_train);
    X_test = mapminmax('apply', X_test, ps);

    % Create and configure feedforward neural network
    hiddenLayers = [30 20 15];
    net = patternnet(hiddenLayers);
    net.trainParam.epochs = 100;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 1.0;  % Use all training data
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;

    % Train the network
    [net, ~] = train(net, X_train, targets_train);

    % Predict network output for test data
    scores = net(X_test);

    % Threshold analysis to calculate FAR, FRR
    thresholds = linspace(0, 1, 100);
    FAR = zeros(size(thresholds));
    FRR = zeros(size(thresholds));

    targetScores = scores(targets_test == 1);
    imposterScores = scores(targets_test == 0);

    for i = 1:length(thresholds)
        t = thresholds(i);
        FAR(i) = sum(imposterScores > t) / length(imposterScores);
        FRR(i) = sum(targetScores <= t) / length(targetScores);
    end

    % Find optimal threshold (EER point)
    [~, idx] = min(abs(FAR - FRR));
    optimalThreshold = thresholds(idx);
    eer = (FAR(idx) + FRR(idx)) / 2;

    % Final predictions and accuracy
    predictions = scores > optimalThreshold;
    acc = mean(predictions == targets_test) * 100;

    % Store metrics
    accuracyList(user) = acc;
    farList(user) = FAR(idx) * 100;
    frrList(user) = FRR(idx) * 100;
    eerList(user) = eer * 100;

    % Display user-specific results
    fprintf('User %02d → Accuracy: %.2f%% | FAR: %.2f%% | FRR: %.2f%% | EER: %.2f%%\n', ...
        user, acc, FAR(idx)*100, FRR(idx)*100, eer*100);
end

% Display overall summary
fprintf('\n=== Overall FFMLP Performance (Frequency Domain) ===\n');
fprintf('Average Accuracy: %.2f%%\n', mean(accuracyList));
fprintf('Average FAR: %.2f%%\n', mean(farList));
fprintf('Average FRR: %.2f%%\n', mean(frrList));
fprintf('Average EER: %.2f%%\n', mean(eerList));
