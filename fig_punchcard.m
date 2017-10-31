function fig_punchcard(SUMMARY, EX, NPER)

%FIG_PUNCHCARD Make a 'punchcard' figure for strategic switching.

MALPHA = 0.4;
CCLR = [0.2*ones(1,3) MALPHA];
DCLR = [0.9*ones(1,3) MALPHA];

Z = SUMMARY(EX).results.more_res.fX;
T = SUMMARY(EX).inputs.T;

n = size(Z,1);
nper = min(size(Z,2), NPER);
if nper < NPER
    fprintf('note: reduced NPER to %.0f since this is all we have.\n', nper);
end

% .. get data, generate X positions
Z = Z(:,end-1-nper+1:end-1);
X = repmat(T-nper+1:T, n, 1);

% .. identify C(=0) and D(=0) strategies
ixC = find(Z==0);
ixD = find(Z==1);

% .. set up data so that we can plot C and D separately as contiguous lines
Zc = double(Z); Zd = double(Z);

Zc(ixD) = NaN;
Zc(ixC) = 1;
Zc = Zc .* repmat([1:n]', 1, nper);

Zd(ixC) = NaN;
Zd(ixD) = 1;
Zd = Zd .* repmat([1:n]', 1, nper);

% .. Plot
figure(1),clf,set(gcf,'Color','w'), hold on
set(gcf, 'Position', [1   707   748   278])
    plot(X', Zc', '-', 'LineWidth', 4, 'Color', CCLR)
    plot(X', Zd', '-', 'LineWidth', 4, 'Color', DCLR)

% dress
set(gca,'TickDir', 'out')
set(gca,'XTick', [T-nper T])
xlabel('Update')
set(gca,'YLim', [0 n+1], 'Ytick', [1 n/2 n])
ylabel('Individual')
set(gca,'FontSize', 14)
box on
