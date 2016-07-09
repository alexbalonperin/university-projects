function oneRunGreedy(s, Q)

global goal actionsX actionsY;

path = {};
selectedActions = {};
counter = 1;
arrowsX = [+0.5,-0.5,0,0,+0.5,-0.5,+0.5,-0.5];
arrowsY = [0,0,+0.5,-0.5,+0.5,-0.5,-0.5,+0.5];

while s(1) ~= goal(1) || s(2) ~= goal(2) 
    path{counter} = s;
    bestAction = greedy(s, Q);
    s_prime = [s(1)+actionsX(bestAction) s(2)+actionsY(bestAction)];
    s = s_prime; 
    selectedActions{counter} = bestAction;
    counter = counter + 1
end

disp('Greedy Finished')
 path{counter} = s; 
 selectedActions{counter} = bestAction;


pathWayX = zeros(1,counter);
pathWayY = zeros(1,counter);
actions = zeros(1,counter);

for k = 1 : counter
    pathWayX(k) = path{k}(1);
    pathWayY(k) = path{k}(2);
    
end


%quiver(pathWayX+0.5,pathWayY+0.5,arrowsX(actions),arrowsY(actions), 'AutoScaleFactor',0.5, 'MaxHeadSize',5, 'Color','r');

plot(pathWayX+0.5,pathWayY+0.5,'-go','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',5);
hold on;            
for k = 1 : counter-1
    actions(k) = selectedActions{k}(1);
    quiver(pathWayX(k)+0.5,pathWayY(k)+0.5,arrowsX(actions(k)),arrowsY(actions(k)), 'AutoScaleFactor',0.5, 'MaxHeadSize',15, 'Color','r');
    hold on;
end
title('Grid of the Windy gridworld', 'FontSize',16);
hold off;