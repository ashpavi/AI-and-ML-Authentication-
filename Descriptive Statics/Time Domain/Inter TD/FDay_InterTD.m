clear all
clc
close all

% Initialize the number of users
num_users = 10;

% Initialize cell array to store time-domain FDay data for each user
Acc_TD_Data_FDay = cell(1, num_users);

% Load and store time-domain data for FDay
for nc = 1:num_users
    filename_FDay = sprintf('U%02d_Acc_TimeD_FDay.mat', nc);
    T_Acc_DataTD_FDay = load(filename_FDay);
    data_FDay = T_Acc_DataTD_FDay.Acc_TD_Feat_Vec(1:36, 1:88); % 36 samples, 88 features
    Acc_TD_Data_FDay{nc} = data_FDay;
end

% Calculate variance for FDay data of each user
var_TD_FDay = zeros(num_users, 88);
for nc = 1:num_users
    var_TD_FDay(nc, :) = var(Acc_TD_Data_FDay{nc});
end

% Plot Variance Comparison for FDay
features = 1:88; 
figure;
hold on; 
colors = lines(num_users); 

for nc = 1:num_users
    plot(features, var_TD_FDay(nc, :), 'LineWidth', 1.5, 'Color', colors(nc, :));
end

legend(arrayfun(@(nc) sprintf('U%02d FDay Variance', nc), 1:num_users, 'UniformOutput', false));
xlabel('Feature Index');
ylabel('Variance Value');
title('Inter-User Variance for FDay in Time Domain');
grid on;
hold off;
