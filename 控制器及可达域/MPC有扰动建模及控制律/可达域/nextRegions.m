function next = nextRegions(Reach, source)
% Must update Guards here when changing application
% Computes reachable states in other modes

% Assuming 41 switch modes, next is a cell array of next regions
% next = cell(42, 1);
%  tspan = [0,0.025:0.05:2.025];
next = cell(21, 1);
 tspan = [0,0.05:0.1:2.1];
% tspan = [0:0.5:2,2.1];
%% mode --> next mode (i to i+1)
if source < 21
    ind = find(Reach.T >= tspan(source)); % Consider all time points after the first switch time
    if ~isempty(ind)
        % Union of reachsets is simpler here because there are no guard constraints
%         x_ref = get_reference_trajectory(tspan(source+1));
%         x_ref1 = [x_ref,0];
%         newCov = Reach.newCover(ind(end),x_ref1);
        newCov = Reach.newCover(ind(end));
%         for i = 2:length(ind)
%             x_ref = get_reference_trajectory(Reach.T(ind(i)));
%             x_ref1 = [x_ref,0];
%             newCov = newCov.coverUnion(Reach, ind(i),x_ref1);
%         end
        % Update mode
        newCov.x0(end) = source+1; % Passive mode (loc=1)
        newCov.X(:,end) = source+1;
    newCov.Xup(:,end) = source+1;
    newCov.Xlow(:,end) = source+1;
    next{source} = newCov;
    end
end
% if source == 21
%     x_ref = get_reference_trajectory(2)
%     x1 = x_ref(:,5);
%     h1 = x_ref(:,6);
%     R = 0.15;
%     ind = find(Reach.T >= 2);
% for i = 1:length(ind)
%                 reachset = horzcat([Reach.Xup(ind(i),5); Reach.Xup(ind(i),5); ...
%                 Reach.Xlow(ind(i),5); Reach.Xlow(ind(i),5)], ...
%                 [Reach.Xup(ind(i),6); Reach.Xlow(ind(i),6); ...
%                 Reach.Xlow(ind(i),6); Reach.Xup(ind(i),6)]);
%             
%             % Create the circular guard region
%             % This is a rough approximation using a square with side length 2*R_circle
%             theta = linspace(0, 2*pi, 100); % 在0到2π之间生成100个点的角度向量
%             x_vals = x1 + R * cos(theta); % 根据中心x坐标和半径计算x值
%             y_vals = h1 + R * sin(theta); % 根据中心h坐标和半径计算h值
%             guardCircle = horzcat(x_vals', y_vals');
%             
%             % Get intersection between the circular guard and reachset
%             [x,y] = polybool('intersection', reachset(:,1), reachset(:,2), ...
%                 guardCircle(:,1), guardCircle(:,2));
% %             if isempty(next{41})
% %                 x_ref = get_reference_trajectory(Reach.T(ind(1)))
% %                 x_ref1 = [x_ref,0];
% %                 next{41} = Reach.newCover(ind(1),x_ref1); % Initialize next{41} to cover R_i
% %                 next{41}.Xup(1,5:6) = [max(x), max(y)];
% %                 next{41}.Xlow(1,5:6) = [min(x), min(y)];
% %                 % Update x0, T, and dia outside of loop
% %             else
% %                 vert = horzcat([next{41}.Xup(:,5); next{41}.Xup(:,5); ...
% %                     next{41}.Xlow(:,5); next{41}.Xlow(:,5)], ...
% %                     [next{41}.Xup(:,6); next{41}.Xlow(:,6); ...
% %                     next{41}.Xlow(:,6); next{41}.Xup(:,6)]);
% %                 [x, y] = polybool('union', vert(:,1), vert(:,2), x, y);
% %             end
%         end
%         
%         % Update t0 to earliest start time
%         next{21}.t0 = min(Reach.T(ind));
%         % Update vx, vy
%         next{21}.Xup(1,1) = max(Reach.Xup(ind,1));
%         next{21}.Xup(1,2) = max(Reach.Xup(ind,2));
%         next{21}.Xup(1,3) = max(Reach.Xup(ind,3));
%         next{21}.Xup(1,4) = max(Reach.Xup(ind,4));
%         next{21}.Xlow(1,1) = min(Reach.Xlow(ind,1));
%         next{21}.Xlow(1,2) = min(Reach.Xlow(ind,2));
%         next{21}.Xlow(1,3) = min(Reach.Xlow(ind,3));
%         next{21}.Xlow(1,4) = min(Reach.Xlow(ind,4));
%         % Update remaining cover parameters
%         next{21}.T = next{21}.t0;
%         next{21}.dia = (next{21}.Xup(1,1:6) - next{21}.Xlow(1,1:6)) ./ 2; % radius
%         next{21}.x0 = next{21}.Xlow(1,1:6) + next{21}.dia;
%         next{21}.x0 = horzcat(next{21}.x0, 22); % Add updated mode
% end
end
% Last switch: Phase 41 (loc=41) --> Phase 42 (loc=42, the final mode)
% if source == 41
%     x_ref = get_reference_trajectory(2)
%     x1 = x_ref(end,5);
%     h1 = x_ref(end,6);
%     R = 0.15;
%     ind = find(Reach.T >= 2);
%     for i = 1:length(ind)
%             % Get x,y position reachset from Yup and Ylow
%             reachset = horzcat([Reach.Xup(ind(i),5); Reach.Xup(ind(i),5); ...
%                 Reach.Xlow(ind(i),5); Reach.Xlow(ind(i),5)], ...
%                 [Reach.Xup(ind(i),6); Reach.Xlow(ind(i),6); ...
%                 Reach.Xlow(ind(i),6); Reach.Xup(ind(i),6)]);
%             
%             % Create the circular guard region
%             % This is a rough approximation using a square with side length 2*R_circle
%             theta = linspace(0, 2*pi, 100); % 在0到2π之间生成100个点的角度向量
%             x_vals = x1 + R * cos(theta); % 根据中心x坐标和半径计算x值
%             y_vals = h1 + R * sin(theta); % 根据中心h坐标和半径计算h值
%             guardCircle = horzcat(x_vals', y_vals');
%             
%             % Get intersection between the circular guard and reachset
%             [x,y] = polybool('intersection', reachset(:,1), reachset(:,2), ...
%                 guardCircle(:,1), guardCircle(:,2));
%             
%             % Get union with previously checked reachsets
%             if isempty(next{41})
%                 x_ref = get_reference_trajectory(Reach.T(ind(1)))
%                 x_ref1 = [x_ref,0];
%                 next{41} = Reach.newCover(ind(1),x_ref1); % Initialize next{41} to cover R_i
%                 next{41}.Xup(1,5:6) = [max(x), max(y)];
%                 next{41}.Xlow(1,5:6) = [min(x), min(y)];
%                 % Update x0, T, and dia outside of loop
%             else
%                 vert = horzcat([next{41}.Xup(:,5); next{41}.Xup(:,5); ...
%                     next{41}.Xlow(:,5); next{41}.Xlow(:,5)], ...
%                     [next{41}.Xup(:,6); next{41}.Xlow(:,6); ...
%                     next{41}.Xlow(:,6); next{41}.Xup(:,6)]);
%                 [x, y] = polybool('union', vert(:,1), vert(:,2), x, y);
%             end
%         end
%         
%         % Update t0 to earliest start time
%         next{41}.t0 = min(Reach.T(ind));
%         % Update vx, vy
%         next{41}.Xup(1,1) = max(Reach.Xup(ind,1));
%         next{41}.Xup(1,2) = max(Reach.Xup(ind,2));
%         next{41}.Xup(1,3) = max(Reach.Xup(ind,3));
%         next{41}.Xup(1,4) = max(Reach.Xup(ind,4));
%         next{41}.Xlow(1,1) = min(Reach.Xlow(ind,1));
%         next{41}.Xlow(1,2) = min(Reach.Xlow(ind,2));
%         next{41}.Xlow(1,3) = min(Reach.Xlow(ind,3));
%         next{41}.Xlow(1,4) = min(Reach.Xlow(ind,4));
%         % Update remaining cover parameters
%         next{41}.T = next{41}.t0;
%         next{41}.dia = (next{41}.Xup(1,1:6) - next{41}.Xlow(1,1:6)) ./ 2; % radius
%         next{41}.x0 = next{41}.Xlow(1,1:6) + next{41}.dia;
%         next{41}.x0 = horzcat(next{41}.x0, 42); % Add updated mode
%     end
        % Check that center point is indeed in next mode (since nextRegion is overapproximated)
%     if next{41}.x0(end) == source
%         error('Need to refine approximated nextRegion (ln 81)');
%     end
    
