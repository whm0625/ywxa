x=zeros(206,6);
u=zeros(206,2);
dx=zeros(206,6);
du=zeros(206,2);
k = 1;
load('Jaccobi.mat');
load('gudingyi_lpv.mat','LPV1');
LPV = LPV1;
syms p
% Ad = subs(Ak, t, p);
% Bd = subs(Bk, t, p);
% x(1,:)=[9.9735   -0.0005    0.2442   -0.0034    -0.6   -0.8];
x(1,:)=xr206(1,:)+[0 0 0 0 -1 -1]; 
for t=0:0.01:2
    dx(k,:)=x(k,:)-xr206(k,:);
    du(k,:)=(F(:,:,k)*dx(k,:)')';
    u(k,:)=du(k,:)+ur206(k,:);
    u0=u(k,:);
    u0=u0';
%     if 1<=k&&k<=11
%         A = Aall(:,:,1);
%         B = Ball(:,:,1);
%     elseif k>=12&&k<=21
%         A = Aall(:,:,2);
%         B = Ball(:,:,2);
%     elseif k>=22&&k<=31
%         A = Aall(:,:,3);
%         B = Ball(:,:,3);
%     elseif k>=32&&k<=41
%         A = Aall(:,:,4);
%         B = Ball(:,:,4);
%     elseif k>=42&&k<=51
%         A = Aall(:,:,5);
%         B = Ball(:,:,5);
%     elseif k>=52&&k<=61
%         A = Aall(:,:,6);
%         B = Ball(:,:,6);
%     elseif k>=62&&k<=71
%         A = Aall(:,:,7);
%         B = Ball(:,:,7);
%     elseif k>=72&&k<=81
%         A = Aall(:,:,8);
%         B = Ball(:,:,8);
%     elseif k>=82&&k<=91
%         A = Aall(:,:,9);
%         B = Ball(:,:,9);
%     elseif k>=92&&k<=101
%         A = Aall(:,:,10);
%         B = Ball(:,:,10);
%     elseif k>=102&&k<=111
%         A = Aall(:,:,11);
%         B = Ball(:,:,11);
%     elseif k>=112&&k<=121
%         A = Aall(:,:,12);
%         B = Ball(:,:,12);
%     elseif k>=122&&k<=131
%         A = Aall(:,:,13);
%         B = Ball(:,:,13);
%     elseif k>=132&&k<=141
%         A = Aall(:,:,14);
%         B = Ball(:,:,14);
%     elseif k>=142&&k<=151
%         A = Aall(:,:,15);
%         B = Ball(:,:,15);
%     elseif k>=152&&k<=161
%         A = Aall(:,:,16);
%         B = Ball(:,:,16);
%     elseif k>=162&&k<=171
%         A = Aall(:,:,17);
%         B = Ball(:,:,17);
%     elseif k>=172&&k<=181
%         A = Aall(:,:,18);
%         B = Ball(:,:,18);
%     elseif k>=182&&k<=191
%         A = Aall(:,:,19);
%         B = Ball(:,:,19);
%     elseif k>=192&&k<=201
%         A = Aall(:,:,20);
%         B = Ball(:,:,20);
%     else
%         A = Aall(:,:,21);
%         B = Ball(:,:,21);
%     end
    A = subs(Ad, p, t);
    B = subs(Bd, p, t);
    closed_loop = A + B * F(:,:,k);
%     closed_loop = A + B * F(:,:,k);
%     tspan = t:0.01:t+0.01;
%     [t, sol]=ode45(@(t,x)linear_model(t,x,closed_loop),tspan,dx(k,:)');
    
%     if k<206
%         x(k+1,:) = sol(end,:)+ xr206(k+1,:);
%     end
    if k<206
        x(k+1,:) = (closed_loop*dx(k,:)')'+ xr206(k+1,:);
    end
    k=k+1;
    
end
xr_x = xr206(:, 5); % 提取参考轨迹的x值
xr_h = xr206(:, 6); % 提取参考轨迹的h值
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
plot(t, xr206(1:201, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('V(m/s)', 'FontSize', 16);
title('t-V');

% 创建其他子图，依此类推
subplot(4, 2, 2);
plot(t, x(1:201, 2), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:201, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('miu(rad)', 'FontSize', 16);
title('t-miu');

subplot(4, 2, 3);
plot(t, x(1:201, 3), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:201, 3), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('alpha(rad)', 'FontSize', 16);
title('t-alpha');

subplot(4, 2, 4);
plot(t, x(1:201, 4), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:201, 4), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('q(rad/s)', 'FontSize', 16);
title('t-q');

subplot(4, 2, 5);
plot(t, x(1:201, 5), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:201, 5), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('x(m)', 'FontSize', 16);
title('t-x');

subplot(4, 2, 6);
plot(t, x(1:201, 6), 'r', 'linewidth', 2);
hold on
plot(t, xr206(1:201, 6), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('h(m)', 'FontSize', 16);
title('t-h');

subplot(4, 2, 7);
plot(t, u(1:201, 1), 'r', 'linewidth', 2);
hold on
plot(t, ur206(1:201, 1), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u1', 'FontSize', 16);
title('t-T');

subplot(4, 2, 8);
plot(t, u(1:201, 2), 'r', 'linewidth', 2);
hold on
plot(t, ur206(1:201, 2), '--b', 'linewidth', 2);
xlabel('t(s)', 'FontSize', 16);
ylabel('u2', 'FontSize', 16);
title('t-deltae');