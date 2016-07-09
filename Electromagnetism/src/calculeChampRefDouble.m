function calculeChampRefDouble(ref1, ref2, thetaI1, thetaI2, TX, RX, D, im2 )
    
global champ; 
    thetaI11 = angleIncident(TX,ref1); % angle incident sur mur vertical
    thetaI21 = angleIncident(ref1,ref2);
    thetaI31 = angleIncident(ref2,RX);
    
    [counterEH counterEV ] = checkIntersection(ref1, TX);
    [counterInterH counterInterV ] = checkIntersection(ref2, ref1);
    [counterRH counterRV]= checkIntersection(ref2, RX) ;

    d_n = distance(im2,RX);   
    Tm1 = coeffTransmission (thetaI11)^counterEV * coeffTransmission(pi/2-thetaI11)^counterEH;
    Tm2 = coeffTransmission (thetaI21)^counterInterV * coeffTransmission(pi/2-thetaI21)^counterInterH;
    Tm3 = coeffTransmission (thetaI31)^counterRV * coeffTransmission(pi/2-thetaI31)^counterRH;
%     Tm1 = coeffTransmission (thetaI11)^counterEV * coeffTransmission(thetaI11)^counterEH;
%     Tm2 = coeffTransmission (thetaI21)^counterInterV * coeffTransmission(thetaI21)^counterInterH;
%     Tm3 = coeffTransmission (thetaI31)^counterRV *   coeffTransmission(thetaI31)^counterRH;
    Rm1 = coeffReflexion (thetaI1);
    Rm2 = coeffReflexion(thetaI2);
    Tm = Tm1*Tm2*Tm3;
    Rm = Rm1*Rm2;
    E_n = D*Tm*Rm*En(d_n);
    champ(int8(RX(1))+1,int8(RX(2))+1) = champ(int8(RX(1))+1,int8(RX(2))+1) + norm(E_n) ;
end