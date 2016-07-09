function [indice Qa actionCounter rewardSum] = selectionMethod_Greedy(Qa,actionCounter,rewardSum)

global Qa_star nbActions;

QaTemp = Qa(1,1:nbActions);


%find action with maximum quality
maxQa = max(QaTemp);
indice = find(maxQa == QaTemp);

%get the reward according to random indice
reward = normrnd(Qa_star(indice),1);
rewardSum = rewardSum + reward;

%number of time action is taken
actionCounter(indice) = actionCounter(indice) + 1;
%current sum of rewards for a particular action
rewardSum(indice) = rewardSum(indice) + reward;

%update quality for action "indice"
Qa(indice) = rewardSum(indice)/actionCounter(indice);

