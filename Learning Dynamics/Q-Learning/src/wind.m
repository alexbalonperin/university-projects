function s = wind(s)
%WIND Summary of this function goes here
%   Detailed explanation goes here

windFactor = 0;
if s(1) > 8 && s(1) < 11
    windFactor = 2;
elseif s(1) == 11 || (s(1) > 5 && s(1) < 9)
    windFactor = 1;
end

if windFactor ~= 0
    windVariance = rand();
    
    if windVariance <= 1/3
        s(2) = s(2) + windFactor;
    elseif windVariance > 1/3 && windVariance <= 2/3
        s(2) = s(2) + windFactor + 1;
    elseif windVariance > 2/3
        s(2) = s(2)+ windFactor - 1;
    end
end

end

