function debit = calculDebit(puissance)

global longueurPlan hauteurPlan;

debit = zeros(longueurPlan-1,hauteurPlan-1);      
for i = 1 : longueurPlan-1
    for j = 1 : hauteurPlan-1
        debit(i,j) = 10^((1/30)*puissance(i,j)+4) ;

        if debit(i,j) > 100 
            debit (i,j) = 100 ;
        end
        if debit<10
            debit(i,j) = 0;
        end

    end
end

end