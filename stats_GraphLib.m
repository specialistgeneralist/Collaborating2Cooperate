function stats_GraphLib(Glib)

%STATS_GRAPHLIB Obtain summary statistics for the Graph Library.
%   STATS_GRAPHLIB(GLIB) Provides a summary table (in the display) of graph 
%   measures such as number of connected components, density, average degree, 
%   and the number of distinct coalitions per coalition size, calculated over 
%   the full number of replicates in the library for a given value of the edge 
%   density parameter e.
%
%   Note: support for the number of connected components measure comes from 
%   the MIT MATLAB networks library (2006-2011):
%      http://strategic.mit.edu/downloads.php?page=matlab_networks
%
%See also NUM_CONN_COMP

N = numel(Glib);
est_largest_k = max(Glib(end).lib(1).sM);
% // This handles the case where a connected sub-graph of size k may not exist 
% in the graph for whatever reason. We use the last (end) card as in most 
% use-cases this will be the condition with the highest graph density, and so, 
% largest connected sub-graphs.


% for each library card (p,e)
for i = 1:N

    num_graphs = numel(Glib(i).lib);

    % init
    z = zeros(num_graphs,1);
    avg_deg = z; dens = z; num_comp = z;
    s_size_dist = repmat(z, 1, est_largest_k);   % use last card in Glib as we assume this is likely the most dense

    % for each graph
    for r = 1:num_graphs
        G = Glib(i).lib(r).G;
        sM = Glib(i).lib(r).sM;
        n = size(G,1);
        num_comp(r,1) = num_conn_comp(full(G));
        avg_deg(r,1) = mean(sum(G,2));
        dens(r,1) = sum(G(1:end))/2 ./ (n*(n-1)/2);
        s_size_dist(r,:) = hist(sM, 1:est_largest_k);
    end
    
    m.e(i,1) = Glib(i).e;
    m.avg_num_comp(i,1) = round(mean(num_comp),1);
    m.avg_density(i,1) = round(mean(dens),2, 'significant');
    m.avg_deg(i,1) = round(mean(avg_deg),1);
    m.avg_S_size_dist(i,:) = round(mean(s_size_dist),0);

end

% display to screen
disp(struct2table(m))
