function calculChampDiffraction(TX, RX, ptDiffraction)
    
    s2 = distance ( TX, ptDiffraction );        %ne connaissant pas l'orientation des murs, ce calcul est bon une fois sur deux, l'autre fois il faut prendre son complémentaire
    phi2 = angleIncident(TX, ptDiffraction );
    
    [counterEH counterEV] = checkIntersection(TX,ptDiffraction);
    Tm = coeffTransmission(phi2)^counterEV * coeffTransmission(pi/2-phi2)^counterEH; % coeff transmission de l'emetteur au point de diffraction
  
    s = distance ( RX, ptDiffraction );
    phi = 2*pi - angleIncident(RX,ptDiffraction);
    
    D = coeffDiffraction (phi, phi2, s, s2) ;
    coeffTot = D*Tm;
    %une fois diffractée, trois possibilités :
    ondeDirecte(ptDiffraction, RX,coeffTot);                   
%     reflexionSimple(ptDiffraction, RX, coeffTot );
%     reflexionDouble(ptDiffraction, RX, coeffTot );
  
end