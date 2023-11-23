%单一控制率+++++++++++++++++++++
% clear
clc
% load('xr.mat')
% load('ur.mat')
% load('AA.mat')
tic
x=zeros(201,6);
u=zeros(201,2);
du=zeros(201,2);
% q=[20,20,1.5,3,15,1];
q=[20,20,1.5,3,80,80];
Q=diag(q);
% r=[0.01 0.01];
r=[80 110];
R=diag(r);

% x(1,:)=[xr(1)+0.5,xr(2)+0.15,xr(3)-0.15,xr(4)+0.05,xr(5)+0.5,xr(6)+0.5];
%x(1,:)=[0,0,13,0,0.177,0];
x(1,:)=[11  0.1  0.2  0.1  0.5 -0.5];
k=1;

dt=0.01;
for t=0:0.01:2

    dx(k,:)=x(k,:)-xr(k,:);

    setlmis([]);  %初始化一个LMI系统，并设置为空


    X1=lmivar(1,[6 1]);
    X2=lmivar(1,[6 1]);
    X3=lmivar(1,[6 1]);
    G=lmivar(1,[6 1]);%6*6的全对称矩阵
    Y=lmivar(2,[2 6]);%2*6的普通矩阵（状态反馈矩阵）
    g=lmivar(1,[1 1]);%实数

    %LMI 1-3
    if t<=0.9

        u2max=0.6;
        u1max=3.6;
    else
        u2max=0.9;
    end
    % 构建LMI约束条件
    lmiterm([-1,1,1,0],[u2max^2 0;0 u1max^2]);
    lmiterm([-1,1,2,Y],1,1);
    lmiterm([-1,2,2,G],1,1);
    lmiterm([-1,2,2,-G],1,1);
    lmiterm([1,2,2,X1],1,1);

    lmiterm([-2,1,1,0],[u2max^2 0;0 u1max^2]);
    lmiterm([-2,1,2,Y],1,1);
    lmiterm([-2,2,2,G],1,1);
    lmiterm([-2,2,2,-G],1,1);
    lmiterm([2,2,2,X2],1,1);

    lmiterm([-3,1,1,0],[u2max^2 0;0 u1max^2]);
    lmiterm([-3,1,2,Y],1,1);
    lmiterm([-3,2,2,G],1,1);
    lmiterm([-3,2,2,-G],1,1);
    lmiterm([3,2,2,X3],1,1);

    %LMI 4-6

    lmiterm([-4,1,1,0],1);
    lmiterm([-4,2,1,0],dx(k,:)');
    lmiterm([-4,2,2,X1],1,1);

    lmiterm([-5,1,1,0],1);
    lmiterm([-5,2,1,0],dx(k,:)');
    lmiterm([-5,2,2,X2],1,1);

    lmiterm([-6,1,1,0],1);
    lmiterm([-6,2,1,0],dx(k,:)');
    lmiterm([-6,2,2,X3],1,1);


    %LMI 7-11
    ii = 1;
    flag1=1;
    if(flag1==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-7,1,1,G],1,1);
        lmiterm([-7,1,1,-G],1,1);
        lmiterm([7,1,1,X1],1,1);

        lmiterm([-7,2,1,G],Ai,1);
        lmiterm([-7,2,1,Y],Bi,1);
        lmiterm([-7,2,2,X1],1,1);

        lmiterm([-7,3,1,G],Q^0.5,1);
        lmiterm([-7,3,2,0],O1);
        lmiterm([-7,3,3,g],1,I1);

        lmiterm([-7,4,1,Y],R^0.5,1);
        lmiterm([-7,4,2,0],O2);
        lmiterm([-7,4,3,0],O2);
        lmiterm([-7,4,4,g],1,I2);  %公式4.33
    end
    flag2=1;
    if(flag2==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-8,1,1,G],1,1);
        lmiterm([-8,1,1,-G],1,1);
        lmiterm([8,1,1,X1],1,1);

        lmiterm([-8,2,1,G],Ai,1);
        lmiterm([-8,2,1,Y],Bi,1);
        lmiterm([-8,2,2,X1],1,1);

        lmiterm([-8,3,1,G],Q^0.5,1);
        lmiterm([-8,3,2,0],O1);
        lmiterm([-8,3,3,g],1,I1);

        lmiterm([-8,4,1,Y],R^0.5,1);
        lmiterm([-8,4,2,0],O2);
        lmiterm([-8,4,3,0],O2);
        lmiterm([-8,4,4,g],1,I2);  %公式4.33
    end
    flag3=1;
    if(flag3==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-9,1,1,G],1,1);
        lmiterm([-9,1,1,-G],1,1);
        lmiterm([9,1,1,X1],1,1);

        lmiterm([-9,2,1,G],Ai,1);
        lmiterm([-9,2,1,Y],Bi,1);
        lmiterm([-9,2,2,X1],1,1);

        lmiterm([-9,3,1,G],Q^0.5,1);
        lmiterm([-9,3,2,0],O1);
        lmiterm([-9,3,3,g],1,I1);

        lmiterm([-9,4,1,Y],R^0.5,1);
        lmiterm([-9,4,2,0],O2);
        lmiterm([-9,4,3,0],O2);
        lmiterm([-9,4,4,g],1,I2);
    end
    flag4=1;
    if(flag4==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-10,1,1,G],1,1);
        lmiterm([-10,1,1,-G],1,1);
        lmiterm([10,1,1,X2],1,1);

        lmiterm([-10,2,1,G],Ai,1);
        lmiterm([-10,2,1,Y],Bi,1);
        lmiterm([-10,2,2,X2],1,1);

        lmiterm([-10,3,1,G],Q^0.5,1);
        lmiterm([-10,3,2,0],O1);
        lmiterm([-10,3,3,g],1,I1);

        lmiterm([-10,4,1,Y],R^0.5,1);
        lmiterm([-10,4,2,0],O2);
        lmiterm([-10,4,3,0],O2);
        lmiterm([-10,4,4,g],1,I2);
    end
    flag5=1;
    if(flag5==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-11,1,1,G],1,1);
        lmiterm([-11,1,1,-G],1,1);
        lmiterm([11,1,1,X2],1,1);

        lmiterm([-11,2,1,G],Ai,1);
        lmiterm([-11,2,1,Y],Bi,1);
        lmiterm([-11,2,2,X2],1,1);

        lmiterm([-11,3,1,G],Q^0.5,1);
        lmiterm([-11,3,2,0],O1);
        lmiterm([-11,3,3,g],1,I1);

        lmiterm([-11,4,1,Y],R^0.5,1);
        lmiterm([-11,4,2,0],O2);
        lmiterm([-11,4,3,0],O2);
        lmiterm([-11,4,4,g],1,I2);
    end
    %LMI 12-16
    ii = 2;
    flag6=1;
    if(flag6==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-12,1,1,G],1,1);
        lmiterm([-12,1,1,-G],1,1);
        lmiterm([12,1,1,X2],1,1);

        lmiterm([-12,2,1,G],Ai,1);
        lmiterm([-12,2,1,Y],Bi,1);
        lmiterm([-12,2,2,X2],1,1);

        lmiterm([-12,3,1,G],Q^0.5,1);
        lmiterm([-12,3,2,0],O1);
        lmiterm([-12,3,3,g],1,I1);

        lmiterm([-12,4,1,Y],R^0.5,1);
        lmiterm([-12,4,2,0],O2);
        lmiterm([-12,4,3,0],O2);
        lmiterm([-12,4,4,g],1,I2);
    end
    flag7=1;
    if(flag7==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-13,1,1,G],1,1);
        lmiterm([-13,1,1,-G],1,1);
        lmiterm([13,1,1,X3],1,1);

        lmiterm([-13,2,1,G],Ai,1);
        lmiterm([-13,2,1,Y],Bi,1);
        lmiterm([-13,2,2,X3],1,1);

        lmiterm([-13,3,1,G],Q^0.5,1);
        lmiterm([-13,3,2,0],O1);
        lmiterm([-13,3,3,g],1,I1);

        lmiterm([-13,4,1,Y],R^0.5,1);
        lmiterm([-13,4,2,0],O2);
        lmiterm([-13,4,3,0],O2);
        lmiterm([-13,4,4,g],1,I2);
    end
    flag8=1;
    if(flag8==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-14,1,1,G],1,1);
        lmiterm([-14,1,1,-G],1,1);
        lmiterm([14,1,1,X3],1,1);

        lmiterm([-14,2,1,G],Ai,1);
        lmiterm([-14,2,1,Y],Bi,1);
        lmiterm([-14,2,2,X3],1,1);

        lmiterm([-14,3,1,G],Q^0.5,1);
        lmiterm([-14,3,2,0],O1);
        lmiterm([-14,3,3,g],1,I1);

        lmiterm([-14,4,1,Y],R^0.5,1);
        lmiterm([-14,4,2,0],O2);
        lmiterm([-14,4,3,0],O2);
        lmiterm([-14,4,4,g],1,I2);
    end
    flag9=1;
    if(flag9==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-15,1,1,G],1,1);
        lmiterm([-15,1,1,-G],1,1);
        lmiterm([15,1,1,X3],1,1);

        lmiterm([-15,2,1,G],Ai,1);
        lmiterm([-15,2,1,Y],Bi,1);
        lmiterm([-15,2,2,X3],1,1);

        lmiterm([-15,3,1,G],Q^0.5,1);
        lmiterm([-15,3,2,0],O1);
        lmiterm([-15,3,3,g],1,I1);

        lmiterm([-15,4,1,Y],R^0.5,1);
        lmiterm([-15,4,2,0],O2);
        lmiterm([-15,4,3,0],O2);
        lmiterm([-15,4,4,g],1,I2);
    end
    flag10=1;
    if(flag10==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-16,1,1,G],1,1);
        lmiterm([-16,1,1,-G],1,1);
        lmiterm([16,1,1,X3],1,1);

        lmiterm([-16,2,1,G],Ai,1);
        lmiterm([-16,2,1,Y],Bi,1);
        lmiterm([-16,2,2,X3],1,1);

        lmiterm([-16,3,1,G],Q^0.5,1);
        lmiterm([-16,3,2,0],O1);
        lmiterm([-16,3,3,g],1,I1);

        lmiterm([-16,4,1,Y],R^0.5,1);
        lmiterm([-16,4,2,0],O2);
        lmiterm([-16,4,3,0],O2);
        lmiterm([-16,4,4,g],1,I2);
    end
    %LMI 17-21
    ii = 3;
    flag11=1;
    if(flag11==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-17,1,1,G],1,1);
        lmiterm([-17,1,1,-G],1,1);
        lmiterm([17,1,1,X3],1,1);

        lmiterm([-17,2,1,G],Ai,1);
        lmiterm([-17,2,1,Y],Bi,1);
        lmiterm([-17,2,2,X3],1,1);

        lmiterm([-17,3,1,G],Q^0.5,1);
        lmiterm([-17,3,2,0],O1);
        lmiterm([-17,3,3,g],1,I1);

        lmiterm([-17,4,1,Y],R^0.5,1);
        lmiterm([-17,4,2,0],O2);
        lmiterm([-17,4,3,0],O2);
        lmiterm([-17,4,4,g],1,I2);
    end
    flag12=1;
    if(flag12==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-18,1,1,G],1,1);
        lmiterm([-18,1,1,-G],1,1);
        lmiterm([18,1,1,X3],1,1);

        lmiterm([-18,2,1,G],Ai,1);
        lmiterm([-18,2,1,Y],Bi,1);
        lmiterm([-18,2,2,X3],1,1);

        lmiterm([-18,3,1,G],Q^0.5,1);
        lmiterm([-18,3,2,0],O1);
        lmiterm([-18,3,3,g],1,I1);

        lmiterm([-18,4,1,Y],R^0.5,1);
        lmiterm([-18,4,2,0],O2);
        lmiterm([-18,4,3,0],O2);
        lmiterm([-18,4,4,g],1,I2);
    end
    flag13=1;
    if(flag13==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-19,1,1,G],1,1);
        lmiterm([-19,1,1,-G],1,1);
        lmiterm([19,1,1,X3],1,1);

        lmiterm([-19,2,1,G],Ai,1);
        lmiterm([-19,2,1,Y],Bi,1);
        lmiterm([-19,2,2,X3],1,1);

        lmiterm([-19,3,1,G],Q^0.5,1);
        lmiterm([-19,3,2,0],O1);
        lmiterm([-19,3,3,g],1,I1);

        lmiterm([-19,4,1,Y],R^0.5,1);
        lmiterm([-19,4,2,0],O2);
        lmiterm([-19,4,3,0],O2);
        lmiterm([-19,4,4,g],1,I2);
    end
    flag14=1;
    if(flag14==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-20,1,1,G],1,1);
        lmiterm([-20,1,1,-G],1,1);
        lmiterm([20,1,1,X3],1,1);

        lmiterm([-20,2,1,G],Ai,1);
        lmiterm([-20,2,1,Y],Bi,1);
        lmiterm([-20,2,2,X3],1,1);

        lmiterm([-20,3,1,G],Q^0.5,1);
        lmiterm([-20,3,2,0],O1);
        lmiterm([-20,3,3,g],1,I1);

        lmiterm([-20,4,1,Y],R^0.5,1);
        lmiterm([-20,4,2,0],O2);
        lmiterm([-20,4,3,0],O2);
        lmiterm([-20,4,4,g],1,I2);

    end
    flag15=1;
    if(flag15==1)
        [Ai,Bi] = get_AiBi(AA,BB,ii,k);

        O1=zeros(6,6);
        O2=zeros(2,6);
        I1=eye(6,6);
        I2=eye(2,2);

        %LMI 3-9
        lmiterm([-21,1,1,G],1,1);
        lmiterm([-21,1,1,-G],1,1);
        lmiterm([21,1,1,X3],1,1);

        lmiterm([-21,2,1,G],Ai,1);
        lmiterm([-21,2,1,Y],Bi,1);
        lmiterm([-21,2,2,X3],1,1);

        lmiterm([-21,3,1,G],Q^0.5,1);
        lmiterm([-21,3,2,0],O1);
        lmiterm([-21,3,3,g],1,I1);

        lmiterm([-21,4,1,Y],R^0.5,1);
        lmiterm([-21,4,2,0],O2);
        lmiterm([-21,4,3,0],O2);
        lmiterm([-21,4,4,g],1,I2);

    end
    lmis=getlmis;
    n=decnbr(lmis);%获取LMI中决策变量的个数
    c=zeros(n,1);
    c(n)=1;
    options=[0,1000, 0,0,0];%迭代次数1000，其他值取默认值

    [copt,xopt]=mincx(lmis,c,options);    %%求解最优解mincx
    %     [copt,xopt]=feasp(lmis,options);%%%%%

    XX1(:,:,k)=dec2mat(lmis,xopt,X1);
    XX2(:,:,k)=dec2mat(lmis,xopt,X2);
    XX3(:,:,k)=dec2mat(lmis,xopt,X3);
    GG(:,:,k)=dec2mat(lmis,xopt,G);
    Y=dec2mat(lmis,xopt,Y);
    g=dec2mat(lmis,xopt,g);

    F(:,:,k)=Y*GG(:,:,k)^-1;
    %     P(:,:,k)=g*XX(:,:,k)^-1;


    du(k,:)=(F(:,:,k)*dx(k,:)')';%式子4.26
    u(k,:)=du(k,:)+ur(k,:);
    u0=u(k,:);
    u0=u0';%这一步的意义是什么

    [t, sol]=ode45(@(t,x,u)real_6d(t,x,u0),[t,t+0.01],x(k,:)');
    x(k+1,:) = sol(end,:);
    k=k+1;
end

toc
t=0:0.01:2;
t=t';
xx=x(1:201,1);
xxr=xr(:,1);
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