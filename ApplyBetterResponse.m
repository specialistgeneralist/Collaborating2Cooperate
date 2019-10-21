function x_out = ApplyBetterResponse(G,x,S,P,pi_t)

%APPLYBETTERRESPONSE Return a vector of better-response strategies.
%   X_OUT = APPLYBETTERRESPONSE(G,X,S,P,PI_T) takes the graph G, original 
%   strategy vector X, coalition S, parameter structure P, and original payoff 
%   vector PI_T, and produces, for each player an outcome strategy vector X_OUT 
%   representing a better response.
%
%See also UPDATEPAYOFFS

% Simon D. Angus
% Copyright, Monash University, 2012-

% History
% 2012-10-16: Initial coding
% 2019-09-26: Added support for CoalitionSwitchingCost

% .. strategy choices (for 1 player or entire coalition)
x_SA = x; x_SA(S) = 0;	% x if all i \in S play 0:C
x_SB = x; x_SB(S) = 1;	% x if all i \in S play 1:D

% .. get payoffs under options
pi_A = UpdatePayoffs(G,x_SA,P);
pi_B = UpdatePayoffs(G,x_SB,P);

% .. check if k>1 coalition, allow for one-time CoalitionalSwitchingCost experiment to be applied
if numel(S) > 1
	bA = all(pi_A(S) - P.CoalitionalSwitchingCost >= pi_t(S));	% is pi(A) >= pi(x) for all i \in S?
	bB = all(pi_B(S) - P.CoalitionalSwitchingCost >= pi_t(S));	% is pi(B) >= pi(x) for all i \in S?
else
	bA = all(pi_A(S) >= pi_t(S));	% is pi(A) >= pi(x) for all i \in S?
	bB = all(pi_B(S) >= pi_t(S));	% is pi(B) >= pi(x) for all i \in S?
end

% .. apply logic
if not(bA) & not(bB)	% neither at least as good, stay
	x_out = x;
elseif bA & not(bB)		% A as good, but not B, switch to A
	x_out = x_SA;
elseif bB & not(bA)		% B as good, but not A, switch to B
	x_out = x_SB;
else					% split equiprobably
	if rand <= 0.5
		x_out = x_SA;
	else
		x_out = x_SB;
	end
end


