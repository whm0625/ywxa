load('gudingyi_lpv');
LPV = LPV1;
t_values = 0:0.1:2;

AA = zeros(6, 6, 3, length(t_values));
BB = zeros(6, 2, 3, length(t_values));

for i = 1:length(t_values)
    t = t_values(i);
    
     newLPV = cellfun(@(f) f(t), LPV);
    dep = zeros([size(LPV) 1]);
    for m=1:6
        for n=1:8
            if eval(['LPV','{m,n}','(',num2str(1),')'])
                dep(m,n,:)=[1];
            end
        end
    end
    if t<2
        domain = [t t_values(i+1)];
    else
        domain = [2 2.1];
    end
    
    gridsize=100;
    [S,U] = tptrans(LPV, dep, domain, gridsize, 'cno');

    W = cell(1, length(U));
    k = 0;

    for a = 1:3
        k = k + 1;
        W{1} = [0 0 0]; % 维度与 A 矩阵个数相同
        W{1}(a) = 1;
        Sa = tprod(S, W);
        Sn(:,:,k)= shiftdim(Sa);
    end

    nn = 6;
    n9 = 3; % A 矩阵的个数
    for a = 1:n9
        Akk = Sn(1:nn, 1:nn, a);
        Bkk = Sn(1:nn, 7:8, a);

        AA(:, :, a, i) = Akk;
        BB(:, :, a, i) = Bkk;
    end
end

save('顶点矩阵无扰动离散0.01.mat','AA','BB');