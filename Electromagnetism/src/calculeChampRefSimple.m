function calculeChampRefSimple (ref, TX, RX,thetaI,D, im)
  
global champ;
     thetaI1 = angleIncident(TX,ref); % on considere angle incident sur un mur vertical, on adapte et prenant le complementaire si besoin pour les calculs
    
     [counterEH counterEV]= checkIntersection(ref, TX);
    Tm1 = coeffTransmission(pi/2- thetaI1)^counterEH *coeffTransmission(thetaI1)^counterEV;
%         Tm1 = coeffTransmission(thetaI1)^counterEH *coeffTransmission(thetaI1)^counterEV;

    thetaI2 = angleIncident(ref,RX);
    [counterRH counterRV] = checkIntersection(ref, RX);
    d_n = distance(im,RX);
    Rm = coeffReflexion(thetaI);
    Tm2 = coeffTransmission(thetaI2)^counterRV * coeffTransmission(pi/2-thetaI2)^counterRH; 
%     Tm2 = coeffTransmission(thetaI2)^counterRV * coeffTransmission(thetaI2)^counterRH; 

    Tm = Tm1 * Tm2;
    E_n = D*Tm*Rm*En(d_n);
    champ(int8(RX(1))+1,int8(RX(2))+1) = champ(int8(RX(1))+1,int8(RX(2))+1) + norm(E_n) ;
end