function S = ChooseCoalition_Binomial(M, sM, K, n, p_dist)

%CHOOSECOALITION_BINOMIAL Choose a coalition from the library.
%   S = CHOOSECOALITION_BINOMIAL(M,SM,K,N,P_DIST) If M is empty, then we assume 
%   a coalition size = 1 (individualistic updating), and randomly choose an 
%   agent from 1..N, else, first a coalition size is chosen based on the 
%   probability distribution over sizes 1..K given in vector P_DIST, then, a 
%   coalition (set of indices \in 1..N) is chosen from a row of the subset of M 
%   having the given coalition size as given in SM.
%
%See also CHOOSE_ONE RANDSAMPLE

% .. check for no-coalition option
if isempty(M)
    S = choose_one(1:n);
    return
end

% .. else choose k first, then uniform pick within
%   nb: we limit k to the upper bound found in the graph, as some graphs will 
%   not have a connected sub-graph of a given size (under SW or Clique-only treatments)

max_k = max(sM);	% largest size coalition
k = randsample(1:max_k, 1, true, p_dist(1:max_k));
ix = find(sM==k);
i = choose_one(ix);		% fast implementation
S = find(M(i,:));
