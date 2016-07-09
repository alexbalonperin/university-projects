classdef State1 < handle
    %STATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        V
        v
        s2
        s3
        policy
        pi
    end

    methods
        %contructor
        function obj=State1(s2,s3)
            
            obj.s2 = s2;
            obj.s3 = s3;
            obj.v = 0;
            obj.V = 0;
            
            %Value iteration
            obj.policy = 0;
            %Policy iteration
            obj.pi = [0 0];

        end
        
        %methods
        
        %VALUE ITERATION
        function obj=calculateValue(obj)
            obj.v = obj.V;
            obj.V = max((Main.R12+ Main.gamma*obj.s2.V),(Main.R13+ Main.gamma*obj.s3.V)) ; 
            
        end
        
        function obj=calculatePolicy(obj)
            tab = [Main.R12+ Main.gamma*obj.s2.V, Main.R13+ Main.gamma*obj.s3.V];
            maximum = max(tab);
            indice = find(maximum==tab);
            obj.policy = indice(1);
        end
        
        %POLICY ITERATION
        function obj=policyEvaluation(obj)
           obj.v = obj.V;

           obj.V = [(Main.R12+ Main.gamma*obj.s2.V),(Main.R13+ Main.gamma*obj.s3.V)]*obj.pi';
        end
        
        function [obj policy_stable]=policyImprovement(obj, policy_stable)
            b = obj.pi;
            obj.pi = zeros(1,2);
            
            t1 = Main.R12+ Main.gamma*obj.s2.V;
            t2 = Main.R13+ Main.gamma*obj.s3.V;
            maximum = max(t1,t2);
          
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
        
        %accessors
        function obj=set.v(obj, newv)
            obj.v = newv;
        end
        function v=get.v(obj)
            v = obj.v;
        end
        function obj=set.V(obj, newV)
            obj.V = newV;
        end
        function V=get.V(obj)
            V = obj.V;
        end 
        function pi=get.pi(obj)
            pi = obj.pi;
        end
    end
    
end

