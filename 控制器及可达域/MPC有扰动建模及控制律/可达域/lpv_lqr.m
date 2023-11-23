%  function LPV_closed=lpv_lqr()
%  function [LPV_closed,Kall]=lpv_lqr()
load('lpvmodel1.mat','LPV1');
LPV=LPV1;

% 定义参数p的范围
%  p_range = 0:0.05:2.05;  % p的范围
%  p_range = 0:0.1:2.1;  % p的范围
 p_range = 0:0.1:2;  % p的范围
syms p;
A = sym('A', [size(LPV, 1), size(LPV, 1)]);
B = sym('B', [size(LPV, 1), size(LPV, 2) - size(A, 1)]);

% 定义LQR控制器参数
Q= [1.5 0 0 0 0 0;
    0 8 0 0 0 0;
    0 0 1.5 0 0 0;
    0 0 0 1.5 0 0;
    0 0 0 0 40 0;
    0 0 0 0 0 15;];
R=[5   0;
    0   50;];
% 存储闭环系统的模型
LPV_closed = zeros(6, 6, numel(p_range));

for i = 1:numel(p_range)
    p = p_range(i);
    
    % 获取当前 p 值对应的 LPV 模型
    LPV_p = cellfun(@(f) f(p), LPV);
    A = LPV_p(1:6, 1:6);
    B = LPV_p(1:6, 7:8);
    
    % 计算 LQR 控制器的增益矩阵 K
    K = lqr(A, B, Q, R);
%     [P, ~, ~] = care(A, B, Q, R)
%      K_back = inv(R) * B' * P;
    % 计算闭环系统的 A 和 B 矩阵
    A_all(:, :, i) = A;
    B_all(:, :, i) = B;
    
    % 存储闭环系统的模型
    LPV_closed(:, :, i) = A - B * K;
    % 将当前 p 值下的 K 存储到 Kall 变量中
    Kall(:, :, i)=K;
end
% end
