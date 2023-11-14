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
    
    
;

varexo
    epsa ${\epsilon}$ (long_name='Epsilon')
;

% Parameters
parameters
    BETA ${\alpha}$ (long_name='Discount factor')
    ALPHA ${\alpha}$ (long_name='capital share')
    DELTA ${\delta}$ (long_name='Controlling depreciations')
    GAMMA ${\gamma}$ (long_name='Consumption utility parameter, labor dissutility parameter')                                                                                         
    RHOA ${\rho}$ (long_name='Persistence parameter')
    OMEGA ${\ommega}$ (long_name='share of non ricardian consumers')
;
% Calibrate parameters
BETA=0.9901;
ALPHA = 0.40;
DELTA = 0.025;
GAMMA = 0.7;
RHOA = 0.9;
OMEGA = 0.7;
% Model equations
model;
    ki = (1 - DELTA)*ki(-1) + Ii; % S by s we entend specif to this model  
    c = OMEGA*ci + (1 - OMEGA)*cj; % S
    l = OMEGA*li + (1 - OMEGA)*lj;% S
    k = OMEGA*ki; %S 
    Iv = OMEGA*Ii;%S 
    log(a)=RHOA*log(a(-1))+epsa; %A 
    y = a*k(-1)^ALPHA*l^(1-ALPHA);% production function 
    y = c + Iv; %market clearing 
    ci= BETA*ci(-1)*(1-DELTA +r); %euler
    cj=w*lj; % FOC
    w=((1-GAMMA)/GAMMA)*(ci/(1-li));% FOC intratemporal optimality
    w=(1-ALPHA)*(k(-1)/l)^ALPHA; %  firms FOC 
    r=ALPHA*(l/k(-1))^(1-ALPHA); % firms FOC 
    w=((1-GAMMA)/GAMMA)*(cj/(1-lj)); %FOC intratemporal optimality
end;
initval;
a = 1;
r = (1/ALPHA)+DELTA-1;
ci=0.7;
cj=0.6;
li=0.2;
lj=0.3;
ki=12;
Ii=0.35;
w=3; %cj/lj 
Ii=0.2;
end;
 steady;
