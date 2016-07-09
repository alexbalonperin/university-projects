function displayResults(res,method,color, actionCounter, rewardVec)

global Qa_star nbActions iterations;

h = zeros(1,nbActions);
   
%Qa over time
% for j = 1: nbActions
%     
%     h(j) = figure(j);
%     h(j) = plot(1:(actionCounter(j)+1), res(1:(actionCounter(j)+1), j), color, 'Marker', '.', 'MarkerSize', 6);
%     
%     l = legend('Random','','Greedy','','Epsilon Greedy','','Softmax','', 8);
%     set(l, 'Interpreter', 'none');
%     str = sprintf('Action %d', j);
%     title(str);
%     xlabel('iteration');
%     ylabel('Qa');    
%     
%     line([0 1000], [Qa_star(j) Qa_star(j)], 'color', 'red');
%     hold on;   
%         
% end
% 
% %Average reward over time
% k = figure(7);
% k = plot(1:iterations, rewardVec(1:iterations), color, 'Marker', '.', 'MarkerSize', 6);
% 
% title('Average Reward');
% xlabel('iteration');
% ylabel('average reward');
% hold on;


for i = 1: nbActions
    l = figure(i+7);  
    l = plot(method, actionCounter(i),'black','Marker', '.', 'MarkerSize', 20);
    set(gca,'XTick',1:1:4);
    set(gca,'XTickLabel',{'Random','Greedy','eps-Greedy','Softmax'});
    xlabel('Selection Method');
    y = sprintf('Count of Action %d', i);
    str1 = sprintf('Number of time Action %d is selected', i);
    ylabel(y);
    title(str1);
    line([method method], [0 actionCounter(i)], 'LineWidth',4,'color', 'black');
    hold on;
   
end


% % \Theta appears as a Greek symbol (see String)
% % Annotate the point (-pi/4, sin(-pi/4))
% text(-pi/4,sin(-pi/4),'\leftarrow sin(-\pi\div4)',...
%      'HorizontalAlignment','left')
% % Change the line color to red and
% % set the line width to 2 points 
% set(p,'Color','red','LineWidth',2)
    
