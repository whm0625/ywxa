function [sys,x0,str,ts,simStateCompliance] = linear_flying2(t,x,u,flag,A_all1, B_all1)
switch flag,
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u,A_all1, B_all1);
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
sizes.NumOutputs     = 6;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
%   x0  = [11  0.1  0.3  0.1  1 -1];
 x0  = [1 0.1 0.05 0.1 1 -1];
%  x0  = [1 0 0 0 1 -1];

%  x0  = [9.952199290302477;0.004200429634922;0.254443894329938;-0.016087320955839;0.011748295347984;-0.002886187974813];

str = [];
ts  = [0 0];
simStateCompliance = 'UnknownSimState';
function sys=mdlDerivatives(t,x,u,A_all1, B_all1)
% persistent current_model_idx
%     
%     if isempty(current_model_idx)
%         % 设置初始模型索引为1
%         current_model_idx = 1;
%     end
%     
%     % 模型切换时间点
% %     switch_times = 0:0.1:2;
      switch_times = [0 0.05 0.15:0.1:2];
%     % 获取当前时间对应的模型索引
%     [~, model_idx] = histc(t, switch_times);
model_idx = 1;  % 初始模型索引为1

for i = 1:numel(switch_times)
    if t > switch_times(i)
        model_idx = i;  % 切换到下一个模型
    else
        break;  % 停止比较，找到对应的模型索引
    end
end
    
%     % 调整模型索引
%     if model_idx > numel(A_all)
%         model_idx = numel(A_all);
%     end
%     
%     if model_idx ~= current_model_idx
%         % 切换到新的模型时，更新模型索引
%         current_model_idx = model_idx;
%     end
    
    % 获取当前模型的参数
    A_model = A_all1(:,:,model_idx);
    B_model = B_all1(:,:,model_idx);
    
    % 使用模型参数计算状态变化率
    sys = A_model * x + B_model * u;

function sys=mdlUpdate(t,x,u)
sys = [];
function sys=mdlOutputs(t,x,u)
  sys = [x(1);x(2);x(3);x(4);x(5);x(6)];
%sys = [x(1);x(2);x(3);x(4);x(5);x(6)]; 
function sys=mdlGetTimeOfNextVarHit(t,x,u)
sampleTime = 1;
sys = t + sampleTime;
function sys=mdlTerminate(t,x,u)
sys = [];  