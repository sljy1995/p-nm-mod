% Inputs :
% curve : pre - computed data about an interest rate curve
% t: time
% Output :
% integ : integral of the local rate function from 0 to t
function integ = getRateIntegral (curve , t)

    % Deny extrapolation beyond 30 days
    maxExtra = 30/365;
    tMax = curve.lastT + maxExtra;

    if t > tMax
        error('Extrapolation beyond last tenor is only allowed up to 30 days.');
    end

    % Extrapolation beyond last tenor (within 30 days)
    if t >= curve.lastT
        integ = curve.I(end) + curve.lastR * (t - curve.lastT);
        return;
    end

    % Find interval i such that curve.t(i) <= t < curve.t(i+1)
    i = find(curve.t <= t, 1, 'last');

    % Evaluate integral
    integ = curve.a(i) + curve.r(i) * t;
end