function point = random_sample_points1(xr)
    % 从初始区域中随机采样一个点，确保 x 在 [-3, 3]，h 在 [-2, 2] 的范围内
    point = xr(1, :);

    % 生成 x 在 [-3, 3] 范围内的值
    point(5) = (6 * rand() - 3);

    % 生成 h 在 [-2, 2] 范围内的值
    point(6) = (4 * rand() - 2);
end