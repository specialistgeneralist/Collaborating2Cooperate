Collaboration leads to cooperation on sparse networks (Angus & Newton, 2018)
===========================================================================

*Codebase to run (in MATLAB) the numerical experiments reported in the paper, or replicate the main figures from the paper, or explore their data.*

## Getting started

### Requirements

For full functionality you will need:

* A recent version of MATLAB (tested with v2017b);
* Toolboxes: **parallel toolbox**, **statistics toolbox**; and
* The **SimRunner** package [1], version 1.0.1 included in this package.

If you do not have the **parallel toolbox**, replace `parfor` with `for` in the `main_exp.m` file. If you do not have the **statistics_toolbox** then the SimRunner [1] package will fall back to using average of previous runs for the prediction of total run time end, as opposed to performing an ensemble random forest model estimation.

**Ref**
[1] Simon D Angus. (2017, October 26). specialistgeneralist/SimRunner. Zenodo. http://doi.org/10.5281/zenodo.1037612

### Usage

See the help documentation of `main_exp` provided below for *Examples* and *Figure replication* instructions.

If you wish to produce a simple time-series plot of a given set of conditions, **copy** and **adapt** the file `example/params_example.m` and then (from the main directory) run with:
```
setup; cd example
params_example_copy     % gives param-structure P to the workspace
res = main_exp(P);
```
Explore the time-series of the run created with e.g.,
```
plot(res.XT.xt), set(gca,'Ylim', [0 1])
```
Inspect the Graph that was used in this run (open the output file with e.g. Graphviz (http://graphviz.org),
```
adj2dot(res.more_res.G)     % --> produces 'net.dot'
```

## Recreating the figures from the paper

See the instructions given in the help documentation of `main_exp` below.

### Contours figure 

![Contours fig]( https://github.com/specialistgeneralist/Collaborating2Cooperate/blob/master/figs/contours.png )

### Networks figure (at benchmark conditions)

![Networks fig]( https://github.com/specialistgeneralist/Collaborating2Cooperate/blob/master/figs/networks.png )


### Timeseries figure (at benchmark conditions)
![Timeseries fig]( https://github.com/specialistgeneralist/Collaborating2Cooperate/blob/master/figs/timeseries.png )


## Main help file and instructions

Recreate in Matlab with `help main_exp`.

```
%MAIN_EXP Run coalitional PD experiments, Angus & Newton (2018).
%   RES = MAIN_EXP(P) conducts a single experimental condition of the 
%   Coalitional PD model, with input parameter structure P and producing 
%   output structure RES.
%
%   if P.R = 1 (single replicate):
%      RES has following structure,
%         res.XT           .. the pop-fraction of D-players t \in 1..T
%         res.more_res.G   .. the Graph (adjacency matrix), G
%         res.more_res.fX  .. the strategy profile for players 1..n for each 
%         of the final R1_nper_store periods.
%   elseif P.R > 1 (multiple replicates):
%      RES has a more simple structure,
%         res.XT   .. as above, but per replicate.
%
%   Examples (start from main directory):
%
%      % ** Set up a parallel session **
%      parpool              % start parallel pool with default cluster
%
%      % Run a single set of parameters,
%      setup; cd example    % ensure everything on path, go to example dir
%      params_example       % provides 'P'
%      res = main_exp(P);
%
%      % Run a multiple parameter study, single replicate, rich output,
%      % produce average cooperation network .dot files
%      setup; cd example    % ensure everything on path, go to example dir
%      SimRunner('main_exp', 'runfile_example_R1.txt', 'test_R1');
%      load test_R1.mat
%      fig_networks(summary, 50)    % avg C colouring from last 50 updates
%               .. produces net_ex[1-9].dot in pwd, use Graphviz to explore
%      fig_timeseries(summary)      % avg C timeseries by exp.
%
%      % Run a multiple parameter study, many replicates, simple output,
%      setup; cd example    % ensure everything on path, go to example dir
%      SimRunner('main_exp', 'runfile_example_R2.txt', 'test_R2');
%      load test_R2.mat
%      fig_timeseries(summary)      % avg C timeseries by exp.
%
%   Figure replication:
%
%      % Contour plot panel
%      setup; cd replication
%      fig_contours
%      % .. explore timeseries of benchmark study
%      load exp010a_baseline
%      fig_timeseries(summary)
%
%      % Networks panel (open .dot files with e.g. Graphviz)
%      setup; cd replication
%      load exp017_p0p5_long
%      fig_networks(summary, 500)   % --> produces net_ex{1,2,3}.dot
%
%      % Timeseries figure
%      setup; cd replication
%      load exp016_e1p0_long
%      fig_timeseries(summary)
%
%   Functions
%   ---------
%   To create a coalitional library:
%    MakeNetLib     Build a coalition library for fast run-time simulation.
%    MakeGraph      Make a graph from a menu of types.
%    GetAllCoalitions_k     Find all possible coalitions, given G and K.
%
%   Conducting experiments:
%    choose_one     A fast version of RANDSAMPLE, returning only 1 item.
%    game_table     Provides a game table, PI.
%    GetKpdf        Obtain a discrete binomial probability distribution.
%    InitStrats     Initialise strategies with given fraction of C.
%    LogUpdates     Provide detailed 'story' information to a log-file.
%    UpdatePayoffs  Calculate total payoffs to each agent in the game.
%    ApplyBetterResponse        Return a vector of better-response strategies.
%    ChooseCoalition_Binomial   Choose a coalition from the library.
%
%   Visualisation:
%    fig_contours   Make all panels of avg C contour plot in (p,e) space.
%    fig_networks   Write a .dot graph file for networks, nodes shaded by %C.
%    fig_timeseries Plot coloured frac C time-series line plot.
%
%See also GAME_TABLE GETKPDF RANDSTREAM
```
