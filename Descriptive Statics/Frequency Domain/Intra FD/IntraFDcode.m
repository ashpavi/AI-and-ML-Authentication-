
clear all
clc
close all

% Initialize user index (for U01)
nc = 10;

% Load frequency-domain data for FDay and MDay
T_Acc_DataTD_Day1 = load(sprintf('U%02d_Acc_FreqD_FDay.mat', nc));
T_Acc_DataTD_Day2 = load(sprintf('U%02d_Acc_FreqD_MDay.mat', nc));

% Extract the data matrices for the first 36 samples and 43 features
Temp_Acc_Data_FD_D1 = T_Acc_DataTD_Day1.Acc_FD_Feat_Vec(1:36, 1:43);
Temp_Acc_Data_FD_D2 = T_Acc_DataTD_Day2.Acc_FD_Feat_Vec(1:36, 1:43);

% Initialize cell arrays to store the matrices for each user
Acc_FD_Data_Day1 = {};  
Acc_FD_Data_Day2 = {};  

% Store the matrices in the cell arrays for the given user (nc)
Acc_FD_Data_Day1{nc} = Temp_Acc_Data_FD_D1;
Acc_FD_Data_Day2{nc} = Temp_Acc_Data_FD_D2;

% Calculate Descriptive Statistics
% Mean
mean_FDay = mean(Acc_FD_Data_Day1{nc});
mean_MDay = mean(Acc_FD_Data_Day2{nc});

% Variance
var_FDay = var(Acc_FD_Data_Day1{nc});
var_MDay = var(Acc_FD_Data_Day2{nc});

% Standard Deviation
std_FDay = std(Acc_FD_Data_Day1{nc});
std_MDay = std(Acc_FD_Data_Day2{nc});

% Plotting the comparison 
features = 1:43; 

figure;

% Mean Comparison
subplot(3, 1, 1);
plot(features, mean_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, mean_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Mean', nc), sprintf('U%02d MDay Mean', nc));
xlabel('Feature Index');
ylabel('Mean Value');
title('Mean Comparison for Frequency FDay and MDay');
grid on;

% Variance Comparison
subplot(3, 1, 2);
plot(features, var_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, var_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Variance', nc), sprintf('U%02d MDay Variance', nc));
xlabel('Feature Index');
ylabel('Variance Value');
title('Variance Comparison for Frequency FDay and MDay');
grid on;

% Standard Deviation Comparison
subplot(3, 1, 3);
plot(features, std_FDay, '-o', 'LineWidth', 1.5); hold on;
plot(features, std_MDay, '-x', 'LineWidth', 1.5);
legend(sprintf('U%02d FDay Std Dev', nc), sprintf('U%02d MDay Std Dev', nc));
xlabel('Feature Index');
ylabel('Standard Deviation Value');
title('Standard Deviation Comparison for Frequency FDay and MDay');
grid on;
