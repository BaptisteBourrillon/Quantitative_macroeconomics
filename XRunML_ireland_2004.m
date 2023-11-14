%% Maximum Likelihood Estimation of Basic New Keynesian Model
  
clear variables; clear global; close all; clc;
addpath('MLRoutines'); % this folder contains our core routines
addpath('OptimRoutines/CMAES','OptimRoutines/CSMINWEL'); % this folder has two useful optimizers: csminwel and cmaes

%% ------------------------------------------------------------------------
% USER CHOICES
% -------------------------------------------------------------------------
% Options
OPT.modelname = 'ireland_2004';
OPT.datafile = 'ireland_2004_data.mat';
OPT.first_obs = 1;
OPT.nobs = 220;
OPT.optimizer.randomize_initval         = 0; % 1: randomize initial values
OPT.optimizer.bounds.penalize_objective = 1; % 1: checks whether bounds are violated in objective function and penalize it
OPT.optimizer.bounds.use_for_optimizer  = 1; % 1: if optimizer supports bounds, use these
% Optimizer to try to find posterior mode, possible values are "fminsearch", "fminunc", "simulannealbnd", "patternsearch", "csminwel", "cmaes"
% you can also loop over the optimizers, e.g. ["fminsearch", "fminunc", "simulannealbnd", "patternsearch", "csminwel", "cmaes"]
OPT.optimizer.name = ["fminsearch","csminwel","cmaes"] 

OPT.optimizer.optim_options = optimset('display','iter','MaxFunEvals',50000,'MaxIter',10000,'TolFun',1e-9,'TolX',1e-4);

% ------------------------------------------------------------------------
% END USER CHOICES: the rest is specified and derived from the 
% *_preprocessing, *_steady_state and *_params files
% -------------------------------------------------------------------------

RunML;

rmpath('MLRoutines');
rmpath('OptimRoutines/CMAES','OptimRoutines/CSMINWEL');
