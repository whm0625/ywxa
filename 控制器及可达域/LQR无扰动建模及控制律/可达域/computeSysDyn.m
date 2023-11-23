function dx = computeSysDyn(t,x,LPV_p)
% 计算系统动态函数
% LPV_p: 闭环系统模型
% x: 当前状态
% x_ref: 参考状态
% v1 = double(subs(Xr_ref(1,:), t));
% miu1 = double(subs(Xr_ref(2,:), t));
% alpha1 = double(subs(Xr_ref(3,:), t));
% q1 = double(subs(Xr_ref(4,:), t));
% x1 = double(subs(Xr_ref(5,:), t));
% h1 = double(subs(Xr_ref(6,:), t));
% 
% x_ref = [v1; miu1; alpha1; q1; x1; h1];
 LPV_p = padarray(LPV_p, [1, 1], 0, 'post');
dx = LPV_p *x;
% dx = zeros(7,1);
% x_ref1 = get_reference_trajectory(t);
% x1 = x(1:6) - x_ref1';
% u = -K *x1;
% T = u(1)+3.8378;
% % tz = NaN;
% deltae1=[-(11+(t)/0.3*22)/180*pi;-(33+(t-0.3)/0.2*15)/180*pi;-(33+15-(t-0.5)/0.2*30)/180*pi;-(18)/180*pi;];
% if t<0.3
%     deltaer=deltae1(1,1);
% else if t<0.5
%         deltaer=deltae1(2,1);
%     else if t<0.7
%             deltaer=deltae1(3,1);
%         else
%             deltaer=deltae1(4,1);
%         end
%     end
% end
% % deltaer=subs(deltaer,tz,t);
% deltae = u(2)+deltaer;
% V = x(1);
% miu = x(2);
% alpha = x(3);
% q = x(4);
% %% Parameters of the Object
% % syms V miu alpha q x h T deltae Vs mius alphas qs xs hs Ts deltaes Vr miur alphar qr xr hr Tr deltaer t dV dmiu dalpha dq dx dh dT ddeltae;
% m=0.8;      rho=1.225;
% c=0.25;     b=1;
% xcg=0.2; xc_4wing=0.25; xc_4tail=0.72;
% g=9.8;      Iy=0.1;
% Sw=0.25;    Se=0.054;
% S=Sw+Se;    Le=0.235; 
% % Bounds of rad: alpha[0.2 1];gamma[-4.1 0.4];deltae[-0.85 -0.15];
% %% Aero-Dynamics
% CL=0.8*sin(2*alpha);
% CD=1.4*(sin(alpha))^2+0.1;
% CM=-Se*Le/S*(0.8*cos(alpha)*sin(2*alpha+2*deltae)+1.4*sin(alpha)*(sin(alpha+deltae))^2+0.1*sin(alpha));
% L=1/2*rho*V^2*Sw*CL;
% D=1/2*rho*V^2*Sw*CD;
% M=1/2*rho*V^2*Sw*CM;
% %% Longitudinal Dynamics
% dx(1)=(T*cos(alpha)-D-m*g*sin(miu))/m;
% dx(2)=(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
% dx(3)=q-(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
% dx(4)=M/Iy;
% dx(5)=V*cos(miu);
% dx(6)=V*sin(miu);
% dx(7) = 0;
end
