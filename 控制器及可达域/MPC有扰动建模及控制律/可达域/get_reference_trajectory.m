function x_ref = get_reference_trajectory(time)
    % 参考轨迹
    sim('guiji_6d1');
    y1 = polyfit(V0.time, V0.signals.values, 8);
    y2 = polyfit(miu0.time, miu0.signals.values, 8);
    y3 = polyfit(alpha0.time, alpha0.signals.values, 8);
    y4 = polyfit(q0.time, q0.signals.values, 8);
    y5 = polyfit(x0.time, x0.signals.values, 8);
    y6 = polyfit(h0.time, h0.signals.values, 8);
    
    t = sym('t');
    Vr = poly2sym(y1, t);
    miur = poly2sym(y2, t);
    alphar = poly2sym(y3, t);
    qr = poly2sym(y4, t);
    xr = poly2sym(y5, t);
    hr = poly2sym(y6, t);
    
%      timespan = time_span(1):0.01:time_span(2);
    x_ref = [double(subs(Vr, time')) double(subs(miur, time')) ...
             double(subs(alphar, time')) double(subs(qr, time')) ...
             double(subs(xr, time')) double(subs(hr, time'))];
end