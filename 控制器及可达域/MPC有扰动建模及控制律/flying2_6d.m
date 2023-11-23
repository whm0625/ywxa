function [sys,x0,str,ts,simStateCompliance] = flying2_6d(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u);
  case 2,
    sys=mdlUpdate(t,x,u);
  case 3,
    sys=mdlOutputs(t,x,u);
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);
  case 9,
    sys=mdlTerminate(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates=6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 7;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [9.9736 0 0.2455  0  0 0];
str = [];
ts  = [0 0];
simStateCompliance = 'UnknownSimState';
function sys=mdlDerivatives(t,x,u)
m=0.8;
rou=1.225;
g=9.8;
Iy=0.1;
Sw=0.25;
Se=0.054;
S=Sw+Se;
Le=0.235; 
T=u(1);
v=x(1);
% afar=x(3)/pi*180;
% gamma=x(2)/pi*180;
% q=x(4)/pi*180;
% der=u(2)/pi*180;
afar=x(3);
gamma=x(2);
q=x(4);
der=u(2);
% x=x(5);
% h=x(6);

CL=0.8*sin(2*afar);
CD=1.4*(sin(afar))^2+0.1;
CM=-Se*Le/S*(0.8*cos(afar)*sin(2*afar+2*der)+1.4*sin(afar)*(sin(afar+der))^2+0.1*sin(afar));
L=1/2*rou*v^2*S*CL;
D=1/2*rou*v^2*S*CD;
M=1/2*rou*v^2*S*CM;

sys(1)=(T*cos(x(3))-D-m*g*sin(x(2)))/m;
sys(2)=(T*sin(x(3))+L-m*g*cos(x(2)))/(m*v);
sys(3)=x(4)-(T*sin(x(3))+L-m*g*cos(x(2)))/(m*v);
sys(4)=M/Iy;
sys(5)=v*cos(x(2));
sys(6)=v*sin(x(2));
function sys=mdlUpdate(t,x,u)
sys = [];
function sys=mdlOutputs(t,x,u)
m=0.8;
rou=1.225;
g=9.8;
Iy=0.1;
Sw=0.25;
Se=0.054;
S=Sw+Se;
Le=0.235; 
T=u(1);
v=x(1);

afar=x(3);
gamma=x(2);
q=x(4);
der=u(2);


CM=-Se*Le/S*(0.8*cos(afar)*sin(2*afar+2*der)+1.4*sin(afar)*(sin(afar+der))^2+0.1*sin(afar));
M=1/2*rou*v^2*S*CM;
sys = [x(1);x(2);x(3);x(4);x(5);x(6);M]; 
function sys=mdlGetTimeOfNextVarHit(t,x,u)
sampleTime = 1;
sys = t + sampleTime;
function sys=mdlTerminate(t,x,u)
sys = [];   