classdef cover < dlnode
    properties
        x0   % initial state
        t0   % initial timestamp
        %         t
        X    % nominal trajectory
        TT
        deltae    %
        Xup  % overapproximated trajectory
        Xlow % underapproximated trajectory
        T    % time steps
        dia  % dim-dimensional vector of cover diameters
        %         dim  % # of continuous variables
        ID   % array position if array is used to contain pointers
        parent % parent node's ID
        children % array of children IDs
        toDelete = false; % 标记是否需要删除该节点
    end
    
    methods
        function c = cover(x0,t0,X,TT,deltae,Xup,Xlow,T,dia,dim,ID,parent) %Initialize the cover
            if nargin < 11
                error('Incorrect number of arguments')
            end
            if length(dia)~=dim
                error('Incorrect dimension for "dia"')
            end
            if length(x0)<dim
                error('Incorrect dimension for "x0"')
            end
            c = c@dlnode();
            c.x0 = x0;
            c.t0 = t0;
            c.X = X;
            c.TT = TT;
            c.deltae = deltae;
            c.Xup = Xup;
            c.Xlow = Xlow;
            c.T = T;
            c.dia = dia;
            %             c.dim = dim;
            c.ID = ID;
            c.parent = parent;
            c.children = [];
        end
        function c = newCover(cov,i)% Creates new cover from the reachset at cov(i)
            if nargin < 2
                error('Incorrect number of arguments')
            end
            dim = length(cov.dia);
%                            newDia = (cov.Xup(i,1:dim)-cov.Xlow(i,1:dim))./2;
             newDia(:,5:dim) = (cov.Xup(i,5:dim)-cov.Xlow(i,5:dim))./2;
%                                newDia = min(cov.dia, newDia);
            %             newDia = min(cov.dia, newDia);
%             c = cover(cov.x0,cov.T(i),cov.X(i,:),cov.Xup(i,:),...
%                 cov.Xlow(i,:),cov.T(i),newDia,dim,cov.ID,cov.parent);
                        c = cover(cov.X(i,:),cov.T(i),cov.X(i,:),cov.TT(i,:),cov.deltae(i,:),cov.Xup(i,:),...
                            cov.Xlow(i,:),cov.T(i),newDia,dim,cov.ID,cov.parent);
        end
        function cov = reduceCover(cov,i)%Reduce the range of the current cover
            if nargin < 2
                error('Incorrect number of arguments')
            end
            dim = length(cov.dia);
            newDia = (cov.Xup(i,1:dim)-cov.Xlow(i,1:dim))./2;
            
            cov.x0 = cov.X(i,:);
            cov.t0 = cov.T(i);
            cov.X = cov.X(i,:);
            cov.TT = cov.TT(i,:);
            cov.deltae = cov.deltae(i,:);
            cov.Xup = cov.Xup(i,:);
            cov.Xlow = cov.Xlow(i,:);
            cov.T = cov.T(i);
            cov.dia = newDia;
        end
        function cov = coverUnion(cov,newCov,i)% Updates cov to be union with newCov(i)
            
            % Used with single reachset cov for nextRegions
            % Used with multiple reachsets and vector i for stitching
            % together a reachtube in computeReachtube
            if nargin < 3
                error('Incorrect number of arguments')
            end
            if length(i) ~= length(cov.T) || length(i) > length(newCov.T)
                disp('Number of reachsets in cover does not match number of indices specified');
                i = i(1:length(newCov.T));
            end
            dim = length(cov.dia);
            if ~isempty(newCov.Xup) && ~isempty(cov.Xup)
                cov.Xup = max(cov.Xup,newCov.Xup(i,:));
                cov.Xlow = min(cov.Xlow,newCov.Xlow(i,:));
                cov.T = min(cov.T,newCov.T(i));
            elseif ~isempty(newCov.Xup) && isempty(cov.Xup)
                cov.Xup = newCov.Xup;
                cov.Xlow = newCov.Xlow;
                cov.T = newCov.T;
            end
%             cov.Xup = max(cov.Xup,newCov.Xup(i,:));
%             cov.Xlow = min(cov.Xlow,newCov.Xlow(i,:));
            %             cov.dia = (cov.Xup(1,1:dim)-cov.Xlow(1,1:dim))./2; % radius
            if ~isempty(cov.Xup)
                cov.dia(:,5:dim) = (cov.Xup(1,5:dim)-cov.Xlow(1,5:dim))./2;
                cov.X(1:dim) = cov.Xlow(1,1:dim)+cov.dia;
            end
            
            %             cov.dia = max(cov.dia, newDia);
             % USED TO BE MAX
            cov.t0 = cov.T(1);
            %             cov.x0(1:dim) = cov.Xlow(1,1:dim)+cov.dia;
%             cov.X(1:dim) = cov.Xlow(1,1:dim)+cov.dia;
            %             cov.X = cov.x0;
%             x_ref = get_reference_trajectory(0);
%             x_ref_loc = [x_ref, zeros(size(x_ref, 1), 1)];
            cov.x0 = cov.x0;
        end
        function addMode(cov,newCov) % newCov should occur sequentially after cov
            if nargin < 2
                error('Incorrect number of arguments')
            end
            % CUTS PREV MODE SHORT BUT WOULDN'T HAVE SHOWN IN PLOTS
            % ANYWAY (NEW COVER COVERS PREV MODE'S TAIL SETS)
            ind = find(abs(cov.T-newCov.t0)<10^-12);
            if ~isempty(ind)
                cov.T = vertcat(cov.T(1:ind),newCov.T);
                cov.X = vertcat(cov.X(1:ind,:),newCov.X);
                cov.TT = vertcat(cov.TT(1:ind,:),newCov.TT);
                cov.deltae = vertcat(cov.deltae(1:ind,:),newCov.deltae);
                cov.Xup = vertcat(cov.Xup(1:ind,:),newCov.Xup);
                cov.Xlow = vertcat(cov.Xlow(1:ind,:),newCov.Xlow);
            else
                cov.T = vertcat(cov.T,newCov.T);
                cov.X = vertcat(cov.X,newCov.X);
                ov.TT = vertcat(cov.TT(1:ind,:),newCov.TT);
                cov.deltae = vertcat(cov.deltae(1:ind,:),newCov.deltae);
                cov.Xup = vertcat(cov.Xup,newCov.Xup);
                cov.Xlow = vertcat(cov.Xlow,newCov.Xlow);
                %             cov.dia = vertcat(cov.dia,newCov.dia);
            end
        end
        function addChildren(cov,children)
            cov.children = children;
        end
        function numnodes = listlength(startNode)
            numnodes = 0;
            if isempty(startNode)
                return
            else
                head = startNode;
                numnodes = 1;
                while ~isempty(head.Next)
                    numnodes = numnodes+1;
                    head = head.Next;
                end
            end
        end
        function leaf = isleaf(cov)
            leaf = zeros(1,length(cov));
            % Check no children
            for i=1:length(cov)
                if isempty(cov(i).children)
                    if length(cov(i).T) <= 1
                        return
                    end
                    leaf(i) = 1;
                end
            end
        end
        function cov = copyCover(cov,newCov)% Copies newCov properties into cov, but maintains linked list
            % properties and ID/parent
            cov.x0 = newCov.x0;
            cov.t0 = newCov.t0;
            cov.X = newCov.X;
            cov.TT = newCov.TT;
            cov.deltae = newCov.deltae;
            cov.Xup = newCov.Xup;
            cov.Xlow = newCov.Xlow;
            cov.T = newCov.T;
            cov.dia = newCov.dia;
            cov.children = [];
        end
    end % end methods
end % end classdef