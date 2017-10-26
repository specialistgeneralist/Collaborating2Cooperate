function out = newton_single(KS)

% NEWTON_SINGLE run a single 'Speed & Coalition' experiment to
%    explore theoretical predictions.
%
%    In this version of the main program, a /single/ run of the
%    model is conducted for plotting or checking purposes.
%
% USAGE
%   OUT = newton_single, see header of function for settings.
%
% OUTPUT
%   The program provides progress information, and when
%   finished (either total number of updates, or stopping condition
%   is met), provides a time series figure of avg. strategy and avg.
%   payoff through the experiment, plus a structure OUT:
%
%     out.avg_x : [1,num_updates] mean strategy profile
%     out.avg_pi: [1,num_updates] mean payoff profile
%
% See documentation for further information.

% Simon D. Angus
% Copyright, Monash University, 2012-

% History
% 2012-10-23: created the single-run from the multi-run code
% 2017-08-25: update to PD project

% INPUTS, manual
% ------------------------------------------------------- %
P.ini.n = 100;		% integer, num agents in model, good if this is a square (for lattices)
P.ini.fB = 0.99;		% fraction of strategy B types at t=0
% -------------------------------------------------------- %
P.k = KS;			% integer, max coalition size to form
%P.k = 2;			% integer, max coalition size to form
P.pi.b = 2;		    % Nowak's 'b' param
P.pi.c = 1;		    % Nowak's 'c' param
% nb: Nowak's 'k' (num_neighbours / degree) param provided below from % MakeGraph()
P.epsilon = 0.10;	% float, tremble probability
P.conv = 0.05;		% fraction of B players to say that convergence to 'all-A'
% -------------------------------------------------------- %
P.T = 1000;	    	% updates to run for (stopping condition?)
% -------------------------------------------------------- %
P.net_type = 2;	% (2=VN-toroidal), integer \in {1,..,9} see 'MakeGraph.m' for details
% -------------------------------------------------------- %

% -------------------------------------------------------- %
% NB, encoding:
%   Assume strat 0:A and  1:B
% -------------------------------------------------------- %

% // Initalise replicate
s1 = RandStream.create('mt19937ar','seed',1);
RandStream.setGlobalStream(s1);
% .. construct graph per network type required (see MakeGraph.m for options)
[G,P.pi.avgD] = MakeGraph(P);
x = rand(P.ini.n,1) <= P.ini.fB;	% init. strats
P.PI = game_table(P);
pi = UpdatePayoffs(G,x,P);

% // Identify all coalitions to avoid run-time calc.
fprintf('main: building coalitional library ... ');
    coalitional_types = ones(P.ini.n,1);        % all capable of collective agency
    [C,M,sM] = GetAllCoalitions_k(G, ones(P.ini.n,1), P.k);
    fprintf('done.\n');

% // Main Loop
t = 1;
conv_flagg = 0;
while (t < P.T) & not(conv_flagg)

    if mod(t,1E3)==0,disp(sprintf('  update: %.0f (avg_x = %.2f)',t,mean(x)));end

    S = ChooseCoalition_k_v2(M,sM,P.k,P.ini.n);
    x = ApplyBetterResponse(G,x,S,P,pi);
	x = ApplyTremble(P,S,x);
	pi = UpdatePayoffs(G,x,P);
	conv_flagg = TestConvergence(x,P);

	out.avg_x(t) = mean(x);
	out.avg_pi(t) = mean(pi);
	t = t + 1;

end % (while t)

figure(1),clf
set(gcf,'Color','w')

subplot(2,1,1)
	set(gca,'FontSize',14)
	plot(out.avg_x,'k-')
	ylabel('Avg. Strategy')
	set(gca,'Ytick',[0 1],'Yticklabel',{'All-A' 'All-B'},'Ylim',[0 1])

subplot(2,1,2)
	set(gca,'FontSize',14)
	plot(out.avg_pi,'k-')
	xlabel('Update')
	ylabel('Avg. payoff')

