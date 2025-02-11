classdef PSCMO < ALGORITHM
% <multi> <real/binary/permutation> <constrained>

%------------------------------- Reference --------------------------------
% S. Zhao, H. Jia, Y. Li and Q. shi, A Constrained Multiobjective 
% Optimization Algorithm with Population State Discrimination Model, 
% Mathematics, 2024.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Yongchao Li (email: liyongchao2001@gmail.com)

    methods
        function main(Algorithm,Problem)
            %% Generate random population
            Population  = Problem.Initialization();
            Auxiliray  = Problem.Initialization();
            N1=50;
            N2=50;
            t=1;
            state=1;

            %% Optimization
            while Algorithm.NotTerminated(Population)
                
                Offspring1=[];
                Offspring2=[];
                p=0.1; 

                % Offspring generation 
                if N1>0
                    r0          = randperm(Problem.N);
                    [r1,r2]     = gnR1R2R3(Problem.N, r0);                
                    Pop1 = Population(r0(1:N1));
                    Pop2 = SelectPbest(Population,Problem,N1,p);
                    Pop3 = Population(r1(1:N1));
                    Pop4 = Population(r2(1:N1));                
                    Offspring1  = OperatorDE_pbest_1(Problem,Pop1,Pop2,Pop3,Pop4);
                end

                if N2>0
                    if Problem.FE/Problem.maxFE<1/2 
                        r0          = randperm(Problem.N);
                        [r1,r2]     = gnR1R2R3(Problem.N, r0);                
                        Pop1 = Auxiliray(r0(1:N2));
                        Pop2 = SelectPbestUPF(Auxiliray,Problem,N2,p,state);
                        Pop3 = Auxiliray(r1(1:N2));
                        Pop4 = Auxiliray(r2(1:N2));                
                        Offspring2  = OperatorDE_pbest_1(Problem,Pop1,Pop2,Pop3,Pop4);
                    else
                        r0          = randperm(Problem.N);
                        [r1,r2]     = gnR1R2R3(Problem.N, r0);                
                        Pop1 = Auxiliray(r0(1:N2));
                        Pop2 = Auxiliray(r1(1:N2));
                        Pop3 = Auxiliray(r2(1:N2));   
                        Offspring2 = OperatorDE_rand_1(Problem,Pop1,Pop2,Pop3);
                    end
                end

                Offspring=[Offspring1,Offspring2];

                % Environmental selection
                [Population,C_Next]  = Main_task_EnvironmentalSelection([Population,Offspring], Problem.N, true);

                % Auxiliray_task_EnvironmentalSelection
                Auxiliray  = Auxiliray_task_EnvironmentalSelection(Auxiliray,Offspring, Population,Problem, state);


                d(t)=mean(pdist2(Population.objs,Auxiliray.objs),'all');
                if t>=2
                    detad(t-1)=abs(d(t)-d(t-1));
                    M_detad(t-1)=mean(detad);
                end

                state=1;
                if t>=3
                    if M_detad(end)<prctile(M_detad, 25)    %
                        state=2;
                    end
                    if detad(end)<min(detad(1:end-1))
                        state=3;
                    end
                end
               
                [N1,N2] = ResourceAllocation(Problem,C_Next,N1,N2);
                
                t=t+1;
                

            end
            
        end
    end
end

