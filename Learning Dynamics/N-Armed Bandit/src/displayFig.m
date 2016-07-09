function displayFig(Qa_current,indice, color, iteration)

figure 1;
M=[1:6;21:30]
switch indice
    case 1
        
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 1');
    case 2
        figure 2;
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 2');
    case 3
        figure 3;
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 3');
    case 4
        figure 4;
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 4');
    case 5
        figure 5;
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 5');
    case 6
        figure 6;
        hold on;
        plot(iteration, Qa_current, color,'Marker', '.', 'MarkerSize', 5);
        title('Action 6');
    
end
if indice == 1000
    xlabel('iteration');
    ylabel('Qa');
end
    

% Annotate the point (-pi/4, sin(-pi/4))
%text(0,70,'\leftarrow convergence point',...
%     'VerticalAlignment','top')

