test_state = [
    [0 0 0 0 0.7 0.35 1];
    [0 0 0 0 0.6 -0.5 1];
    [0 0 0 0 -0.5 -0.25 1];
    [0 0 0 0 -0.1 0.1 1]
    ];
% x_ref = get_reference_trajectory(Reach.T');
x_ref = get_reference_trajectory(Reach.T');
figure;
% scatter(initial_centers(:, 1), initial_centers(:, 2), 'g', 'filled'); % 初始集点
hold on;
for i = 1:length(initial_centers)
    x = [initial_centers(i, 1) - initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) + initial_radii(i, 1), initial_centers(i, 1) - initial_radii(i, 1)];
    y = [initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) - initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2), initial_centers(i, 2) + initial_radii(i, 2)];
    fill(x, y, 'g', 'FaceAlpha', 0.8, 'EdgeColor', 'none'); % 使用 'fill' 函数绘制填充区域
end
batchsize = 500;
numPipes = 1787;
for batchstart = 1:batchsize:numPipes
    batchend = min(batchstart+batchsize-1,numPipes);
    for j = batchstart:batchend
%         xup1=xup(:,:,j)+x_ref;
%         xlow1=xlow(:,:,j)+x_ref;
        for i = 1:10:2007
            reach = horzcat([xup1(i,5); xup1(i,5); ...
                xlow1(i,5); xlow1(i,5);xup1(i,5)], ...
                [xup1(i,6); xlow1(i,6); ...
                xlow1(i,6); xup1(i,6); xup1(i,6)]);
            % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
            %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
            patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.1, 'EdgeColor', 'none');
        end
    end
%     drawnow;
end
% for j = 1:1297
%     xup1=xup(:,:,j)+x_ref;
%     xlow1=xlow(:,:,j)+x_ref;
%     for i = 1:2007
%         reach = horzcat([xup1(i,5); xup1(i,5); ...
%             xlow1(i,5); xlow1(i,5);xup1(i,5)], ...
%             [xup1(i,6); xlow1(i,6); ...
%             xlow1(i,6); xup1(i,6); xup1(i,6)]);
%         % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%         %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%         patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.01, 'EdgeColor', 'none');
%     end
% end
% timespan = 0:0.05:2;
% x_ref = get_reference_trajectory(timespan);
x_ref_x = x_ref(:, 5); % 提取参考轨迹的x值
x_ref_h = x_ref(:, 6); % 提取参考轨迹的h值
radius = 0.15;
plot(x_ref_x, x_ref_h, 'Color', 'r', 'LineWidth', 2);
plot(x_ref_x(2007), x_ref_h(2007), 'ok');
viscircles([x_ref_x(2007), x_ref_h(2007)], radius, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
[x_values1,h_values1] = test(test_state);
for i = 1:4
    plot(x_values1(:,:,i), h_values1(:,:,i), 'r-', 'LineWidth', 1.5);
end