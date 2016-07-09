classdef Simulation
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties
        delta
        tabV
        tabPi
        nbOfValues
        iterations
        s1
        s2
        s3
        s4
        s5
        states
        policy_stable
        tabPiCurrent
    end
    
    
    methods
        function obj=Simulation
            obj.delta = 1;
            obj.nbOfValues = 2;
            obj.iterations = 100;
            obj.tabV = zeros(500,Main.numberOfStates);
            obj.tabPi = {};
            obj.tabPiCurrent = zeros(1,Main.numberOfStates);
            obj.s4 = State4();
            obj.s5 = State5();
            obj.s2 = State2();
            obj.s3 = State3(obj.s4,obj.s5);
            obj.s1 = State1(obj.s2,obj.s3);
            obj.policy_stable = false;
            obj.states = {obj.s1 obj.s2 obj.s3 obj.s4 obj.s5};
        end
            
        function valueIteration(obj)

            i = 1;
            delta = 1;
            while i < obj.iterations
                 while obj.delta > Main.theta
                    obj.delta = 0;
                    for j = 1 : Main.numberOfStates
                        
                        obj.states{j} = obj.states{j}.calculateValue;
                        s_current = obj.states{j};
                        obj.tabV(obj.nbOfValues,j) = s_current.V;
                        obj.delta = max(obj.delta,abs(s_current.v - s_current.V));
                         
                    end
                    obj.nbOfValues = obj.nbOfValues + 1;
                    
                 end
                for j = 1 : Main.numberOfStates
                    obj.states{j} = obj.states{j}.calculatePolicy;
                    s_current = obj.states{j};

                    obj.tabPiCurrent(j) = s_current.policy;
                    
                end
                obj.tabPi{i} = obj.tabPiCurrent;
               i = i + 1 ;
            end
            display = Display(obj.tabV,obj.tabPi,obj.iterations,obj.nbOfValues);
            display.results;
            
        end
        
        
        function policyIteration(obj)
            i = 1;
           
            while (i < obj.iterations)
                obj.delta = 1;
                 while obj.delta >= Main.theta
                    obj.delta = 0;
                    for j = 1 : Main.numberOfStates
                        obj.states{j} = obj.states{j}.policyEvaluation;
                        s_current = obj.states{j};
                        if s_current.pi(1) == 0 
                            obj.tabPiCurrent(j) = 2;
                        elseif s_current.pi(1) == 1 
                            obj.tabPiCurrent(j) = 1;
                        end
                        obj.tabV(obj.nbOfValues,j) = s_current.V;
                        obj.delta = max(obj.delta,abs(s_current.v - s_current.V));
                         
                    end
                    obj.tabPi{obj.nbOfValues-1} = obj.tabPiCurrent;
                    obj.nbOfValues = obj.nbOfValues + 1;
                    
                    
                end
                obj.policy_stable = true;
                obj.tabPiCurrent = zeros(1,Main.numberOfStates);
                for j = 1 : Main.numberOfStates
                    [obj.states{j} obj.policy_stable] = obj.states{j}.policyImprovement(obj.policy_stable);
                    if s_current.pi(1) == 0 && s_current.pi(2) == 1
                        obj.tabPiCurrent(j) = 2;
                    elseif s_current.pi(1) == 1 && s_current.pi(2) == 0
                        obj.tabPiCurrent(j) = 1;
                    end
                end
                obj.tabPi{obj.nbOfValues-1} = obj.tabPiCurrent;
                i = i + 1 ;
                if obj.policy_stable
                    break;
                end
                
                
               
            end
            display = Display(obj.tabV,obj.tabPi,obj.iterations,obj.nbOfValues);
            display.results;
        end
        
    end

end

