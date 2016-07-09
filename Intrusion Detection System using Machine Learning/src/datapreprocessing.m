function [attack, normal_sample] = datapreprocessing(attack_dataset, normal_dataset, features)


attack_sample = datasample(attack_dataset, training_size, 'Replace', false);

normal_sample.attack = datasample(normal_dataset,size(attack_sample,1),'Replace',false);
normal_sample.attack_Y = normal_sample.attack(:,42);
normal_sample.attack_Y.label = zeros(size(normal_sample.attack_Y,1),1);
normal_sample.attack = normal_sample.attack(:,1:41);

attack.svm = attack_dataset(:,features.attack.svm);
attack.lgp = attack_dataset(:,features.attack.lgp);
attack.mars = attack_dataset(:,features.attack.mars);
attack.combined = attack_dataset(:,features.attack.combined);
attack.ALL = attack_dataset(:,1:41);

attack.Y = attack_dataset(:,42);
attack.Y.label = ones(size(attack.Y,1),1);

attack.svm_tr = cat(1,normal_sample.attack(:,features.attack.svm),attack.svm);
[attack.svm_tr idx] = datasample(attack.svm_tr,size(attack.svm_tr,1),'Replace',false);

attack.lgp_tr = cat(1,normal_sample.attack(:,features.attack.lgp),attack.lgp);
attack.lgp_tr = attack.lgp_tr(idx,:);
attack.mars_tr = cat(1,normal_sample.attack(:,features.attack.mars),attack.mars);
attack.mars_tr = attack.mars_tr(idx,:);
attack.combined_tr = cat(1,normal_sample.attack(:,features.attack.combined),attack.combined);
attack.combined_tr = attack.combined_tr(idx,:);
attack.ALL_tr = cat(1,normal_sample.attack,attack.ALL);
attack.ALL_tr = attack.ALL_tr(idx,:);

attack.Y_tr = cat(1,normal_sample.attack_Y,attack.Y);
attack.Y_tr = attack.Y_tr(idx,:);