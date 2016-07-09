function plotQuiver(Q)

global nbActions goal;

%Move to be in the center of the cells
arrowsX = [+0.5,-0.5,0,0,+0.5,-0.5,+0.5,-0.5];
arrowsY = [0,0,+0.5,-0.5,+0.5,-0.5,-0.5,+0.5];
xmin = 1;
ymin = 1;
xmax = 12;
ymax = 7;
xGoal = goal(1);
yGoal = goal(2);
QValuesAroundCurrentPosition = zeros(1,8);

for i = 1:xmax
    for j = 1:ymax
        if (i ~= xGoal || j ~= yGoal)
            for a = 1:nbActions
                QValuesAroundCurrentPosition(a) = Q(i, j, a);
            end
            bestValueForNextAction = max(QValuesAroundCurrentPosition);
            actions = find(bestValueForNextAction == QValuesAroundCurrentPosition);
            sizeOfActions = size(actions);
            for k = 1:nbActions 
                if sizeOfActions(2) > 1
                    for action = 1 : sizeOfActions(2)
                        quiver(i+0.5,j+0.5,arrowsX(actions(action)),arrowsY(actions(action)), 'AutoScaleFactor',0.5, 'MaxHeadSize',5, 'Color','b');
                        hold on;
                    end
                else 
                     quiver(i+0.5,j+0.5,arrowsX(actions(1)),arrowsY(actions(1)), 'AutoScaleFactor',0.5, 'MaxHeadSize',5, 'Color','b');
                     hold on;
                end       
            end
        end
        
    end
end
axis([xmin 13 ymin 8]);
grid on;
end