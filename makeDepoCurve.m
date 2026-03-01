% Inputs :
% ts: array of size N containing times to settlement in years
% dfs: array of size N discount factors
% Output :
% curve : a struct containing data needed by getRateIntegral
function curve = makeDepoCurve (ts , dfs)

    ts  = ts(:);
    dfs = dfs(:);
    
    % Ensure length of ts and dfs are the same i.e. N
    if numel(ts) ~= numel(dfs)
        error('ts and dfs must have the same length.');
    end

    % Ensure that elements in ts are strictly increasing and positive
    if any(ts <= 0) || any(diff(ts) <= 0)
        error('ts must be strictly increasing and > 0.');
    end

    % Ensure that any discount factors are positive
    if any(dfs <= 0) || any(dfs > 1.5)  % dfs>1 can happen with negative rates, but 1.5 is sanity
        error('dfs must be positive.');
    end

    % Include t0 = 0 with df0 = 1 for bootstrapping
    t  = [0; ts]; % size N + 1
    df = [1; dfs]; % size N + 1

    dt = diff(t); % size N

    % Bootstrap local rates
    % r_i = - (ln P(0,t_{i+1}) - ln P(0,t_i)) / (t_{i+1}-t_i)
    r = -(log(df(2:end)) - log(df(1:end-1))) ./ dt; % size N

    % Precompute cumulative integrals
    % I(1)=0, I(i+1)=I(i)+r(i)*dt(i)
    I = zeros(size(t)); % size N + 1
    I(2:end) = cumsum(r .* dt);

    % Precompute a_i
    % For t in [t_i, t_{i+1}):  ∫0^t r = I(i) + r(i)*(t - t_i)
    %                        = (I(i) - r(i)*t_i) + r(i)*t
    a = I(1:end-1) - r .* t(1:end-1); % size N

    % Store in struct
    curve.t     = t;
    curve.r     = r;
    curve.I     = I;
    curve.a     = a;
    curve.lastT = t(end);
    curve.lastR = r(end);
end