function plotRewardsAndSteps(allRewardsSums,allNbSteps,Q)

global nbEpisodes;

figure(1)
hold on;
plot(1:nbEpisodes,allRewardsSums);
title('Total collected reward per episode', 'FontSize',16)
xlabel('Episode Number','FontName','Courier')
ylabel('Total collected reward per episode','FontName','Courier')
hold off;
figure(2)
hold on;
plot(1:nbEpisodes,allNbSteps);
title('Number of steps to reach the goal per episode', 'FontSize',16)
xlabel('Episode Number','FontName','Courier')
ylabel('Number of steps to reach the goal per episode','FontName','Courier')
hold off;
figure(3)
plotQuiver(Q);
disp('plot Quiver Finished')

end