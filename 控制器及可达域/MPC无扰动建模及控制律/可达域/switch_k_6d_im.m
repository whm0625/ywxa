clear all;
clc;
sim('guiji_6d');

%�������켣
y1 = polyfit(v0.time,v0.signals.values,5);
y2 = polyfit(gamma0.time,gamma0.signals.values,5);
y3 = polyfit(afar0.time,afar0.signals.values,5);
y4 = polyfit(q0.time,q0.signals.values,5);
y5 = polyfit(x0.time,x0.signals.values,5);
y6 = polyfit(h0.time,h0.signals.values,5);

%����켣
t=sym('t');
tt=sym('tt');
v1=poly2sym(y1,t);
gamma1=poly2sym(y2,t);
afar1=poly2sym(y3,t);
q1=poly2sym(y4,t);
x1=poly2sym(y5,t);
h1=poly2sym(y6,t);

v2=subs(v1,t,tt);
gamma2=subs(gamma1,t,tt);
afar2=subs(afar1,t,tt);
q2=subs(q1,t,tt);
x2=subs(x1,t,tt);
h2=subs(h1,t,tt);

der1=[-(11+(t)/0.3*22)/180*pi;-(33+(t-0.3)/0.2*15)/180*pi;-(33+15-(t-0.5)/0.2*30)/180*pi;-(18)/180*pi;];

Q= [1.5 0 0 0 0 0;
    0 8 0 0 0 0;
    0 0 1.5 0 0 0;
    0 0 0 1.5 0 0;
    0 0 0 0 40 0;
    0 0 0 0 0 15;];
R=[5   0;
    0   50;];
loc = 1;
i=1;
%ȡʱ��
for tz=0:0.1:0.5;
    
    v2_v=double(subs(v1,t,tz));
    gamma2_v=double(subs(gamma1,t,tz));
    afar2_v=double(subs(afar1,t,tz));
    q2_v=double(subs(q1,t,tz));
    x2_v=double(subs(x1,t,tz));
    h2_v=double(subs(h1,t,tz));
    if tz<0.3
        der_v=double(subs(der1(1,1),t,tz));
    else if tz<0.5
            der_v=double(subs(der1(2,1),t,tz));
        else
            der_v=double(subs(der1(4,1),t,tz));
        end
    end
    
    %����ȡʱ�̵����Է���
    U1=[3.8378 der_v]'
    X1=[v2_v gamma2_v afar2_v q2_v x2_v h2_v]'
    %      if tz==0.5
    %             X1=[9.747  0.067  0.39  0.99   5.02  0.058];
    %      end
    [A,B,C,D]=linmod2('fly2_6d',X1,U1);
    
    %���lqr��k
    [K,S,E]=lqr(A,B,Q,R);
    A_all(:,:,loc)=A;
    B_all(:,:,loc)=B;
    Kall1(:,:,loc)=K;
    
    Kall(i:i+1,1:6)=K;
    i=i+2;
    loc = loc+1;
end

for tz=0.6:0.1001:1
    
    v2_v=double(subs(v1,t,tz));
    gamma2_v=double(subs(gamma1,t,tz));
    afar2_v=double(subs(afar1,t,tz));
    q2_v=double(subs(q1,t,tz));
    x2_v=double(subs(x1,t,tz));
    h2_v=double(subs(h1,t,tz));
    if tz<0.7
        der_v=double(subs(der1(3,1),t,tz));
    else
        der_v=double(subs(der1(4,1),t,tz));
    end
    if tz==0.6
        X1=[9.4  0.11  0.45  1.1   6  0.14]'
        %         else if tz==1.4
        %                 X1=[5.01 0.337 0.712 -0.167 11.5 1.65]'
        %             else if tz==1.6
        %                      X1=[4.43 0.244 0.759 -0.339 12.40 1.93]'
        %                 else if tz==2
        %                         X1=[3.92 -0.048 0.86 -0.85 14.05 2.1]'
    else
        X1=[v2_v gamma2_v afar2_v q2_v x2_v h2_v]'
        %                     end
        %                 end
        %             end
    end
    %����ȡʱ�̵����Է���
    U1=[3.8378 der_v]'
    [A,B,C,D]=linmod2('fly2_6d',X1,U1)
    
    %���lqr��k
    [K,S,E]=lqr(A,B,Q,R);
    A_all(:,:,loc)=A;
    B_all(:,:,loc)=B;
    Kall1(:,:,loc)=K;
    
    Kall(i:i+1,1:6)=K;
    i=i+2;
    loc = loc+1;
end

for tz=1:0.1001:1.5
    v2_v=double(subs(v1,t,tz));
    gamma2_v=double(subs(gamma1,t,tz));
    afar2_v=double(subs(afar1,t,tz));
    q2_v=double(subs(q1,t,tz));
    x2_v=double(subs(x1,t,tz));
    h2_v=double(subs(h1,t,tz));
    
    der_v=double(subs(der1(4,1),t,tz));
    
    if tz==1.4008
        X1=[5.01 0.337 0.712 -0.167 11.5 1.65]'
        %             else if tz==1.6
        %                      X1=[4.43 0.244 0.759 -0.339 12.40 1.93]'
        %                 else if tz==2
        %                         X1=[3.92 -0.048 0.86 -0.85 14.05 2.1]'
    else
        X1=[v2_v gamma2_v afar2_v q2_v x2_v h2_v]'
        %                     end
        %                 end
        %             end
    end
    %����ȡʱ�̵����Է���
    U1=[3.8378 der_v]'
    [A,B,C,D]=linmod2('fly2_6d',X1,U1)
    
    %���lqr��k
    [K,S,E]=lqr(A,B,Q,R);
    A_all(:,:,loc)=A;
    B_all(:,:,loc)=B;
    Kall1(:,:,loc)=K;
    
    Kall(i:i+1,1:6)=K;
    i=i+2;
    loc = loc+1;
end

for tz=1.5:0.1:2
    v2_v=double(subs(v1,t,tz));
    gamma2_v=double(subs(gamma1,t,tz));
    afar2_v=double(subs(afar1,t,tz));
    q2_v=double(subs(q1,t,tz));
    x2_v=double(subs(x1,t,tz));
    h2_v=double(subs(h1,t,tz));
    
    der_v=double(subs(der1(4,1),t,tz));
    
    if tz==1.6
        X1=[4.43 0.244 0.759 -0.339 12.40 1.93]'
    else if tz==2
            X1=[3.92 -0.048 0.86 -0.85 14.05 2.1]'
        else
            X1=[v2_v gamma2_v afar2_v q2_v x2_v h2_v]'
        end
    end
    %����ȡʱ�̵����Է���
    U1=[3.8378 der_v]'
    [A,B,C,D]=linmod2('fly2_6d',X1,U1)
    
    %���lqr��k
    [K,S,E]=lqr(A,B,Q,R);
    A_all(:,:,loc)=A;
    B_all(:,:,loc)=B;
    Kall1(:,:,loc)=K;
    
    Kall(i:i+1,1:6)=K;
    i=i+2;
    loc = loc+1;
end

%     sim('sim_switch_6d');