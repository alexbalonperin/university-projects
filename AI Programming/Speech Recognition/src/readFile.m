function [y, hz] = readFile(file)

try
    [y, hz] = wavread(file);
    figure(1)
    plot(1:size(y),y)
catch ERR_MSG
    % if something didn't work correctly the error message displays
    disp('Error Reading Data! Check Unit')
    rethrow(ERR_MSG)
end

end