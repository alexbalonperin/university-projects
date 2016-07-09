function bestAction = greedy(s,Q)

valuesOfNextActions = zeros(1,8);

for action = 1:8  
    valuesOfNextActions(action) = Q(s(1),s(2),action);  
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
%check if the agent is still in the table
bestAction = checkPosition(s,bestAction);

end
