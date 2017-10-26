function [G,varargout] = MakeGraph(P)

%MAKEGRAPH Make a graph from a menu of types.
%   G = MAKEGRAPH(P) Provides adjacency matrix G based on the number of agents 
%   P.INI.N, graph type P.NET_TYPE, and in some cases edge density P.E found in 
%   parameter array P.
%
%   [G,AVGD] = MAKEGRAPH(P) Additionally provides the average degree of G.
%
%   Graph types available (P.NET_TYPE):
% 	 case 1 Von-Neumann, dis-continuous boundary.
%    case 2 Von_Neumann, continuous boundary (toroidal).
%  	 case 3 VN, continuous, with 10% re-wiring to make Small-World.
% 	 case 4 VN, continuous, with 100% rewiring to make random.
% 	 case 5 Moore, dis-continuous boundary.
% 	 case 6 Moore, continous boundary (toroidal).
% 	 case 7 Ring, 4-regular.
% 	 case 8 Ring, 4-regular, 10% rewiring to make Small-World.
% 	 case 9 Ring, 4-regular, 100% rewiring to make random.
% 	 case 10 Scale-free, avg. degree 4 using SFNG algorithm.
% 	 case 11 Erdos_Renyi with no singletons
%
%See also REWIRE ERDOS_RENYI

% History
%  12-11-01: changed 'sw' definition from 5% to 10% rewiring
%  17-08-25: updated to provide an optional avg. degree
%  17-09-06: added Erdos-Renyi graphs option (11)

L = round(sqrt(P.ini.n));		% side-length if required
switch P.net_type
	case 1 %'von-0'
		G = vonneumanngraph(L,0);
	case 2 %'von-1'
		G = vonneumanngraph(L,1);
	case 3 %'von-1-sw'
		G = rewireR(vonneumanngraph(L,1),0.10);
	case 4 %'von-1-rand'
		G = rewireR(vonneumanngraph(L,1),1.0);
	case 5 %'moore-0'
		G = mooregraph(L,0);
	case 6 %'moore-1'
		G = mooregraph(L,1);
	case 7 %'ring-d4-reg'
		G = rewire(P.ini.n,4,0);
	case 8 %'ring-d4-sw'
		G = rewire(P.ini.n,4,0.10);
	case 9 %'ring-d4-rand'
		G = rewire(P.ini.n,4,1.0);
	case 10 %'scale-free-d4'
		G = scalefree(P.ini.n,4);
    case 11 %'erdos-reny with no singletons'
        G = erdos_renyi(P.ini.n,P.e,1); % '1' ~ no singletons
	end

if nargout > 1
    avgD = mean(sum(G'));
    varargout{1} = avgD;
end

