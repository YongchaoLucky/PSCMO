function return_pop=SelectPbestUPF(Auxiliray,Problem,N,p,state)
% Select Pbest

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Yongchao Li (email: liyongchao2001@gmail.com)

     if state==1
        StandardObjs=normalize(Auxiliray.objs,'range',[0,1]);
        d=sqrt(sum(StandardObjs.^2, 2));
        [~,idx]     = sort(d);
     else
        StandardObjs=normalize(Auxiliray.objs,'range',[0,1]);
        d=sqrt(sum(StandardObjs.^2, 2));
        s = mean(1 - pdist2(Auxiliray.decs,Auxiliray.decs, 'cosine'),2);
        d_s = sqrt(d.^2+s.^2);
        [~,idx]     = sort(d_s);
     end

    pop  = Auxiliray(idx(1:Problem.N*p));
    return_pop=pop(randi(Problem.N*p,1,N));
end