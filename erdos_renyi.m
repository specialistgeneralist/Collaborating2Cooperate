function G = erdos_renyi(N,E,varargin)

% ERDOS_RENYI produces an E-R undirected random graph of size N and edge 
% probability E, regardless of the presence of singletons (default). See 
% options for ensuring singletons are avoided.
%
% G = ERDOS_RENYI(N,E) G is a symmetric adjacency matrix [N,N] with edge 
% probability E.
%
% OPTIONS
% G = ERDOS_RENYI(...,NO_SING) if NO_SING=0 (default) singletons that arise 
% will be retained, if NO_SING=1, then singletons will be joined to some other 
% vertex (uniformly chosen) until no singletons are left.
% NB: G can be disconnected in either treatment.

% default, option
NO_SING = 0;
if nargin > 2
    NO_SING = varargin{1};
end

% basic random graph: we calculate the rounded number of edges to form as E.N, 
% and then form these at random, rather than using a random/threshold 
% approach, to ensure we land as close as possible to the given E.
mask = triu(ones(N),1);
ix = find(mask);        % locations of upper triangle
r_ix = randsample(ix, round(E*numel(ix)));      % choose E.N of these at random
G = logical(zeros(N));
G(r_ix) = 1;
G = G + G';             % symmetric

if NO_SING==1
    d = sum(G,2);
    ix_rem = find(d==0);      % indices of singletons remaining
    while isempty(ix_rem)==false
        i = choose_one(ix_rem);
        j = choose_one(setdiff(1:N,i)); % choose one other vertex
        % add edge
        G(i,j) = 1;
        G(j,i) = 1;
        % update
        d = sum(G,2);
        ix_rem = find(d==0);
    end
end

