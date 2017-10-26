function pi = game_table(b,c)

%GAME_TABLE Provides a game table, PI.
%   PI = GAME_TABLE(B,C) Provides the payoff matrix PI for given values of 
%   game-table parameters B and C.
%
%   Note: Axelrod payoffs [3 0; 5 1] can be specified by leaving either B or C 
%   empty.

%  (C,C) (C,D)
%  (D,C) (D,D)

if isempty(b) | isempty(c)
    fprintf('nb: using Axelrod payoffs\n')
    pi = [3 0; 5 1];
else
    pi = [ 2*b-c b-c; b 0];
end
