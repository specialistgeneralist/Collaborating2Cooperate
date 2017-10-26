function [Glib] = MakeNetLib(N,R,K,E)

%MAKENETLIB Build a coalition library for fast run-time simulation.
%   GLIB = MAKENETLIB(N,R,K,E) Creates a network library and pre-computed 
%   coalition data structure to allow fast run-time simulation. Makes R 
%   replicates with coalition sizes up to K enumerated, for E-R graphs of size 
%   N, and edge-prob set E.
%
%   Computation is carried out in parallel (over replicates).
%   Intermediate outputs are saved after each value of E is completed.
%
%See also MAKEGRAPH GETALLCOALITIONS_K

P.net_type = 11;        % random graph
P.ini.n = N;
coalitional_types = ones(P.ini.n,1);        % all capable of collective agency

for j = 1:numel(E)

    P.e = E(j);     % edge-prob
    t_lib.G = [];
    t_lib.M = [];
    t_lib.sM = [];

	parfor r = 1:R
	
		% .. random stream is reproducible, the seed is the replicate #
		s1 = RandStream.create('mt19937ar','seed',r);
		RandStream.setGlobalStream(s1);
		
        % .. make graph
        G = MakeGraph(P);

        % .. get coalitions
        [C,M,sM] = GetAllCoalitions_k(G, ones(P.ini.n,1), K);

        t_lib(r).G = sparse(G);
        t_lib(r).M = M;
        t_lib(r).sM = sM;

    end

    Glib(j).e = P.e;
    Glib(j).lib = t_lib;

    save('graph_lib_tmp.mat', 'Glib')

    disp_prog(j,numel(E));

    clear t_lib

end


