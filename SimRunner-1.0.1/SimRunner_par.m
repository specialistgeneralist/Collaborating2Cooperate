function simrunner_par(RUNF, EXPNAME)

% SIMRUNNER_PAR Run experiments in parallel.
%    SIMRUNNER_PAR(RUNF, EXPNAME) requires that the (strictly named) main file 
%    'main_par.m' is on the path and, like 'test_main.m', accepts a structure 
%    of inputs 'inputs'.  RUNF is the runfile containing the structured array 
%    CONSTANT and vectors of experimental conditions contained in structured 
%    array VARIABLE.  EXPNAME is the output .mat file name to save.
%
%    Saves the same structure as in SIMRUNNER, however, due to the parallel 
%    nature of this version, only saves the outcome once all parallel jobs are 
%    finished.
%
%       Example: run the test runfile in parallel
%          SimRunner_par('test_runfile.txt', 'par_out')
%
%    For more information on setup see the helpfile for SIMRUNNER.
%
%    Notes:
%       - no information on progress is provided in this version.
%       - requires Distributed Computing Toolbox.
%
% See also SIMRUNNER MAKE_EXPS_TABLE SMARTTIME PREDICT_TIME

% Author: SA, 2 Oct 2017 (Monash)

% TODO
%  SA: Progress meter. This is not trivial in parallel.

% .. check license
if license('checkout', 'distrib_computing_toolbox') == 0
    error('Did not find distributed computing toolbox installed.')
end

% .. Ingest constants and variables
T = make_exps_table(RUNF);

% .. Setup
n_ex = height(T);
runtime = [];

% .. Run (parallel)
parfor ex = 1:n_ex
    rng(1)              % for reproducibility
    % .. get inputs for this run
    inputs = table2struct(T(ex,:));
    % .. save inputs, evaluate model
    summary(ex).inputs  = inputs;
    summary(ex).start   = datestr(now);
    summary(ex).results = main_par(inputs);
    summary(ex).stop    = datestr(now);
end
% .. finish up, save
save([EXPNAME],'summary');
