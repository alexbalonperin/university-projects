function [ bestAction reward ] = epsGreedy(s,Q)
%EPSGREEDY Summary of this function goes here
%   Detailed explanation goes here
global actionsX actionsY goal;

eps = 1;
reward = -1;
rewardGoal = 10;
xGoal = goal(1);
yGoal = goal(2);
valuesOfNextActions = zeros(1,8);
selection = rand();
if selection > eps
    for action = 1:8  
        valuesOfNextActions(action) = Q(s(1),s(2),action) ; 
    end
    maxValue = max(valuesOfNextActions);
    bestActions = find(maxValue == valuesOfNextActions);
    sizeOfbestActions = size(bestActions);
    if  sizeOfbestActions(2) > 1
        num = ceil(sizeOfbestActions(2)*rand());
        bestAction = bestActions(num);
    else
        bestAction = bestActions(1);
    end
    bestAction = checkPosition(s,bestAction);
    s_prime = [s(1) + actionsX(bestAction) s(2)+actionsY(bestAction)];
    if (s_prime(1) == xGoal && s_prime(2) == yGoal)
            reward = rewardGoal;
    end    
else
    randAction = ceil(8*rand());
    bestAction = checkPosition(s,randAction);
    s_prime = [s(1) + actionsX(bestAction) s(2)+actionsY(bestAction)];
    if (s_prime(1) == xGoal && s_prime(2) == yGoal)
            reward = rewardGoal;
    end 
end

end

