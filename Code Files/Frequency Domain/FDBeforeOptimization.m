clear; 

numUsers = 10;
numFeatures = 43;  % Frequency domain features

% Initialize performance metric lists
accuracyList = zeros(1, numUsers);
farList = zeros(1, numUsers);
frrList = zeros(1, numUsers);
eerList = zeros(1, numUsers);

for user = 1:numUsers
    % Load training and testing data
    trainData = load(sprintf('User%02d_FreqD_train_Template.mat', user)).trainData;
    testData  = load(sprintf('User%02d_FreqD_test_Template.mat', user)).testData;

    % Extract features and labels
    X_train = trainData(:, 1:numFeatures)';
    targets_train = trainData(:, end)';
    X_test  = testData(:, 1:numFeatures)';
    targets_test  = testData(:, end)';

    % Create basic feedforward neural network
    net = patternnet(10);
    net.trainParam.epochs = 100;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 1.0;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;

    % Train the network
    net = train(net, X_train, targets_train);

    % Predict scores and apply fixed threshold of 0.5
    scores = net(X_test);
    predictions = round(scores);  % Fixed threshold = 0.5

    % Calculate accuracy
    acc = mean(predictions == targets_test) * 100;

    % Calculate FAR and FRR using threshold = 0.5
    targetScores = scores(targets_test == 1);
    imposterScores = scores(targets_test == 0);
    FAR = sum(imposterScores > 0.5) / length(imposterScores);
    FRR = sum(targetScores <= 0.5) / length(targetScores);
    EER = (FAR + FRR) / 2;

    % Store results
    accuracyList(user) = acc;
    farList(user) = FAR * 100;
    frrList(user) = FRR * 100;
    eerList(user) = EER * 100;

    % Print user results
    fprintf('User %02d → Accuracy: %.2f%% | FAR: %.2f%% | FRR: %.2f%% | EER: %.2f%%\n', ...
        user, acc, FAR * 100, FRR * 100, EER * 100);
end

% Overall results
fprintf('\n=== Overall FFMLP Performance (Frequency Domain) [Before Optimization] ===\n');
fprintf('Average Accuracy: %.2f%%\n', mean(accuracyList));
fprintf('Average FAR: %.2f%%\n', mean(farList));
fprintf('Average FRR: %.2f%%\n', mean(frrList));
fprintf('Average EER: %.2f%%\n', mean(eerList));
