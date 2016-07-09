function puissance = calculPuissance

global  longueurPlan hauteurPlan champ h_e R_a pasR Zcable;
TauL = (R_a - Zcable) /  (R_a + Zcable );
puissance = zeros ( longueurPlan-1, hauteurPlan-1);
for i = 1 : longueurPlan-1
    for j = 1 : hauteurPlan-1
        puissance(i,j) = 1/(8*R_a)*(abs(h_e*champ(i+1,j+1)*pasR^2))^2;             %%% ATTENTION *pasR^2 : faire la moyenne par rapport au pas! 
        puissance (i,j) = puissance(i,j)*( 1 - TauL^2);
        puissance(i,j) = 10 * log(puissance(i,j) * 1E3);
        if puissance(i,j)<-100 %A cause du log de zero sur les murs où en zone rouge
            puissance(i,j) = -100;
        elseif puissance(i,j)>  20
            puissance(i,j) = 20;
        elseif isnan(puissance(i,j))
            puissance(i,j) = -50;
        end
    end
end

end