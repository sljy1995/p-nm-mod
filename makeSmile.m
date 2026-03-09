% Inputs :
% fwdCurve : forward curve data
% T: time to expiry of the option
% cps: vetor if 1 for call , -1 for put
% deltas : vector of delta in absolute value (e.g. 0.25)
% vols : vector of volatilities
% Output :
% curve : a struct containing data needed in getSmileK
function [ curve ]= makeSmile ( fwdCurve , T, cps , deltas , vols )
% Hints :
% 1. assert vector dimension match
% 2. resolve strikes using deltaToStrikes
% 3. check arbitrages
% 4. compute spline coefficients
% 5. compute parameters aL , bL , aR and bR

    % Assert conditions on vector and vector length
    assert(isvector(cps) && isvector(deltas) && isvector(vols), ...
        'cps, deltas, vols must be vectors.');
    assert(numel(cps) == numel(deltas) && numel(deltas) == numel(vols), ...
        'cps, deltas, vols must have the same length.');

    cps    = cps(:);
    deltas = deltas(:);
    vols   = vols(:);

    % Resolve strikes using deltaToStrikes
    Ks = deltaToStrikes(fwdCurve, T, cps, deltas, vols);
    Ks = Ks(:);
    
    % Get Fwd Spot Prices
    fwds = getFwdSpot(fwdCurve, T);
    fwds = fwds(:);

    % Get Call Prices
    calls = getBlackCall(fwds, T, Ks , vols);

    % Sort by strike and ensure that there are at least 3 smile points
    [Ks, idx] = sort(Ks);
    vols = vols(idx);
    cps  = cps(idx);
    calls = calls(idx);
    
    % Check for arbitrage - condition: (C_i - C_{i-1}) / (K_i - K_{i-1}) < (C_{i+1} - C_i) / (K_{i+1} - K_i)
    slope = diff(calls)./diff(Ks);
    assert(all(diff(slope) > 0), "The price of a call option must be convex in strike");
