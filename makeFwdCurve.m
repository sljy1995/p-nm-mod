% Inputs :
% domCurve : domestic IR curve data
% forCurve : domestic IR curve data
% spot : spot exchange rate
% tau: lag between spot and settlement
% Output :
% curve : a struct containing data needed by getFwdSpot
function curve = makeFwdCurve ( domCurve , forCurve , spot , tau)

    % Store variables needed in getFwdSpot
    curve.domCurve = domCurve;
    curve.forCurve = forCurve;
    curve.spot     = spot;
    curve.tau      = tau;

    % Use getRateIntegral to derive domestic and foreign rates at tau
    Id_tau = getRateIntegral(domCurve, tau);
    If_tau = getRateIntegral(forCurve, tau);

    % Tabulate value of P_d(tau) and P_f(tau) as the exponential of their negative rates
    curve.Pd_tau = exp(-Id_tau);
    curve.Pf_tau = exp(-If_tau);
    
end