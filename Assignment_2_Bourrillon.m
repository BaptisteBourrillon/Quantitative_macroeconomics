               %2 Properties Of Lag-Order Selection Criteria%
% =======================================================================
% =======================================================================
Store_matrix_AIC= nan(100,5); % this matrices will store the lag selected for every r
Store_matrix_SIC=nan(100,5);
for r=1:100  % seting then number of  M.C repetions to one hundred 
    %initialisation of a sequence of DATA%
    T=10100; % number of observations 
    YY=nan(T,2); % creation of the data vector
    U=randn(T,2);
    Sima_u= [0.9 0.2;0.2 0.5];
    UU= U*Sima_u;
    %coefficient matrices :
    A1=[2.4 1.0 ; 0 1.1];
    A2=[-2.15 -0.9; 0 -0.41];
    A3=[0.852 0.2 ;0 0.06];
    A4 =[-0.126 0; 0 0.0003];
    YY(1:4,:)=0.3;% setting first observations 
    %generating data:
         for t=5:T
            YY(t,:)= A1*YY(t-1,:)'+A2*YY(t-2,:)' + A3*YY(t-3,:)' +A4*YY(t-4,:)' +UU(t,:)';
         end  
    YY=YY(100:10100,:); %getting rid of the first 100 observations 

     %%Computation of the Value of the criteria 

    %creation of different sample size 
     YY1=YY(9920:10000,:);
     YY2=YY(9840:10000,:);
     YY3=YY(9760:10000,:);
     YY4=YY(9500:10000,:);
     YY5=YY(100:10000,:);
     for e=1:5 
           if e==1  
                     YY=YY1;
           elseif e==2 
                     YY=YY2;
           elseif e==3
                     YY=YY3;
           elseif e==4 
                     YY=YY4; 
           else 
                     YY=YY5; 
           end 
                        pmax=6;
                        K=2;   
                        T =size(YY(:,1));
                        T=T(1,1);
                        T_eff = T-pmax;
                        INFO_CRIT = nan(pmax,2);
                        Y=transpose(YY((pmax+1):T,:));
                        Zmax = transpose(lagmatrix(YY,1:pmax));
                        Zmax = Zmax(:,pmax+1:T);
                        Zmax = [ones(1,T_eff); Zmax];
                        
                        for m=1:pmax
                            n = 1+K*m;                
                            Z = Zmax(1:n,:);                 
	                        Ahat = (Y*Z')/(Z*Z');            % OLS and ML estimator
                            uhat = Y-Ahat*Z;                 % Residuals
                            log_det_SIGMLm = log(det((uhat*uhat')./T_eff)); % ML estimate of variance of errors
                            phi_m = (m*K^2+K);
                            INFO_CRIT(m,1) = log_det_SIGMLm + 2/T_eff * phi_m;             % Akaike
                            INFO_CRIT(m,2) = log_det_SIGMLm + log(T)/T_eff * phi_m;        % Schwartz
                        end
    
                            result= [transpose(1:pmax) INFO_CRIT];
                            nlag_AIC = find(result(:,2)==(min(result(:,2))));
                            nlag_SIC = find(result(:,3)==(min(result(:,3))));
                           
                     %storing the result for every sample size at every M.C repetitions          
                  Store_matrix_AIC(r,e)=nlag_AIC; 
                  Store_matrix_SIC(r,e)=nlag_SIC;               
     end
     

end 
% =========================================================================
% =========================================================================
% Discussion on the results we obtainned  %
% 1) 
 display(sum(Store_matrix_AIC==4));
display(sum(Store_matrix_SIC==4));
display(sum(Store_matrix_SIC==4)-sum(Store_matrix_AIC==4));
%the sum is negative of the first 4 sample size meaning that AIC is more
%consistence on small sample size than SIC , but for biggest sample size SIC is
%more consitent 
%2)
display(sum(Store_matrix_AIC<4));
%As the sample size increase the  number of underestimation of the lag
%order decrease, for   the biggest the number of underestimation of the
%true lag order is 0 :Asymptotically, AIC never  selects a lag order that is lower than the true lag order.


%3) 
display(sum(Store_matrix_AIC<Store_matrix_SIC));  
% The lag order estimate by AIC is often greater than the one estimate by
% SIC this occurs  mostly on finite sample. 

%4) 
display((Store_matrix_SIC<4));
display(sum(((Store_matrix_SIC<4))));
display(sum(Store_matrix_AIC>4));
% Underestimating, the true lag order of a model result in the creation of
% biased when estimating it. Therefore overestimating the true lag order
% should be prefered to underestimating it. The results obtained show that AIC
% sometimes overestimated the true lag order -on finit and on large sample size-.  This result is supported by
% by KOEHLER and MURPHREE (1987)-but their paper use ARMA model-. SIC has a
% very strong tendency to underestimate the true lag order, on  finite
% sample size.But SIC is also way more  accurate than AIC on
% large sample size. It follows that we should use AIC on finit sample
% size to estimate the lag order of model. On the contrary, we should
% prefer the use of SIC on large sample size. 

