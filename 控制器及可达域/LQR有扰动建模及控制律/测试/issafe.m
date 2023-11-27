function safe = issafe(x,u,xr)
% load('xr(0.0.01.2).mat');
xr_last = xr(201,:);
safe = true;
for i=1:size(x,1)
    if x(i,1)>25 || x(i,1)<0 || ...
            x(i,2)>pi/4 || x(i,2)<-pi/4 || ...
            x(i,3)>pi/2 || x(i,3)<-pi/2 || ...
            x(i,4)>3.5 || x(i,4)<-3.5|| ...
            x(i,5)>16 || x(i,5)<-3 || ...
            x(i,6)>10 || x(i,6)<-2
        safe = false;
        return
    end
end
for i=1:size(u,1)
    if u(i,1)>8 || u(i,1)<0 || ...
            u(i,2)>pi/3 || u(i,2)<-pi/3
        safe = false;
        return
    end
end
if   x(201,1)-xr_last(1,1)>0.5 || x(201,1)-xr_last(1,1)<-0.5 || ...
        x(201,5)-xr_last(1,5)>0.15 || x(201,5)-xr_last(1,5)<-0.15 || ...
        x(201,6)-xr_last(1,6)>0.15 || x(201,6)-xr_last(1,6)<-0.15
    safe = false;
    %     disp('unsafe');
    return
end
end