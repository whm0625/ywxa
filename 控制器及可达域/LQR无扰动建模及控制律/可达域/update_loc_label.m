function loc = update_loc_label(t)
  tspan = [0,0.05:0.1:2.05];
%  tspan = [0,0.025:0.05:1.975,2,2.05];
% if t < 2
%     [~, loc] = histc(t, tspan);
% else
%     loc = 22;
% end
[~, loc] = histc(t, tspan);
end