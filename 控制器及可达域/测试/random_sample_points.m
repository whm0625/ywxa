function point = random_sample_points(centers, radii,xr)
    % 从初始区域中随机采样一个点
    % 使用每个维度上的均匀分布采样
    random_index = randi(size(centers, 1));
    point = xr(1, :);

    for dim = 5:6
        center = centers(random_index,dim-4);
        radius = radii(random_index,dim-4);
        point(dim) = center + (2 * rand() - 1) * radius;
    end
end