function [cov,safeflag,unsafeflag]=computeReachtube1(cov)
global dim time_span tol fulldim
% tol = 10^-12;
% syms p t
load('Jaccobi.mat');

load('xr206.mat');
load('ur206.mat');
% load('F_origin.mat');
load('F线性无扰动.mat');
% Ad = subs(Ak, t, p);
% Bd = subs(Bk, t, p);
timespan = cov.t0:0.01:cov.t0+0.1;
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
init_state=cov.x0;
kk = uint8(cov.t0*100 + 1);
k = 1;
k_init = k;
x(k,:) = init_state(1:6);  % 初始状态

V0 = diag(cov.dia);
V0 = cat(1,V0,zeros(1,size(V0,2))); % add zeros for extra dimension (loc)
V0 = cat(2,V0,zeros(size(V0,1),1));
V = cell(dim, 1);
for t=timespan
    dx(k,:)=x(k,:)-xr206(kk,:);
    du(k,:)=(F(:,:,kk)*dx(k,:)')';
    u(k,:)=du(k,:)+ur206(kk,:);
    %     u0=u(k,:);
    %     u0=u0';
    %     A = subs(Ad, p, t);
    %     B = subs(Bd, p, t);
    A = Aall(:,:,kk);
    B = Ball(:,:,kk);
    closed_loop = A + B * F(:,:,kk);
    if kk<206
        x(k+1,:) = (closed_loop*dx(k,:)')'+ xr206(kk+1,:);
    end
%     [~, sol]=ode45(@(t,x,u)real_6d(t,x,u0),[t,t+0.01],x(k,:)');
%     x(k+1,:) = sol(end,:);
    k=k+1;
    kk = kk+1;
end
x = x(1:length(x)-1,:);
TT_temp = [];
deltae_temp = [];
for i = 1:dim
    kk = uint8(cov.t0*100 + 1);
    k=1;
     xtemp(k,:) = x(k,:)'+V0(1:6,i);
    for t=timespan
        dxtemp(k,:)=xtemp(k,:)-xr206(kk,:);
        dutemp(k,:)=(F(:,:,kk)*dxtemp(k,:)')';
        utemp(k,:)=dutemp(k,:)+ur206(kk,:);
        %         u0=utemp(k,:);
        %         u0=u0';
        %         A = subs(Ad, p, t);
        %         B = subs(Bd, p, t);
        A = Aall(:,:,kk);
        B = Ball(:,:,kk);
        closed_loop = A + B * F(:,:,kk);
        if kk<206
            xtemp(k+1,:) = (closed_loop*dxtemp(k,:)')'+ xr206(kk+1,:);
        end
%         [~, soltemp]=ode45(@(t,x,u)real_6d(t,x,u0),[t,t+0.01],x(k,:)'+ V0(1:6,i), options);
%         xtemp(k+1,:) = soltemp(end,:);
        k=k+1;
        kk=kk+1;
    end
    
    xtemp = xtemp(1:length(xtemp)-1,:);
    TT_temp = [TT_temp utemp(:,1)];
    deltae_temp = [deltae_temp utemp(:,2)];
    
    V{i} = x(:,1:dim)- xtemp(:,1:dim);
end
% figure;
% hold on;
% plot(x(:,5), x(:,6), 'Color', 'r', 'LineWidth', 2);
% plot(xtemp(:,5), xtemp(:,6), 'Color', 'b', 'LineWidth', 2);

cov.T = timespan';
cov.X = [x,zeros(size(x, 1), 1)];
cov.TT = [u(:,1),TT_temp];
cov.deltae = [u(:,2),deltae_temp];
% 更新初始状态容许范围的上界和下界
cov.Xup = zeros(size(cov.X,1),fulldim);
cov.Xlow = zeros(size(cov.X,1),fulldim);
% 用超矩形逼近可达域
for i = 1:length(timespan)
    cov.Xup(i, 1:dim) = cov.X (i, 1:dim) + max(-V{1}(i, :), V{1}(i, :)) + max(-V{2}(i, :),...
        V{2}(i, :)) + max(-V{3}(i, :), V{3}(i, :)) + max(-V{4}(i, :), V{4}(i, :)) ...
        + max(-V{5}(i, :), V{5}(i, :)) + max(-V{6}(i, :), V{6}(i, :));
    cov.Xlow(i, 1:dim) = cov.X (i, 1:dim) + min(-V{1}(i, :), V{1}(i, :)) + min(-V{2}(i, :),...
        V{2}(i, :)) + min(-V{3}(i, :), V{3}(i, :)) + min(-V{4}(i, :), V{4}(i, :))...
        + min(-V{5}(i, :), V{5}(i, :)) + min(-V{6}(i, :), V{6}(i, :));
end

%%%%% Update discrete location %%%%%
if init_state(fulldim) ~= 0
    % If a mode should be updated, then make sure the mode~=0 when passed to ARPOD_update
    cov.Xup(:,end) = -1;
    cov.Xlow(:,end) = -1;
    for i = 1:size(cov.X,1)
        cov.X(i,end) = update_loc_label(cov.T(i));
        cov.Xup(i,end) = update_loc_label(cov.T(i));
        cov.Xlow(i,end) = update_loc_label(cov.T(i));
    end
end
% figure;
% % subplot(1, 2, 1);
% for i = 1:length(cov.T)
%     reach = horzcat([cov.Xup(i,5); cov.Xup(i,5); ...
%         cov.Xlow(i,5); cov.Xlow(i,5);cov.Xup(i,5)], ...
%         [cov.Xup(i,6); cov.Xlow(i,6); ...
%         cov.Xlow(i,6); cov.Xup(i,6); cov.Xup(i,6)]);
%     reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%     patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.5, 'EdgeColor', 'none');
% end
unsafeflag = 0;

[cov] = invariantPrefix(cov,init_state(end));


% cov.x0 = delta_X(length(cov.T), :);
% for k = 1:6
%     cov.dia(:,k) = V{k}(length(cov.T), k);
% end

%%%%% Check if safety properties of current mode are satisfied %%%%%
[safeflag,~] = isSafe(cov.x0,cov.Xup,cov.Xlow,cov.T,cov.deltae,cov.TT);
% subplot(1, 2, 2);
% for i = 1:length(cov.T)
%     reach = horzcat([cov.Xup(i,5); cov.Xup(i,5); ...
%         cov.Xlow(i,5); cov.Xlow(i,5);cov.Xup(i,5)], ...
%         [cov.Xup(i,6); cov.Xlow(i,6); ...
%         cov.Xlow(i,6); cov.Xup(i,6); cov.Xup(i,6)]);
%     % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
% %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%     patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 0.5, 'EdgeColor', 'none');
% end
if ~unsafeflag %safeflag == 1 && unsafeflag == 0
    % Check "nextRegions"
    nextCov = nextRegions(cov,init_state(end));
    for j=1:length(nextCov)
        if ~isempty(nextCov{j})
            [nextCov{j},nextSafe,~] = computeReachtube1(nextCov{j});
            if nextSafe == 0
                % Break and partition initial set
                safeflag = 0;
                %                 disp('partition');
                cov.addMode(nextCov{j});
                %                 cov = cov.reduceCover(1); % no need to return entire reachtube
                return
            end
            cov.addMode(nextCov{j}); % if safe, add to reachtube and continue checking subsequent modes
        end
    end
    disp('This partition is safe');
elseif unsafeflag == 1
    % Return unsafe
    disp('terminate unsafe');
    % get unsafe trajectory; store it in cov.Y & cov.Yup/low=[]
    % cov = ...
    return
else % safeflag == 0
    % Break and partition initial set
    disp('partition');
    cov = cov.reduceCover(1);
end

% Returns safe if diameters becomes less than tolerance
if any(cov.dia(find(cov.dia)) < tol) && (safeflag==0) && (unsafeflag==0)
    safeflag = 1;
    disp('cover diameter smaller than user-defined tolerance, will not partition');
end