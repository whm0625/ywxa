load('xr(0.0.01.2).mat');
load('ur(0.0.01.2).mat');
load('Kall线性离散无扰动.mat');
x(1,:)  = xr(1,:) + [0.1 0.1 0.1 0.1 -0.5 -0.5];
t_span = 0:0.01:2;
for k = 1:length(t_span)-1
        Ki = Kall(:,:,k);
        dx = x(k, :)' - xr(k, :)';
        du = -(Ki * dx)';
        u(k, :) = du + ur(k, :);
        u0 = du(k, :)';
        
        [~, sol] = ode45(@(t, x) nonlinear_model(t, dx, u0), [t_span(k), t_span(k+1)], dx(k, :)');
        dx(k+1, :) = sol(end, :);
        if k<201
            x(k+1, :) = dx(k+1, :) + xr(k+1, :);
        end
end