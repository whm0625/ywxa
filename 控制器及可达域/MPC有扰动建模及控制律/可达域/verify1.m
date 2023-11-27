function [safe,Reach,xup,xlow,initial_centers,initial_radii]=verify1(initial_state,initial_diameter,guardTime)
% This function checks the model specified by the NAME_modelX.m files,
% given the initial state, diameter of the initial set of states, and
% the interval of time during which a transition to Passive will occur.
% The function returns the reachtube and a flag indicating if the
% system will conform to all the safety constraints.
% For a n-dimensional system, 'initial_state' should be an n+1-dim
% vector and 'inital_diameter' should be an n-dim vector.

%%%%% Set up %%%%%
% clc; clear all; close all;
% profile on
dbstop if error
safe = -1;                              % -1: UNKNOWN, 0: UNSAFE, 1: SAFE
global tol dim fulldim time_span guardPassive loc F Aall Ball xr206 ur206
tol = 10^-12;
partitionBnd = 6;                       % max # partitions that can occur before terminating
partitionNum = 0;
load('Jaccobi.mat');
load('F线性无扰动.mat');
load('xr206.mat');
load('ur206.mat');

%%%%% Initialize problem parameters %%%%%
if nargin < 3
    disp('Not enough input arguments, using default values');
    %      initial_state  = [0 0 0 0 0 0 1]; % [delta_v,delta_miu,delta_alpha,delta_q,delta_x,delta_h,loc]
     initial_state = [xr206(1,:) 1];
% initial_state=[11  0.1  0.2  0.1  0.5 -0.5 1];
    %     initial_state  = [11  0.1  0.3  0.1  1 -1 1];
    %     initial_diameter = [0.2,0.02,0.03,0.1,1,1]';     % determines initial set with initial_state as center point
    initial_diameter = [0,0,0,0,3,2];     % determines initial set with initial_state as center point
else
    guardPassive = guardTime;
end
count = 0;
Reach = [];
fulldim = 7;
dim = 6;                                % Model dimension (6 state variables)
time_span = [0,2];                    % Total time horizon (s)
timespan = time_span(1):0.01:time_span(2);
% x_ref = get_reference_trajectory(timespan);
simulation_number = 0;                  % Counter for # times a reachtube is computed
start = 1;                              % Index of starting cover
lastID = 1;                             % Index of last cover added to the stack
% Initialize the stack by adding the initial set as the first cover
queue(start) = cover(initial_state,time_span(1),[],[],[],[],[],[],initial_diameter,dim,start,0);
head = queue(start).Next;               % Pointer to head of the queue of covers to be checked
verified_partitions = 0;
Children1 = [];
xup = [];
xlow = [];
% 存储初始集的中心和半径信息
initial_centers = [];
initial_radii = [];
%%%%% Verification Algorithm %%%%%
tic;
flag = true;
% verified_partitions = 0;
while (flag)
    % Compute the reachtube from the cover 'queue(start)' and check its safety
    
    [queue(start),safeflag,unsafeflag]=computeReachtube1(queue(start));
%         x_ref = get_reference_trajectory(queue(start).T');
%         x_ref_loc = [x_ref, zeros(size(x_ref, 1), 1)];
% %         queue(start).X = queue(start).X + x_ref_loc;
% %         queue(start).Xup = queue(start).Xup + x_ref_loc;
% %         queue(start).Xlow = queue(start).Xlow + x_ref_loc;
%             figure;
%             hold on;
%             for i = 1:length(queue(start).T)
%                 reach = horzcat([queue(start).Xup(i,5); queue(start).Xup(i,5); ...
%                     queue(start).Xlow(i,5); queue(start).Xlow(i,5);queue(start).Xup(i,5)], ...
%                     [queue(start).Xup(i,6); queue(start).Xlow(i,6); ...
%                     queue(start).Xlow(i,6); queue(start).Xup(i,6); queue(start).Xup(i,6)]);
%                 % reach = horzcat(Reach.Yup(i, :), Reach.Ylow(i, :));
%                 %     viscircles([x0, h0], 0.15, 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1);
%                 patch(reach(:, 1), reach(:, 2), [0, 0.5, 1],'FaceAlpha', 1, 'EdgeColor', 'none');
%             end
%             plot(queue(start).X(:,5), queue(start).X(:,6), 'Color', 'r', 'LineWidth', 2);
%          plot(queue(start).Xtemp(:,5), queue(start).Xtemp(:,6), 'Color', 'b', 'LineWidth', 2);
%             hold on;
% %             x_ref = get_reference_trajectory(timespan);
%             xr_x = xr(:, 5); % 提取参考轨迹的x值
%             xr_h = xr(:, 6); % 提取参考轨迹的h值
%             radius = 0.15;
%             plot(xr_x, xr_h, 'Color', 'r', 'LineWidth', 2);
%         %     hold on; %
%             plot(xr_x(end), xr_h(end), 'ok');
%             viscircles([xr_x(end), xr_h(end)], radius, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
    disp('Simulating from:');
    disp(queue(start).x0);
    disp('with delta:');
    disp(queue(start).dia);
    simulation_number = simulation_number+1;
    disp('Simulation # ');
    disp(simulation_number);
    
    %%%%% Check the safety flags %%%%%
    % CASE: the reachtube is safe, check next cover
    if safeflag
        disp('this trajactory is safe,go to next');
        initial_centers = [initial_centers; queue(start).x0(5:6)];
        initial_radii = [initial_radii; queue(start).dia(5:6)];
        count = count + 1;
        xup(:,5:6,count) = queue(start).Xup(:, 5:6);
        xlow(:,5:6,count) = queue(start).Xlow(:, 5:6);
%                 xup = [xup; queue(start).Xup(:, 5)];
%                 xlow = [xlow; queue(start).Xlow(:, 6)];
%                 plotReach(queue(start));
        % Prune leaves
        if start~=1 && all(queue(queue(queue(start).parent).children).isleaf)
            parID = queue(queue(start).parent).ID;
            childID = queue(parID).children;
            mergedChildren = [];
            %             queue(parID) = [];
            for i=1:length(childID)
                if queue(childID(i)).toDelete==true
                    queue(childID(i)).removeNode;
                    delete(queue(childID(i)));
                else
                    if isempty(mergedChildren)
                        mergedChildren = childID(i);
                        queue(parID).copyCover(queue(mergedChildren));
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    else
                        queue(parID) = queue(parID).coverUnion(...
                            queue(childID(i)),1:length(queue(childID(i)).T));
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    end
                end
            end
            queue(parID).children  = [];
            partitionNum = partitionNum-1;
            %             queue(parID).copyCover(queue(childID(1)));
            %             for i=2:length(childID)
            %                 queue(parID) = queue(parID).coverUnion(...
            %                     queue(childID(i)),1:length(queue(childID(i)).T));
            %                 queue(childID(i)).removeNode;
            %                 delete(queue(childID(i)));
            %             end
            %             queue(childID(1)).removeNode;
            %             delete(queue(childID(1)));
            %             partitionNum = partitionNum-1;
            
            % Recursive check for leaves
            while ~isempty(parID) && parID~=1
                parID = queue(queue(parID).parent).ID;
                if all(queue(queue(parID).children).isleaf)
                    childID = queue(parID).children;
                    isMerged = false;
                    for i=1:length(childID)
                        if ~isempty (queue(childID(i)).X)
                            if ~isMerged
                                queue(parID).copyCover(queue(childID(i)));
                                isMerged = true;  % Set the flag to true after the first merge
                            else
                                queue(parID) = queue(parID).coverUnion(queue(childID(i)), 1:length(queue(childID(i)).T));
                            end
                        end
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    end
                    queue(parID).children  = [];
                    partitionNum = partitionNum-1;
                else
                    parID = [];
                end
            end
            %             verified_partitions = 0;
        end
        
        % CASE: the reachtube is safe and all covers have been checked, terminate
        if isempty(head)
            safe = 1;
            flag = false;
            disp('all the partitions has been verified to be safe');
            %             plotReach(queue(1),1:2); % plot results
        end
    else
        % CASE: a bug trace was found, terminate
        if unsafeflag
            flag = false;
            safe = 0;
            queue(start).toDelete = true;
            disp('finding one trajectory in the unsafe set');
        else
            % CASE: the reachtube is not safe but no more partitions should occur, terminate
            if partitionNum >= partitionBnd
                disp('Max number of partitions reached. Unknown results.');
                safe = -1;
                queue(start).toDelete = true;
                %                 queue(start).removeNode;
                %                 delete(queue(start));
                %                 head = head.Next;
                %                 verified_partitions = verified_partitions + 1;
                %                 break
                %                  return
                % CASE: the reachtube is not safe, partition cover and continue checking
            else
                disp('finding one suspect reachtube, partition it');
                [newA,newB] = cutset(queue(start).x0,queue(start).dia,3,...
                    dim,queue(start).t0);
                
                % Reduces redundant partitions e.g. when there are zero-diameter dimensions
                [newA,ia,~] = unique(newA,'rows');
                newB = newB(ia,:);
                
                % Add partitions to queue
                partitionNum = partitionNum + 1;
                lastID = lastID+1;
                queue(lastID) = cover(newA(1,:),queue(start).t0,...
                    [],[],[],[],[],[],newB(1,:),dim,lastID,queue(start).ID);
                queue(lastID).insertAfter(queue(start));
                head = queue(lastID);
                
                % Update children
                queue(start).addChildren(lastID:(lastID+size(newA,1)-1));
                for i=2:size(newA,1)
                    lastID = lastID+1;
                    queue(lastID) = cover(newA(i,:),queue(start).t0,...
                        [],[],[],[],[],[],newB(i,:),dim,lastID,queue(start).ID);
                    queue(lastID).insertAfter(queue(lastID-1));
                end
                Children1 = queue(start).children;
                queue(start) = cover([0 0 0 0 0 0 1], time_span(1), [],[],[], [], [], queue(start).T, [0 0 0 0 0 0],dim,start,queue(start).parent);
                queue(start).children = Children1;
            end
        end
        %          if  start >head.ID
        %             partitionNum = partitionNum - 1;
        if start~=1 && all(queue(queue(queue(start).parent).children).isleaf)
            parID = queue(queue(start).parent).ID;
            childID = queue(parID).children;
            mergedChildren = [];
            %             queue(parID) = [];
            for i=1:length(childID)
                if queue(childID(i)).toDelete==true
                    queue(childID(i)).removeNode;
                    delete(queue(childID(i)));
                else
                    if isempty(mergedChildren)
                        mergedChildren = childID(i);
                        queue(parID).copyCover(queue(mergedChildren));
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    else
                        queue(parID) = queue(parID).coverUnion(...
                            queue(childID(i)),1:length(queue(childID(i)).T));
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    end
                end
            end
            queue(parID).children  = [];
            partitionNum = partitionNum-1;
            while ~isempty(parID) && parID~=1
                parID = queue(queue(parID).parent).ID;
                if all(queue(queue(parID).children).isleaf)
                    childID = queue(parID).children;
                    isMerged = false;
                    for i=1:length(childID)
                        if ~isempty (queue(childID(i)).X)
                            if ~isMerged
                                queue(parID).copyCover(queue(childID(i)));
                                isMerged = true;  % Set the flag to true after the first merge
                            else
                                queue(parID) = queue(parID).coverUnion(queue(childID(i)), 1:length(queue(childID(i)).T));
                            end
                        end
                        queue(childID(i)).removeNode;
                        delete(queue(childID(i)));
                    end
                    queue(parID).children  = [];
                    partitionNum = partitionNum-1;
                else
                    parID = [];
                end
            end
        end
        if isempty(head)
            safe = 1;
            flag = false;
            disp('all the partitions has been verified to be safe');
        end
        %         end
    end % end post-simulation safety check
    
    % Compute reachtube for next cover
    if flag
        %         if  start >head.ID
        %             partitionNum = partitionNum - 1;
        %         end
        start = head.ID;
        head = head.Next; % pointer to top of queue
        %         if isempty(head)
        %             parentID = queue(start).parent;
        %             head = queue(parentID);
        %             %             if parentID == 1
        %             %                 break;
        %             %             end
        %             %             head = parent
        %             %             partitionNum = partitionNum - 1;
        %         end
    end
end % end verification no covers left to check
toc;
% x_ref = get_reference_trajectory(queue(1).T');
% x_ref_loc = [x_ref, zeros(size(x_ref, 1), 1)];
% queue(1).X = queue(1).X + x_ref_loc;
% queue(1).Xup = queue(1).Xup + x_ref_loc;
% queue(1).Xlow = queue(1).Xlow + x_ref_loc;
Reach = queue(1);
% filename='MPC(5,2.5)';
save('MPC(3,2)线性有扰动.mat', 'Reach','initial_centers','initial_radii','xup','xlow');
% plotReach(Reach,initial_centers,initial_radii,xup,xlow);

% disp('number of simulations:');
% disp(simulation_number);