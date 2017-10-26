function [i] = choose_one(ids)

%CHOOSE_ONE A fast version of RANDSAMPLE, returning only 1 item.
%   I = CHOOSE_ONE(IDS) selects a single item from vector IDS.
%
%   Note: CHOOSE_ONE is ~ 1.8 times faster than RANDSAMPLE.
%
%See also RANDPERM

L = numel(ids);
r = randperm(L);
i = ids(r(1));

