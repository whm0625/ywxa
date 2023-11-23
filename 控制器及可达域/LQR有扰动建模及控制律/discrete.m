syms  V miu alpha q x h T deltae Vw t p

m=0.8;
rou=1.225;
g=9.8;
Iy=0.1;
Sw=0.25;
Se=0.054;
% S=Sw;
S=Sw+Se;
Le=0.235;

CL=0.8*sin(2*alpha);
CD=1.4*(sin(alpha))^2+0.1;
CM=-Se*Le/S*(0.8*cos(alpha)*sin(2*alpha+2*deltae)+1.4*sin(alpha)*(sin(alpha+deltae))^2+0.1*sin(alpha));
% L=1/2*rou*(V+Vw)^2*S*CL;
% D=1/2*rou*(V+Vw)^2*S*CD;
% M=1/2*rou*(V+Vw)^2*S*CM;

L=1/2*rou*(V)^2*S*CL;
D=1/2*rou*(V)^2*S*CD;
M=1/2*rou*(V)^2*S*CM;

f1=(T*cos(alpha)-D-m*g*sin(miu))/m;
f2=(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f3=q-(T*sin(alpha)+L-m*g*cos(miu))/(m*V);
f4=M/Iy;
f5=V*cos(miu);
f6=V*sin(miu);

f=[f1 f2 f3 f4 f5 f6];

dt=0.01;
A=jacobian(f,[V miu alpha q x h]);
A=A*dt+eye(6,6);
% A=A*dt;
B=jacobian(f,[T deltae]);
B=B*dt;

sim('guiji_6d1');
y1 = polyfit(V0.time,V0.signals.values,5);
y2 = polyfit(miu0.time,miu0.signals.values,5);
y3 = polyfit(alpha0.time,alpha0.signals.values,5);
y4 = polyfit(q0.time,q0.signals.values,5);
y5 = polyfit(x0.time,x0.signals.values,5);
y6 = polyfit(h0.time,h0.signals.values,5);
t=sym('t');
tt=sym('tt');
Vr=poly2sym(y1,t);
miur=poly2sym(y2,t);
alphar=poly2sym(y3,t);
qr=poly2sym(y4,t);
xr=poly2sym(y5,t);
hr=poly2sym(y6,t);

Tr=3.7698;
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
Ak=subs(A,[V miu alpha q h T deltae],[Vr miur alphar qr hr Tr deltaer]);
Bk=subs(B,[V miu alpha q h T deltae],[Vr miur alphar qr hr Tr deltaer]);
