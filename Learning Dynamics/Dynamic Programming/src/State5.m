classdef State5 < handle
    %STATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        V
        v
        policy
        pi
        piInit
    end
    
    methods
        %contructor
        function obj=State5
            
            obj.v = 0;
            obj.V = 0;
            obj.policy = 0;
            obj.pi = [1 0];
            obj.piInit = obj.pi;
        end
        
         %methods
         %VALUE ITERATION
        function obj=calculateValue(obj)
           obj.v = obj.V;
           obj.V = (Main.R55+ Main.gamma*obj.V);
        end
        function obj=calculatePolicy(obj)
            obj.policy = 1;
        end
        
         %POLICY ITERATION
        function obj=policyEvaluation(obj)
           obj.v = obj.V;
           obj.V = (Main.R55+ Main.gamma*obj.V);
        end
        
        function [obj policy_stable]=policyImprovement(obj, policy_stable)
            b = obj.pi;
            obj.pi = zeros(1,2);
            obj.pi = obj.piInit;
          
            if (obj.pi ~= b)
                policy_stable = false;
            end
        end
        
    end
    
end

