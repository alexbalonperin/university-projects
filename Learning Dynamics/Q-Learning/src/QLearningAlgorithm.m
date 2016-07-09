function [Q rewardTot nbSteps] = QLearningAlgorithm(s,Q)

global nbActions gamma alpha goal actionsX actionsY;

rewardTot = 0;
nbSteps = 0;

while s(1) ~= goal(1) || s(2) ~= goal(2) 
    
    [bestAction reward] = epsGreedy(s, Q);
    
    
    %Add wind to the map
    s_prime = wind(s);
    s_prime = [s_prime(1)+actionsX(bestAction) s_prime(2)+actionsY(bestAction)];
  
    s_prime = checkPositionAfterWind(s_prime);
    QValuesAroundCurrentPosition = zeros(1,8);
    for a = 1:nbActions
        QValuesAroundCurrentPosition(a) = Q(s_prime(1), s_prime(2), a);
    end
    bestValueForNextAction = max(QValuesAroundCurrentPosition);
    Q(s(1),s(2),bestAction) = Q(s(1),s(2),bestAction) + alpha*(reward + gamma*bestValueForNextAction - Q(s(1),s(2),bestAction));
   
    s = s_prime;
    rewardTot = rewardTot + reward;
    nbSteps = nbSteps + 1;
end

end