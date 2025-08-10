clear; 

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

    % Create basic feedforward neural network
    net = patternnet([30 10 15]);
    net.trainParam.epochs = 100;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 1.0;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;

    % Train the network
    net = train(net, X_train, targets_train);

    % Predict using test data
    scores = net(X_test);
    predictions = round(scores);  % Fixed threshold = 0.5

    % Accuracy calculation
    acc = mean(predictions == targets_test) * 100;

    % Error rates
    targetScores = scores(targets_test == 1);
    imposterScores = scores(targets_test == 0);
    FAR = sum(imposterScores > 0.5) / length(imposterScores);
    FRR = sum(targetScores <= 0.5) / length(targetScores);
    EER = (FAR + FRR) / 2;

    % Store metrics
    accuracyList(user) = acc;
    farList(user) = FAR * 100;
    frrList(user) = FRR * 100;
    eerList(user) = EER * 100;

    % Display user results
    fprintf('User %02d → Accuracy: %.2f%% | FAR: %.2f%% | FRR: %.2f%% | EER: %.2f%%\n', ...
        user, acc, FAR * 100, FRR * 100, EER * 100);
end

% Display overall summary
fprintf('\n=== Overall FFMLP Performance (Time Domain) [Before Optimization] ===\n');
fprintf('Average Accuracy: %.2f%%\n', mean(accuracyList));
fprintf('Average FAR: %.2f%%\n', mean(farList));
fprintf('Average FRR: %.2f%%\n', mean(frrList));
fprintf('Average EER: %.2f%%\n', mean(eerList));



