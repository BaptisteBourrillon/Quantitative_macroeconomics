                    % 1 Theoretical and Simulated Moments% 
% =========================================================================
% =========================================================================
%QUESTION 2;3;4

% =========================================================================

%Q 2;3 : 

%we put the first for loop such that at every loop the residuals change so
% we have R differents  Data set 
R=100;
% number of data set 
% the folowing object will store the mean and the covariance of Y at every
% loop
Me_store=nan(R,2);
Cv_store=nan(2*R,2);
j = 0;
for i=1:R 
    j = j+2;
    %%initialisation of a sequence of DATA
    T=100; % number of observations 
    YY=nan(T,2); % creation of the data vector
    UU=randn(T,2);
    % setting up proper second order moment: 
    UU(:,1)= 0.9*UU(:,1); 
    UU(:,2)= 0.5*UU(:,2);
    % coeffiencent matrix :
     A=[0.2   0.3 
           -0.6    1.1 ];
    YY(1,:)=0.4; %  seting the first obersations
    % generating the data : 
    for t=2:T
        YY(t,:)=A*YY(t-1,:)'+ UU(t,:)';
    end  
    % storing for every sample Mean and Covariance 
    Me_store(i,:)=mean(YY); 
    Cv_store(j:j+1,:)=cov(YY);
   
end 
%computing averages 
mean(Me_store) ;
Cv_store=Cv_store(2:2*R+1,:); %get rid of a remaining nan
mean(Cv_store);
display(mean(Me_store));
%here  we  create the conditions  to have a mean of the differentes covariance
%across the R samples 
prepformean= [0,0 ;0,0];
for n=1:2:(2*R-1) 
prepformean = prepformean+ Cv_store(n:n+1,:);
end 
Mean_of_the_cov=prepformean*(1/(2*R)); % mean of all the covariance across R 
Simga_y_E=(1/T)*(YY)'*YY;
%%%========================================================================
%Q3;comment 
% as there is no intercept in our model, the theoritical mean is  0,
% and the theorical covariance is Simga Y.  thus: 
diff = Simga_y_E-Mean_of_the_cov; % "diff" should be close from Zero
display(mean(Me_store)); % and this value  should be close from Zero 

%%%========================================================================
%Q4 
% when T rise the samples mean tends to 0, hence we convergerd toward the theoretical  mean.  For "diff" there is no clear
% is no clear trend, it might due to the fact that the way we compute
% diff,sigma_y or the mean of the covariance is not appropriate.
%A rise in R doesn't seems to have a specific effect on the mean samples and on their covariance .   