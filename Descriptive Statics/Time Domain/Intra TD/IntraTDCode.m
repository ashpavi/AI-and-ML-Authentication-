clear all
clc
close all

% Initialize user index (for U10 for example)
nc = 10;

% Load time-domain data for FDay and MDay
T_Acc_DataTD_Day1 = load(sprintf('U%02d_Acc_TimeD_FDay.mat', nc));
T_Acc_DataTD_Day2 = load(sprintf('U%02d_Acc_TimeD_MDay.mat', nc));

% Extract the data matrices for the first 36 samples and 88 features
Temp_Acc_Data_TD_D1 = T_Acc_DataTD_Day1.Acc_TD_Feat_Vec(1:36, 1:88);
Temp_Acc_Data_TD_D2 = T_Acc_DataTD_Day2.Acc_TD_Feat_Vec(1:36, 1:88);

% Store in cell arrays for the given user (nc)
Acc_TD_Data_Day1{nc} = Temp_Acc_Data_TD_D1;
Acc_TD_Data_Day2{nc} = Temp_Acc_Data_TD_D2;

% Descriptive Statistics
mean_FDay = mean(Acc_TD_Data_Day1{nc});
mean_MDay = mean(Acc_TD_Data_Day2{nc});

var_FDay = var(Acc_TD_Data_Day1{nc});
var_MDay = var(Acc_TD_Data_Day2{nc});

std_FDay = std(Acc_TD_Data_Day1{nc});
std_MDay = std(Acc_TD_Data_Day2{nc});

% Plotting
features = 1:88;

figure;

% Mean
subplot(3, 1, 1);
plot(features, mean_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, mean_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Mean', nc), sprintf('U%02d MDay Mean', nc));
xlabel('Feature Index');
ylabel('Mean Value');
title('Mean Comparison for Time Domain (FDay vs MDay)');
grid on;

% Variance
subplot(3, 1, 2);
plot(features, var_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, var_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Variance', nc), sprintf('U%02d MDay Variance', nc));
xlabel('Feature Index');
ylabel('Variance Value');
title('Variance Comparison for Time Domain (FDay vs MDay)');
grid on;

% Standard Deviation
subplot(3, 1, 3);
plot(features, std_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, std_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Std Dev', nc), sprintf('U%02d MDay Std Dev', nc));
xlabel('Feature Index');
ylabel('Standard Deviation Value');
title('Standard Deviation Comparison for Time Domain (FDay vs MDay)');
grid on;
