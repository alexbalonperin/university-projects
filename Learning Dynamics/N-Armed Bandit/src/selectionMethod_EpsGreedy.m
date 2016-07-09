function [indice Qa actionCounter rewardSum] = selectionMethod_EpsGreedy(Qa, actionCounter,rewardSum)


eps = 0.2;
a = 0;
b = 1;
random = a + (b-a).*rand(1,1);

if(random < eps)
    [indice Qa actionCounter rewardSum] = selectionMethod_Random(Qa, actionCounter,rewardSum);
else
    [indice Qa actionCounter rewardSum] = selectionMethod_Greedy(Qa, actionCounter,rewardSum);
end