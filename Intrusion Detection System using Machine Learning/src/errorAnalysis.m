function [fp_slmc fn_slmc] = errorAnalysis(FP, FN, error, time)

FPR.ALL = error.ALL(4)/(error.ALL(2)+error.ALL(4));
A.ALL = (error.ALL(1)+error.ALL(2))/sum(error.ALL);
P.ALL = error.ALL(1)/(error.ALL(1)+error.ALL(4));
R.ALL = error.ALL(1)/(error.ALL(1)+error.ALL(3));
F1score.ALL = 2*((P.ALL*R.ALL)/(P.ALL+R.ALL));

FPR.svm = error.svm(4)/(error.svm(2)+error.svm(4));
A.svm = (error.svm(1)+error.svm(2))/sum(error.svm);
P.svm = error.svm(1)/(error.svm(1)+error.svm(4));
R.svm = error.svm(1)/(error.svm(1)+error.svm(3));
F1score.svm = 2*((P.svm*R.svm)/(P.svm+R.svm));

FPR.lgp = error.lgp(4)/(error.lgp(2)+error.lgp(4));
A.lgp = (error.lgp(1)+error.lgp(2))/sum(error.lgp);
P.lgp = error.lgp(1)/(error.lgp(1)+error.lgp(4));
R.lgp = error.lgp(1)/(error.lgp(1)+error.lgp(3));
F1score.lgp = 2*((P.lgp*R.lgp)/(P.lgp+R.lgp));

FPR.mars = error.mars(4)/(error.mars(2)+error.mars(4));
A.mars = (error.mars(1)+error.mars(2))/sum(error.mars);
P.mars = error.mars(1)/(error.mars(1)+error.mars(4));
R.mars = error.mars(1)/(error.mars(1)+error.mars(3));
F1score.mars = 2*((P.mars*R.mars)/(P.mars+R.mars));

FPR.combined = error.combined(4)/(error.combined(2)+error.combined(4));
A.combined = (error.combined(1)+error.combined(2))/sum(error.combined);
P.combined = error.combined(1)/(error.combined(1)+error.combined(4));
R.combined = error.combined(1)/(error.combined(1)+error.combined(3));
F1score.combined = 2*((P.combined*R.combined)/(P.combined+R.combined));


fprintf('False Positive problematic indices :\n')
FP.ALL;
fp_slmc = intersect(intersect(intersect(FP.svm,FP.lgp),FP.mars),FP.combined);


fp_g = intersect(fp_slmc,FP.ALL);

fprintf('False Negative problematic indices :\n')
FN.ALL;
fn_slmc = intersect(intersect(intersect(FN.svm,FN.lgp),FN.mars), FN.combined);

fn_g = intersect(fn_slmc,FN.ALL);

fprintf('ERROR ANALYSIS:\n');
    
fprintf('False Positives\n');
fprintf('ALL: %.1f\n',size(FP.ALL,1));
fprintf('Three algo with 5 features+combined: %.1f\n',size(fp_slmc,1));
fprintf('General: %.1f\n',size(fp_g,1));

fprintf('False Negatives\n');
fprintf('ALL: %.1f\n',size(FN.ALL,1));
fprintf('Three algo with 5 features+combined: %.1f\n',size(fn_slmc,1));
fprintf('General: %.1f\n',size(fn_g,1));

fprintf('ALL:\n');

fprintf('False Positive Rate: %.6f\n',FPR.ALL);
fprintf('Accuracy: %.6f\n',A.ALL);
fprintf('Precision: %.6f\n',P.ALL);
fprintf('Recall: %.6f\n',R.ALL);
fprintf('F1score: %.6f\n',F1score.ALL);
fprintf('Training time: %.6f\n',time.ALL.training);
fprintf('Prediction time: %.6f\n',time.ALL.test);


fprintf('\nsvm:\n');

fprintf('False Positive Rate: %.6f\n',FPR.svm);
fprintf('Accuracy: %.6f\n',A.svm);
fprintf('Precision: %.6f\n',P.svm);
fprintf('Recall: %.6f\n',R.svm);
fprintf('F1score: %.6f\n',F1score.svm);
fprintf('Training time: %.6f\n',time.svm.training);
fprintf('Prediction time: %.6f\n',time.svm.test);

fprintf('\nlgp:\n');

fprintf('False Positive Rate: %.6f\n',FPR.lgp);
fprintf('Accuracy: %.6f\n',A.lgp);
fprintf('Precision: %.6f\n',P.lgp);
fprintf('Recall: %.6f\n',R.lgp);
fprintf('F1score: %.6f\n',F1score.lgp);
fprintf('Training time: %.6f\n',time.lgp.training);
fprintf('Prediction time: %.6f\n',time.lgp.test);

fprintf('\nmars:\n');

fprintf('False Positive Rate: %.6f\n',FPR.mars);
fprintf('Accuracy: %.6f\n',A.mars);
fprintf('Precision: %.6f\n',P.mars);
fprintf('Recall: %.6f\n',R.mars);
fprintf('F1score: %.6f\n',F1score.mars);
fprintf('Training time: %.6f\n',time.mars.training);
fprintf('Prediction time: %.6f\n',time.mars.test);

fprintf('\ncombined:\n');

fprintf('False Positive Rate: %.6f\n',FPR.combined);
fprintf('Accuracy: %.6f\n',A.combined);
fprintf('Precision: %.6f\n',P.combined);
fprintf('Recall: %.6f\n',R.combined);
fprintf('F1score: %.6f\n',F1score.combined);
fprintf('Training time: %.6f\n',time.combined.training);
fprintf('Prediction time: %.6f\n',time.combined.test);