var 
    y   ${Y}$ (long_name='Selling output') 
    c   ${C}$ (long_name='Consumption')
    ci  ${Ci}$ (long_name='Consumption of agent i')
    cj  ${Cj}$ (long_name='Consumption of agent j ')
    k   ${K}$ (long_name='Capital')
    ki  ${Ki}$ (long_name='i agent Capital')
    l   ${L}$ (long_name='Labor')
    li  ${Li}$ (long_name='labor of i agent')
    lj  ${Lj}$ (long_name='labor of j agent')
    a   ${A}$ (long_name='Productivity')
    r   ${R}$ (long_name='Interest rate')
    w   ${W}$ (long_name='Real Wage')
    Ii  ${Ii}$ (long_name='Investment of agent i')
    Iv  ${Iv}$ (long_name='Total investment')
    p   ${P}$ (long_name='Total profit ') %this models include profit 
    pi 
;

varexo
    epsa ${\epsilon}$ (long_name='Epsilon')
;

% Parameters , 
parameters
    BETA ${\beta}$ (long_name='discount factor')
    ALPHA ${\alpha}$ (long_name='capital share')
    DELTA ${\delta}$ (long_name='Controlling depreciations')
    GAMMA ${\gamma}$ (long_name='Consumption utility parameter, labor dissutility parameter')                                                                                         
    RHOA ${\rho}$ (long_name='Persistence parameter')
    OMEGA ${\ommega}$ (long_name='share of non ricardian consumers')
   
;
% Calibrate parameters
BETA=0.9901; % 1/(r+1-DELTA) with r at ss 
ALPHA = 0.40;
DELTA = 0.025;
GAMMA = 0.7;
RHOA = 0.9;
OMEGA = 0.7;
% Model equations
model;
    ki = (1 - DELTA)*ki(-1) + Ii;%S by s we entend specif to this model
    c = OMEGA*ci + (1 - OMEGA)*cj;% S
    l = OMEGA*li + (1 - OMEGA)*lj;%S
    k = OMEGA*ki;%S
    Iv = OMEGA*Ii;%s
    log(a)=RHOA*log(a(-1))+epsa; % technology 
    p = y - w*l - r*k(-1);% profit 
    y = a*k(-1)^ALPHA*l^(1-ALPHA);% production fonction 
    y = c + Iv;% market clearing 
    ci= BETA*ci(-1)*(1-DELTA +r) ;% euleur equation 
    cj=w*lj;%consumer foc 
    w=((1-GAMMA)/GAMMA)*(ci/(1-li))*((GAMMA)/(1-GAMMA)*((1-lj)/cj));% intratemporal optimality 
    w=(1-ALPHA)*(k(-1)/l)^ALPHA;% firms FOC
    r=ALPHA*(l/k(-1))^(1-ALPHA); %firms FOC
    %w=((1-GAMMA)/GAMMA)*(cj/(1-lj)); % we use the the equality with W to plug this in the 52
    p=OMEGA*pi;
    ci=w*li + r*ki(-1) + pi;
    end; %  prepocessing work we have as many equations as endogenous variable 
 initval; %in this blocks we use somme of the steady state condition we were able to derive but as we weren't able to solve annalitical the model we have to use initval and to comme with possible value 
 a = 1;
 r = (1/BETA)+DELTA-1;
ci=0.7;
li=0.2;
lj=0.3;
ki=12;
ci=0.6;
w=cj/lj; 
ki=9;
Ii=0.35;
y=1.3; 
pi=2; 
end;
  steady;


  commodity_unit= oo_.steady_state(M_.endo_names=="y") % structure to get steady state 