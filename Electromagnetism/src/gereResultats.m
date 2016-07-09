
function gereResultats(Resultat)
global vec longueurPlan hauteurPlan ; 
%cr?er les matrices de r?ception lorsqu'il y a trois ?metteurs

phaseDeCalculLancee = 1 
counter = 1 ;
Puissance3Emetteurs = {};
Debit3Emetteurs = {};

for i = 1 : length(Resultat)-2
    for j = 1+i : length(Resultat)-1
        for k = 1+j : length(Resultat)

                if i~=j && j~=k && k~=i
                matriceP = zeros (longueurPlan-1,hauteurPlan-1);
                matriceD = zeros (longueurPlan-1,hauteurPlan-1);
                for m = 1 : longueurPlan-1
                    for n = 1 : hauteurPlan-1
                       maximumP = max(Resultat{i}{1}(m,n),max(Resultat{j}{1}(m,n),Resultat{k}{1}(m,n)));
                        matriceP(m,n) = maximumP;
                        maximumD = max(Resultat{i}{2}(m,n),max(Resultat{j}{2}(m,n),Resultat{k}{2}(m,n)));
                        matriceD(m,n) = maximumD;
                    end
                end
                Puissance3Emetteurs{counter} = { matriceP Resultat{i}{3} Resultat{j}{3} Resultat{k}{3} };
                Debit3Emetteurs{counter} = { matriceD Resultat{i}{3} Resultat{j}{3} Resultat{k}{3} };
                counter = counter + 1 ;
            
            end
        end
    end
end
phaseDeCalculLancee = 2 
%trouver meilleur dans les deux cas
meilleureMoyenneP = 1 ; 
% meilleurEcartTypeP = 1 ;
tempP = zeros(longueurPlan*hauteurPlan)  ;
temp2P = zeros(longueurPlan*hauteurPlan);

for i = 1 : length(Puissance3Emetteurs)
%         if abs(mean(mean(Puissance3Emetteurs{meilleureMoyenneP}{1}))-mean(mean(Puissance3Emetteurs{i}{1}))) < 0.1           
%             counter1=1;
%             for m = 1 : longueurPlan-1
%                 for n = 1 : hauteurPlan-1
%                     tempP(counter1) = Puissance3Emetteurs{i}{1}(m,n);                    % celui qu'on teste
%                     temp2P(counter1) = Puissance3Emetteurs{meilleureMoyenneP}{1}(m,n);   % l'indice qui a l ecart type le plus petit actuellement
%                     counter1 = counter1+1;
%                 end
%             end    
%                 if sqrt(var(tempP)) < sqrt (var(temp2P))
%                         meilleureMoyenneP = i;
%                 end
        if mean(mean(Puissance3Emetteurs{meilleureMoyenneP}{1})) < mean(mean(Puissance3Emetteurs{i}{1}))
            meilleureMoyenneP = i;
       
        end
end

% meilleurEcartTypeP = meilleurEcartTypeP
meilleureMoyenneP = meilleureMoyenneP
moyenneP = mean(mean(Puissance3Emetteurs{meilleureMoyenneP}{1}))
minP = min(min(Puissance3Emetteurs{meilleureMoyenneP}{1}))
maxP = max(max(Puissance3Emetteurs{meilleureMoyenneP}{1}))

moyenneD = mean(mean(Debit3Emetteurs{meilleureMoyenneP}{1}))
minD = min(min(Debit3Emetteurs{meilleureMoyenneP}{1}))
maxD = max(max(Debit3Emetteurs{meilleureMoyenneP}{1}))

Gui_project_ZC(vec,Puissance3Emetteurs{meilleureMoyenneP}{1},[Puissance3Emetteurs{meilleureMoyenneP}{2}; Puissance3Emetteurs{meilleureMoyenneP}{3} ;Puissance3Emetteurs{meilleureMoyenneP}{4}]);
Gui_project_DR(vec,Debit3Emetteurs{meilleureMoyenneP}{1},[Puissance3Emetteurs{meilleureMoyenneP}{2}; Puissance3Emetteurs{meilleureMoyenneP}{3} ;Puissance3Emetteurs{meilleureMoyenneP}{4}]);
positionZCmoyenneP = [Puissance3Emetteurs{meilleureMoyenneP}{2}; Puissance3Emetteurs{meilleureMoyenneP}{3} ;Puissance3Emetteurs{meilleureMoyenneP}{4}]
% positionZCmoyenneD = [Debit3Emetteurs{meilleureMoyenneD}{2}; Debit3Emetteurs{meilleureMoyenneD}{3} ;Debit3Emetteurs{meilleureMoyenneD}{4}]

end