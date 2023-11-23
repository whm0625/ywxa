function safe = issafe(x)
load('xr(0.0.01.2).mat');
xr_last = xr(201,:);
safe = true;
if   x(201,1)-xr_last(1,1)>0.5 || x(201,1)-xr_last(1,1)<-0.5 || ...
        x(201,5)-xr_last(1,5)>0.15 || x(201,5)-xr_last(1,5)<-0.15 || ...
        x(201,6)-xr_last(1,6)>0.15 || x(201,6)-xr_last(1,6)<-0.15
    safe = false;
%     disp('unsafe');
    return
end
end