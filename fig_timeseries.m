function fig_timeseries(summary)

%FIG_TIMESERIES Plot coloured frac C time-series line plot.
%   FIG_TIMESERIES(SUMMARY) Addresses each experiment of SUMMARY and plots both 
%   individual population fraction of cooperators as feint lines, and the 
%   average over all replicates as a solid line. Colours are matched between 
%   individual and average using primitive (default) colours.
%
%   Example
%
%   >> load expDisruption.mat
%   >> fig_timeseries(summary)
%
%See also PLOT

% .. prepare figure, fix position for reproducible size
figure(1),clf
set(gcf,'Color','w', 'Position', [3   699   747   286])
hold on

% .. get native colours, expand set if needed
clrs = get(gca,'colororder');
n_ex = numel(summary);
if n_ex > size(clrs,1)
    clrs0 = clrs;
    while size(clrs,1) < n_ex
        clrs = [clrs;clrs0];
    end
end

% .. extract + plot
n = summary(1).inputs.T;
xx = [1:n]';
for i = 1:n_ex

    % .. data
    p = summary(i).inputs.p;
    e = summary(i).inputs.e;
    res = summary(i).results;
    X = 1-[res.XT.xt];          % fC = 1-fD
    m_x = mean(X,2);

    % .. plot
    % .. smooth for R=1
    if summary(i).inputs.R == 1
        m_x = smoothdata(m_x, 'lowess');
    else
        plot(xx, X, '-', 'LineWidth', 0.4, 'Color', [clrs(i,:) 0.05])
    end
    plot(xx, m_x, '-', 'LineWidth', 2, 'Color', [clrs(i,:) 0.8])


    % .. put exp. number LHS of plot for identification
    text(n*1.05, m_x(end), ['ex' num2str(i)])

end

% .. dress
set(gca,'FontSize',14, 'Ylim', [0 1], 'YTick', [0 0.25 0.5 0.75 1.0])
ylabel('Cooperation Fraction')
xlabel('Update')
