function [x,u] = simulate_system(x0, u, Kall, t_span,xr,ur)
    x = zeros(length(t_span), 6);
    x(1, :) = x0;

    for k = 1:length(t_span)-1
        Ki = Kall(:,:,k);
        dx = x(k, :)' - xr(k, :)';
        du = -(Ki * dx)';
        u(k, :) = du + ur(k, :);
        u0 = u(k, :)';

        [~, sol] = ode45(@(t, x) nonlinear_model(t, x, u0), [t_span(k), t_span(k+1)], x(k, :)');
        x(k+1, :) = sol(end, :);
    end
end