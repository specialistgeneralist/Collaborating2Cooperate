function [varargout] = MakeNetLib_complete(N,K)

%MAKENETLIB_COMPLETE Build a coalition libary for the complete graph.
%   MAKENETLIB_COMPLETE(N,K) A fast algorithm for defining all possible complete
%   sub-graphs (cliques) up to size K using NCHOOSEK rather than sub-graph
%   exploration in the case of sparse networks.
%
%   Output library (Glib) is saved to the PWD in 'graph_lib_complete_tmp.mat'
%   and optionally as a variable in the workspace.
%
%   See also NCHOOSEK SUB2IND

if K==1
    error('Sorry, coalitions only defined on K>1')
end

% .. graph
G = sparse([ones(N) - diag(ones(1,N))]);

% .. initialise, k=1 singleton 'coalitions' first
M = logical(zeros(N,N));
ix = sub2ind(size(M),[1:N]',[1:N]');
M(ix) = 1;

% .. calc
for k = 2:K
    c = nchoosek(1:N,k);
    n = size(c,1);
    ne = numel(c);
    r = [1:n]' * ones(1,k);
    ix = sub2ind([n N], reshape(r,ne,1), reshape(c,ne,1));
    m = logical(zeros(n,N));
    m(ix) = 1;
    M = [M; m];
end

% .. out
sM = sum(M,2);
Glib.e = 1;
Glib.lib.G  = G;
Glib.lib.M  = M;
Glib.lib.sM = sM;
    
% .. save
fprintf(' --> saving Glib to ''graph_lib_complete_tmp.mat'' ... ')
save('graph_lib_complete_tmp.mat', 'Glib')
fprintf('done.\n')

if nargout > 0
    varargout{1} = Glib;
    end

