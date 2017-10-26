function plot_timeseries(summary)

% PLOT_TIMESERIES plot all replicates for each experiment in SUMMARY, with 
% mean trace overlaid.

figure(1),clf
set(gcf,'Color','w', 'Position', [3   699   747   286])
clrs = get(gca,'colororder');
hold on

% .. extract + plot
n = summary(1).inputs.T;
xx = [1:n]';
for i = 1:numel(summary)

    p = summary(i).inputs.p;
    e = summary(i).inputs.e;
    res = summary(i).results;
    X = 1-[res.XT.xt];
    m_x = mean(X,2);

    plot(xx, X, '-', 'LineWidth', 0.4, 'Color', [clrs(i,:) 0.05])
    plot(xx, m_x, '-', 'LineWidth', 2, 'Color', [clrs(i,:) 0.8])

    text(n*1.05, m_x(end), ['ex' num2str(i)])

end

% .. dress
set(gca,'FontSize',14, 'Ylim', [0 1], 'YTick', [0 0.25 0.5 0.75 1.0])
ylabel('Cooperation Fraction')
xlabel('Update')

