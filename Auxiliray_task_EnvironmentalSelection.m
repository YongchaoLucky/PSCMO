function [return_pop,Next] = Auxiliray_task_EnvironmentalSelection(Auxiliray,Offspring, Population,Problem, state)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    Pop=[Auxiliray,Offspring];
       
    if state==1
        StandardObjs=normalize(Pop.objs,'range',[0,1]);         % Select from auxiliary populations and offspring
        d=sqrt(sum(StandardObjs.^2, 2));                        % Only emphasizing convergence
        Next        = false(1,numel(Pop));
        [~,idx]     = sort(d);
        Next(idx(1:Problem.N))=true;
        return_pop  = Pop(Next);
    % [return_pop,Next] = Main_task_EnvironmentalSelection(Pop,Problem.N,false);
    elseif state==2
        StandardObjs=normalize(Pop.objs,'range',[0,1]);         % Select from auxiliary populations and offspring
        d=sqrt(sum(StandardObjs.^2, 2));                        % Balancing diversity and convergence
        s = mean(1 - pdist2(Pop.objs,Pop.objs, 'cosine'),2);
        V=[d,s];
        % Non-dominated Sorting Selection
        [FrontNo,MaxFNo] = NDSort(V,Problem.N);
        Next = FrontNo < MaxFNo;
        CrowdDis = CrowdingDistance(V,FrontNo);
        Last     = find(FrontNo==MaxFNo);
        [~,Rank] = sort(CrowdDis(Last),'descend');
        Next(Last(Rank(1:Problem.N-sum(Next)))) = true;
        return_pop = Pop(Next);
    else
        d=sum(pdist2(Pop.objs,Population.objs),2);              %Select from the auxiliary population, main population, and offspring
        s = mean(1 - pdist2(Pop.objs,Pop.objs, 'cosine'),2);    %Emphasizing only diversity
        V=[d,s];
        % Non-dominated Sorting Selection
        [FrontNo,MaxFNo] = NDSort(V,Problem.N);
        Next = FrontNo < MaxFNo;
        CrowdDis = CrowdingDistance(V,FrontNo);
        Last     = find(FrontNo==MaxFNo);
        [~,Rank] = sort(CrowdDis(Last),'descend');
        Next(Last(Rank(1:Problem.N-sum(Next)))) = true;
        return_pop = Pop(Next);
    end


end

