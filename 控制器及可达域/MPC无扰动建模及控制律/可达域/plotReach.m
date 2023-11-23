function plotReach(Reach,initial_centers,initial_radii,xup,xlow)
% Plots the reachtube in x-h coordinates

%% Plot x-h reachtube
load('xr(0.0.01.2).mat');
load('ur(0.0.01.2).mat');
% load('MPC(5,2.5).mat');
load('MPC(4,2)线性无扰动.mat');
% figure;
% grid on; grid minor; hold on
% xlabel('Position (x)');
% ylabel('Height (h)');
% x0=Reach.x0(5,:);
% h0=Reach.x0(6,:);
% Plot the reachset for each time step
valid_indices = Reach.T <= 2;
valid_xup_all = xup(valid_indices,:,:);
valid_xlow_all = xlow(valid_indices,:,:);

% for i = 1:length(Reach.T)
%     reach = horzcat([Reach.Xup(i,5); Reach.Xup(i,5); ...
%         Reach.Xlow(i,5); Reach.Xlow(i,5);Reach.Xup(i,5)], ...
%         [Reach.Xup(i,6); Reach.Xlow(i,6); ...
%         Reach.Xlow(i,6); Reach.Xup(i,6); Reach.Xup(i,6)]);
%     % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%     %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%     patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.03, 'EdgeColor', 'none');
% end
% for i = 1:length(initial_centers)
%     x = [initial_centers(i, 1) - initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) - initial_radii(i, 1)];
%     y = [initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2)];
%     fill(x, y, 'g', 'FaceAlpha', 0.8, 'EdgeColor', 'none'); % 使用 'fill' 函数绘制填充区域
% end
% plot(x_values, h_values, 'r-', 'LineWidth', 2);
% for i = 1:4
%     plot(x_values1(:,:,i), h_values1(:,:,i), 'r-', 'LineWidth', 1.5);
% end
% x_ref = get_reference_trajectory(timespan);
xr_x = xr(:, 5); % 提取参考轨迹的x值
xr_h = xr(:, 6); % 提取参考轨迹的h值
x_center = xr_x(200); % x的中心
h_center = xr_h(200); % h的中心
x_radius = 0.15; % x的半径
h_radius = 0.15; % h的半径
%     radius = 0.15;
%     plot(x_ref_x, x_ref_h, 'Color', 'r', 'LineWidth', 2);
%     plot(xr_x(200), xr_h(200), 'ok');
%     viscircles([xr_x(200),xr_h(200)], radius, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
% rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'Curvature', [1, 1], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);
% rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);
% % legend('Reachtube');
% % legend('Reachtube');
% title('Position and Height Reachtube');
% hold off

figure;
grid on; grid minor; hold on
xlabel('Position (x)');
ylabel('Height (h)');

batchsize = 500;
numPipes = size(valid_xup_all, 3);
for batchstart = 1:batchsize:numPipes
    batchend = min(batchstart+batchsize-1,numPipes);
    for j = batchstart:batchend
        valid_xup = valid_xup_all(:,:,j);
        valid_xlow = valid_xlow_all(:,:,j);
        for i = 1:size(valid_xup, 1)
            reach = horzcat([valid_xup(i,5); valid_xup(i,5); ...
                valid_xlow(i,5); valid_xlow(i,5);valid_xup(i,5)], ...
                [valid_xup(i,6); valid_xlow(i,6); ...
                valid_xlow(i,6);valid_xup(i,6); valid_xup(i,6)]);
            % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
            %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
            patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.1, 'EdgeColor', 'none');
        end
    end
end
for i = 1:length(initial_centers)
    x = [initial_centers(i, 1) - initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) - initial_radii(i, 1)];
    y = [initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2)];
    fill(x, y, 'g', 'FaceAlpha', 0.8, 'EdgeColor', 'none'); % 使用 'fill' 函数绘制填充区域
end
% rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'Curvature', [1, 1], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);
rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);

% legend('Reachtube');
% legend('Reachtube');
title('Position and Height Reachtube');

% test_state = [
%     xr(1,:)+[0 0 0 0 -2 -1.9];
%     xr(1,:)+[0 0 0 0 0.6 -0.5];
%     xr(1,:)+[0 0 0 0 -0.5 -0.25];
%     xr(1,:)+[0 0 0 0 -0.1 0.1]
%     ];
% [x_values1,h_values1] = test(test_state);
% for i = 1:4
%     plot(x_values1(:,:,i), h_values1(:,:,i), 'r-', 'LineWidth', 1.5);
% end

hold off
% 
% folder = 'D:\待学习\鲁棒MPC\可达域\图\';
% figFileName = fullfile(folder, 'MPC(4.2,2)无扰动.fig');
% saveas(gcf, figFileName);
% figFileName = fullfile(folder, 'MPC(4.2,2)无扰动.jpg');
% saveas(gcf, figFileName);
% saveas(gcf, 'Position and Height Reachtube.fig');
% saveas(gcf, 'Position and Height Reachtube.jpg');

end