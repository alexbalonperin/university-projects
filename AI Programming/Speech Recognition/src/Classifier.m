classdef Classifier
   properties (Access = private)
       models;
       noHiddenLeft = 5;
       noHiddenRight = 5;
       noHiddenStart = 5;
       noHiddenStop = 5;
       distr = 'MixtGauss';
       nbWords = 4;
       threshold = 1000;
       utilities
       encoder
       em
       maxiter = 100;
       nb_files = 35;   %number of query files
       nb_observations;
   end
   
   methods
       function obj = Classifier  
            obj.models = [HMM('left', obj.noHiddenLeft, obj.distr),...
                HMM('right', obj.noHiddenRight, obj.distr), ...
                HMM('stop', obj.noHiddenStop, obj.distr), ...
                HMM('go', obj.noHiddenStart, obj.distr)];
            obj.utilities = Utilities();
            obj.encoder = Encoding();
            obj.em = EM(obj.maxiter,obj.distr,obj.threshold);
       end
       
       function training(obj)
           for i=1:size(obj.models,2)
               concatFilesPath = obj.utilities.concatFilesWAV(obj.models(i).getWord);
               
               observations = obj.encoder.encodeSignal(concatFilesPath);
               obj.nb_observations = size(observations,1);
               obj.em.setNbObs(obj.nb_observations)
               %[label,model,llh] = emgm(observations',[1])
               obj.em.ExpMax(observations, obj.models(i));
               options = statset('Display','final');
               result = gmdistribution.fit(observations,3,'Options',options);
               result
%                for state=1:obj.models(i).getNoHidden
%                    obj.models(i).getObsModels{state}.getSigma
%                end
           end
       end
       
       function training2(obj)
           for i=1:size(obj.models,2)
               for file_nb=1:25
                   %concatFilesPath = obj.utilities.concatFilesWAV(obj.models(i).getWord);
                   observations = obj.encoder.encodeSignal(strcat('files/soundfile-wav/',obj.models(i).getWord,'_',int2str(file_nb),'.wav'));
                   %observations = obj.encoder.encodeSignal(concatFilesPath);
                   obj.nb_observations = size(observations,1);
    %                options = statset('Display','final');
    %                result = gmdistribution.fit(observations,3,'Options',options);
                   %result
                   %[label,model,llh] = emgm(observations',[1])
                   obj.em.ExpMax(observations, obj.models(i));
               end
           end
       end
       
       function classify(obj)
           fid = fopen('files/querySolution.txt');
           solution = fgetl(fid);
           success = 0;
           for file_nb=0:obj.nb_files
               fprintf('\n\nFile number %d\n',file_nb); 
               observations = obj.encoder.encodeSignal(strcat('files/query-wav/query_',int2str(file_nb),'.wav'));
               
               ll_vec = zeros(1,size(obj.models,2));
               for i=1:size(obj.models,2)
%                    for state=1:obj.models(i).getNoHidden
%                         obj.models(i).getObsModels{state}.getSigma
%                    end
                   display('here')
                   log_likelihood = -inf(1,obj.maxiter);
                   converged = false;
                   t=1;
                   while ~converged && t < obj.maxiter
                       t=t+1;
                       [log_likelihood(t), ~, ~] = HMM.backward_forward(obj.models(i),observations);
                       converged = abs(log_likelihood(t) - log_likelihood(t-1)) < obj.threshold;%*abs(log_likelihood(t));
                   end
                    if converged
%                         fprintf('Converged in %d steps.\n',t-1);
%                         fprintf('Log-likelihood for the word %s: %f\n',obj.models(i).getWord(),log_likelihood(t-1));
                    else
%                         fprintf('Not converged in %d steps.\n',obj.maxiter);
                    end
                    ll_vec(i) = log_likelihood(t-1);
               end
               ll_vec
               [log_lik idx] = max(ll_vec);
%                fprintf('The word is %s with likelihood %f\n',obj.models(idx).getWord, log_lik);
               if ischar(solution)
                    solution = fgetl(fid);
               end
               if(strcmp(solution,sprintf('%s\t%s',int2str(file_nb),upper(obj.models(idx).getWord))))
                   display('YES THE ALGO WAS SUCCESSFUL')
                   success = success +1;
               else
                   display('OH NOOO IT DID NOT GET IT')
               end
           end   
           
           display('****************************************************')
           fprintf('Percentage of success : %2.2d%c \n',(success/obj.nb_files)*100,'%');
           display('****************************************************')
           fclose(fid);
       end
       
       
   end
end