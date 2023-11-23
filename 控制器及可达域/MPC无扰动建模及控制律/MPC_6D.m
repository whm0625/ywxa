%单一控制率+++++++++++++++++++++
clear;
clc
tic
x=zeros(206,6);
u=zeros(206,2);
dx=zeros(206,6);
du=zeros(206,2);
q=[1,3,1,1,70,30];
load('xr206.mat');
load('ur206.mat');
% load('gudingyi_lpv.mat','LPV1');
load('顶点矩阵无扰动.mat');
load('Jaccobi.mat');
% LPV = LPV1;
syms p t
% A = Soriginxin(1:6,1:6);
% B = Soriginxin(1:6,7:8);
% Ts = 0.01; % 例如，假设采样时间为 0.01 秒
% 
% % 符号型的离散化
% Ad = eye(size(A)) + Ts * A;
% Bd = Ts * B;

Ad = subs(Ak, t, p);
Bd = subs(Bk, t, p);

Q=diag(q);
%  r=[100 110];
r=[8 100];
R=diag(r);

%  x(1,:)=[0+0.8,0-0.8,13+0.5,0+0.15,0.177-0.15,0];
%   x(1,:)=[9.9735   -0.0005    0.2442   -0.0034    -0.3   -0.3];
 x(1,:)=xr206(1,:);
k=1;
dt=0.01;
% dx(1,:)=x(1,:)-xr206(1,:);
for t=0:0.01:2.05
    
    dx(k,:)=x(k,:)-xr206(k,:);
    
    setlmis([]);
    X=lmivar(1,[6 1]);
    Y=lmivar(2,[2 6]);
    g=lmivar(1,[1 1]);
    
    %LMI 1
    if t<=0.9
        u1max=3.6;
        u2max=0.6;
    else
        u2max=0.9;
    end
    lmiterm([-1,1,1,0],[u1max^2 0;0 u2max^2]);
    lmiterm([-1,1,2,Y],1,1);
    lmiterm([-1,2,2,X],1,1);
    
    %LMI 2
    lmiterm([-2,1,1,0],1);
    lmiterm([-2,2,1,0],dx(k,:)');
    lmiterm([-2,2,2,X],1,1);
    
    for i=3:5
        if 1<=k&&k<=5
            Ai=AA(:,:,i-2,1);
            Bi=BB(:,:,i-2,1);
        elseif k>=6&&k<=15
            Ai=AA(:,:,i-2,2);
            Bi=BB(:,:,i-2,2);
        elseif k>=16&&k<=25
            Ai=AA(:,:,i-2,3);
            Bi=BB(:,:,i-2,3);
        elseif k>=26&&k<=35
            Ai=AA(:,:,i-2,4);
            Bi=BB(:,:,i-2,4);
        elseif k>=36&&k<=45
            Ai=AA(:,:,i-2,5);
            Bi=BB(:,:,i-2,5);
        elseif k>=46&&k<=55
            Ai=AA(:,:,i-2,6);
            Bi=BB(:,:,i-2,6);
        elseif k>=56&&k<=65
            Ai=AA(:,:,i-2,7);
            Bi=BB(:,:,i-2,7);
        elseif k>=66&&k<=75
            Ai=AA(:,:,i-2,8);
            Bi=BB(:,:,i-2,8);
        elseif k>=76&&k<=85
            Ai=AA(:,:,i-2,9);
            Bi=BB(:,:,i-2,9);
        elseif k>=86&&k<=95
            Ai=AA(:,:,i-2,10);
            Bi=BB(:,:,i-2,10);
        elseif k>=96&&k<=105
            Ai=AA(:,:,i-2,11);
            Bi=BB(:,:,i-2,11);
        elseif k>=106&&k<=115
            Ai=AA(:,:,i-2,12);
            Bi=BB(:,:,i-2,12);
        elseif k>=116&&k<=125
            Ai=AA(:,:,i-2,13);
            Bi=BB(:,:,i-2,13);
        elseif k>=126&&k<=135
            Ai=AA(:,:,i-2,14);
            Bi=BB(:,:,i-2,14);
        elseif k>=136&&k<=145
            Ai=AA(:,:,i-2,15);
            Bi=BB(:,:,i-2,15);
        elseif k>=146&&k<=155
            Ai=AA(:,:,i-2,16);
            Bi=BB(:,:,i-2,16);
        elseif k>=156&&k<=165
            Ai=AA(:,:,i-2,17);
            Bi=BB(:,:,i-2,17);
        elseif k>=166&&k<=175
            Ai=AA(:,:,i-2,18);
            Bi=BB(:,:,i-2,18);
        elseif k>=176&&k<=185
            Ai=AA(:,:,i-2,19);
            Bi=BB(:,:,i-2,19);
        elseif k>=186&&k<=195
            Ai=AA(:,:,i-2,20);
            Bi=BB(:,:,i-2,20);
        else
            Ai=AA(:,:,i-2,21);
            Bi=BB(:,:,i-2,21);
        end
        %   Bi=[0         0;
        %       0         0;
        %       0    0.0327;
        %       0    0.0404;
        %       0   -0.0404;
        % -0.1640         0;];
        
        
        %         Ai=eye(4,4);
        %         Bi=eye(4,2);
        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);
        
        %LMI 3-9
        lmiterm([-i,1,1,X],1,1);
        
        lmiterm([-i,2,1,X],Ai,1);
        lmiterm([-i,2,1,Y],Bi,1);
        lmiterm([-i,2,2,X],1,1);
        
        lmiterm([-i,3,1,X],Q^0.5,1);
        lmiterm([-i,3,2,0],O1);
        lmiterm([-i,3,3,g],1,I1);
        
        lmiterm([-i,4,1,Y],R^0.5,1);
        lmiterm([-i,4,2,0],O2);
        lmiterm([-i,4,3,0],O2);
        lmiterm([-i,4,4,g],1,I2);
    end
    
    lmis=getlmis;
    n=decnbr(lmis);%获取LMI中决策变量的个数
    c=zeros(n,1);
    c(n)=1;
    options=[0,1000, 0,0,0];
    
    [copt,xopt]=mincx(lmis,c,options);
    %     [copt,xopt]=feasp(lmis,options);%%%%%
    
    XX(:,:,k)=dec2mat(lmis,xopt,X);
    Y=dec2mat(lmis,xopt,Y);
    g=dec2mat(lmis,xopt,g);
    
    F(:,:,k)=Y*XX(:,:,k)^-1;
    P(:,:,k)=g*XX(:,:,k)^-1;
    
    
    du(k,:)=(F(:,:,k)*dx(k,:)')';
    u(k,:)=du(k,:)+ur206(k,:);
    u0=u(k,:);
    u0=u0';
    u1 = du(k,:)';
    %     F1 = F(:,:,k);
    %     p = t;
    %     lpv = cellfun(@(f) f(p),LPV);
    %     A = lpv(1:6,1:6);
    %     B = lpv(1:6,7:8);
    A = subs(Ad, p, t);
    B = subs(Bd, p, t);
    closed_loop = A + B * F(:,:,k);
    
    %     tspan = t:0.01:t+0.01;
    %     [t, sol]=ode45(@(t,x)linear_model(t,x,closed_loop),tspan,dx(k,:)');
    
    if k<206
        x(k+1,:) = (closed_loop*dx(k,:)')'+ xr206(k+1,:);
        %         x(k+1,:) = sol(end,:)+ xr206(k+1,:);
    end
    k=k+1;
end
toc
t=0:0.01:2.05;
t=t';
xx=x(1:206,1);
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

% 调整子图之间的间距
% set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
