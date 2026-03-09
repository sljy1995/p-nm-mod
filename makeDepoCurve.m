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
    ts  = [0; ts]; % size N + 1
    dfs = [1; dfs]; % size N + 1
    
    % Ensure ts is sorted in ascending order, with corresponding dfs rearranged accordingly
    [ts, idx] = sort(ts);
    dfs = dfs(idx);
    curve.ts = ts;
    curve.dfs = dfs;

    % Calculate period (T_n - T_{n-1}) discount factors and period lengths
    curve.period_dfs = [dfs(1); [dfs(2:end)]./dfs(1:end-1)];
    curve.period_lens = [ts(1); diff(ts)];

    % Bootstrap local rates
    % r_i = - (ln P(0,t_{i+1}) - ln P(0,t_i)) / (t_{i+1}-t_i)
    curve.r = -(log(curve.period_dfs)) ./ period.lens; % size N

    % Precompute cumulative integrals
    % I(1)=0, I(i+1)=I(i)+r(i)*dt(i)
    I = zeros(size(t)); % size N + 1
    I(2:end) = cumsum(r .* dt);
    curve.I = I;

    % Precompute a_i
    % For t in [t_i, t_{i+1}):  ∫0^t r = I(i) + r(i)*(t - t_i)
    %                        = (I(i) - r(i)*t_i) + r(i)*t
    a = I(1:end-1) - r .* t(1:end-1); % size N
    curve.a = a;

    % Store last T and local rate r to support extrapolation of rates beyond last T
    curve.lastT = curve.ts(end);
    curve.lastR = curve.r(end);

end