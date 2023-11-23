% init_state=[11  0.1  0.2  0.1  0.5 -0.5];
x0=[9.9735   -0.0005    0.2442   -0.0034   -0.9640   -0.6708];
% timespan = 0:0.01:2;
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
cov.t0 = 0;
timespan = cov.t0:0.01:cov.t0+2;

% [cov.T, sol]=ode45(@(t,x,u)real_6d(t,x,xr,ur,F),timespan,init_state', options);
% delta_X = sol - xr
k = uint8(cov.t0*100 + 1);
% x = xr(k, :);  % 初始状态
x = x0;
u0 = ur(k, :);
for t=timespan
    dx(k,:)=x(k,:)-xr(k,:);
    du(k,:)=(F(:,:,k)*dx(k,:)')';
    u(k,:)=du(k,:)+ur(k,:);
    u0=u(k,:);
    u0=u0';
    [t, sol]=ode45(@(t,x,u)real_6d(t,x,u0),[t,t+0.01],x(k,:)');
    x(k+1,:) = sol(end,:);
    k=k+1;
end
% t=0:0.01:2;
t=timespan;
t=t';
figure('Name', 'All Plots', 'Position', [100, 100, 800, 600]);

% 创建第一个子图
subplot(4, 2, 1);
plot(t, x(1:length(t), 1), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('V(m/s)', 'FontSize', 16);
title('t-V');

% 创建其他子图，依此类推
subplot(4, 2, 2);
plot(t, x(1:length(t), 2), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('miu(rad)', 'FontSize', 16);
title('t-miu');

subplot(4, 2, 3);
plot(t, x(1:length(t), 3), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 3), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('alpha(rad)', 'FontSize', 16);
title('t-alpha');

subplot(4, 2, 4);
plot(t, x(1:length(t), 4), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 4), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('q(rad/s)', 'FontSize', 16);
title('t-q');

subplot(4, 2, 5);
plot(t, x(1:length(t), 5), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 5), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('x(m)', 'FontSize', 16);
title('t-x');

subplot(4, 2, 6);
plot(t, x(1:length(t), 6), 'r', 'linewidth', 2);
hold on
plot(t, xr(1:length(t), 6), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('h(m)', 'FontSize', 16);
title('t-h');

subplot(4, 2, 7);
plot(t, u(1:length(t), 1), 'r', 'linewidth', 2);
hold on
plot(t, ur(1:length(t), 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u1', 'FontSize', 16);
title('t-T');

subplot(4, 2, 8);
plot(t, u(1:length(t), 2), 'r', 'linewidth', 2);
hold on
plot(t, ur(1:length(t), 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u2', 'FontSize', 16);
title('t-deltae');
