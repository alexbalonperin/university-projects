function simulation3(Qa)

global nbActions iterations Qa_star;


%vector of results
res = zeros(iterations, nbActions);
actionCounter = zeros(1,nbActions);

tau1 = 0.05;
tau2 = 3;
tau3 = 50;
rewardSum = zeros(1,nbActions);

for i = 1: iterations
  
    [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa,actionCounter, tau1, rewardSum);
    
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
%Qa over time
for j = 1: nbActions
    h(j) = figure(j);
    str = sprintf('OverEstimating Q-values Softmax Tau = 0.05 : Action %d ', j);
    h(j) = plot(1:(actionCounter(j)+1), res(1:(actionCounter(j)+1),j), 'green', 'Marker', '.', 'MarkerSize', 6);
    title(str);
    xlabel('iteration');
    ylabel('Qa');
    hold on;
    line([0 1000], [Qa_star(j) Qa_star(j)], 'color', 'red');
end


%vector of results
res = zeros(iterations, nbActions);
actionCounter = zeros(1,nbActions);
rewardSum = zeros(1,nbActions);
for i = 1: iterations
  
    [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa,actionCounter, tau2, rewardSum);
    
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

%Qa over time
for j = 1: nbActions
    h(j + nbActions) = figure(j + nbActions);
    str = sprintf('OverEstimating Q-values Softmax Tau = 3 : Action %d ',j);
    h(j+nbActions) = plot(1:(actionCounter(j)+1), res(1:(actionCounter(j)+1),j), 'yellow', 'Marker', '.', 'MarkerSize', 6);
    title(str);
    xlabel('iteration');
    ylabel('Qa');
    hold on;
    line([0 1000], [Qa_star(j) Qa_star(j)], 'color', 'red');
end
 

%vector of results
res = zeros(iterations, nbActions);
actionCounter = zeros(1,nbActions);
rewardSum = zeros(1,nbActions);
for i = 1: iterations
  
    [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa,actionCounter, tau3,rewardSum);
    
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

%Qa over time
for j = 1: nbActions
    h(j+nbActions*2) = figure(j+nbActions*2);
    str = sprintf('OverEstimating Q-values Softmax Tau = 50 : Action %d ', j);
    h(j+nbActions*2) = plot(1:(actionCounter(j)+1), res(1:(actionCounter(j)+1),j), 'black', 'Marker', '.', 'MarkerSize', 6);
    title(str);
    xlabel('iteration');
    ylabel('Qa');
    hold on;
    line([0 1000], [Qa_star(j) Qa_star(j)], 'color', 'red');
end

%vector of results
res = zeros(iterations, nbActions);
actionCounter = zeros(1,nbActions);
rewardSum = zeros(1,nbActions);
for i = 1: iterations
  
    [indice Qa actionCounter rewardSum] = selectionMethod_Greedy(Qa,actionCounter, rewardSum);
    
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


%Qa over time
for j = 1: nbActions
    h(j+nbActions*3) = figure(j+nbActions*3);
    str = sprintf('OverEstimating Q-values Greedy: Action %d ',j);
    h(j+nbActions*3) = plot(1:(actionCounter(j)+1), res(1:(actionCounter(j)+1),j), 'cyan', 'Marker', '.', 'MarkerSize', 6);
    title(str);
    xlabel('iteration');
    ylabel('Qa');
    hold on;
    line([0 1000], [Qa_star(j) Qa_star(j)], 'color', 'red');
end

