% Inputs :
% curve : pre - computed fwd curve data
% T: forward spot date
% Output : Forward spot - fwdSpot
% fwdSpot : E[S(t) | S (0)]
function fwdSpot = getFwdSpot (curve , T)
   
    % Get T + tau
    tF = T + curve.tau;

    % Get cumulative integrals (rates at time tF)
    Id_tF = getRateIntegral(curve.domCurve, tF);
    If_tF = getRateIntegral(curve.forCurve, tF);

    % Get discount factors at tF
    Pd_tF = exp(-Id_tF);
    Pf_tF = exp(-If_tF);

    % G0(T) = S0 * Pd(tau)/Pf(tau) * Pf(T+tau)/Pd(T+tau)
    fwdSpot = curve.spot * (curve.Pd_tau / curve.Pf_tau) * (Pf_tF / Pd_tF);

end