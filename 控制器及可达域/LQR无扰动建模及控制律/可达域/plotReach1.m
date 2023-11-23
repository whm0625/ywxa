function plotReach1(Reach,x_values1, h_values1)
% Plots the reachtube in x-h coordinates
timespan = 0:0.01:2;
%% Plot x-h reachtube

figure; grid on; grid minor; hold on
xlabel('Position (x)');
ylabel('Height (h)');
% x0=Reach.x0(5,:);
% h0=Reach.x0(6,:);
% Plot the reachset for each time step
for i = 1:length(Reach.T)
    reach = horzcat([Reach.Xup(i,5); Reach.Xup(i,5); ...
        Reach.Xlow(i,5); Reach.Xlow(i,5);Reach.Xup(i,5)], ...
        [Reach.Xup(i,6); Reach.Xlow(i,6); ...
        Reach.Xlow(i,6); Reach.Xup(i,6); Reach.Xup(i,6)]);
    % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
    patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.5, 'EdgeColor', 'none');
end
% plot(x_values, h_values, 'r-', 'LineWidth', 2);
for i = 1:4
    plot(x_values1(:,:,i), h_values1(:,:,i), 'r-', 'LineWidth', 1.5);
end
x_ref = get_reference_trajectory(timespan);
    x_ref_x = x_ref(:, 5); % 提取参考轨迹的x值
    x_ref_h = x_ref(:, 6); % 提取参考轨迹的h值
    radius = 0.15;
%     plot(x_ref_x, x_ref_h, 'Color', 'r', 'LineWidth', 2);
    plot(x_ref_x(end), x_ref_h(end), 'ok');
    viscircles([x_ref_x(end), x_ref_h(end)], radius, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
legend('Reachtube');
title('Position and Height Reachtube');
end