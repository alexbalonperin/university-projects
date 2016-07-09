clear all;
close all;
clc;
figure;
hold on;
largueurPlan = 10;
longueurPlan = 20;
vecResultat{longueurPlan,largueurPlan} = [];
tic
vec = planSimple;
 crois = croisements(vec);
 resultat = zeros(46,46);
TX = [1 1];
% for m = 1 : longueurPlan
%     for n = 1 : largueurPlan
%         %Vérifie qu'on est pas sur un mur avant de positionner le récepteur
%         eSurLeMur = false;
%         for k = 1 : length(vec)
%             if vec(k,1) <= m && vec(k,2) <= n && m <= vec(k,3)  &&  n <= vec(k,4)
%                 eSurLeMur = true;
%                 break;
%             end
%         end
%         %Vérifie aussi qu'on est pas en zone rouge avant de placer le
%         %récepteur
%         dansZoneRouge = (m >= 13 && n >= 4 && n <= 34 && m <= 27);
%         if ~dansZoneRouge && ~eSurLeMur  
%             TX = [m n];
% 
%             %Matrice des résultats contenant les puissances recues au recepteur
%             resultat = zeros (39,44);
% 
%             %Dessin emetteur 
            plot(TX(1), TX(2), 'black', 'Marker', '.', 'MarkerSize' ,20); 

            %parcourt le plan complet avec le recepteur
%             for i = 1  :0.5:longueurPlan
%                 for j = 1  : largueurPlan
i=14;
j=7;
 plot(i, j, 'r', 'Marker', '.', 'MarkerSize' ,5); 
                    rSurLeMur = false;
                    %Vérifie qu'on est pas sur un mur avant de positionner le récepteur
                    %2 millioniemes de secondes dans le pire des cas.
                    for k = 1 : length(vec)
                        if vec(k,1) <= i && vec(k,2) <= j && i <= vec(k,3)  &&  j <= vec(k,4)
                            rSurLeMur = true;
                            break;
                        end
                    end
%                     %Vérifie aussi qu'on est pas en zone rouge avant de placer le
%                     %récepteur
                    if  ~rSurLeMur  
                        RX = [i j    0 0 0];
                        
                        %reflexions
%                         RX = ondeDirecte(vec, TX, RX);
%                         pause
%                         RX = reflexionSimple(vec, crois, TX, RX, resultat);
                        RX = reflexionDouble2 ( vec, crois, TX, RX) ;
                       RX
                   

%         resultat (i+1,j+1) = RX(3) + RX(4);
                   end
%                 end
%             end 
            
           % vecResultat{m,n} = resultat;
%         end
%     end
% end
toc
% 
% for x = 0 : 7
%    y = droite ( 1, 2, 4, 3, x, 'ver');
%     [x,y]
%     plot(x,y,'o');
% end

%PARAMETRES: 
%fréquence du réseau : 2.45 GHz
%mur: epaisseur : 0.1m
%     permittivité relative: epsR = 5
%     conductivité : sigma = 0.1 S/m
%cable: 1m
%       impédance caractéristique: omega = 50 ohms
%       atténuation : 1dB/m
%antenne : dipole lambda/2 sans perte pas adaptée
%Puissance : en décibel --> P[dBm] = 10 log P[W]/1mW
%Valeurs extrêmes:
%                   Sensibilité: -90 dBm à -60dBm
%                   Débit binaire : 10Mb/s à 100Mb/s


%NOTE pour plus tard : ne pas parcourir 3 fois le plan avec un emetteur
%mais le faire une fois et sommer 3 matrices parmi les résultats. 
%(simuler qu'on a 3 emetteurs) --> principe de superposition