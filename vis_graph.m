function vis_graph(G,varargin)

% VIS_GRAPH produces a simple .dot file for graph plotting of a graph, G 
% (adjacency matrix), and optionally with strategy profile X.


% .. option
inc_strats = 0;
if nargin > 1
    inc_strats = 1;
    vColid = varargin{1};   % vector, length n(vertices), corresponding to Cols array
    Cols = varargin{2};     % cell array, e.g. {'red' 'blue'}
end

% .. make dot file
adj2dot(G, vColid, Cols)


