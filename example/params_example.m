% PARAMS_EXAMPLE Example param structure for use with SimRunner.
% >> params_example    % will give 'P' to the workspace
% ------------------------------------------------------- %                                      
P.ini.n = 32;       % integer, num agents in model
P.ini.fB = 0.50;    % fraction of strategy D types at t=0 
% -------------------------------------------------------- %
P.k = 5;    % integer, max coalition size to form
P.b = 3;    % param for Game. (\beta = b/c)    =0 to force Axelrod payoffs
P.c = 4;    % param for Game. (\beta = b/c)    =0 to force Axelrod payoffs
% -------------------------------------------------------- %                                     
P.p = 0.5;   % coalitional update probability
P.e = 0.1;  % Random graph E-R edge prob.
%-------------------------------------------------------- %                                     
P.T = 100;  % updates to run for
P.R = 1;    % replicates (max should be size of nets in coalitional_library_fname file), if R=1 then we store rich information
P.R1_nper_store = 50;   % if R=1, then how many final periods' worth of strategy profiles to store
% -------------------------------------------------------- 
% support for running the Disruption experiment
constant.DisruptionActive = 0;           % switch on disruption phase
constant.DisruptionTrigger.T = 3000;      % period to start disruption
constant.Disruption.p = 0.0;             % value of 'p' during disruption
constant.Disruption.t = 1000;            % num periods to run disruption for
% -------------------------------------------------------- %                                     
P.coalitional_library_fname = 'GraphLib_n32_k5_r50.mat';
% -------------------------------------------------------- %


