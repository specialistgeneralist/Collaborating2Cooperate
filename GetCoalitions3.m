function [S] = GetCoalition3(G, P, p_dist)

% GETCOALITION3 Runtime coalition generator for a given graph and
%    starting node, this version (3) drops the tunable branching
%    param and instead uses all adjacent vertices to the coalition
%    set S as potential new members of S.
%
% [S] = GetCoalition(G,P) for a given graph G, uses input
%    param structure to build a coaltion around a random agent
%    i of size up to P.k.
%
% Algorithm:
%   S <- I    :Enrol I into coalition S
%   Turtles <- adjacent vertices to S (not in S already)
%   While |S| < k {
%      j <- choose one vertex \in Turtles
%      S <- S \bigcap j
%      Turtles <- adjacent vertices to S (not in S already)
%      }
%
% Note
%   We conduct the node addition element-wise, so that all possible
%   coalitional topologies are possible.

% Simon D. Angus
% Copyright, Monash University, 2013-

% History
%  2019-10-11:
%    .. Updated to support distributional choice of k with 'p_dist'
%    .. Added check for empty new neighbour set


% first, get a k using the PDF over 1..k
k = randsample(1:P.k, 1, true, p_dist(1:P.k));

% next, get an i
i = choose_one(1:P.ini.n);

% initial coalition
S  = [i];	                % i \in S, by assumption
nS = numel(S);              % |S|
Turtles = GetTurtles(S,G);  % get all adjacent nodes to S, not in S

% loop until nS = k, though break if no more growth possible
while nS < k & ~isempty(Turtles)
    j = choose_one(Turtles);        % uniform choice from Turtles
    S = [S j];                  % add j to S
    nS = numel(S);              % update S
    Turtles = GetTurtles(S,G);  % update turtles
end

% ------------------------------------------------ %
function T = GetTurtles(S,G)

[I,J] = find(G(S,:));       % J contains all adjacent nodes to Turtles
T = setdiff(unique(J),S);   % ensure not already in S

