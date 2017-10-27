function [y] = int2strL(x,L)

%INT2STRL Convert integer into string, pre-pad with zeros.
%   Y = INT2STRL(X,L) Takes input integer X and apply INT2STR but pre-pad the 
%   result with required number of 0s to ensure LENGTH(Y)=L.
%
%See also INT2STR

s = int2str(x);
s_l = length(s);

if  s_l < L
    s_a = [int2str(10^(L-s_l)) s];
    y = s_a(2:L+1);
else
    y = s;
end
