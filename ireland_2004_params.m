function [PARAM, ESTIM_PARAM, MODEL] = ireland_2004_params(MODEL)

%% Calibrate parameters
PARAM.BETA     = 0.99;   % discount factor
PARAM.PSI      = 0.1;    % output gap slope in Phillips curve
%PARAM.ALPHA_PI = 0.0001; % slope parameter in Phillips curve

%% Calibrate covariance matrix of shocks and measurement errors and store into MODEL
MODEL.Sigma_u = eye(MODEL.exo_nbr); % identity matrix as we sacle this in the model equations using model parameters
MODEL.Sigma_e = zeros(MODEL.varobs_nbr,MODEL.varobs_nbr); % no measurement errors

%% Which parameters to estimate?
% Only uncommented parameters are estimated
%                      {INITIAL_VALUE, LOWER_BOUND, UPPER_BOUND}
ESTIM_PARAM.ALPHA_PI = {0.2,0,1}; % slope parameter in Phillips curve
ESTIM_PARAM.ALPHA_X  = {0.07,0,1}; % slope parameter in IS curve
ESTIM_PARAM.RHO_A    = {0.8,0,0.999}; % persistence preference shock
ESTIM_PARAM.RHO_E    = {0.8,0,0.999}; % persistence cost-push shock
ESTIM_PARAM.OMEGA    = {0.05,0.0001,1}; % scale parameter preference innovation in IS curve
ESTIM_PARAM.RHO_PI   = {0.2,0,0.999}; % feedback policy rule inflation
ESTIM_PARAM.RHO_G    = {0.2,0,0.999}; % feedback policy rule output growth
ESTIM_PARAM.RHO_X    = {0.03,0,0.999}; % feedback policy rule output gap
ESTIM_PARAM.SIG_A    = {0.03,0,0.5}; % standard error preference innovation
ESTIM_PARAM.SIG_E    = {0.01,0,0.5}; % standard error cost-push innovation
ESTIM_PARAM.SIG_Z    = {0.01,0,0.5}; % standard error TFP innovation
ESTIM_PARAM.SIG_R    = {0.01,0,0.5}; % standard error monetary policy innovation

