function [safe, unsafe] = isSafe(X, Xup, Xlow,T,deltae,TT,xr206)
    % Check safety of reachtube (Yup/Ylow) or simulation trace (Y)
%     load('xr206.mat');
    % Linearized constraints
    safe = 1;
    unsafe = 0;
    loc = X(1,end);
    xr_last = xr206(201,:);
    if nargin == 1
        loc = -1; % Check only simulation trace
    end

    switch loc
        %     case {-1,1,2,3,4}
        case {-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
            %       case {-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41}
            for i=1:length(Xlow(:,1))

                if Xup(i,1)>25 || Xup(i,1)<0 || ...
                        Xup(i,2)>pi/4 || Xup(i,2)<-pi/4 || ...
                        Xup(i,3)>pi/2 || Xup(i,3)<-pi/2 || ...
                        Xup(i,4)>3.5 || Xup(i,4)<-3.5|| ...
                        Xup(i,5)>16 || Xup(i,5)<-3 || ...
                        Xup(i,6)>10 || Xup(i,6)<-2
                    safe = 0;
                    disp(' unsafe process xup ');
                    %                 disp(i);
                    return
                end

                if Xlow(i,1)>25 || Xlow(i,1)<0 || ...
                        Xlow(i,2)>pi/4 || Xlow(i,2)<-pi/4 || ...
                        Xlow(i,3)>pi/2 || Xlow(i,3)<-pi/2 || ...
                        Xlow(i,4)>3.5 || Xlow(i,4)<-3.5|| ...
                        Xlow(i,5)>16 || Xlow(i,5)<-3 || ...
                        Xlow(i,6)>10 || Xlow(i,6)<-2
                    safe = 0;
                    disp('unsafe process xlow ');
                    %                 disp(i);
                    return
                end
                for j = 1:size(TT,2)   %推力
                    if TT(i,j)>8 || TT(i,j)<0
                        safe = 0;
                        disp('unsafe process T ');
                        return
                    end
                end
                for j = 1:size(deltae,2)    %舵偏角
                    if deltae(i,j)>pi/3 || deltae(i,j)<-pi/3
                        safe = 0;
                        disp('unsafe process deltae ');
                        return
                    end
                end
                
                if   abs(Xup(i,1)-xr_last(1,1))<0.5 &&...
                        abs(Xup(i,5)-xr_last(1,5))<0.15 && ...
                        abs(Xup(i,6)-xr_last(1,6))<0.15 && ...
                        abs(Xlow(i,1)-xr_last(1,1))<0.5 && ...
                        abs(Xlow(i,5)-xr_last(1,5))<0.15 && ...
                        abs(Xlow(i,6)-xr_last(1,6))<0.15
                    
                    return
                end
                
            end
        case 21
            tolerance = 1e-4;
            indice = find(abs(T - 2) < tolerance);
            for i=1:indice
                if Xup(i,1)>25 || Xup(i,1)<0 || ...
                        Xup(i,2)>pi/4 || Xup(i,2)<-pi/4 || ...
                        Xup(i,3)>pi/2 || Xup(i,3)<-pi/2 || ...
                        Xup(i,4)>3.5 || Xup(i,4)<-3.5|| ...
                        Xup(i,5)>16 || Xup(i,5)<0 || ...
                        Xup(i,6)>10 || Xup(i,6)<0
                    safe = 0;
                    disp('unsafe ending xup ');
                    return
                end
                if Xlow(i,1)>25 || Xlow(i,1)<0 || ...
                        Xlow(i,2)>pi/4 || Xlow(i,2)<-pi/4 || ...
                        Xlow(i,3)>pi/2 || Xlow(i,3)<-pi/2 || ...
                        Xlow(i,4)>3.5 || Xlow(i,4)<-3.5|| ...
                        Xlow(i,5)>16 || Xlow(i,5)<0 || ...
                        Xlow(i,6)>10 || Xlow(i,6)<0
                    safe = 0;
                    disp('unsafe ending xlow ');
                    return
                end
                for j = 1:size(TT,2)   %推力
                    if TT(i,j)>8 || TT(i,j)<0
                        safe = 0;
                        disp('unsafe process T ');
                        return
                    end
                end
                for j = 1:size(deltae,2)
                    if deltae(i,j)>pi/3 || deltae(i,j)<-pi/3
                        safe = 0;
                        disp('unsafe process deltae ');
                        return
                    end
                end
            end
            %             if   Xup(indice,1)-xr_last(1,1)>0.5 || Xlow(indice,1)-xr_last(1,1)<-0.5 || ...
            %                     Xup(indice,5)-xr_last(1,5)>0.15 || Xlow(indice,5)-xr_last(1,5)<-0.15 || ...
            %                     Xup(indice,6)-xr_last(1,6)>0.15 || Xlow(indice,6)-xr_last(1,6)<-0.15
            %                 safe = 0;
            %                 disp('unsafe ending(x.h) ');
            %                 return
            %             end
            % 落点范围1
            if   Xup(indice,1)-xr_last(1,1)>0.5 || Xup(indice,1)-xr_last(1,1)<-0.5 || ...
                    Xup(indice,5)-xr_last(1,5)>0.15 || Xup(indice,5)-xr_last(1,5)<-0.15 || ...
                    Xup(indice,6)-xr_last(1,6)>0.15 || Xup(indice,6)-xr_last(1,6)<-0.15|| ...
                    Xlow(indice,1)-xr_last(1,1)>0.5 || Xlow(indice,1)-xr_last(1,1)<-0.5 || ...
                    Xlow(indice,5)-xr_last(1,5)>0.15 || Xlow(indice,5)-xr_last(1,5)<-0.15 || ...
                    Xlow(indice,6)-xr_last(1,6)>0.15 || Xlow(indice,6)-xr_last(1,6)<-0.15
                safe = 0;
                disp('unsafe ending(x.h) ');
                return
            end
    end
end