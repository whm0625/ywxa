function [x_values,h_values] = test_mpc(test_state)
global dim time_span tol
tol = 10^-12;
init_states  = test_state;
time_span = [0,2];
load('xr(0.0.01.2).mat');
load('ur(0.0.01.2).mat');
load('F_origin_new.mat');

F201 = F(:,:,201);
% load('F_origin_disturbance.mat');
x=zeros(201,6);
u=zeros(201,2);
dx=zeros(201,6);
du=zeros(201,2);

x_values = [];
h_values = [];

for idx = 1:4
    x(1,:) = init_states(idx,:);
    k=1;
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
%     t=0:0.01:2;
%     t=t';
%     
%     % 创建一个新的大图
%     figure('Name', 'All Plots', 'Position', [100, 100, 800, 600]);
%     
%     % 创建第一个子图
%     subplot(4, 2, 1);
%     plot(t, x(1:201, 1), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 1), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('V(m/s)', 'FontSize', 16);
%     title('t-V');
%     
%     % 创建其他子图，依此类推
%     subplot(4, 2, 2);
%     plot(t, x(1:201, 2), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 2), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('miu(rad)', 'FontSize', 16);
%     title('t-miu');
%     
%     subplot(4, 2, 3);
%     plot(t, x(1:201, 3), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 3), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('alpha(rad)', 'FontSize', 16);
%     title('t-alpha');
%     
%     subplot(4, 2, 4);
%     plot(t, x(1:201, 4), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 4), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('q(rad/s)', 'FontSize', 16);
%     title('t-q');
%     
%     subplot(4, 2, 5);
%     plot(t, x(1:201, 5), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 5), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('x(m)', 'FontSize', 16);
%     title('t-x');
%     
%     subplot(4, 2, 6);
%     plot(t, x(1:201, 6), 'r', 'linewidth', 2);
%     hold on
%     plot(t, xr(1:201, 6), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('h(m)', 'FontSize', 16);
%     title('t-h');
%     
%     subplot(4, 2, 7);
%     plot(t, u(1:201, 1), 'r', 'linewidth', 2);
%     hold on
%     plot(t, ur(1:201, 1), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('u1', 'FontSize', 16);
%     title('t-T');
%     
%     subplot(4, 2, 8);
%     plot(t, u(1:201, 2), 'r', 'linewidth', 2);
%     hold on
%     plot(t, ur(1:201, 2), '--b', 'linewidth', 2);
%     xlabel('t(s)', 'FontSize', 16);
%     ylabel('u2', 'FontSize', 16);
%     title('t-deltae');
    x_values(:,:,idx) = x(:,5);
    h_values(:,:,idx) = x(:,6);
end
end

