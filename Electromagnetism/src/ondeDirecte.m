function ondeDirecte( TX, RX, D)

global champ dessin; 

[counterH counterV] = checkIntersection (TX, RX );
thetaI = angleIncident (TX,RX);
Tm = coeffTransmission(thetaI)^counterV*coeffTransmission(pi/2-thetaI)^counterH;
d_n = distance(TX,RX);

if distance (TX,RX)~=0
    E_n = D*Tm*En(d_n);
    champ(int8(RX(1))+1,int8(RX(2))+1) = champ(int8(RX(1))+1,int8(RX(2))+1)+ E_n;  
    if dessin
        line([TX(1) RX(1)], [TX(2) RX(2)], 'Color', 'magenta');    
    end
end    
end