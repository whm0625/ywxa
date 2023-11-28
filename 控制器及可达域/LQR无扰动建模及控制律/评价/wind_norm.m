i = 1;
for t = 0:0.01:2
    if t<=0.7
        Vw(i)=-0.5-sin(1.43*pi*t);
    else
        Vw(i)=-0.5;
    end
    i = i+1;
end
Vw = Vw';

% 计算风扰在0-2s内的2范数
time_interval = 0:0.01:2;
norm_2 = norm(Vw);

disp(['风扰在0-2s内的2范数为 ', num2str(norm_2)]);

load('无扰动初始区域的面积.mat');
area = totalArea;

load('有扰动初始区域的面积.mat');
area_disturbance = totalArea;

robustness_index = (area - area_disturbance) / norm_2;

disp(['鲁棒性指标为 ', num2str(robustness_index)]);