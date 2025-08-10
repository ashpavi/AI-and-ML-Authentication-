clear all
clc
close all

% Initialize the number of users
num_users = 10;

% Initialize cell array to store TDFD FDay data for each user
Acc_TDFD_Data_FDay = cell(1, num_users);

% Load and store time-frequency domain data for FDay
for nc = 1:num_users
    filename_FDay = sprintf('U%02d_Acc_TimeD_FreqD_FDay.mat', nc);
    T_Acc_DataTDFD_FDay = load(filename_FDay);
    data_FDay = T_Acc_DataTDFD_FDay.Acc_TDFD_Feat_Vec(1:36, 1:131); % 36 samples, 131 features
    Acc_TDFD_Data_FDay{nc} = data_FDay;
end

% Calculate variance for FDay data of each user
var_TDFD_FDay = zeros(num_users, 131);
for nc = 1:num_users
    var_TDFD_FDay(nc, :) = var(Acc_TDFD_Data_FDay{nc});
end

% Plot Variance Comparison for FDay
features = 1:131; 
figure;
hold on; 
colors = lines(num_users); 

for nc = 1:num_users
    plot(features, var_TDFD_FDay(nc, :), 'LineWidth', 1.5, 'Color', colors(nc, :));
end

legend(arrayfun(@(nc) sprintf('U%02d FDay Variance', nc), 1:num_users, 'UniformOutput', false));
xlabel('Feature Index');
ylabel('Variance Value');
title('Inter-User Variance for FDay in Time-Frequency Domain');
grid on;
hold off;
