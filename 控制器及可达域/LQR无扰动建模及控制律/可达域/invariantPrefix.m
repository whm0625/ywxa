function [Reach] = invariantPrefix(Reach, loc)
% Returns the portion of the reachtube that may or must be in mode 'loc'
tolerance = 1e-10;
% Initialize mode_indices cell array
%  mode_indices = cell(42, 1);
 mode_indices = cell(22, 1);
% Define the time points for each mode (change this according to your time intervals)
%  mode_times = [0,0.025:0.05:1.975,2,2.01]; % Add time points for all 41 modes
 mode_times = [0,0.05:0.1:1.95,2.05]; % Add time points for all 21 modes
% Generate mode indices based on time intervals
for i = 1:length(mode_times)-1
         mode_indices{i} = find(Reach.T >= mode_times(i) & Reach.T <= mode_times(i+1));
    %     mode_indices{i} = find(Reach.T >= mode_times(i) & abs(Reach.T - mode_times(i+1)) < tolerance);
%     for j = 1:length(Reach.T)
%         if Reach.T(j) >= mode_times(i) && Reach.T(j) <= mode_times(i+1)
%             mode_indices{i} = [mode_indices{i} j];
%         end
%     end
end

% Get the index set corresponding to the specified loc
indices = mode_indices{loc};

% Use the specified indices to extract the relevant portions from Reach
Reach.X = Reach.X(indices, :);
Reach.Xup = Reach.Xup(indices, :);
Reach.Xlow = Reach.Xlow(indices, :);
Reach.TT = Reach.TT(indices, :);
Reach.deltae = Reach.deltae(indices, :);
Reach.T = Reach.T(indices);
% xtemp = xtemp(indices, :);
end