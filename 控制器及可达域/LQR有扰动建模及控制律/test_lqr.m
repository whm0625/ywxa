dx=zeros(206,6);
x=zeros(206,6);
u=zeros(206,2);
du=zeros(206,2);
load('xr206.mat');
load('ur206.mat');
load('Jaccobi.mat');
 % x(1,:)=[11  0.1  0.3  0.1  1 -1];
x(1,:)=xr206(1,:)+[0 0 0 0 1 -1];
k=1;
% syms Vw
for t = 0:0.01:2.05
    dx(k, :) = x(k, :) - xr206(k, :);
    A = Aall(:,:,k);
    B = Ball(:,:,k);
    Ki=Kall(:,:,k);
    du(k,:)=-(Ki*dx(k,:)')';
    u(k,:)=du(k,:)+ur206(k,:);
    u0=u(k,:);
    u0=u0';
    closed_loop = A - B * Ki;
    
    if k<206
        x(k+1,:) = (closed_loop*dx(k,:)')'+ xr206(k+1,:);
    end
    k=k+1;
end
t=0:0.01:2.05;
t=t';
xr_x = xr206(:, 5); % 提取参考轨迹的x值
xr_h = xr206(:, 6); % 提取参考轨迹的h值
x_center = xr_x(200); % x的中心
h_center = xr_h(200); % h的中心
x_radius = 0.15; % x的半径
h_radius = 0.15; % h的半径

figure;
plot(x(1:200, 5), x(1:200, 6), 'r', 'linewidth', 2);
rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);
% 创建一个新的大图
figure('Name', 'All Plots', 'Position', [100, 100, 800, 600]);

% 创建第一个子图
subplot(4, 2, 1);
plot(t, x(1:206, 1), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('V(m/s)', 'FontSize', 16);
title('t-V');

% 创建其他子图，依此类推
subplot(4, 2, 2);
plot(t, x(1:206, 2), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('miu(rad)', 'FontSize', 16);
title('t-miu');

subplot(4, 2, 3);
plot(t, x(1:206, 3), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 3), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('alpha(rad)', 'FontSize', 16);
title('t-alpha');

subplot(4, 2, 4);
plot(t, x(1:206, 4), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 4), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('q(rad/s)', 'FontSize', 16);
title('t-q');

subplot(4, 2, 5);
plot(t, x(1:206, 5), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 5), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('x(m)', 'FontSize', 16);
title('t-x');

subplot(4, 2, 6);
plot(t, x(1:206, 6), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:206, 6), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('h(m)', 'FontSize', 16);
title('t-h');

subplot(4, 2, 7);
plot(t, u(1:206, 1), 'r', 'linewidth', 2);
hold on
plot(t, ur206(1:206, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u1', 'FontSize', 16);
title('t-T');

subplot(4, 2, 8);
plot(t, u(1:206, 2), 'r', 'linewidth', 2);
hold on
plot(t, ur206(1:206, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u2', 'FontSize', 16);
title('t-deltae');