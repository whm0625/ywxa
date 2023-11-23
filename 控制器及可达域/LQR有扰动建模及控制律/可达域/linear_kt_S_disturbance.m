function [sys,x0,str,ts,simStateCompliance] = linear_kt_S(t,x,u,flag,Kall1)
    
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
    sys=mdlOutputs(t,x,u,Kall1);
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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
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
function sys=mdlOutputs(t,x,u,Kall1)
% sym j;
% j=2*round(t*10)+1;
% Kt=Kall(j:j+1,1:6);
model_idx = 1;  % 初始模型索引为1
switch_times = [0 0.05 0.15:0.1:2];
for i = 1:numel(switch_times)
    if t > switch_times(i)
        model_idx = i;  % 切换到下一个模型
    else
        break;  % 停止比较，找到对应的模型索引
    end
end
Kt = Kall1(:,:,model_idx);
sys=-Kt*u;
sys = [sys(1);sys(2);]; 
function sys=mdlGetTimeOfNextVarHit(t,x,u)
sampleTime = 1;
sys = t + sampleTime;
function sys=mdlTerminate(t,x,u)
sys = [];   
