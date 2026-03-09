% Inputs :
% fwd: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% cp: 1 for call , -1 for put
% sigma : implied Black volatility of the option
% delta : delta in absolute value (e.g. 0.25)
% Output :
% K: strike of the option
function K = getStrikeFromDelta (fwd , T, cp , sigma , delta )

    arguments
        fwd double {mustBePositive}
        T double {mustBeNonnegative}
        cp double {mustBeMember(cp, [-1, 1])}
        sigma double {mustBePositive}
        delta double {mustBeBetween(delta, 0, 1, "closed")}
    end

    totalVol = sigma .* sqrt(T);
    totalVolSq = totalVol.^2;

    % For call option,
    % d_1 = norminv(|delta|)
    % For put option,
    % d_1 = -norminv(|delta|)

    if cp == 1
        d = norminv(delta);
    else
        d = -norminv(delta);
    end

    % K = fwd * exp(-totalVol * d_1 + 0.5 * totalVol^2)
    K = fwd * exp(-totalVol .* d + 0.5 .* totalVolSq);
    K = max(K, 1e-10);
    
   

