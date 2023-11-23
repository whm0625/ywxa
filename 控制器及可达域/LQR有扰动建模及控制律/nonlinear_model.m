function out =real_6d(t,x,u)
m=0.8;
rou=1.225;
g=9.8;
Iy=0.1;
Sw=0.25;
Se=0.054;
% S=Sw;
S=Sw+Se;
Le=0.235;
if t<=0.7
    Vw=-0.5-sin(1.43*pi*t);
else
    Vw=-0.5;  
end
%  Vw=0;
V=x(1);
miu=x(2);
alpha=x(3);
q=x(4);
h=x(6);

T=u(1);
deltae=u(2);

CL=0.8*sin(2*alpha);
CD=1.4*(sin(alpha))^2+0.1;
CM=-Se*Le/S*(0.8*cos(alpha)*sin(2*alpha+2*deltae)+1.4*sin(alpha)*(sin(alpha+deltae))^2+0.1*sin(alpha));

L=1/2*rou*(V+Vw)^2*S*CL;
D=1/2*rou*(V+Vw)^2*S*CD;
M=1/2*rou*(V+Vw)^2*S*CM;

f1=(T*cos(alpha)-D-m*g*sin(miu))/m;
f2=(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f3=q-(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f4=M/Iy;
f5=V*cos(miu);
f6=V*sin(miu);

out=[f1;f2;f3;f4;f5;f6];
