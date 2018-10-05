function pi = game_table(b,c)

%GAME_TABLE Provides a game table, PI.
%   PI = GAME_TABLE(B,C) Provides the payoff matrix PI for given values of 
%   game-table parameters B and C.
%
%   Note: Axelrod payoffs [3 0; 5 1] can be specified by setting either B or C 
%   to 0.

%  (C,C) (C,D)
%  (D,C) (D,D)

if b==0 | c==0
    fprintf('nb: using Axelrod payoffs\n')
    pi = [3 0; 5 1];
else
    pi = [ 2*b-c b-c; b 0];
end
