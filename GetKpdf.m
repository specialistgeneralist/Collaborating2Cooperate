function pdf = GetKpdf(k,p)

%GETKPDF Obtain a discrete binomial probability distribution.
%   PDF = GETKPDF(K,P) Produces a probability distrubtion vector (length K)
%   over the coalition sizes 1..K, for a given binomial probabilty parameter P.
%
%   See also BINOPDF

pdf = binopdf(0:k-1, k-1, p);    % prob. distro over k=1:P.k
