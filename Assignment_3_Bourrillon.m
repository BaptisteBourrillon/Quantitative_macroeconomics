
%3 How Well Does the IS-LM Model Fit Postwar US Data?%

%==========================================================================
%==========================================================================
%%Q2,Q3,Q4 
%% REDUCE FORM ESTIMATION

DS=importdata("C:\Users\User\Desktop\QM\Quantitative-Macroeconomics-midterm_exam_WS2223_v1.0.0\data\gali1992.csv");%importing Data
Y=DS.data;
ENDO=Y;
opt.const=1; %estimating with a constant 
nlag=4;
% reduced form estimation 
VAR = VARReducedForm(ENDO,nlag,opt);

%% STRUCTURAL ESTIMATION 
% We check how the data are ordered, this will be important when doing the
% restrictions and ploting the IRF
DS.textdata; % the order is the same than in the pdf 
[obs_nbr,var_nbr] = size(ENDO);
% to get the Theta matrix : 
A1inv_big = inv(eye(size(VAR.Acomp,1))-VAR.Acomp); 
LRMat = A1inv_big(1:var_nbr,1:var_nbr); 
 
B0_diageps= [chol(VAR.SigmaOLS) ones(var_nbr,1)];% Use Cholesky decomposition as an imput value 
f = str2func('ISLMSR_f');%get our fonction of restrictions 
f(B0_diageps,VAR.SigmaOLS,LRMat )%looking for error

%% Options for fsolve
 TolX = 1e-4; % termination tolerance on the current point
 TolFun = 1e-9; % termination tolerance on the function value
 MaxFunEvals = 50000; % maximum number of function evaluations allowed
 MaxIter = 1000
 ; % maximum number of iterations allowed
 % algorithm used in fsolve is trust−region−dogleg;
 options= optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter,'Algorithm',"trust-region-dogleg");
%runing the numerical optimisation : 
[B0_diageps,fval,exitflag,output] = fsolve(f,B0_diageps,options,VAR.SigmaOLS,LRMat);

B0_opt = B0_diageps(:,1:var_nbr); %get B0
B0inv_opt=inv(B0_opt); %get inverse 
%making positive all diagonal elements, thanks to normalisation rule on B0.. 
if any(diag(B0inv_opt)<0)
 x = diag(B0inv_opt)<0;
 B0inv_opt(:,find(x==1)) = -1*B0inv_opt(:,find(x==1));
end

 SIGeps = B0_diageps(:,var_nbr+1); % geting the variances 
 impact = B0inv_opt*diag(sqrt(SIGeps)); 

impact*impact'-VAR.SigmaOLS; % this value should be close from the null matrix 
 %% PLOTING THE STRUCTURAL IMPULSES RESPONSE FONCTIONS 
%seting options and names
 varnames=["GDP level", " Nominal Yield ","Growth in M1", "Inflation Rate"] ;
 epsnames=[" Agregate  supply ", "Money Supply","Money Demand","Aggregate demand"] + " Shocks";
IRFcumsum=[1,0,0,0]; %The GDP is asked in level,and in the DATA is in differenced therefore we apply cumsum on delta_gnp. The others Data there already in the good type.
 nsteps=30;
 Acomp=VAR.Acomp;
 %ploting  IRFs
IRFpoint  = IRFs(Acomp,impact,nsteps,IRFcumsum,varnames,epsnames);
