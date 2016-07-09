classdef HMM < handle
%   Class implementing the Hidden Markov Model 
%   with assorted inference mechanism

%NOTE:
%   if a phoneme is uttered during more than one frame 
%   than the state stays the same 


    properties (Access = private)
        word            % word represented by the HMM 
        noHidden        % possible states (state = phoneme) 
        priorHidden     % distribution to determine the initial state
        dynModel        % transition matrix containing the probabilities a(ij) to go from a state i to a state j 
        obsModels       % 
        distr
    end
    
    methods (Static = true)
        function [log_likelihood, fwd_msg, bwd_msg] = backward_forward(model,observations)
            [log_likelihood, fwd_msg, normalizer] = HMM.forwardHMM(model,observations);
            bwd_msg = HMM.backwardHMM(model, observations, normalizer);
%             display(fwd_msg)
%             display(bwd_msg)
%             pause
        end
        
        function [log_lik, fwd_messages, normalizer] = forwardHMM(model, data)
           
           % obsVec(j) = P(o(t)| S(t) = j) 
           %  --> probability of observing o(t) 
           %  --> knowing that the current state is j
           %
           % diag(obsVec) = B(t)
           % fwd_messages = f' = alpha(t)/sum(alpha(t)(j)) [normalization of alpha]
           %
           % alpha(t) = vector of the P(o(1:T), S(t) = j)
           %  --> probability that the observations are o(1:T) and 
           %  --> the state is j
           
            log_lik = 0; totalTime = size(data,1); 
            fwd_messages = zeros(model.getNoHidden, totalTime); 
            obsVec = zeros(1, model.getNoHidden);
            normalizer = zeros(1,totalTime);
            % Loop over all time-slots:
            for t = 0:totalTime-1
                % Calculate the observation matrix. 
                % This amounts to calculating likelihoods based on observation model. 
                for state = 1:model.getNoHidden
                    obsVec(state) = model.getObsModels{state}.CalcLikelihood(data(t+1,:));
                end
                
                % Do ?forward iterations?:
                if t==0 
                    fwd_messages(:, t+1) = diag(obsVec) * model.getPriorHidden;
                else
                    %fwd_messages(:, t+1) = logsumexp(diag(obsVec) * model.getDynModel' * fwd_messages(:,t))
                    fwd_messages(:, t+1) = diag(obsVec) * model.getDynModel' * fwd_messages(:,t);
                    
                end
                % Normalize: 
                
                normalizer(t+1) = sum(fwd_messages(:, t+1)); % Add error control: small value? 
     
                fwd_messages(:, t+1) = (fwd_messages(:, t+1) / normalizer(t+1)); 
                log_lik = log_lik + log(normalizer(t+1));
                
            end
       end
       
       function bwd_messages = backwardHMM(model, data, normalizer)
           
           % obsVec(j) = P(o(t)| S(t) = j) 
           %  --> probability of observing o(t) 
           %  --> knowing that the current state is j
           %
           % diag(obsVec) = B(t)
           % fwd_messages = f' = alpha(t)/sum(alpha(t)(j)) [normalization of alpha]
           %
           % alpha(t) = vector of the P(o(1:T), S(t) = j)
           %  --> probability that the observations are o(1:T) and 
           %  --> the state is j
     
            totalTime = size(data,1); 
            bwd_messages = zeros(model.getNoHidden, totalTime); 
            obsVec = zeros(1,model.getNoHidden);
            % Loop over all time-slots:

            for t = totalTime:-1:1
                
                % Do ?forward iterations?:
                if t==totalTime
                    bwd_messages(:, t) = ones(1,model.getNoHidden);
                else
                    % Calculate the observation matrix. 
                % This amounts to calculating likelihoods based on observation model. 
                    for state = 1:model.getNoHidden
                        obsVec(state) = model.getObsModels{state}.CalcLikelihood(data(t+1,:));
                    end
                    bwd_messages(:, t) =  model.getDynModel * diag(obsVec) * bwd_messages(:,t+1);
                end
                bwd_messages(:, t) = (bwd_messages(:, t) / normalizer(t)); 
                
            end
 
       end
    end
    
    methods
        function obj=HMM(word,noHidden,distr)
            obj.word = word;
            obj.noHidden = noHidden;
            obj.dynModel = (1/noHidden)*ones(noHidden,noHidden);
            obj.dynModel = [0.5 0.8 0.01 0.01 0.01;0.01 0.5 0.8 0.01 0.01;...
                0.01 0.01 0.5 0.8 0.01; 0.01 0.01 0.01 0.5 0.8; 0.3 0.01 0.01 0.01 0.5];
            obj.priorHidden = (1/noHidden)*ones(noHidden,1);
            obj.distr = distr;
            for state=1:noHidden
                obj.obsModels{state} = ObsModel(distr);
            end
        end
        
        function setPriorHidden(obj,gamma)  
            if strcmp(obj.distr,'MixtGauss')
                obj.priorHidden = gamma(:,1,1);
            elseif strcmp(obj.distr, 'Gauss')
                obj.priorHidden = gamma(:,1);
            else
                error(strcat('Error: Distribution ',obj.distr,' does not exist'))
            end
%            display('------------------------------------------------')
%            display('UPDATING Prior')
%            display(obj.priorHidden)
%            display('------------------------------------------------')
        end
        
        function setDynModel(obj, xi, gamma)
%             gamma
%             xi
%             pause
            if strcmp(obj.distr,'MixtGauss')
                
                for i=1:obj.noHidden
                    stmt = sum(gamma(i,1:end-1,1));
                    for j=1:obj.noHidden
                        obj.dynModel(i,j) = sum(xi(i,j,1:end-1))/stmt;
                    end
                end
                sum1 = zeros(1,obj.noHidden);
                for i=1:obj.noHidden
                    sum1(i) = sum(obj.dynModel(i,:));
                end
                %display('SUM')
                %sum1

                for i=1:obj.noHidden
                    for j=1:obj.noHidden
                        obj.dynModel(i,j) = obj.dynModel(i,j)/sum1(i);
                    end
                end
                %display(obj.dynModel)
                %pause
            elseif strcmp(obj.distr, 'Gauss') 
                for i=1:obj.noHidden
                    stmt = sum(gamma(i,1:end-1));
                    for j=1:obj.noHidden
                        obj.dynModel(i,j) = sum(xi(i,j,1:end-1))/stmt;
                    end
                end
            else
                error(strcat('Error: Distribution ',obj.distr,' does not exist'))
            end
%            display('------------------------------------------------')
%            display('UPDATING A(ij)')
%            display(obj.dynModel)
%            display('------------------------------------------------')
%            pause
        end

        %
        %       ACCESSORS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function word = getWord(obj) 
            word = obj.word;
        end
        function noHidden = getNoHidden(obj)
            noHidden = obj.noHidden;
        end
        function priorHidden = getPriorHidden(obj)
            priorHidden = obj.priorHidden;
        end
        function dynModel = getDynModel(obj)
            dynModel = obj.dynModel;
        end
        function obsModels = getObsModels(obj)
            obsModels = obj.obsModels;
        end
    end
end