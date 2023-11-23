 function [x_values1,h_values1] = test(test_state)
global dim time_span tol
tol = 10^-12;
init_states  = test_state;
time_span = [0,2];
timespan = time_span(1):0.05:time_span(2);
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
LPV_closed=lpv_lqr();
% 假设每个时间步长为delta_t
time_step = 0.1;
% num_steps = ceil((time_span(2) - time_span(1)) / time_step) + 1;
num_steps = ceil((time_span(2) - time_span(1)) / 0.1) + 1;
x_values = [];
h_values = [];
x_values1 = [];
h_values1 = [];
T1=[];
% 参考轨迹
sim('guiji_6d1');
y1 = polyfit(V0.time,V0.signals.values,8);
y2 = polyfit(miu0.time,miu0.signals.values,8);
y3 = polyfit(alpha0.time,alpha0.signals.values,8);
y4 = polyfit(q0.time,q0.signals.values,8);
y5 = polyfit(x0.time,x0.signals.values,8);
y6 = polyfit(h0.time,h0.signals.values,8);
t=sym('t');
tt=sym('tt');
Vr=poly2sym(y1,t);
miur=poly2sym(y2,t);
alphar=poly2sym(y3,t);
qr=poly2sym(y4,t);
xr=poly2sym(y5,t);
hr=poly2sym(y6,t);
Tr=3.7698;
deltaer=[-(11+(t)/0.3*22)/180*pi;-(33+(t-0.3)/0.2*15)/180*pi;-(33+15-(t-0.5)/0.2*30)/180*pi;-(18)/180*pi;];
Xr_ref = [Vr; miur; alphar; qr; xr; hr];
for idx = 1:4
        init_state = init_states(idx,:);
        x_values = [];
        h_values = [];
for i = 1:num_steps
    % 获取当前时间步的时间
    current_time = time_span(1) + (i - 1) * time_step;
    
    % 获取当前模型
    LPV_p = LPV_closed(:, :, i);
    
    % 设置时间跨度
    timespan1 = max(current_time - time_step/2, 0): 0.001: min(current_time + time_step/2, 2);
    % 使用ODE求解器计算状态轨迹
    sys_dyn = @(t, x) computeSysDyn(t,x,LPV_p);
[~, delta_X] = ode45(sys_dyn, timespan1, init_state', options);
    x_ref = [double(subs(Vr, timespan1')) double(subs(miur, timespan1')) double(subs(alphar, timespan1')) double(subs(qr, timespan1')) double(subs(xr, timespan1')) double(subs(hr, timespan1'))];
    x_ref_loc = [x_ref, zeros(size(x_ref, 1), 1)];
    current_X = delta_X + x_ref_loc;
    
     init_state = delta_X(end, :)';
%      init_state(:,5:6) = delta_X(end, 5:6)';
    %     v_values = [v_values;current_X(:, 1)];
    %     miu_values = [miu_values;current_X(:, 2)];
    %     alpha_values = [alpha_values;current_X(:, 3)];
    %     q_values = [q_values;current_X(:, 4)];
    x_values = [x_values; current_X(:, 5)];
    h_values = [h_values; current_X(:, 6)];
    T1 = [T1; timespan1'];
    % 计算当前时刻的参考状态
    
%     x_ref_values = [x_ref_values; x_ref(:, 5)];
%     h_ref_values = [h_ref_values; x_ref(:, 6)];
    
end
     x_values1(:,:,idx) = x_values;
     h_values1(:,:,idx) = h_values;
end
% figure; grid on; grid minor; hold on
% for i = 1:length(x_values_low)
%     reach = horzcat([x_values_up(i); x_values_up(i); ...
%         x_values_low(i); x_values_low(i); x_values_up(i)], ...
%         [h_values_up(i); h_values_low(i); ...
%         h_values_low(i); h_values_up(i); h_values_up(i)]);
%     % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%     %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%     patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.5, 'EdgeColor', 'none');
%     %     hold on;
% end
% for i = 1:4
%     plot(x_values4(:,:,i), h_values4(:,:,i), 'r-', 'LineWidth', 1.5);
% end
% plot(x_values, h_values, 'r-', 'LineWidth', 1.5);
% xlabel('x');
% ylabel('h');
% title('x-h Curve');
% hold off; % 关闭叠加模式
% 
% figure;
% hold on
% plot(x_values, h_values, 'r-', 'LineWidth', 1.5);
% xlabel('x');
% ylabel('h');
% title('x-h Curve');
% hold off; % 关闭叠加模式
% % x和x_ref曲线
% figure;
% hold on;
% plot(T1, x_values, 'b', 'LineWidth', 1.5);
% plot(T1, x_ref_values, 'r--', 'LineWidth', 1.5);
% hold off;
% xlabel('t');
% ylabel('x');
% legend('x', 'x_{ref}');
% title('t-x Curve');
%
% % h和h_ref曲线
% figure;
% hold on;
% plot(T1, h_values, 'b', 'LineWidth', 1.5);
% plot(T1, h_ref_values, 'r--', 'LineWidth', 1.5);
% hold off;
% xlabel('t');
% ylabel('h');
% legend('h', 'h_{ref}');
% title('t-h Curve');
%
% figure;
% plot(T1, x_values);
% xlabel('t');
% ylabel('x');
% title('t-x Curve');
%
% figure;
% plot(T1, h_values);
% xlabel('t');
% ylabel('h');
% title('t-h Curve');
%
% figure;
% plot(T1, v_values);
% xlabel('t');
% ylabel('v');
% title('t-v Curve');
%
% figure;
% plot(T1, miu_values);
% xlabel('t');
% ylabel('miu');
% title('t-miu Curve');
%
% figure;
% plot(T1, alpha_values);
% xlabel('t');
% ylabel('alpha');
% title('t-alpha Curve');
%
% figure;
% plot(T1, q_values);
% xlabel('t');
% ylabel('q');
% title('t-q Curve');
%
% % figure;
% % plot(T1, x_ref_values);
% % xlabel('t');
% % ylabel('x_{ref}');
% % title('t-x_{ref} Curve');
% %
% % figure;
% % plot(T1, h_ref_values);
% % xlabel('t');
% % ylabel('h_{ref}');
% % title('t-h_{ref} Curve');
 end