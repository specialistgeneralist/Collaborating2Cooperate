function fig_networks(summary, NPER)

%FIG_NETWORKS Write a .dot graph file for networks, nodes shaded by %C.
%   FIG_NETWORKS(SUMMARY, NPER) Writes a .dot format file for a shaded node 
%   network specified by each experiment in SUMMARY, assuming SUMMARY arises 
%   from a single replicate run of MAIN_EXP (R=1). This switch ensures that the 
%   graph is stored in SUMMARY(i).RESULTS.MORE_RES.G and the full strategy 
%   vector for each update is contained in (...).MORE_RES.FX. FIG_NETWORKS works 
%   with the strategy vector to calculate the fraction of time each vertex 
%   spends as C over the last NPER of the run and creates G with nodes coloured 
%   by a 5 level colour binning of %C.
%
%   Output file names, for experiments 1..N (length of SUMMARY) are:
%      net_ex1.dot, net_ex2.dot, ..., net_exN.dot
%
%See also VIS_GRAPH

% .. node colours ~ follow reverse Matlab Bone for levels as given
Cols = {'"#FFFFFF"' '"#DEE9E9"' '"#9DB7BB"' '"#6E788B"' '"#44425C"'};     % colour levels (reverse Matlab.bone)

% .. check input has enough updates stored for NPER chosen
NPER_max = summary(1).inputs.R1_nper_store;
if NPER > NPER_max
    fprintf('nb: requested NPER (%.0f) >> NPER_max (%.0f), so using max, instead.\n', NPER, NPER_max);
    NPER = NPER_max;
end

% .. loop over each experiment
n_ex = numel(summary);
for i = 1:n_ex

    % .. get Graph, and calc average %C for each vertex
    G = summary(i).results.more_res.G;
    fX = summary(i).results.more_res.fX;
    mX = 1-mean(fX(:,end-NPER+1:end),2);        % convert to f(C)

    % .. colour band indices
    ix_none = find(mX < 0.1);
    ix_L1 = find(0.1 <= mX & mX <0.3);
    ix_L2 = find(0.3 <= mX & mX <0.5);
    ix_L3 = find(0.5 <= mX & mX <0.7);
    ix_L4 = find(0.7 <= mX);

    % .. create map
    vCol_id = zeros(numel(mX),1);
    vCol_id(ix_none) = 1;
    vCol_id(ix_L1) = 2;
    vCol_id(ix_L2) = 3;
    vCol_id(ix_L3) = 4;
    vCol_id(ix_L4) = 5;

    % .. make net.dot, then rename
    adj2dot(G, vCol_id, Cols)
    system(sprintf('mv net.dot net_ex%.0f.dot', i));

end

