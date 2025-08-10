clear; clc;

numUsers = 10;
numFeatures = 88;  % Time domain features

% Initialize performance metric lists
accuracyList = zeros(1, numUsers);
farList = zeros(1, numUsers);
frrList = zeros(1, numUsers);
eerList = zeros(1, numUsers);

for user = 1:numUsers
    % Load training and testing data (Time Domain)
    trainData = load(sprintf('User%02d_TimeD_train_Template.mat', user)).trainData;
    testData  = load(sprintf('User%02d_TimeD_test_Template.mat', user)).testData;

    % Extract features and labels
    X_train = trainData(:, 1:numFeatures)';
    targets_train = trainData(:, end)';
    X_test  = testData(:, 1:numFeatures)';
    targets_test  = testData(:, end)';

    % Normalize the data
    [X_train, ps] = mapminmax(X_train);
    X_test = mapminmax('apply', X_test, ps);

    % Create and configure the neural network
    net = patternnet([30 20 15]);
    net.trainParam.epochs = 100;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 1.0;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;

    % Train the network
    [net, ~] = train(net, X_train, targets_train);

    % Get scores (predicted probabilities)
    scores = net(X_test);

    % Threshold sweep for FAR/FRR analysis
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

    % Find Equal Error Rate (EER)
    [~, idx] = min(abs(FAR - FRR));
    optimalThreshold = thresholds(idx);
    EER = (FAR(idx) + FRR(idx)) / 2;

    % Make final predictions using optimal threshold
    predictions = scores > optimalThreshold;
    acc = mean(predictions == targets_test) * 100;

    % Store metrics
    accuracyList(user) = acc;
    farList(user) = FAR(idx) * 100;
    frrList(user) = FRR(idx) * 100;
    eerList(user) = EER * 100;

    % Display user metrics
    fprintf('User %02d → Accuracy: %.2f%% | FAR: %.2f%% | FRR: %.2f%% | EER: %.2f%%\n', ...
        user, acc, FAR(idx)*100, FRR(idx)*100, EER*100);
end

% Final summary
fprintf('\n=== Overall FFMLP Performance (Time Domain) [After Optimization] ===\n');
fprintf('Average Accuracy: %.2f%%\n', mean(accuracyList));
fprintf('Average FAR: %.2f%%\n', mean(farList));
fprintf('Average FRR: %.2f%%\n', mean(frrList));
fprintf('Average EER: %.2f%%\n', mean(eerList));
