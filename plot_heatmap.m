function plot_heatmap(summary, NPOINTS, varargin)

%PLOT_HEATMAP Draw a single avg C contour plot in (p,e) space.
%   PLOT_HEATMAP(SUMMARY, NPOINTS) Plots a single heatmap over a series of 
%   experiment results for many (p,e) values at an assumed constant (b,c) (or 
%   Axelrod) game setup. (b,c) is taken from SUMMARY(1).{b,c}. Average C is 
%   calculated from the grand average of the last NPOINTS of each replicate, 
%   over all replicates in the dataset.
%
%   PLOT_HEATMAP creates an implied avg. C surface by first trying INTERP2 but 
%   falling back to SCATTEREDINTERPOLANT if the sampling of (p,e) space is not 
%   gridded (nb: grids need not be evenly spaced). Both approaches prepare a 
%   mesh of granularity steps 0.01 from min to max of each of the p and e 
%   values found across all experiments. Finally CONTOURF is used to create a 
%   flat coloured contour representation of the surface.
%
%   PLOT_HEATMAP(..., NEWFIG) By default a new figure is not created 
%   (NEWFIG=0) so that multiple panels can be placed next to each other.
%
%See also INTERP2 SCATTEREDINTERPOLANT CONTOURF

% .. handle options
MESH_STEP = 0.01;
CONTOUR_Z = [0.1 0.3 0.5 0.7];
NEWFIG    = 0;     % current fig(=0), or make new fig(=1)
if nargin > 2
    NEWFIG = varargin{1};
end

% .. get the static values of (b,c) for this plot
b = summary(1).inputs.b;
c = summary(1).inputs.c;

% .. init
n = numel(summary);
zz = zeros(n,1);
p = zz;
e = zz;
m_x = zz;
s_x = zz;

% .. extract data, average last NPOINTS of each trace
for i = 1:n
    p(i,1) = summary(i).inputs.p;
    e(i,1) = summary(i).inputs.e;
    res = summary(i).results;
    X = [res.XT.xt];
    Xsample = X(end-NPOINTS+1:end,:);
    m_x(i,1) = mean(Xsample(1:end));
end

% .. organise data into matrices
ps = unique(p);
es = unique(e);
zz = NaN(numel(ps),numel(es));
R=zz; P=zz; E=zz;
for i = 1:numel(ps)
    for j = 1:numel(es)
        k = find(p==ps(i) & e==es(j));
        try
	        C(i,j) = 1-m_x(k);      % fraction of C = 1-f(D)
	        P(i,j) = ps(i);
	        E(i,j) = es(j);
        end
    end
end

% .. prepare smooth surface by interpolation
pp = [min(ps):MESH_STEP:max(ps)];
ee = [min(es):MESH_STEP:max(es)];
[Ps,Es] = meshgrid(pp,ee);
try     % gridded underlying (p,e)
    Cs = interp2(P', E', C', Ps', Es', 'spline');
catch   % if underlying (p,e) are not gridded, fall back to scattered interpolation
    F = scatteredInterpolant([p e], 1-m_x, 'linear');
    Cs = F(Ps,Es);
end

% .. plot
if NEWFIG, figure(H),clf, end
    set(gcf,'Color','w')
cmap = flipud(bone);       % inverted bone colormap (light=low, dark=high)
try
    [cC,ch] = contourf(Ps', Es', Cs, CONTOUR_Z, 'LineWidth', 2);
    set(gca, 'CLim', [0 1.0]);
    clabel(cC,ch, 'LabelSpacing', inf,  'FontSize', 9);
    colormap(cmap)
end

% .. dress
set(gca,'Xtick', ps, 'Ytick', es, 'Xlim', [0 max(ps)])
set(gca,'FontSize', 12)
shading flat
grid on
% .. labels
if NEWFIG
    xlabel('p (~ Coalitionality)')
    ylabel('e (graph density)')
end
% .. handle Axelrod case, or (b,c)
if isempty(b)
    title(sprintf('Axelrod',b,c))
else
    title(sprintf('b=%.2f, c=%.2f',b,c))
end

