classdef Main
    %MAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        theta = 0.1;
        gamma = 0.9;
        %gamma = 1;
        numberOfStates = 5;
         
        R12 = 1;
        R13 = 0;   
        R22 = 1;
        R34 = -2;
        R35 = 2;
        R44 = -2;
        R55 = 2;
        
        P12 = 1;
        P13 = 1;
        P22 = 1; 
        P34 = 1;
        P35 = 1;      
        P44 = 1;    
        P55 = 1;
  
    end
   
    
    methods(Static = true)
        function  main
            clc;
            clear all;
            close all;
            sim = Simulation;
            sim.valueIteration;
            %sim.policyIteration;
            
        end
    end
    
end

