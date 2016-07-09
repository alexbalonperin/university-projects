classdef Display
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties
        tabV
        tabPi
        nbOfValues
        iterations
    end
    
    
    methods
        function obj=Display(tabV,tabPi,iterations,nbOfValues)
         
            obj.nbOfValues = nbOfValues;
            obj.iterations = iterations;
            obj.tabV = tabV;
            obj.tabPi = tabPi;
        end
        function obj=results(obj) 
            value(obj);
            policy(obj);
            policyHisto(obj); 
        end
    end
    
    methods(Access = private)
        function value(obj)
             figure(1)
             hold on;
             
             for j = 1 : Main.numberOfStates
                
                switch j
                    case 1
                        color = 'green';
                    case 2
                        color = 'red';
                    case 3 
                        color = 'cyan';
                    case 4
                        color = 'black';
                    case 5
                        color = 'blue';
                end
                plot(0:(obj.nbOfValues-2),obj.tabV(1:(obj.nbOfValues-1),j), color, 'Marker', '.','MarkerSize', 2);
                l = legend('State1','State2','State3','State4','State5',5,'Location', 'East');
                %axis([0,obj.nbOfValues+10,-20,20]);
                set(l, 'Interpreter','none');
                xlabel('iterations');
                ylabel('V');
                str = {'\fontsize{16}\fontname{candara}Value Iteration Algorithm:'; '\fontsize{12}function state value V over time'};
               
                title(str);
                hold on;
                
           
             end
            
        end
        
        function policy(obj)
            figure(2)
                hold on;
             sizePi = size(obj.tabPi);
             for j = 1 : Main.numberOfStates
                
                switch j
                    case 1
                        color = 'green';
                        marker = '+';
                    case 2
                        color = 'red';
                        marker = '*';
                    case 3 
                        color = 'cyan';
                        marker = 'o';
                    case 4
                        color = 'black';
                        marker = '.';
                    case 5
                        color = 'blue';
                        marker = 'd';
                end

                for i = 1:sizePi(2)-1
                    h = plot(i-1,(obj.tabPi{i}(j)));
                    set(h, 'Marker',marker,'MarkerSize',5);
                    set(h,'Color', color);
                    hold on;
                      
                end
               
                
                
                
                l = legend('State1','State2','State3','State4','State5',5, 'Location', 'East');
                 pause;
                set(l, 'Interpreter','none');
                axis([0,obj.nbOfValues+10,-3,3]);
              
                xlabel('iterations');
                ylabel('\pi');
                str = {'\fontsize{16}\fontname{candara}Value Iteration Algorithm:'; '\fontsize{12}state policy over time'};

                title(str);
                
               
             end 
        end
        
        function policyHisto(obj)
            figure(3)
                hold on;
            
                sizePi = size(obj.tabPi);
                    obj.tabPi{sizePi(2)-1}
             for j = 1 : Main.numberOfStates
                
                bar(j,obj.tabPi{sizePi(2)-1}(j));
                xlabel('iterations');
                ylabel('\pi');
                str = {'\fontsize{16}\fontname{candara}Value Iteration Algorithm:'; '\fontsize{12}state policy over time'};
                set(gca,'XTick',1:5)
                set(gca,'XTickLabel',{'State1','State2','State3','State4','State5'})
               
                title(str);
                hold on;
               
             end 
        end
    end
end

