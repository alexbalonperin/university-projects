function [FPR_mean A_mean P_mean R_mean F1score_mean time_mean fp_slmc fn_slmc] = cv(svm, lgp, mars, ALL, combined, Y)
    index = randsample(size(svm,1),size(svm,1));
	size_CV = floor(size(svm,1)/10);
    max_iter = 10000;
    options = optimset('MaxIter',max_iter);
    
    Jcv_svm = zeros(1,10);
    Jcv_ALL = zeros(1,10);
    Jcv_lgp = zeros(1,10);
    Jcv_mars = zeros(1,10);
    Jcv_combined = zeros(1,10);
    
    fp_general = []; 
    fn_general = [];
    fp_all = zeros(1,10); 
    fn_all = zeros(1,10); 
    
    lgp = normc(double(lgp));
    mars = normc(double(mars));
    svm = normc(double(svm));
    combined = normc(double(combined));
    ALL = normc(double(ALL));
    
    svm_bool = false;
    fp_slmc = [];
    fn_slmc = [];
    
    for i = 1:10
        
        i
        
        i_ts = (((i-1)*size_CV+1):(i*size_CV));
        i_tr = setdiff(index,i_ts);

        Ycv.tr = Y.label(i_tr);
        Ycv.ts = Y.label(i_ts);
        
        
        svm_cv_tr = svm(i_tr,:);
        svm_cv_ts = svm(i_ts,:);
        
        lgp_cv_tr = lgp(i_tr,:);
        lgp_cv_ts = lgp(i_ts,:);
        
        mars_cv_tr = mars(i_tr,:);
        mars_cv_ts = mars(i_ts,:);
        
        combined_cv_tr = combined(i_tr,:);
        combined_cv_ts = combined(i_ts,:);
        
        ALL_cv_tr = ALL(i_tr,:);
        ALL_cv_ts = ALL(i_ts,:);
        
        tic
        if(svm_bool)
            %model_ALL = svmtrain(ALL_cv_tr,Ycv.tr,'kernel_function','rbf','options',options);
            model_ALL = svmtrain(ALL_cv_tr,Ycv.tr,'kernel_function','polynomial','options',options);
        else
            model_ALL = ClassificationTree.fit(ALL_cv_tr,Ycv.tr);
        end
        time.ALL.training(i) = toc;
        tic
        if(svm_bool)
            h = svmclassify(model_ALL,ALL_cv_ts);  
        else
            h = predict(model_ALL,ALL_cv_ts);
        end
        time.ALL.cv(i) = toc;
        Jcv_ALL(i) = sum(~(h == Ycv.ts))/size_CV;
          
        error.ALL = [sum(h == Ycv.ts & Ycv.ts == 1),sum(h == Ycv.ts & Ycv.ts == 0),sum(h ~= Ycv.ts & Ycv.ts == 1),sum(h ~= Ycv.ts & Ycv.ts == 0)];
        FP.ALL = find(h ~= Ycv.ts & Ycv.ts == 0);
        FN.ALL = find(h ~= Ycv.ts & Ycv.ts == 1);
        fp_all(i) = error.ALL(4);
        fn_all(i) = error.ALL(3);
        
        tic
        if(svm_bool)
            %model_ALL = svmtrain(ALL_cv_tr,Ycv.tr,'kernel_function','rbf','options',options);
            model_combined = svmtrain(combined_cv_tr,Ycv.tr,'kernel_function','polynomial','options',options);
        else
            model_combined = ClassificationTree.fit(combined_cv_tr,Ycv.tr);
        end
        time.combined.training(i) = toc;
        tic
        if(svm_bool)
            h = svmclassify(model_combined,combined_cv_ts);  
        else
            h = predict(model_combined,combined_cv_ts);
        end
        time.combined.cv(i) = toc;
        Jcv_combined(i) = sum(~(h == Ycv.ts))/size_CV;
          
        error.combined = [sum(h == Ycv.ts & Ycv.ts == 1),sum(h == Ycv.ts & Ycv.ts == 0),sum(h ~= Ycv.ts & Ycv.ts == 1),sum(h ~= Ycv.ts & Ycv.ts == 0)];
        FP.combined = find(h ~= Ycv.ts & Ycv.ts == 0);
        FN.combined = find(h ~= Ycv.ts & Ycv.ts == 1);       
        
        tic
        if(svm_bool)
            %model_svm = svmtrain(svm_cv_tr,Ycv.tr,'kernel_function','rbf','options',options);
            model_svm = svmtrain(svm_cv_tr,Ycv.tr,'kernel_function','polynomial','options',options);
             
        else
            model_svm = ClassificationTree.fit(svm_cv_tr,Ycv.tr);
        end
        time.svm.training(i) = toc;
        tic
        if(svm_bool)
            h = svmclassify(model_svm,svm_cv_ts);
        else
            h = predict(model_svm,svm_cv_ts);
        end
        time.svm.cv(i) = toc;
        Jcv_svm(i) = sum(~(h == Ycv.ts))/size_CV;
        
        error.svm = [sum(h == Ycv.ts & Ycv.ts == 1),sum(h == Ycv.ts & Ycv.ts == 0),sum(h ~= Ycv.ts & Ycv.ts == 1),sum(h ~= Ycv.ts & Ycv.ts == 0)];
        FP.svm = find(h ~= Ycv.ts & Ycv.ts == 0);
        FN.svm = find(h ~= Ycv.ts & Ycv.ts == 1);
        
        
        tic
        if(svm_bool)
            %model_lgp = svmtrain(lgp_cv_tr,Ycv.tr,'kernel_function','rbf','options',options);
            model_lgp = svmtrain(lgp_cv_tr,Ycv.tr,'kernel_function','polynomial','options',options);
        else
            model_lgp = ClassificationTree.fit(lgp_cv_tr,Ycv.tr);
        end
        time.lgp.training(i) = toc;
        tic
        if(svm_bool)
            h = svmclassify(model_lgp,lgp_cv_ts);
        else
            h = predict(model_lgp,lgp_cv_ts);
        end
        time.lgp.cv(i) = toc;
        Jcv_lgp(i) = sum(~(h == Ycv.ts))/size_CV;
        
        error.lgp = [sum(h == Ycv.ts & Ycv.ts == 1),sum(h == Ycv.ts & Ycv.ts == 0),sum(h ~= Ycv.ts & Ycv.ts == 1),sum(h ~= Ycv.ts & Ycv.ts == 0)];
        FP.lgp = find(h ~= Ycv.ts & Ycv.ts == 0);
        FN.lgp = find(h ~= Ycv.ts & Ycv.ts == 1);
        
        tic
        if(svm_bool)
            %model_mars = svmtrain(mars_cv_tr,Ycv.tr,'kernel_function','rbf','options',options);
            model_mars = svmtrain(mars_cv_tr,Ycv.tr,'kernel_function','polynomial','options',options);
        else
            model_mars = ClassificationTree.fit(mars_cv_tr,Ycv.tr);
        end
        time.mars.training(i) = toc;
        tic
        if(svm_bool)
            h = svmclassify(model_mars,mars_cv_ts);
        else
            h = predict(model_mars,mars_cv_ts);
        end
        time.mars.cv(i) = toc;
        Jcv_mars(i) = sum(~(h == Ycv.ts))/size_CV;
        
        error.mars = [sum(h == Ycv.ts & Ycv.ts == 1),sum(h == Ycv.ts & Ycv.ts == 0),sum(h ~= Ycv.ts & Ycv.ts == 1),sum(h ~= Ycv.ts & Ycv.ts == 0)];
        FP.mars = find(h ~= Ycv.ts & Ycv.ts == 0);
        FN.mars = find(h ~= Ycv.ts & Ycv.ts == 1);
        
        error
        
        FPR.ALL(i) = error.ALL(4)/(error.ALL(2)+error.ALL(4));
        A.ALL(i) = (error.ALL(1)+error.ALL(2))/sum(error.ALL);
        P.ALL(i) = error.ALL(1)/(error.ALL(1)+error.ALL(4));
        R.ALL(i) = error.ALL(1)/(error.ALL(1)+error.ALL(3));
        F1score.ALL(i) = 2*((P.ALL(i)*R.ALL(i))/(P.ALL(i)+R.ALL(i)));
        
        FPR.svm(i) = error.svm(4)/(error.svm(2)+error.svm(4));
        A.svm(i) = (error.svm(1)+error.svm(2))/sum(error.svm);
        P.svm(i) = error.svm(1)/(error.svm(1)+error.svm(4));
        R.svm(i) = error.svm(1)/(error.svm(1)+error.svm(3));
        F1score.svm(i) = 2*((P.svm(i)*R.svm(i))/(P.svm(i)+R.svm(i)));
    
        FPR.lgp(i) = error.lgp(4)/(error.lgp(2)+error.lgp(4));
        A.lgp(i) = (error.lgp(1)+error.lgp(2))/sum(error.lgp);
        P.lgp(i) = error.lgp(1)/(error.lgp(1)+error.lgp(4));
        R.lgp(i) = error.lgp(1)/(error.lgp(1)+error.lgp(3));
        F1score.lgp(i) = 2*((P.lgp(i)*R.lgp(i))/(P.lgp(i)+R.lgp(i)));

        FPR.mars(i) = error.mars(4)/(error.mars(2)+error.mars(4));
        A.mars(i) = (error.mars(1)+error.mars(2))/sum(error.mars);
        P.mars(i) = error.mars(1)/(error.mars(1)+error.mars(4));
        R.mars(i) = error.mars(1)/(error.mars(1)+error.mars(3));
        F1score.mars(i) = 2*((P.mars(i)*R.mars(i))/(P.mars(i)+R.mars(i)));
        
        FPR.combined(i) = error.combined(4)/(error.combined(2)+error.combined(4));
        A.combined(i) = (error.combined(1)+error.combined(2))/sum(error.combined);
        P.combined(i) = error.combined(1)/(error.combined(1)+error.combined(4));
        R.combined(i) = error.combined(1)/(error.combined(1)+error.combined(3));
        F1score.combined(i) = 2*((P.combined(i)*R.combined(i))/(P.combined(i)+R.combined(i)));
        

         fprintf('False Positive problematic indices :\n')
         FP.ALL
         fp_slmc_cv = intersect(intersect(intersect(FP.svm,FP.lgp),FP.mars),FP.combined)
         if ~isempty(fp_slmc_cv)
            fp_slmc = [fp_slmc; (fp_slmc_cv + (i-1)*size_CV)]
         end
         
         fp_g = intersect(fp_slmc_cv,FP.ALL)
         if ~isempty(fp_g)
            fp_general = [fp_general; (fp_g + (i-1)*size_CV)]
         end
         fprintf('False Negative problematic indices :\n')
         FN.ALL
         fn_slmc_cv = intersect(intersect(intersect(FN.svm,FN.lgp),FN.mars), FN.combined)
         if ~isempty(fn_slmc_cv)
            fn_slmc = [fn_slmc; (fn_slmc_cv + (i-1)*size_CV)]
         end
         fn_g = intersect(fn_slmc_cv,FN.ALL)
         if ~isempty(fn_g)
            fn_general = [fn_general; (fn_g + (i-1)*size_CV)]
         end
    end
    
    Jcv_svm_mean = mean(Jcv_svm)
    Jcv_ALL_mean = mean(Jcv_ALL)
    Jcv_lgp_mean = mean(Jcv_lgp)
    Jcv_mars_mean = mean(Jcv_mars)
    Jcv_combined_mean = mean(Jcv_combined)
    
    FPR_mean.ALL = mean(FPR.ALL);
    FPR_mean.svm = mean(FPR.svm);
    FPR_mean.lgp = mean(FPR.lgp);
    FPR_mean.mars = mean(FPR.mars);
    FPR_mean.combined = mean(FPR.combined);
    
    A_mean.ALL = mean(A.ALL);
    A_mean.svm = mean(A.svm);
    A_mean.lgp = mean(A.lgp);
    A_mean.mars = mean(A.mars);
    A_mean.combined = mean(A.combined);
     
    P_mean.ALL = mean(P.ALL);
    P_mean.svm = mean(P.svm);
    P_mean.lgp = mean(P.lgp);
    P_mean.mars = mean(P.mars);
    P_mean.combined = mean(P.combined);
    
    R_mean.ALL = mean(R.ALL);
    R_mean.svm = mean(R.svm);
    R_mean.lgp = mean(R.lgp);
    R_mean.mars = mean(R.mars);
    R_mean.combined = mean(R.combined);
    
    F1score_mean.ALL = mean(F1score.ALL);
    F1score_mean.svm = mean(F1score.svm);
    F1score_mean.lgp = mean(F1score.lgp);
    F1score_mean.mars = mean(F1score.mars);
    F1score_mean.combined = mean(F1score.combined);
    
    time_mean.training.ALL = mean(time.ALL.training);
    time_mean.cv.ALL = mean(time.ALL.cv);
    time_mean.training.svm = mean(time.svm.training);
    time_mean.cv.svm = mean(time.svm.cv);
    time_mean.training.lgp = mean(time.lgp.training);
    time_mean.cv.lgp = mean(time.lgp.cv);
    time_mean.training.mars = mean(time.mars.training);
    time_mean.cv.mars = mean(time.mars.cv);
    time_mean.training.combined = mean(time.combined.training);
    time_mean.cv.combined = mean(time.combined.cv);
    
    nb_fp_general = size(fp_general,1);
    nb_fn_general = size(fn_general,1);
    nb_fp_all = sum(fp_all);
    nb_fn_all = sum(fn_all);
    nb_fp_svm_lgp_mars_combined = size(fp_slmc,1);
    nb_fn_svm_lgp_mars_combined = size(fn_slmc,1);
    
    fprintf('ERROR ANALYSIS:\n');
    
    fprintf('False Positives\n');
    fprintf('ALL: %.1f\n',nb_fp_all);
    fprintf('Three algo with 5 features+combined: %.1f\n',nb_fp_svm_lgp_mars_combined);
    fprintf('General: %.1f\n',nb_fp_general);
    
    fprintf('False Negatives\n');
    fprintf('ALL: %.1f\n',nb_fn_all);
    fprintf('Three algo with 5 features+combined: %.1f\n',nb_fn_svm_lgp_mars_combined);
    fprintf('General: %.1f\n',nb_fn_general);
    
    fprintf('ALL:\n');
    
    fprintf('False Positive Rate: %.6f\n',FPR_mean.ALL);
    fprintf('Accuracy: %.6f\n',A_mean.ALL);
    fprintf('Precision: %.6f\n',P_mean.ALL);
    fprintf('Recall: %.6f\n',R_mean.ALL);
    fprintf('F1score: %.6f\n',F1score_mean.ALL);
    fprintf('Training time: %.6f\n',time_mean.training.ALL);
    fprintf('Prediction time: %.6f\n',time_mean.cv.ALL);
    
    
    fprintf('\nsvm:\n');
        
    fprintf('False Positive Rate: %.6f\n',FPR_mean.svm);
    fprintf('Accuracy: %.6f\n',A_mean.svm);
    fprintf('Precision: %.6f\n',P_mean.svm);
    fprintf('Recall: %.6f\n',R_mean.svm);
    fprintf('F1score: %.6f\n',F1score_mean.svm);
    fprintf('Training time: %.6f\n',time_mean.training.svm);
    fprintf('Prediction time: %.6f\n',time_mean.cv.svm);
    
    fprintf('\nlgp:\n');
        
    fprintf('False Positive Rate: %.6f\n',FPR_mean.lgp);
    fprintf('Accuracy: %.6f\n',A_mean.lgp);
    fprintf('Precision: %.6f\n',P_mean.lgp);
    fprintf('Recall: %.6f\n',R_mean.lgp);
    fprintf('F1score: %.6f\n',F1score_mean.lgp);
    fprintf('Training time: %.6f\n',time_mean.training.lgp);
    fprintf('Prediction time: %.6f\n',time_mean.cv.lgp);

    fprintf('\nmars:\n');

    fprintf('False Positive Rate: %.6f\n',FPR_mean.mars);
    fprintf('Accuracy: %.6f\n',A_mean.mars);
    fprintf('Precision: %.6f\n',P_mean.mars);
    fprintf('Recall: %.6f\n',R_mean.mars);
    fprintf('F1score: %.6f\n',F1score_mean.mars);
    fprintf('Training time: %.6f\n',time_mean.training.mars);
    fprintf('Prediction time: %.6f\n',time_mean.cv.mars);
    
    fprintf('\ncombined:\n');

    fprintf('False Positive Rate: %.6f\n',FPR_mean.combined);
    fprintf('Accuracy: %.6f\n',A_mean.combined);
    fprintf('Precision: %.6f\n',P_mean.combined);
    fprintf('Recall: %.6f\n',R_mean.combined);
    fprintf('F1score: %.6f\n',F1score_mean.combined);
    fprintf('Training time: %.6f\n',time_mean.training.combined);
    fprintf('Prediction time: %.6f\n',time_mean.cv.combined);
    
end
