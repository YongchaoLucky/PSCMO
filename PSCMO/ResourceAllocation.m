function [N1,N2]=ResourceAllocation(Problem,C_Next,N1,N2)
% Resource Allocation

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Yongchao Li (email: liyongchao2001@gmail.com)


    N=Problem.N;

    C_ConditionalP1 = sum(C_Next(N+1:N+N1))/N1;
    U_ConditionalP1 = sum(C_Next(N+N1:end))/N2;

    N1=N*(1-C_ConditionalP1); 
    N2=N*(1-U_ConditionalP1);

    N1=max(1,round(N1));
    N2=max(1,round(N2));

end