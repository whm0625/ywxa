load('LQR(3,2)线性离散无扰动1.mat');

totalArea = 0;

for i = 1:size(initial_radii, 1)
    width = initial_radii(i, 1) * 2;  % 宽度是直径
    height = initial_radii(i, 2) * 2; % 高度是直径
    area = width * height;
    totalArea = totalArea + area;
end

disp(['无扰动初始区域的面积为：', num2str(totalArea)]);
save('无扰动初始区域的面积.mat','totalArea');

load('LQR(4,2)线性离散有扰动.mat');

totalArea = 0;

for i = 1:size(initial_radii, 1)
    width = initial_radii(i, 1) * 2;  % 宽度是直径
    height = initial_radii(i, 2) * 2; % 高度是直径
    area = width * height;
    totalArea = totalArea + area;
end


disp(['有扰动初始区域的面积为：', num2str(totalArea)]);
save('有扰动初始区域的面积.mat','totalArea');