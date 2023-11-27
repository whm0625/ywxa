function accuracy = test_initial_region(initial_centers, initial_radii,F)
load('xr(0.0.01.2).mat');
load('ur(0.0.01.2).mat');
load('F线性无扰动.mat');
load('Jaccobi.mat');
% 生成测试用的时间向量
t_span = 0:0.01:2;
random_count = 1000000;
% 初始化准确计数器
accurate_count = 0;

for i = 1:random_count
    % 获取当前初始点的中心和半径
    random_point = random_sample_points(initial_centers, initial_radii,xr);
    x=zeros(201,6);
    u=zeros(201,2);
    dx=zeros(201,6);
    du=zeros(201,2);
    % 初始化状态
    x(1,:) = random_point;
    % 模拟系统演化
    k = 1;
    for t=0:0.01:2
        dx(k,:)=x(k,:)-xr(k,:);
        du(k,:)=(F(:,:,k)*dx(k,:)')';
        u(k,:)=du(k,:)+ur(k,:);
        u0=u(k,:);
        u0=u0';
        A = Aall(:,:,k);
        B = Ball(:,:,k);
        closed_loop = A + B * F(:,:,k);
        
        if k<201
            x(k+1,:) = (closed_loop*dx(k,:)')'+ xr(k+1,:);
        end
        k=k+1; 
    end
    
    % 判断末端是否在期望范围内
    if issafe(x)
        accurate_count = accurate_count + 1;
    end
end

% 计算准确率
accuracy = accurate_count / random_count;
end