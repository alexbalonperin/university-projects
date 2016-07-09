function simulation1(Qa)

nbSelectedMethods = 4;
QaTemp = Qa;

for i = 1: nbSelectedMethods
    
    [res actionCounter rewardVec] = learningProcess(i, QaTemp);

    switch i 
        case 1
           result1 = res;
        case 2
           result2 = res;
        case 3
           result3 = res;
        case 4
           result4 = res; 
    end
    
    switch i 
        case 1
           displayResults(result1,i,'green', actionCounter, rewardVec);
        case 2
           displayResults(result2,i,'blue', actionCounter,rewardVec);
        case 3
           displayResults(result3,i,'yellow', actionCounter,rewardVec);
        case 4
           displayResults(result4,i,'black', actionCounter,rewardVec);
    end
    i
end 

