function plotResults( bestActions, path,counter )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 for k = 1 : counter-1
     plot(path{k}(1),path{k}(2),'--ro','LineWidth',1);
     hold on;
end

hold off;

end

