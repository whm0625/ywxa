x=zeros(201,6);
u=zeros(201,2);
dx=zeros(201,6);
du=zeros(201,2);
k = 1;
% x(1,:)=[9.9735   -0.0005    0.2442   -0.0034    -0.6   -0.8];
x(1,:)=xr206(1,:)+[0 0 0 0 -0.8 -0.8]; 
for t=0:0.01:2
    dx(k,:)=x(k,:)-xr(k,:);
    du(k,:)=(F(:,:,k)*dx(k,:)')';
    u(k,:)=du(k,:)+ur(k,:);
    u0=u(k,:);
    u0=u0';
    
    [~, sol]=ode45(@(t,x,u)real_6d(t,x,u0),[t,t+0.01],x(k,:)');
    x(k+1,:) = sol(end,:);
    k=k+1;
    
end
xr_x = xr(:, 5); % 提取参考轨迹的x值
xr_h = xr(:, 6); % 提取参考轨迹的h值
x_center = xr_x(200); % x的中心
h_center = xr_h(200); % h的中心
x_radius = 0.15; % x的半径
h_radius = 0.15; % h的半径

t=0:0.01:2;
t=t';
figure;
plot(x(1:201, 5), x(1:201, 6), 'r', 'linewidth', 2);
rectangle('Position', [x_center - x_radius, h_center - h_radius, 2 * x_radius, 2 * h_radius], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 1);
% 创建一个新的大图
figure('Name', 'All Plots', 'Position', [100, 100, 800, 600]);

% 创建第一个子图
subplot(4, 2, 1);
plot(t, x(1:201, 1), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('V(m/s)', 'FontSize', 16);
title('t-V');

% 创建其他子图，依此类推
subplot(4, 2, 2);
plot(t, x(1:201, 2), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('miu(rad)', 'FontSize', 16);
title('t-miu');

subplot(4, 2, 3);
plot(t, x(1:201, 3), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 3), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('alpha(rad)', 'FontSize', 16);
title('t-alpha');

subplot(4, 2, 4);
plot(t, x(1:201, 4), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 4), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('q(rad/s)', 'FontSize', 16);
title('t-q');

subplot(4, 2, 5);
plot(t, x(1:201, 5), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 5), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('x(m)', 'FontSize', 16);
title('t-x');

subplot(4, 2, 6);
plot(t, x(1:201, 6), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:201, 6), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('h(m)', 'FontSize', 16);
title('t-h');

subplot(4, 2, 7);
plot(t, u(1:201, 1), 'r', 'linewidth', 2);
hold on
plot(t, ur(1:201, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u1', 'FontSize', 16);
title('t-T');

subplot(4, 2, 8);
plot(t, u(1:201, 2), 'r', 'linewidth', 2);
hold on
plot(t, ur(1:201, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u2', 'FontSize', 16);
title('t-deltae');