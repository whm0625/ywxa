sym p
Ad = subs(Ak, t, p);
Bd = subs(Bk, t, p);
i = 1;
for t=0:0.01:2.05
    %     lpv = cellfun(@(f) f(p),LPV);
    A = subs(Ad, p, t);
    B = subs(Bd, p, t);
    Aall(:,:,i) = A;
    Ball(:,:,i) = B;
    i = i + 1;
end
Aall = double(Aall);
Ball = double(Ball);
save('Jaccobi.mat', 'Aall','Ball');