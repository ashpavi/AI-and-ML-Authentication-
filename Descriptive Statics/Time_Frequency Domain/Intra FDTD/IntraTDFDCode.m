clear all
clc
close all

% Initialize user index (e.g., U10)
nc = 10;

% Load time-frequency domain data for FDay and MDay
T_Acc_DataTDFD_Day1 = load(sprintf('U%02d_Acc_TimeD_FreqD_FDay.mat', nc));
T_Acc_DataTDFD_Day2 = load(sprintf('U%02d_Acc_TimeD_FreqD_MDay.mat', nc));

% Extract the data matrices: 36 samples × 131 features
Temp_Acc_Data_TDFD_D1 = T_Acc_DataTDFD_Day1.Acc_TDFD_Feat_Vec(1:36, 1:131);
Temp_Acc_Data_TDFD_D2 = T_Acc_DataTDFD_Day2.Acc_TDFD_Feat_Vec(1:36, 1:131);

% Store in cell arrays for the given user
Acc_TDFD_Data_Day1{nc} = Temp_Acc_Data_TDFD_D1;
Acc_TDFD_Data_Day2{nc} = Temp_Acc_Data_TDFD_D2;

% Descriptive Statistics
mean_FDay = mean(Acc_TDFD_Data_Day1{nc});
mean_MDay = mean(Acc_TDFD_Data_Day2{nc});

var_FDay = var(Acc_TDFD_Data_Day1{nc});
var_MDay = var(Acc_TDFD_Data_Day2{nc});

std_FDay = std(Acc_TDFD_Data_Day1{nc});
std_MDay = std(Acc_TDFD_Data_Day2{nc});

% Plotting
features = 1:131;

figure;

% Mean
subplot(3, 1, 1);
plot(features, mean_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, mean_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Mean', nc), sprintf('U%02d MDay Mean', nc));
xlabel('Feature Index');
ylabel('Mean Value');
title('Mean Comparison for Time-Frequency Domain (FDay vs MDay)');
grid on;

% Variance
subplot(3, 1, 2);
plot(features, var_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, var_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Variance', nc), sprintf('U%02d MDay Variance', nc));
xlabel('Feature Index');
ylabel('Variance Value');
title('Variance Comparison for Time-Frequency Domain (FDay vs MDay)');
grid on;

% Standard Deviation
subplot(3, 1, 3);
plot(features, std_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, std_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Std Dev', nc), sprintf('U%02d MDay Std Dev', nc));
xlabel('Feature Index');
ylabel('Standard Deviation Value');
title('Standard Deviation Comparison for Time-Frequency Domain (FDay vs MDay)');
grid on;
