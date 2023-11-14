function f = ISLMSR_f(B0_diageps,SIGMAUHAT,LRMat)
    nvars = size(SIGMAUHAT,1);
    B0 = B0_diageps(:,1:nvars); % get B0 
    diageps = diag(B0_diageps(1:nvars,nvars+1));% get  SIG_eps
    B0inv = inv(B0); % get inverse 
    THETA = LRMat*B0inv; %long run 
    f=[vech(B0inv*diageps*B0inv'-SIGMAUHAT);
        THETA(1,2)-0;
        THETA(1,3)-0;
        THETA(1,4)-0;
        B0inv(1,2)-0;
        B0inv(1,3)-0;  
        B0(2,3)-0;
        B0(1,1)-1;
        B0(2,2)-1;
        B0(3,3)-1;
        B0(4,4)-1
        ];


  
  
    