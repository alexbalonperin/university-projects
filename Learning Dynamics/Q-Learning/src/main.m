close all;
clear all;
clc;

global goal gamma alpha xmax ymax actionsX actionsY nbActions nbEpisodes;

xGoal = 10;
yGoal = 4;
goal = [xGoal, yGoal];
gamma = 0.9;
alpha = 0.1;
nbActions = 8;
xmax = 12;
ymax = 7;
actionsX = [+1,-1,0,0,+1,-1,+1,-1];
actionsY = [0,0,+1,-1,+1,-1,-1,+1];

nbEpisodes = 5000;
xStart = 1;
yStart = 4;
start = [xStart yStart];

allRewardsSums = zeros(1,nbEpisodes);
allNbSteps = zeros(1,nbEpisodes);
Q = zeros(xmax,ymax,nbActions);
for j = 1: ymax
    Q(1, j, 8) = -inf;
    Q(1, j, 2) = -inf;
    Q(1, j, 6) = -inf;
    
    Q(xmax, j, 5) = -inf;
    Q(xmax, j, 1) = -inf;
    Q(xmax, j, 7) = -inf;
end

for i = 1: xmax
    Q(i, 1, 6) = -inf;
    Q(i, 1, 4) = -inf;
    Q(i, 1, 7) = -inf;
    
    Q(i, ymax, 8) = -inf;
    Q(i, ymax, 3) = -inf;
    Q(i, ymax, 5) = -inf;
end


tic
for l = 1: nbEpisodes
    s = start;
    [Q rewardTot nbSteps] = QLearningAlgorithm(s,Q);
    allRewardsSums(l) = rewardTot; 
    allNbSteps(l) = nbSteps;
    l
end
disp('Q-Learning Finished')
plotRewardsAndSteps(allRewardsSums, allNbSteps,Q)

%ONE RUN WITH GREEDY TO MAKE THE PATH
oneRunGreedy(start,Q);
disp('Finished')
toc


