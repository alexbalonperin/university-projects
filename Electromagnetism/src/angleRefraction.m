function thetaT = angleRefraction (eps1,eps2,thetaI)

    thetaT = asin(sqrt(eps1/eps2)*sin(thetaI));

end