function [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa, actionCounter, tau, rewardSum)

global nbActions Qa_star;

sumQa = 0;
proba = zeros(1,6);
for i = 1:nbActions
    sumQa = sumQa + exp(Qa(i)/tau);
end

for i = 1:nbActions
    proba(i) = exp(Qa(i)/tau)/sumQa;
end

maxQa = max(proba);
indice = find( maxQa == proba);

%get the reward according to random indice
reward = normrnd(Qa_star(indice),1);

%number of time action is taken
actionCounter(indice) = actionCounter(indice) + 1;

%current sum of rewards for a particular action
rewardSum(indice) = rewardSum(indice) + reward;

%update quality for action "indice"
Qa(indice) = rewardSum(indice)/actionCounter(indice);