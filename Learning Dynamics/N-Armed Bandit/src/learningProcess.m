function [res actionCounter rewardVec] = learningProcess(methodSelected, QaTemp)

global nbActions iterations;

%vector of results
 res = zeros(iterations, nbActions);
 Qa = QaTemp;
 tau = 3;
 actionCounter = zeros(1,nbActions);
 
 rewardSum = zeros(1,nbActions);
 rewardVec = zeros(1,iterations);
 rewardSumAll = 0;
 
%learning iterative process 
for j = 1: iterations

    %action selection methods
    switch methodSelected 
        case 1
           [indice Qa actionCounter rewardSum] = selectionMethod_Random(Qa, actionCounter, rewardSum);
        case 2
           [indice Qa actionCounter rewardSum] = selectionMethod_Greedy(Qa, actionCounter, rewardSum);
        case 3
           [indice Qa actionCounter rewardSum] = selectionMethod_EpsGreedy(Qa, actionCounter, rewardSum);

        case 4
           [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa,actionCounter, tau, rewardSum);
    end
    rewardSumAll = rewardSumAll + rewardSum(indice);
    rewardVec(j) = rewardSumAll/j;
    actionCounterTemp = actionCounter(indice);
    actionCounterTemp = actionCounterTemp + 1;
    %add the quality to the right action
    switch indice
        case 1
            res(actionCounterTemp,1) = Qa(1);
        case 2
            res(actionCounterTemp,2) = Qa(2);
        case 3
            res(actionCounterTemp,3) = Qa(3);
        case 4
            res(actionCounterTemp,4) = Qa(4);
        case 5
            res(actionCounterTemp,5) = Qa(5);
        case 6
            res(actionCounterTemp,6) = Qa(6);
    end  
end
