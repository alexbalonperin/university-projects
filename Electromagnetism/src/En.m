function E_n = En(d)

global eps_0 mu_0 frequence P_TX lambda B;


eta = 1;                                    % eta = (R_ar/R_ar+R_al) avec R_al = 0
D = 16/3*pi;                                  %Dmax [dBi]-->décibels par rapport à une antenne isotrope
Gain_TX = eta*D;                           

E_n = sqrt(60*Gain_TX*P_TX)*exp(-1i*B*d)/d;
E_n = norm(E_n);
end