% Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall(f, T, Ks, Vs)

    % Validate inputs according to required conditions
    arguments
        f  double {mustBePositive}
        T  double {mustBeNonnegative}
        Ks double {mustBeNonnegative}
        Vs double {mustBePositive}
    end
    
    % Ensure Ks and Vs have same length
    Ks = Ks(:);
    Vs = Vs(:);
    assert(numel(Ks) == numel(Vs), "Length of Ks must be the same as Vs");

    % For all K = 0, u = f,
    zerosIdx = (Ks == 0);
    u = zeros(size(Ks));
    u(zerosIdx) = f;
    
    % If T <= 0, u = max(f-Ks, 0)
    % u = f*N(d1) - K*N(D2) for T > 0
    posIdx = (Ks > 0);
    if T == 0
        u(posIdx) = max(f-Ks(posIdx), 0);
        return;
    end

    totalVol = Vs(posIdx) .* sqrt(T);
    d1 = (log(f ./ Ks(posIdx)))/totalVol + 0.5 .* totalVol;
    d2 = d1 - totalVol;
    u(posIdx) = f .* normcdf(d1) - Ks(posIdx) .* normcdf(d2);
end