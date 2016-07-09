classdef EM < handle
    properties
        maxiter
        distr
        nb_observations
        threshold
    end
    methods  
        function obj=EM(maxiter,distr,threshold)
            obj.maxiter = maxiter;
            obj.distr = distr;
            obj.threshold = threshold;
        end
        
       function ExpMax(obj, observations,model)
           log_likelihood = -inf(obj.maxiter,1);
           converged = false;
           t=1;
           while ~converged && t < obj.maxiter
               t=t+1;
               [gamma, log_likelihood(t), xi] = obj.expectation(observations, model); 
               obj.maximisation(observations, model, gamma, xi);
               converged = abs(log_likelihood(t) - log_likelihood(t-1)) < obj.threshold;%*abs(log_likelihood(t));
               log_likelihood(t)
           end
            if converged
                fprintf('Converged in %d steps.\n',t-1);
                fprintf('Log-likelihood for the word %s: %f\n',model.getWord(),log_likelihood(t-1));
            else
                fprintf('Not converged in %d steps.\n',obj.maxiter);
            end
       end 
        
       function gamma = calcGammaMixture(obj, fwd_msg, bwd_msg,model,data)
            gamma = zeros(size(fwd_msg));
            distrib = zeros(model.getNoHidden,obj.nb_observations,ObsModel.nb_component);
            c = zeros(model.getNoHidden,ObsModel.nb_component);
            normalizer = zeros(model.getNoHidden,obj.nb_observations);
            norm = zeros(ObsModel.nb_component,obj.nb_observations);
            for state=1:size(fwd_msg,1)
                c(state,:) = model.getObsModels{state}.getMixingProportion;
                for k=1:ObsModel.nb_component 
                    distrib(state,:, k) = model.getObsModels{state}.CalcLikelihoodMixture(data,k);
                    norm(k,:) = c(state,k)*distrib(state,:,k);
                end
                for k=1:ObsModel.nb_component 
                    weighted_norm = c(state,k)*distrib(state,:,k);
                    normalizer(state,:) = sum(norm,1);
                    gamma(state,:,k) = (fwd_msg(state,:).*bwd_msg(state,:))/sum(fwd_msg(state,:).*bwd_msg(state,:))...
                        .*(weighted_norm./normalizer(state,:));
                end 
            end
       end 
       
       function gamma = calcGamma(obj, fwd_msg, bwd_msg)
            gamma = zeros(size(fwd_msg));
            for i=1:size(fwd_msg,1)
                gamma(i,:) = (fwd_msg(i,:).*bwd_msg(i,:))/sum(fwd_msg(i,:).*bwd_msg(i,:));
            end 
       end  
       
       
       function xi = calcXi(obj,fwd_msg, bwd_msg, model,data)
           xi = zeros(model.getNoHidden,model.getNoHidden,obj.nb_observations);
           dynModel = model.getDynModel;
           obsVec = zeros(model.getNoHidden,1);
           for t=1:obj.nb_observations-1
             for state = 1:model.getNoHidden
                obsVec(state) = model.getObsModels{state}.CalcLikelihood(data(t+1,:));
             end
             normalizer  = 0;
             for k=1:model.getNoHidden
               for l=1:model.getNoHidden
                   normalizer = normalizer + fwd_msg(k,t)*dynModel(k,l)*diag(obsVec(l))*bwd_msg(l,t+1); 
               end
             end
             for i=1:model.getNoHidden
               for j=1:model.getNoHidden
                   xi(i,j,t) = ((fwd_msg(i,t)*dynModel(i,j)*diag(obsVec(j))*bwd_msg(j,t+1))/normalizer)+1e-7;  
               end
             end
           end
       end
       
       function [gamma , log_likelihood, xi] = expectation(obj, observations, model)
            [log_likelihood, fwd_msg, bwd_msg] = HMM.backward_forward(model,observations);
   
            if strcmp(obj.distr,'MixtGauss')
                gamma = obj.calcGammaMixture(fwd_msg, bwd_msg, model,observations);
            elseif strcmp(obj.distr, 'Gauss')
                gamma = obj.calcGamma(fwd_msg, bwd_msg);
            else
                error(strcat('Error: Distribution ',obj.distr,' does not exist'))
            end
          
            xi = obj.calcXi(fwd_msg,bwd_msg,model,observations);
 
       end
       
       function maximisation(obj, observations, model, gamma, xi)
           for state=1:model.getNoHidden
               
%            display('************************************************')
%            fprintf('STATE NUMBER %d\n',state)
%            display('************************************************')
               if strcmp(obj.distr,'MixtGauss')
                   model.getObsModels{state}.setMuMixture(gamma, observations,state); 
                   model.getObsModels{state}.setSigmaMixture(gamma, observations,state); 
                   model.getObsModels{state}.setMixingProportion(gamma,state);
               elseif strcmp(obj.distr, 'Gauss')    
                   model.getObsModels{state}.setMu(gamma(state,:), observations); 
                   model.getObsModels{state}.setSigma(gamma(state,:), observations); 
               else
                    error(strcat('Error: Distribution ',obj.distr,' does not exist'));
               end  
           %display('************************************************')
           
           end
           model.setPriorHidden(gamma);
           model.setDynModel(xi, gamma);
       end
       
       function setNbObs(obj,nb_observations)
           obj.nb_observations = nb_observations;
       end
    end
end