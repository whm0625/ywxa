% clear;
% clc;
%% Parameters of the Object
syms V miu alpha q x h T deltae Vs mius alphas qs xs hs Ts deltaes Vr miur alphar qr xr hr Tr deltaer t dV dmiu dalpha dq dx dh dT ddeltae;
m=0.8;      rho=1.225;
c=0.25;     b=1;
xcg=0.2; xc_4wing=0.25; xc_4tail=0.72;
g=9.8;      Iy=0.1;
Sw=0.25;    Se=0.054;
S=Sw+Se;    Le=0.235; 
% Bounds of rad: alpha[0.2 1];gamma[-4.1 0.4];deltae[-0.85 -0.15];
%% Aero-Dynamics
CL=0.8*sin(2*alpha);
CD=1.4*(sin(alpha))^2+0.1;
CM=-Se*Le/S*(0.8*cos(alpha)*sin(2*alpha+2*deltae)+1.4*sin(alpha)*(sin(alpha+deltae))^2+0.1*sin(alpha));
L=1/2*rho*V^2*S*CL;
D=1/2*rho*V^2*S*CD;
M=1/2*rho*V^2*S*CM;
%% Longitudinal Dynamics
f1=(T*cos(alpha)-D-m*g*sin(miu))/m;
f2=(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f3=q-(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f4=M/Iy;
f5=V*cos(miu);
f6=V*sin(miu);
f=[f1;f2;f3;f4;f5;f6];
%% Trajectory Linearization
% diff(X)-diff(Xr)=f(X,u)-f(Xr,ur);
% ��diff(Xr)=diff(f(Xr,ur),X)*��Xr+diff(f(Xr,ur),u)*��ur;
fr=subs(subs(subs(subs(subs(subs(subs(subs(f,V,Vs),miu,mius),alpha,alphas),q,qs),x,xs),h,hs),T,Ts),deltae,deltaes);
V=Vs+dV;    miu=mius+dmiu;    alpha=alphas+dalpha;    q=qs+dq;    x=xs+dx;    h=hs+dh;   T=Ts+dT;    deltae=deltaes+ddeltae;
f=eval(f);
f11=diff(f,dV);f12=diff(f,dmiu);f13=diff(f,dalpha);f14=diff(f,dq);f15=diff(f,dx);f16=diff(f,dh);
f17=diff(f,dT);f18=diff(f,ddeltae);

dV=0;   dmiu=0;   dalpha=0;   dq=0;   dx=0;   dh=0;    dT=0;   ddeltae=0;
f11=eval(f11);f12=eval(f12);f13=eval(f13);f14=eval(f14);f15=eval(f15);f16=eval(f16);
f17=eval(f17);f18=eval(f18);
sub1=[f11,f12,f13,f14,f15,f16,f17,f18];

Sorigin=[sub1];
%% Reference Values
sim('guiji_6d1');
y1 = polyfit(V0.time,V0.signals.values,5);
y2 = polyfit(miu0.time,miu0.signals.values,5);
y3 = polyfit(alpha0.time,alpha0.signals.values,5);
y4 = polyfit(q0.time,q0.signals.values,5);
y5 = polyfit(x0.time,x0.signals.values,5);
y6 = polyfit(h0.time,h0.signals.values,5);

%����켣
t=sym('t');
tt=sym('tt');
Vr=poly2sym(y1,t);
miur=poly2sym(y2,t);
alphar=poly2sym(y3,t);
qr=poly2sym(y4,t);
xr=poly2sym(y5,t);
hr=poly2sym(y6,t);
Tr=3.8378;
tz = NaN;
deltae1=[-(11+(tz)/0.3*22)/180*pi;-(33+(tz-0.3)/0.2*15)/180*pi;-(33+15-(tz-0.5)/0.2*30)/180*pi;-(18)/180*pi;];
if tz<0.3
    deltaer=subs(deltae1(1,1),tz,t);
else if tz<0.5
        deltaer=subs(deltae1(2,1),tz,t);
    else if tz<0.7
            deltaer=subs(deltae1(3,1),tz,t);
        else
            deltaer=subs(deltae1(4,1),tz,t);
        end
    end
end
deltaer=subs(deltaer,tz,t);
v2=subs(Vr,t,tt);
miu2=subs(miur,t,tt);
alpha2=subs(alphar,t,tt);
q2=subs(qr,t,tt);
x2=subs(xr,t,tt);
h2=subs(hr,t,tt);
%% Functions about 't';
Soriginxin=subs(Sorigin,Vs,Vr);
Soriginxin=subs(Soriginxin,mius,miur);
Soriginxin=subs(Soriginxin,alphas,alphar);
Soriginxin=subs(Soriginxin,qs,qr);
Soriginxin=subs(Soriginxin,ss,xr);
Soriginxin=subs(Soriginxin,hs,hr);
Soriginxin=subs(Soriginxin,Ts,Tr);
Soriginxin=subs(Soriginxin,deltaes,deltaer);
Ak = Soriginxin(1:6,1:6);
Bk = Soriginxin(1:6,7:8);
new1=str2sym('p(1)');
SLpv0=subs (Soriginxin,t, new1);
LPV1=cell(6,8);
for i=1:6
    for j=1:8
        eval(['LPV1','{i,j}','=','@(p)',vectorize(SLpv0(i,j)),';']);
    end
end
save('lpvmodel1.mat','LPV1');