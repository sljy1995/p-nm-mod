% Inputs :
% curve : pre - computed fwd curve data
% T: forward spot date
% Output : Forward spot - fwdSpot
% fwdSpot : E[S(t) | S (0)]
function fwdSpot = getFwdSpot (curve , T)

    S0  = curve.spot;
    tau = curve.tau;

    tF = T + tau;

    Id_tF = getRateIntegral(curve.domCurve, tF);
    If_tF = getRateIntegral(curve.forCurve, tF);

    Pd_tF = exp(-Id_tF);
    Pf_tF = exp(-If_tF);

    % G0(T) = S0 * Pd(tau)/Pf(tau) * Pf(T+tau)/Pd(T+tau)
    fwdSpot = S0 * (curve.Pd_tau / curve.Pf_tau) * (Pf_tF / Pd_tF);
end