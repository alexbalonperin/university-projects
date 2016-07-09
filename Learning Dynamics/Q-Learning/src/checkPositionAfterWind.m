function position = checkPositionAfterWind(position)

global ymax;

if position(2) > ymax
    num = ceil(2*rand());
    if num == 1
        if position(1) < 12
            position(1) = position(1) + 1;
        end
        position(2) = 7;
    else
        position(1)  = position(1) - 1;
        position(2) = 7;
    end
end

end