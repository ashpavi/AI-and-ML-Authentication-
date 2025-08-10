clear;

numUsers = 10;
numFeatures = 131;  % Total features in TDFD
topK = 50;          % Number of selected features

% Initialize performance metric lists
accuracyList = zeros(1, numUsers);
farList = zeros(1, numUsers);
frrList = zeros(1, numUsers);
eerList = zeros(1, numUsers);

for user = 1:numUsers
    % Load training and testing data (TDFD)
    trainData = load(sprintf('User%02d_TDFD_train_Template.mat', user)).trainData;
    testData  = load(sprintf('User%02d_TDFD_test_Template.mat', user)).testData;

    % Combine for feature selection
    X = [trainData(:, 1:numFeatures); testData(:, 1:numFeatures)];
    Y = [trainData(:, end); testData(:, end)];

    % Apply ReliefF to rank features
    [rankedIdx, ~] = relieff(X, Y, 10);
    selectedIdx = rankedIdx(1:topK);

    % Use only selected features
    X_train = trainData(:, selectedIdx)';
    Y_train = trainData(:, end)';
    X_test  = testData(:, selectedIdx)';
    Y_test  = testData(:, end)';

    % Normalize features
    [X_train, ps] = mapminmax(X_train);
    X_test = mapminmax('apply', X_test, ps);

    % Create FFMLP network
    net = patternnet([30 20 15]);
    net.performFcn = 'crossentropy';           % Set performance function to avoid warning
    net.trainFcn = 'trainlm';                  % Levenberg-Marquardt
    net.trainParam.epochs = 100;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 1.0;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;

    % Train the network
    [net, ~] = train(net, X_train, Y_train);

    % Predict outputs
    scores = net(X_test);

    % Threshold sweep for FAR and FRR
    thresholds = linspace(0, 1, 100);
    FAR = zeros(size(thresholds));
    FRR = zeros(size(thresholds));

    targetScores = scores(Y_test == 1);
    imposterScores = scores(Y_test == 0);

    for i = 1:length(thresholds)
        t = thresholds(i);
        FAR(i) = sum(imposterScores > t) / length(imposterScores);
        FRR(i) = sum(targetScores <= t) / length(targetScores);
    end

    % Equal Error Rate (EER)
    [~, idx] = min(abs(FAR - FRR));
    optimalThreshold = thresholds(idx);
    EER = (FAR(idx) + FRR(idx)) / 2;

    % Final prediction
    predictions = scores > optimalThreshold;
    acc = mean(predictions == Y_test) * 100;

    % Store metrics
    accuracyList(user) = acc;
    farList(user) = FAR(idx) * 100;
    frrList(user) = FRR(idx) * 100;
    eerList(user) = EER * 100;

    % Display per-user result
    fprintf('User %02d → Accuracy: %.2f%% | FAR: %.2f%% | FRR: %.2f%% | EER: %.2f%%\n', ...
        user, acc, FAR(idx)*100, FRR(idx)*100, EER*100);
end

% Final summary
fprintf('\n=== Overall FFMLP Performance (TDFD with Feature Selection) ===\n');
fprintf('Average Accuracy: %.2f%%\n', mean(accuracyList));
fprintf('Average FAR: %.2f%%\n', mean(farList));
fprintf('Average FRR: %.2f%%\n', mean(frrList));
fprintf('Average EER: %.2f%%\n', mean(eerList));
