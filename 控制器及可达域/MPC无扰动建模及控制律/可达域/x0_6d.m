function [sys,x0,str,ts,simStateCompliance] = x0(t,x,u,flag, Vr,miur,alphar,qr,xr,hr)
    
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
switch flag,
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u);
  case 2,
    sys=mdlUpdate(t,x,u);
  case 3,
    sys=mdlOutputs(t,x,u, Vr,miur,alphar,qr,xr,hr);
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);
  case 9,
    sys=mdlTerminate(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
simStateCompliance = 'UnknownSimState';
function sys=mdlDerivatives(t,x,u)
sys = [];


function sys=mdlUpdate(t,x,u)
sys = [];
function sys=mdlOutputs(t,x,u,Vr,miur,alphar,qr,xr,hr)
% v1,gamma1,afar1,q1,x1,h1
% v2,gamma2,afar2,q2,x2,h2
%     t=sym('t');
% tt=sym('tt');
% sys(1)=double(subs(v2,tt,t));
% sys(2)=double(subs(gamma2,tt,t));
% sys(3)=double(subs(afar2,tt,t));
% sys(4)=double(subs(q2,tt,t));
% sys(5)=double(subs(x2,tt,t));
% sys(6)=double(subs(h2,tt,t));

sys(1)=double(subs(Vr,t));
sys(2)=double(subs(miur,t));
sys(3)=double(subs(alphar,t));
sys(4)=double(subs(qr,t));
sys(5)=double(subs(xr,t));
sys(6)=double(subs(hr,t));



sys = [sys(1);sys(2);sys(3);sys(4);sys(5);sys(6)];
function sys=mdlGetTimeOfNextVarHit(t,x,u)
sampleTime = 1;
sys = t + sampleTime;
function sys=mdlTerminate(t,x,u)
sys = [];   
