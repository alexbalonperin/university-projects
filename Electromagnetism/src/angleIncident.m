function thetaI = angleIncident(pt1, pt2)
% 
% if pt1(1) ~= pt2(1)
%     if pt1(1) > pt2(1) && pt1(2) >= pt2(2)
%         thetaI = atan((pt1(2) - pt2(2))/(pt1(1) - pt2(1)));
%     elseif pt1(1) > pt2(1) && pt1(2) <= pt2(2)
%         thetaI = atan((pt2(2) - pt1(2))/(pt1(1) - pt2(1)));
%     elseif pt1(1) < pt2(1) && pt1(2) <= pt2(2)
%         thetaI = atan((pt2(2) - pt1(2))/(pt2(1) - pt1(1)));
%     elseif pt1(1) < pt2(1) && pt1(2) >= pt2(2)
%         thetaI = atan((pt1(2) - pt2(2))/(pt2(1) - pt1(1)));
%     
%     end
% else
%     thetaI = pi/2;
% end
if pt1(1) ~= pt2(1)
         thetaI = atan((pt1(2) - pt2(2))/(pt1(1) - pt2(1)));
else
    thetaI = pi/2;
end

while (thetaI>pi/2)
    thetaI = abs(thetaI-pi);
end
% 
% if min(1) > ref(1)
%     thetaI = thetaI + pi;
% end
% while thetaI > pi/2
%     thetaI = thetaI - pi /2;
% end
% while thetaI < 0 
%     thetaI = thetaI + pi/2;
% end
end