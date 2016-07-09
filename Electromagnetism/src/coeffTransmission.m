% Calcul du Coefficient de transmission
% -------------------------------------
% Recoit l'angle thi en RADIAN

function Tm = coeffTransmission(thetaI)

% Constantes
%------------

global frequence mu_0 eps_0 epsR l sigma;

w    = 2*pi*frequence;                                  % Pulsation (oméga) de la norme IEEE 802.11n
epsm = eps_0*epsR;                                      % Permittivité du mur
epsmb= epsm-1i*sigma/w;                                 % Permittivité complexe équivalente du mur (7.25)

Z1   = sqrt(mu_0/eps_0)  ;                              % Impédance de l'air = impédance du vide en EM (Ohms)               
Z2   = sqrt(mu_0/epsmb);                                % Impédance du mur (8.17) (Ohms)

thetaT  = asin(sqrt(eps_0/epsmb)*sin(thetaI));          % Loi de Snell (8.5) : Angle de refraction "theta t" 
s    = l/cos(thetaT);                                   % Distance parcourue dans le mur (m)                                    

B    = w*sqrt(mu_0*eps_0);
alpha = w*sqrt(mu_0*epsmb/2)*(sqrt(1+(sigma/(w*epsmb))^2)-1)^(1/2); % (7.35)
beta = w*sqrt(mu_0*epsmb/2)*(sqrt(1+(sigma/(w*epsmb))^2)+1)^(1/2);
Bm = real(alpha + 1i*beta);                                   % (7.32) Gamma = Bm

e1 = exp(-1i*Bm*s);                                     % exponentielle 1
e2 = exp(2*1i*Bm*s*sin(thetaT)*sin(thetaI));            % exponentielle 2

% Coefficient intermédiaire : formule (8.39)
GammaPerp=(Z2*cos(thetaI)-Z1*cos(thetaT))/(Z2*cos(thetaI)+Z1*cos(thetaT));  
%-------------------------------------------------------
% Coefficient de Transmission formule (8.44)
% Tm=abs((1-GammaPerp^2)*(e1)/(1-(GammaPerp^2)*(e1^2)*e2)); 
%-------------------------------------------------------
Tm=(1-GammaPerp^2)*(e1)/(1-(GammaPerp^2)*(e1^2)*e2); 
Tm = norm(Tm);
