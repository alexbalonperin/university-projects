function simulation2(Qa)

global iterations nbActions Qa_star;

actionCounter = zeros(1,nbActions);
QaAvg1 = zeros(1,iterations);
QaAvg2 = zeros(1,iterations);
QaAvg3 = zeros(1,iterations);
QaAvg4 = zeros(1,iterations);
QaAvg5 = zeros(1,iterations);
QaAvg6 = zeros(1,iterations);
counter1 = 1;
counter2 = 1;
counter3 = 1;
counter4 = 1;
counter5 = 1;
counter6 = 1;
QaSum1 = 0;
QaSum2 = 0;
QaSum3 = 0;
QaSum4 = 0;
QaSum5 = 0;
QaSum6 = 0;
%tau1 = 3;
tau2 = 5;
rewardSum = zeros(1,nbActions);
    
for i = 1:iterations-1
    for j = 1:iterations
        [indice Qa actionCounter rewardSum] = selectionMethod_Softmax(Qa,actionCounter, tau2, rewardSum);               
    end
   
    QaSum1 = QaSum1 + Qa(1);
    QaAvg1(1,counter1) = QaSum1/counter1;
    counter1 = counter1 + 1;


    QaSum2 = QaSum2 + Qa(2);
    QaAvg2(1,counter2) = QaSum2/counter2;
    counter2 = counter2 + 1;

    QaSum3 = QaSum3 + Qa(3);
    QaAvg3(1,counter3) = QaSum3/counter3;
    counter3 = counter3 + 1;

    QaSum4 = QaSum4 + Qa(4);
    QaAvg4(1,counter4) = QaSum4/counter4;
    counter4 = counter4 + 1;

    QaSum5 = QaSum5 + Qa(5);
    QaAvg5(1,counter5) = QaSum5/counter5;
    counter5 = counter5 + 1;

    QaSum6 = QaSum6 + Qa(6);
    QaAvg6(1,counter6) = QaSum6/counter6;
    counter6 = counter6 + 1;
    i
    Qa
    tau2 = 5*(1000-i)/1000
end

counter1 = counter1 - 1;
counter2 = counter2 - 1;
counter3 = counter3 - 1;
counter4 = counter4 - 1;
counter5 = counter5 - 1;
counter6 = counter6 - 1;

 h(1) = figure(1) ;
 h(1) = plot(1:counter1,QaAvg1(1,1:counter1),'black', 'Marker','.','MarkerSize', 6); 
 hold on;
 line([0 1000], [Qa_star(1) Qa_star(1)], 'color', 'red');
 title('Sofmax : Action 1 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 h(2) = figure(2);
 h(2) = plot(1:counter2,QaAvg2(1,1:counter2),'red', 'Marker','.','MarkerSize', 6);
 hold on;
 line([0 1000], [Qa_star(2) Qa_star(2)], 'color', 'red');
 title('Sofmax : Action 2 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 h(3) = figure(3) ;
 h(3) = plot(1:counter3,QaAvg3(1,1:counter3),'blue', 'Marker','.','MarkerSize', 6);
 hold on;
 line([0 1000], [Qa_star(3) Qa_star(3)], 'color', 'red');
 title('Sofmax : Action 3 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 h(4) = figure(4) ;
 h(4) = plot(1:counter4,QaAvg4(1,1:counter4),'green', 'Marker','.','MarkerSize', 6);
 hold on;
 line([0 1000], [Qa_star(4) Qa_star(4)], 'color', 'red');
 title('Sofmax : Action 4 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 h(5) = figure(5);
 h(5) = plot(1:counter5,QaAvg5(1,1:counter5),'yellow', 'Marker','.','MarkerSize', 6);
 hold on;
 line([0 1000], [Qa_star(5) Qa_star(5)], 'color', 'red');
 title('Sofmax : Action 5 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 h(6) = figure(6) ;
 h(6) = plot(1:counter6,QaAvg6(1,1:counter6),'cyan', 'Marker','.','MarkerSize', 6);
 hold on;
 line([0 1000], [Qa_star(1) Qa_star(1)], 'color', 'red');
 title('Sofmax : Action 6 : Qa average over time');
 xlabel('iterations');
 ylabel('Qa average');
 