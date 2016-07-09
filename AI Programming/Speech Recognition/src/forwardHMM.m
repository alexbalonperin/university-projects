function [log_lik fwd_messages] = forwardHMM(model, data)

log_lik = 0; totalTime = size(data,2); 
fwd_messages = zeros(model.noHidden, totalTime); 
obsVec = zeros(model.noHidden,1);
% Loop over all time-slots:
for t = 0:totalTime-1
    % Calculate the observation matrix. 
    % This amounts to calculating likelihoods based on observation model. 
    for state = 1:model.noHidden
        obsVec(state) = model.obsModels{state}.CalcLikelihood(data(:,t+1));
    end
    % Do ?forward iterations?:
    if t==0 
        fwd_messages(:, t+1) = diag(obsVec) * model.priorHidden;
    else
        fwd_messages(:, t+1) = diag(obsVec) * model.dynModel' * fwd_messages(:,t);
    end
    % Normalize: 
    normalizer = sum(fwd_messages(:, t+1)); % Add error control: small value? 
    fwd_messages(:, t+1) = fwd_messages(:, t+1) ./ normalizer; 
    log_lik = log_lik + log(normalizer);
end

end