function [indice Qa actionCounter rewardSum] = selectionMethod_Random(Qa,actionCounter, rewardSum)

global Qa_star;


%generate random integer
%indice = randi([1 6],'int');
a = 1;
b = 7;
indice = a + (b-a).*rand(1,1);
indice = floor(indice);

%get the reward according to random indice
reward = normrnd(Qa_star(indice),1);

%number of time action is taken
actionCounter(indice) = actionCounter(indice) + 1;

%current sum of rewards for a particular action
rewardSum(indice) = rewardSum(indice) + reward;

%update quality for action "indice"
Qa(indice) = rewardSum(indice)/actionCounter(indice);




