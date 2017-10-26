function pi = UpdatePayoffs(G,x,P)

%UPDATEPAYOFFS Calculate total payoffs to each agent in the game.
%   PI = UPDATEPAYOFFS(G,X,P) where G is the graph adjacency matrix, X is the 
%   strategy vector, and P is a structure of inputs params.
%
%See also SUB2IND RESHAPE

% History
% 2012-10-16: Initial coding
% 2017-08-25: Updated for PD project

PI = P.PI;      % payoff table
n = P.ini.n;    % num players

% get plays of player 1 and 2 as if all play all to col vectors
x1 = reshape(x*ones(1,n),n^2,1);
x2 = reshape(ones(n,1) * x',n^2,1);

% convert to indices in payoff table
ix = sub2ind(size(PI),x1+1,x2+1);

% get payoffs from table as if all play all
pi_all = PI(ix);

% put back into adjacency matrix, apply graph, collect
pi = [sum([G .* reshape(pi_all,n,n)]')]';
