function fig_contours(varargin)

%FIG_CONTOURS Make all panels of avg C contour plot in (p,e) space.
%   FIG_CONTOURS products a 2r x 3c sub-plot figure for six experiments at 
%   various combinations of (b,c), and the Axelrod settings.
%
%   FIG_CONTOURS(TYPE) allows for plotting 'small-world' results or 'clique-
%   only' results per the extentions.
%
%   Examples:
%
%   >> fig_contours
%   >> fig_contours('small-world')
%
%See also PLOT_HEATMAP

% History
%   2019-10-19 Added support for Large-N experiment

NPOINTS = 500;

if nargin > 0
    TYPE = varargin{1};
else
    TYPE = 'null';
end

% .. Figure set up
figure(1),clf,set(gca,'Color','w')
set(gcf,'Position', [5   552   712   433])      % for reproducible dimensions

% .. Experiment listing to load and names
switch TYPE
    case  'cliques-only'
        fprintf(' --> displaying Cliques-only data ...\n')
    %    'Arthur' experiments - sub-graph Cliques (complete) only
    exp_list = { ...
        'expArthur_b2c3', '(2,3) lower', ...
        'expArthur_b3c4', '(3,4) lower', ...
        'expArthur_b4c5', '(4,5) lower', ...
        'expArthur_b1p01c2p01', '(1.01,2.01) lower', ...
        'expArthur_axelrod', 'Axelrod', ...
        'expArthur_b32c33', '(32,33)'};

    case  'small-world'
        fprintf(' --> displaying Small-World data ...\n')
    %     Small-World experiments
    exp_list = { ...
        'expSW_b2c3', '(2,3) lower', ...
        'expSW_b3c4', '(3,4) lower', ...
        'expSW_b4c5', '(4,5) lower', ...
        'expSW_b1p01c2p01', '(1.01,2.01) lower', ...
        'expSW_axelrod', 'Axelrod', ...
        'expSW_b32c33', '(32,33)'};

    case 'large-N'
         fprintf(' --> displaying Large-N data ...\n')
    %     Large-N experiment
    exp_list = { ...
        'largeN_sparse_b2c3_t30k', '(2,3) lower', ...
        'largeN_sparse_b3c4_t30k', '(3,4) lower', ...
        'largeN_sparse_b4c5_t30k', '(4,5) lower', ...                
        'largeN_sparse_b1p01c2p01_t30k', '(1.01,2.01) lower boundary', ...
        'largeN_sparse_Axelrod_t30k', 'Axelrod', ...
        'largeN_sparse_b32c33_t30k', '(32,33)'};

    otherwise
    %    Main paper
    exp_list = { ...
        'exp011a_low', '(2,3) lower', ...
        'exp010a_baseline','(3,4) benchmark', ...
        'exp012a_high', '(4,5) upper', ...
        'exp014a_lowboundary', '(1.01,2.01) lower boundary', ...
        'exp013a_axelrod', 'Axelrod', ...
        'exp015a_highboundary', '(32,33) upper boundary'};
end

% .. loop
for i = [1:numel(exp_list)/2]
    % .. load dataset
    k = (i-1)*2+1;
    efile = exp_list{k};
    ename = exp_list{k+1};
    eval(sprintf('load %s.mat', efile));    % --> gives 'summary'
    n = summary(1).inputs.ini.n;
    e_min = summary(1).inputs.e;
    e_max = summary(numel(summary)).inputs.e;
    % .. plot
    subplot(2,3,i)
        plot_heatmap(summary, NPOINTS)
        % .. dress: handle different N
        switch n
        case 32
            set(gca,'Xlim', [0 0.9], 'Xtick', [0 0.3 0.6 0.9], 'Ytick', [0.05 0.15 0.3 0.4])
        otherwise
            set(gca,'Xlim', [0 0.9], 'Xtick', [0 0.3 0.6 0.9], 'Ytick', [e_min e_min+(e_max-e_min)/2 e_max])
        end
end
