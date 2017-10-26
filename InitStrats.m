function x = InitStrats(n,f)

%INITSTRATS Initialise strategies with given fraction of C.
%   X = INITSTRATS(N,F) provides a binary vector [N,1] with random assignment 
%   of round(F*N) of agents to stategy 1 (i.e. 'D')
%
%See also RANDSAMPLE

x = zeros(n,1);
ix = randsample(1:n, round(f*n));
x(ix) = 1;
