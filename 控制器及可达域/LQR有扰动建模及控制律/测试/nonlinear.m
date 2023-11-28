tic;
load('xr(0.0.01.2).mat');
load('ur(0.0.01.2).mat');
load('Kall线性离散无扰动1.mat');
% 生成测试用的时间向量
t_span = 0:0.01:2;
random_count = 10000;
% 初始化准确计数器
accurate_count = 0;

% 存储安全轨迹的终点
% safe_trajectories = zeros(length(t_span), 6,random_count);

for i = 1:random_count
    % 获取当前初始点的中心和半径
    random_point = random_sample_points1(xr);
    x0 = random_point;
    u = zeros(length(t_span), 2);
    
    % 模拟系统演化
    [x,u] = simulate_system(x0, u, Kall, t_span,xr,ur);
    
    % 判断末端是否在期望范围内
    if issafe(x,u,xr)
        accurate_count = accurate_count + 1;
         safe_trajectories(:, :,accurate_count) = x;
        init_safe(accurate_count,:) = x0;
    end
end

% 绘制安全轨迹
figure;hold on
% for j = 1:size(safe_trajectories,3)
%     plot(safe_trajectories(:, 5,j), safe_trajectories(:, 6,j), 'b.');
% 
% end
scatter(init_safe(:, 5), init_safe(:, 6), 10, 'r','filled');
% 在图中绘制 safe_trajectories

xlabel('x');
ylabel('h');
% title('Safe Trajectories');
toc;