function D = coeffDiffraction (phi, phi2, s, s2)

% angle en degré et vérifie bien de prendre le bon angle.
% Constantes
%------------

global frequence mu_0 eps_0;

w    = 2*pi*frequence;                           % Pulsation (oméga) de la norme IEEE 802.11n

L    = (s*s2)/(s+s2);                           % (8.80)
delta= pi-(phi-phi2);

B    = w*sqrt(mu_0*eps_0);
exp1 = exp(-1i*pi/4);

% Calcul numérique de la fonction de Fresnel : formule (8.81)
ft   = Ft(2*B*L*sin(delta/2)*sin(delta/2));     
%------------------------------------------------------------
% Calcul du coefficient de Diffraction
D    = -((exp1)*ft)/(2*sqrt(B*2*pi*L)*sin(delta/2));
D = norm (D);
%------------------------------------------------------------