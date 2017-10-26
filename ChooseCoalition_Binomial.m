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
k = randsample(1:K, 1, true, p_dist);
ix = find(sM==k);
i = choose_one(ix);
S = find(M(i,:));
