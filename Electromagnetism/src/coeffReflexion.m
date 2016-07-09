% Calcul du coefficient de reflexion
% ----------------------------------
% Recois l'angle thi en DEGRE ! 

function Rm = coeffReflexion(thi)

% Constantes
% ----------

global frequence mu_0 eps_0 sigma epsR l;

w    = 2*pi*frequence;                                  % Pulsation (oméga) de la norme IEEE 802.11n
epsm = eps_0*epsR;                               % Permittivité du mur
epsmb= epsm-1i*sigma/w;                           % Permittivité complexe équivalente du mur (7.25)

Z1   = 337;                                     % Impédance de l'air (Ohms)
Z2   = sqrt(mu_0/epsmb);                         % Impédance du mur (8.17) (Ohms)

tht  = asin(sqrt(eps_0/epsmb)*sin(thi));         % Loi de Snell (8.5) : Angle de refraction "theta t" 

s    = l/cos(tht);                              % Distance parcourue dans le mur (m)            

B    = w*sqrt(mu_0*eps_0);
alpha = w*sqrt(mu_0*epsmb/2)*(sqrt(1+(sigma/(w*epsmb))^2)-1)^(1/2); % (7.35)
beta = w*sqrt(mu_0*epsmb/2)*(sqrt(1+(sigma/(w*epsmb))^2)+1)^(1/2);
Bm = real(alpha + 1i*beta);                                          % (7.32) Gamma = Bm            


e1 = (exp(-2*1i*Bm*s));                            % exponentielle 1
e2 = exp(2*1i*Bm*s*sin(tht)*sin(thi));            % exponentielle 2

% Coefficient intermédiaire : formule (8.39)
GammaPerp   = (Z2*cos(thi)-Z1*cos(tht))/(Z2*cos(thi)+Z1*cos(tht));   
%-------------------------------------------------------------------
% Coefficient de Transmission formule (8.43)
% Rm=abs(GammaPerp + ((1-GammaPerp^2)*(GammaPerp*e1*e2)/(1-(GammaPerp^2)*e1*e2))); 
%-------------------------------------------------------------------
Rm=GammaPerp + ((1-GammaPerp^2)*(GammaPerp*e1*e2)/(1-(GammaPerp^2)*e1*e2)); 
Rm = norm(Rm);