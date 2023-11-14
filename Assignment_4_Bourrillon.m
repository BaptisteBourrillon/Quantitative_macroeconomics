              %4 Sign-identified Monetary SVAR Model for US%
% =======================================================================
% =======================================================================

%Q.1 
%the first colum is a demand shock : output, interest rate and prices increase. the second
%column is a supply/cost push shock ouput increase and prices decrease.The
%last column is a contractionary monetary policy shocks that increase 
% interest rates and lower inflation and output.
% =======================================================================

%Q.2
%%handling Data
DS=importdata("C:\Users\User\Desktop\QM\Quantitative-Macroeconomics-midterm_exam_WS2223_v1.0.0\data\MonPol.csv");
DS.textdata;% the ordering is the samme than in WOLF(2022) 
Y=DS.data;
%%Estimation of the reduce form 
ENDO=Y;
nlag=4; %lag order=4
opt.const=1; %estimating a with a constant 
VAR = VARReducedForm(ENDO,nlag,opt);
VAR.SigmaOLS; % OLS estimated residual covariance matrix 
Acomp=VAR.Acomp; %getting the companion form for the IRfs 
P=chol(VAR.SigmaOLS,"lower"); 
%Set up 
H=20;
nsteps=H; 
N=1000;
varnames=["GDP","Inflation CPi","Federals Funds Rate"];
epsnames=["AD","AS","MP"] +" Shocks";
IRFcumsum=[1,0,0];% The GDP will be in Level 
[nobs K]=size(Y);
IRFvals = nan(K,K,H+1,N); %initialising storing vector 
n=1 ; %initialisazing value of n 

while n<N +1 %  the loop stop when n=N
    Q = drawRotationMatrixQ(K);
    B0_inv=P*Q;
     if sign(B0_inv(1,1)) == 1 && sign(B0_inv(1,2)) == 1 && sign(B0_inv(1,3)) == -1 && sign(B0_inv(2,1)) == 1 && sign(B0_inv(2,2)) == -1 && sign(B0_inv(2,3)) == -1 && sign(B0_inv(3,1)) == 1 && sign(B0_inv(3,3)) == 1
          % here i copied pasteand adapted the code of the IRF point
          % function to compute the IRF points 
            nvars = size(B0_inv,1);
           nlag  = size(Acomp,2)/nvars;
           J = [eye(nvars) zeros(nvars,nvars*(nlag-1))];
                    Ah = eye(size(Acomp)); % 
                    JtB0inv = J'*B0_inv;
                    for h=1:(nsteps+1)
                        IRFpoint(:,:,h) = J*Ah*JtB0inv;
                        Ah = Ah*Acomp; 
                    end
                 
                    for ivar = 1:nvars
                        if IRFcumsum(ivar) == true
                            IRFpoint(ivar,:,:) = cumsum(IRFpoint(ivar,:,:),3);
                        end
                    end
IRFvals(:,:,:,n)=IRFpoint; %storing the value at every lopp
         n=n+1; % if the sign restriction is fulfiled n increase 
    end 
end 
%%Ploting using IRFS functions as a reference 
count=1;
steps = 0:1:(nsteps-1); %-1 solve size issues;
figure("name",": Sign-identified IRFs");
 for  ivars=1:K % index for variables
        for ishocks=1:K % index for shocks    
           IRFS = squeeze(IRFvals(ivars,ishocks,1:nsteps,:));
            subplot(K,K,count);
            plot(steps,IRFS,'LineWidth',1);
            title(epsnames(ishocks), 'FontWeight','bold','FontSize',10);
            ylabel(varnames(ivars), 'FontWeight','bold','FontSize',10);
            count = count+1;
        end
 end

