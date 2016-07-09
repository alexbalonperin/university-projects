classdef State3 < handle
    %STATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        s4
        s5
        V
        v
        policy
        pi
    end
    
    methods
        %contructor
        function obj=State3(s4,s5)
            obj.s4 = s4;
            obj.s5 = s5;
            obj.v = 0;
            obj.V = 0;
            obj.policy = 0;
            obj.pi = [1 0];
            
        end
        
         %methods
     
         %VALUE ITERATION
        function obj=calculateValue(obj)
           obj.v = obj.V;
           obj.V = max(Main.R34+ Main.gamma*obj.s4.V, Main.R35+ Main.gamma*obj.s5.V);
        end
        function obj=calculatePolicy(obj)
            tab = [Main.R34+ Main.gamma*obj.s4.V, Main.R35+ Main.gamma*obj.s5.V];
            maximum = max(tab);
            indice = find(maximum==tab);
            obj.policy = indice(1);
        end
       
        %POLICY ITERATION
        function obj=policyEvaluation(obj)
           obj.v = obj.V;
           obj.V = [(Main.R34+ Main.gamma*obj.s4.V),(Main.R35+ Main.gamma*obj.s5.V)]*obj.pi';
        end
        
        function [obj policy_stable]=policyImprovement(obj, policy_stable)
            b = obj.pi;
            obj.pi = zeros(1,2);
            
            t1 = Main.R34+ Main.gamma*obj.s4.V;
            t2 = Main.R35+ Main.gamma*obj.s5.V;
            maximum = max(t1,t2);
            maximum
            if maximum == t1
                obj.pi = [1 0];
            elseif maximum == t2
                obj.pi = [0 1];
            end
            obj.pi
            isSame = (obj.pi ~= b);
            if isSame(1)
                policy_stable = false;
            end
        end
        function pi=get.pi(obj)
            pi = obj.pi;
        end
       
    end
  
end