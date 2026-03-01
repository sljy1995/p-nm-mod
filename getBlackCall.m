% Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall (f, T, Ks , Vs)

    % Ensure Ks and Vs have same length

    Ks = Ks(:);
    Vs = Vs(:);

    if numel(Ks) ~= numel(Vs)
        error("Ks and Vs must have the same length.")
    end

    % Ensure Ks and f are >= 0
    
    if any(Ks <= 0)
        error("Strike price must be strictly positive")
    end

    if f <= 0
        error("Forward price must be strictly positive")
    end

    % If T <= 0, u = max(f-Ks, 0)
    % u = f*N(d1) - K*N(D2) for T > 0
    
    if T <= 0
        u = max(f-Ks, 0);
        return;
    end

    d1 = (log(f ./ Ks) + (0.5 .* Vs.^2) .* T) ./ (Vs .* sqrt(T));
    d2 = d1 - Vs .* sqrt(T);
    u = f .* normcdf(d1) - Ks .* normcdf(d2);
    
end