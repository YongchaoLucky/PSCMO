function return_pop=SelectPbest(Population,Problem,N,p)
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


    Standard=normalize([Population.objs,Population.cons] ,'range',[0,1]);
    d=sqrt(sum(Standard.^2, 2));

    StandardObjs=normalize(Population.objs,'range',[0,1]);
    s = mean(1 - pdist2(StandardObjs,StandardObjs, 'cosine'),2);

    V=[d,s];

    % Non-dominated Sorting Selection
    [FrontNo,MaxFNo] = NDSort(V,Problem.N*p);
    Next = FrontNo < MaxFNo;
    CrowdDis = CrowdingDistance(V,FrontNo);
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:Problem.N*p-sum(Next)))) = true;
    pop = Population(Next);
    
    return_pop=pop(randi(Problem.N*p,1,N));
    
end

