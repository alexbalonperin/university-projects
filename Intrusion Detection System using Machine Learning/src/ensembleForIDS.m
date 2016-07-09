function ensembleForIDS(istesting, class, trainingset, testset)
clc;

features.r2l.svm = vertcat({'srv_count'},{'service'},{'duration'},{'count'},{'dst_host_count'});
features.r2l.lgp = vertcat({'is_guest_login'},{'num_access_files'},{'dst_bytes'},{'num_failed_logins'},{'logged_in'});
features.r2l.mars = vertcat({'srv_count'},{'service'},{'dst_host_srv_count'},{'count'},{'logged_in'});
features.r2l.combined = unique([features.r2l.svm,features.r2l.lgp,features.r2l.mars]);

features.probe.svm = vertcat({'src_bytes'},{'dst_host_srv_count'},{'count'},{'protocol_type'},{'srv_count'});
features.probe.lgp = vertcat({'srv_diff_host_rate'},{'rerror_rate'},{'dst_host_diff_srv_rate'},{'logged_in'},{'service'});
features.probe.mars = vertcat({'src_bytes'},{'dst_host_srv_count'},{'dst_host_diff_srv_rate'},{'dst_host_same_srv_rate'},{'srv_count'});
features.probe.combined = unique([features.probe.svm,features.probe.lgp,features.probe.mars]);

features.u2r.svm = vertcat({'src_bytes'},{'duration'},{'protocol_type'},{'logged_in'},{'flag'});
features.u2r.lgp = vertcat({'root_shell'},{'dst_host_srv_serror_rate'},{'num_file_creations'},{'serror_rate'},{'dst_host_same_src_port_rate'});
features.u2r.mars = vertcat({'duration'},{'dst_host_srv_count'},{'count'},{'dst_host_count'},{'srv_count'});
features.u2r.combined = unique([features.u2r.svm,features.u2r.lgp,features.u2r.mars]);

features.dos.svm = vertcat({'count'},{'srv_count'},{'dst_host_srv_serror_rate'},{'serror_rate'},{'dst_host_same_src_port_rate'});
features.dos.lgp = vertcat({'count'},{'num_compromised'},{'wrong_fragment'},{'land'},{'logged_in'});
features.dos.mars = vertcat({'count'},{'srv_count'},{'dst_host_srv_diff_host_rate'},{'src_bytes'},{'dst_bytes'});
features.dos.combined = unique([features.dos.svm,features.dos.lgp,features.dos.mars]);

training_size = 10000; 

if(istesting)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   Preparation of the TEST set for each class:
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %   The normal instances are concatenated with the instances of each class
    %   according to the number of instances of the class. The labels are
    %   replaced by '0' or '1' depending if the instance represent normal traffic or an attack.
    %   The case of DoS is a bit different since neptune and smurf account
    %   for most of the instances. With this setting, a random selection
    %   will be give a poor distribution of the variety of DoS attacks.
    %   Instead, we select a sample of 5000 instances from neptune attacks 
    %   and a sample of 5000 instances of smurf attacks. The instances of
    %   all the other types of attacks are included entirely. This lead to
    %   a test set for DoS attacks of size 17,761.
    
    %   DoS
    %%%%%%%%%%%%%%
    
    dos_size = 5000;
    neptune_testset = datasample(testset.dos(strmatch('neptune.',testset.dos.label),:),dos_size,'Replace',false);
    smurf_testset = datasample(testset.dos(strmatch('smurf.',testset.dos.label),:),dos_size,'Replace',false);
    dos_restOftestset = testset.dos([strmatch('apache2.',testset.dos.label);  strmatch('back.',testset.dos.label); ...
         strmatch('land.',testset.dos.label); strmatch('mailbomb.',testset.dos.label); strmatch('pod.',testset.dos.label);...
         strmatch('processtable.',testset.dos.label); strmatch('teardrop.',testset.dos.label); strmatch('udpstorm.',testset.dos.label)],:);
    
    %test set for dos attacks 
     
    dos_test = cat(1,neptune_testset,smurf_testset, dos_restOftestset);
    normal_test.dos = datasample(testset.normal,size(dos_test,1),'Replace', false);
    original_test.dos = cat(1,normal_test.dos,dos_test);
    
    %Modify the normal labels
    
    normal_test.dos_Y = normal_test.dos(:,42);
    normal_test.dos_Y.label = zeros(size(normal_test.dos_Y,1),1);
    normal_test.dos = normal_test.dos(:,1:41);
    
    %Modify the DoS labels
    
    dos.Y = dos_test(:,42);
    dos.Y.label = ones(size(dos.Y,1),1);
    dos_test = dos_test(:,1:41);
    
    %concat normal and DoS labels
    dos.Y_ts = cat(1,normal_test.dos_Y,dos.Y);
    
    %concat normal and DoS examples
    dos.X_ts = cat(1,normal_test.dos,dos_test);
    
    %shuffle both examples and labels
    [dos.X_ts idx] = datasample(dos.X_ts,size(dos.X_ts,1),'Replace',false);
    dos.Y_ts = dos.Y_ts(idx,:);
    
    %shuffle the original dataset with all the different labels 
    original_test.dos = original_test.dos(idx,:);
    
    %select the features for each algorithm
    
    dos.svm.X_ts = dos.X_ts(:,features.dos.svm);
    dos.lgp.X_ts = dos.X_ts(:,features.dos.lgp);
    dos.mars.X_ts = dos.X_ts(:,features.dos.mars);
    dos.combined.X_ts = dos.X_ts(:,features.dos.combined);
    dos.ALL.X_ts = dos.X_ts(:,1:41);
    
    
    %   R2L
    %%%%%%%%%%%%%%%%
    
    %test set for r2l attacks
    
    normal_test.r2l = datasample(testset.normal,size(testset.r2l,1),'Replace', false);
    original_test.r2l = cat(1,normal_test.r2l,testset.r2l);

    %Modify the normal labels
    
    normal_test.r2l_Y = normal_test.r2l(:,42);
    normal_test.r2l_Y.label = zeros(size(normal_test.r2l_Y,1),1);
    normal_test.r2l = normal_test.r2l(:,1:41);
    
    %Modify the r2l labels
    
    r2l.Y = testset.r2l(:,42);
    r2l.Y.label = ones(size(r2l.Y,1),1);
    testset.r2l = testset.r2l(:,1:41);
    
    %concat normal and r2l labels
    r2l.Y_ts = cat(1,normal_test.r2l_Y,r2l.Y);
    
    %concat normal and r2l examples
    r2l.X_ts = cat(1,normal_test.r2l,testset.r2l);
    
    %shuffle both examples and labels
    [r2l.X_ts idx] = datasample(r2l.X_ts,size(r2l.X_ts,1),'Replace',false);
    r2l.Y_ts = r2l.Y_ts(idx,:);
    
    %shuffle the original dataset with all the different labels 
    original_test.r2l = original_test.r2l(idx,:);
    
    %select the features for each algorithm
    
    r2l.svm.X_ts = r2l.X_ts(:,features.r2l.svm);
    r2l.lgp.X_ts = r2l.X_ts(:,features.r2l.lgp);
    r2l.mars.X_ts = r2l.X_ts(:,features.r2l.mars);
    r2l.combined.X_ts = r2l.X_ts(:,features.r2l.combined);
    r2l.ALL.X_ts = r2l.X_ts(:,1:41);
    
    
    
    %   U2R
    %%%%%%%%%%%%%%%%
    
    %test set for u2r attacks
    
    normal_test.u2r = datasample(testset.normal,size(testset.u2r,1),'Replace', false);
    original_test.u2r = cat(1,normal_test.u2r,testset.u2r);
    
    %Modify the normal labels

    normal_test.u2r_Y = normal_test.u2r(:,42);
    normal_test.u2r_Y.label = zeros(size(normal_test.u2r_Y,1),1);
    normal_test.u2r = normal_test.u2r(:,1:41);
    
    %Modify the u2r labels
    
    u2r.Y = testset.u2r(:,42);
    u2r.Y.label = ones(size(u2r.Y,1),1);
    testset.u2r = testset.u2r(:,1:41);
    
    %concat normal and u2r labels
    u2r.Y_ts = cat(1,normal_test.u2r_Y,u2r.Y);
    
    %concat normal and u2r examples
    u2r.X_ts = cat(1,normal_test.u2r,testset.u2r);
    
    %shuffle both examples and labels
    [u2r.X_ts idx] = datasample(u2r.X_ts,size(u2r.X_ts,1),'Replace',false);
    u2r.Y_ts = u2r.Y_ts(idx,:);
    
    %shuffle the original dataset with all the different labels 
    original_test.u2r = original_test.u2r(idx,:);
    
    %select the features for each algorithm
    
    u2r.svm.X_ts = u2r.X_ts(:,features.u2r.svm);
    u2r.lgp.X_ts = u2r.X_ts(:,features.u2r.lgp);
    u2r.mars.X_ts = u2r.X_ts(:,features.u2r.mars);
    u2r.combined.X_ts = u2r.X_ts(:,features.u2r.combined);
    u2r.ALL.X_ts = u2r.X_ts(:,1:41);
    
    
    %   Probe
    %%%%%%%%%%%%%%%%
    
    %test set for probe attacks
    
    normal_test.probe = datasample(testset.normal,size(testset.probe,1),'Replace', false);
    original_test.probe = cat(1,normal_test.probe,testset.probe);

    %Modify the normal labels
    
    normal_test.probe_Y = normal_test.probe(:,42);
    normal_test.probe_Y.label = zeros(size(normal_test.probe_Y,1),1);
    normal_test.probe = normal_test.probe(:,1:41);
    
    %Modify the probe labels
    
    probe.Y = testset.probe(:,42);
    probe.Y.label = ones(size(probe.Y,1),1);
    testset.probe = testset.probe(:,1:41);
    
    %concat normal and probe labels
    probe.Y_ts = cat(1,normal_test.probe_Y,probe.Y);
    
    %concat normal and probe examples
    probe.X_ts = cat(1,normal_test.probe,testset.probe);
    
    %shuffle both examples and labels
    [probe.X_ts idx] = datasample(probe.X_ts,size(probe.X_ts,1),'Replace',false);
    probe.Y_ts = probe.Y_ts(idx,:);
    
    %shuffle the original dataset with all the different labels 
    original_test.probe = original_test.probe(idx,:);
    
    %select the features for each algorithm
    
    probe.svm.X_ts = probe.X_ts(:,features.probe.svm);
    probe.lgp.X_ts = probe.X_ts(:,features.probe.lgp);
    probe.mars.X_ts = probe.X_ts(:,features.probe.mars);
    probe.combined.X_ts = probe.X_ts(:,features.probe.combined);
    probe.ALL.X_ts = probe.X_ts(:,1:41);
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   Preparation of the TRAINING set for each class:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   The normal instances are concatenated with the instances of each class
%   according to the number of instances of the class. The labels are
%   replaced by '0' or '1' depending if the instance represent normal traffic or an attack. 

%   R2L
%%%%%%%%%%%%%%%%%%%%

%training set for r2l attacks

normal_sample.r2l = datasample(trainingset.normal,size(trainingset.r2l,1),'Replace',false);
original_training.r2l = cat(1, normal_sample.r2l,trainingset.r2l);

%Modify the normal labels

normal_sample.r2l_Y = normal_sample.r2l(:,42);
normal_sample.r2l_Y.label = zeros(size(normal_sample.r2l_Y,1),1);
normal_sample.r2l = normal_sample.r2l(:,1:41);

%Modify the r2l labels

r2l.Y = trainingset.r2l(:,42);
r2l.Y.label = ones(size(r2l.Y,1),1);
r2l_trainingset = trainingset.r2l(:,1:41);

%concat normal and r2l labels
r2l.Y_tr = cat(1,normal_sample.r2l_Y,r2l.Y);

%concat normal and r2l examples
r2l.X_tr = cat(1,normal_sample.r2l,r2l_trainingset);

%shuffle both examples and labels
[r2l.X_tr idx] = datasample(r2l.X_tr,size(r2l.X_tr,1),'Replace',false);
r2l.Y_tr = r2l.Y_tr(idx,:);

%shuffle the original dataset with all the different labels 
original_training.r2l = original_training.r2l(idx,:);

%select the features for each algorithm

r2l.svm.X_tr = r2l.X_tr(:,features.r2l.svm);
r2l.lgp.X_tr = r2l.X_tr(:,features.r2l.lgp);
r2l.mars.X_tr = r2l.X_tr(:,features.r2l.mars);
r2l.combined.X_tr = r2l.X_tr(:,features.r2l.combined);
r2l.ALL.X_tr = r2l.X_tr(:,1:41);
    
%   U2R
%%%%%%%%%%%%%%%%%%%%

%training set for u2r attacks

normal_sample.u2r = datasample(trainingset.normal,size(trainingset.u2r,1),'Replace',false);
original_training.u2r = cat(1, normal_sample.u2r,trainingset.u2r);

%Modify the normal labels

normal_sample.u2r_Y = normal_sample.u2r(:,42);
normal_sample.u2r_Y.label = zeros(size(normal_sample.u2r_Y,1),1);
normal_sample.u2r = normal_sample.u2r(:,1:41);

%Modify the u2r labels

u2r.Y = trainingset.u2r(:,42);
u2r.Y.label = ones(size(u2r.Y,1),1);
u2r_trainingset = trainingset.u2r(:,1:41);

%concat normal and u2r labels
u2r.Y_tr = cat(1,normal_sample.u2r_Y,u2r.Y);

%concat normal and u2r examples
u2r.X_tr = cat(1,normal_sample.u2r,u2r_trainingset);

%shuffle both examples and labels
[u2r.X_tr idx] = datasample(u2r.X_tr,size(u2r.X_tr,1),'Replace',false);
u2r.Y_tr = u2r.Y_tr(idx,:);

%shuffle the original dataset with all the different labels 
original_training.u2r = original_training.u2r(idx,:);

%select the features for each algorithm

u2r.svm.X_tr = u2r.X_tr(:,features.u2r.svm);
u2r.lgp.X_tr = u2r.X_tr(:,features.u2r.lgp);
u2r.mars.X_tr = u2r.X_tr(:,features.u2r.mars);
u2r.combined.X_tr = u2r.X_tr(:,features.u2r.combined);
u2r.ALL.X_tr = u2r.X_tr(:,1:41);


%   Probe
%%%%%%%%%%%%%%%%%%%%%%%%%%

%training set for probe attacks

probe_sample = datasample(trainingset.probe,training_size,'Replace',false);
normal_sample.probe = datasample(trainingset.normal,size(probe_sample,1),'Replace',false);
original_training.probe = cat(1, normal_sample.probe,probe_sample);

%Modify the normal labels

normal_sample.probe_Y = normal_sample.probe(:,42);
normal_sample.probe_Y.label = zeros(size(normal_sample.probe_Y,1),1);
normal_sample.probe = normal_sample.probe(:,1:41);

%Modify the probe labels

probe.Y = probe_sample(:,42);
probe.Y.label = ones(size(probe.Y,1),1);
probe_trainingset = probe_sample(:,1:41);

%concat normal and probe labels
probe.Y_tr = cat(1,normal_sample.probe_Y,probe.Y);

%concat normal and probe examples
probe.X_tr = cat(1,normal_sample.probe,probe_trainingset);

%shuffle both examples and labels
[probe.X_tr idx] = datasample(probe.X_tr,size(probe.X_tr,1),'Replace',false);
probe.Y_tr = probe.Y_tr(idx,:);

%shuffle the original dataset with all the different labels 
original_training.probe = original_training.probe(idx,:);

%select the features for each algorithm

probe.svm.X_tr = probe.X_tr(:,features.probe.svm);
probe.lgp.X_tr = probe.X_tr(:,features.probe.lgp);
probe.mars.X_tr = probe.X_tr(:,features.probe.mars);
probe.combined.X_tr = probe.X_tr(:,features.probe.combined);
probe.ALL.X_tr = probe.X_tr(:,1:41);


%   DoS
%%%%%%%%%%%%%%%%%%%%%%%%%%

%training set for DoS attacks

dos_size = 5000;
neptune_trainingset = datasample(trainingset.dos(strmatch('neptune.',trainingset.dos.label),:),dos_size,'Replace',false);
smurf_trainingset = datasample(trainingset.dos(strmatch('smurf.',trainingset.dos.label),:),dos_size,'Replace',false);
dos_restOftrainingset = trainingset.dos([strmatch('back.',trainingset.dos.label);  strmatch('land.',trainingset.dos.label); ...
     strmatch('pod.',trainingset.dos.label); strmatch('teardrop.',trainingset.dos.label)],:);

dos_sample = cat(1,neptune_trainingset,smurf_trainingset,dos_restOftrainingset);
normal_sample.dos = datasample(trainingset.normal,size(dos_sample,1),'Replace',false);
original_training.dos = cat(1, normal_sample.dos,dos_sample);

%Modify the normal labels

normal_sample.dos_Y = normal_sample.dos(:,42);
normal_sample.dos_Y.label = zeros(size(normal_sample.dos_Y,1),1);
normal_sample.dos = normal_sample.dos(:,1:41);

%Modify the dos labels

dos.Y = dos_sample(:,42);
dos.Y.label = ones(size(dos.Y,1),1);
dos_trainingset = dos_sample(:,1:41);

%concat normal and dos labels
dos.Y_tr = cat(1,normal_sample.dos_Y,dos.Y);

%concat normal and dos examples
dos.X_tr = cat(1,normal_sample.dos,dos_trainingset);

%shuffle both examples and labels
[dos.X_tr idx] = datasample(dos.X_tr,size(dos.X_tr,1),'Replace',false);
dos.Y_tr = dos.Y_tr(idx,:);

%shuffle the original dataset with all the different labels 
original_training.dos = original_training.dos(idx,:);

%select the features for each algorithm

dos.svm.X_tr = dos.X_tr(:,features.dos.svm);
dos.lgp.X_tr = dos.X_tr(:,features.dos.lgp);
dos.mars.X_tr = dos.X_tr(:,features.dos.mars);
dos.combined.X_tr = dos.X_tr(:,features.dos.combined);
dos.ALL.X_tr = dos.X_tr(:,1:41);


if(~istesting)
    switch(class)
        case 'u2r'
            [FPR_mean A_mean P_mean R_mean F1score_mean time_mean fp_slmc.u2r fn_slmc.u2r] = cv(u2r.svm.X_tr, u2r.lgp.X_tr, u2r.mars.X_tr, u2r.ALL.X_tr, u2r.combined.X_tr, u2r.Y_tr);
            fn_slmc.u2r
            fp_slmc.u2r
            %original_training.u2r(fp_slmc.u2r,:)
            original_training.u2r(fn_slmc.u2r,42)
            unique(original_training.u2r.label)
            unique(trainingset.u2r.label)
            
        case 'r2l'
            [FPR_mean A_mean P_mean R_mean F1score_mean time_mean fp_slmc.r2l fn_slmc.r2l] = cv(r2l.svm.X_tr, r2l.lgp.X_tr, r2l.mars.X_tr, r2l.ALL.X_tr, r2l.combined.X_tr, r2l.Y_tr);
            fn_slmc.r2l
            fp_slmc.r2l
            original_training.r2l(fn_slmc.r2l, [features.probe.combined ; {'label'}])
            unique(original_training.r2l.label)
            unique(trainingset.r2l.label)
        case 'probe'
            [FPR_mean A_mean P_mean R_mean F1score_mean time_mean fp_slmc.probe fn_slmc.probe] = cv(probe.svm.X_tr, probe.lgp.X_tr, probe.mars.X_tr, probe.ALL.X_tr, probe.combined.X_tr, probe.Y_tr);
            fn_slmc.probe
            fp_slmc.probe
            original_training.probe(fn_slmc.probe, [features.probe.combined ; {'label'}])

        case 'dos'
            [FPR_mean A_mean P_mean R_mean F1score_mean time_mean fp_slmc.dos fn_slmc.dos] = cv(dos.svm.X_tr, dos.lgp.X_tr, dos.mars.X_tr, dos.ALL.X_tr, dos.combined.X_tr, dos.Y_tr);
            fn_slmc
            fp_slmc
            original_training.dos(fn_slmc.dos,42)
            unique(original_training.dos.label)
            unique(trainingset.dos.label)
        case 'all'
            
    end
    
else
    
    fprintf('Testing the ensemble....');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   User to Root
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\nUSER TO ROOT\n')
    
    u2r.ALL.X_tr = normc(double(u2r.ALL.X_tr));
    u2r.svm.X_tr = normc(double(u2r.svm.X_tr));
    u2r.lgp.X_tr = normc(double(u2r.lgp.X_tr));
    u2r.mars.X_tr = normc(double(u2r.mars.X_tr));
    u2r.combined.X_tr = normc(double(u2r.combined.X_tr));
    
    u2r.ALL.X_ts = normc(double(u2r.ALL.X_ts));
    u2r.svm.X_ts = normc(double(u2r.svm.X_ts));
    u2r.lgp.X_ts = normc(double(u2r.lgp.X_ts));
    u2r.mars.X_ts = normc(double(u2r.mars.X_ts));
    u2r.combined.X_ts = normc(double(u2r.combined.X_ts));
    
    u2r.Y_tr = u2r.Y_tr.label;
    u2r.Y_ts = u2r.Y_ts.label;
    
    %   ALL
    %%%%%%%%%%%%%%%
    tic
    
    u2r.model_ALL = ClassificationTree.fit(u2r.ALL.X_tr,u2r.Y_tr);
    time.u2r.ALL.training = toc;
    tic
    h = predict(u2r.model_ALL,u2r.ALL.X_ts);
    time.u2r.ALL.test = toc;
    error.u2r.ALL = [sum(h == u2r.Y_ts & u2r.Y_ts == 1),sum(h == u2r.Y_ts & u2r.Y_ts == 0),sum(h ~= u2r.Y_ts & u2r.Y_ts == 1),sum(h ~= u2r.Y_ts & u2r.Y_ts == 0)];
    FP.u2r.ALL = find(h ~= u2r.Y_ts & u2r.Y_ts == 0);
    FN.u2r.ALL = find(h ~= u2r.Y_ts & u2r.Y_ts == 1);
    fp.u2r.all = error.u2r.ALL(4);
    fn.u2r.all = error.u2r.ALL(3);
    
    %   SVM
    %%%%%%%%%%%%%%
    
    tic
    u2r.model_svm = ClassificationTree.fit(u2r.svm.X_tr,u2r.Y_tr);
    time.u2r.svm.training = toc;
    tic
    h = predict(u2r.model_svm,u2r.svm.X_ts);
    time.u2r.svm.test = toc;
    error.u2r.svm = [sum(h == u2r.Y_ts & u2r.Y_ts == 1),sum(h == u2r.Y_ts & u2r.Y_ts == 0),sum(h ~= u2r.Y_ts & u2r.Y_ts == 1),sum(h ~= u2r.Y_ts & u2r.Y_ts == 0)];
    FP.u2r.svm = find(h ~= u2r.Y_ts & u2r.Y_ts == 0);
    FN.u2r.svm = find(h ~= u2r.Y_ts & u2r.Y_ts == 1);
    fp.u2r.svm = error.u2r.svm(4);
    fn.u2r.svm = error.u2r.svm(3);
    
    %   LGP
    %%%%%%%%%%%%%
    
    tic
    u2r.model_lgp = ClassificationTree.fit(u2r.lgp.X_tr,u2r.Y_tr);
    time.u2r.lgp.training = toc;
    tic
    h = predict(u2r.model_lgp,u2r.lgp.X_ts);
    time.u2r.lgp.test = toc;
    error.u2r.lgp = [sum(h == u2r.Y_ts & u2r.Y_ts == 1),sum(h == u2r.Y_ts & u2r.Y_ts == 0),sum(h ~= u2r.Y_ts & u2r.Y_ts == 1),sum(h ~= u2r.Y_ts & u2r.Y_ts == 0)];
    FP.u2r.lgp = find(h ~= u2r.Y_ts & u2r.Y_ts == 0);
    FN.u2r.lgp = find(h ~= u2r.Y_ts & u2r.Y_ts == 1);
    fp.u2r.lgp = error.u2r.lgp(4);
    fn.u2r.lgp = error.u2r.lgp(3);
    
    %   MARS
    %%%%%%%%%%%%%
    
    tic
    u2r.model_mars = ClassificationTree.fit(u2r.mars.X_tr,u2r.Y_tr);
    time.u2r.mars.training = toc;
    tic
    h = predict(u2r.model_mars,u2r.mars.X_ts);
    time.u2r.mars.test = toc;
    error.u2r.mars = [sum(h == u2r.Y_ts & u2r.Y_ts == 1),sum(h == u2r.Y_ts & u2r.Y_ts == 0),sum(h ~= u2r.Y_ts & u2r.Y_ts == 1),sum(h ~= u2r.Y_ts & u2r.Y_ts == 0)];
    FP.u2r.mars = find(h ~= u2r.Y_ts & u2r.Y_ts == 0);
    FN.u2r.mars = find(h ~= u2r.Y_ts & u2r.Y_ts == 1);
    fp.u2r.mars = error.u2r.mars(4);
    fn.u2r.mars = error.u2r.mars(3);
    
    %   COMBINED
    %%%%%%%%%%%%%
    
    tic
    u2r.model_combined = ClassificationTree.fit(u2r.combined.X_tr,u2r.Y_tr);
    time.u2r.combined.training = toc;
    tic
    h = predict(u2r.model_combined,u2r.combined.X_ts);
    time.u2r.combined.test = toc;
    error.u2r.combined = [sum(h == u2r.Y_ts & u2r.Y_ts == 1),sum(h == u2r.Y_ts & u2r.Y_ts == 0),sum(h ~= u2r.Y_ts & u2r.Y_ts == 1),sum(h ~= u2r.Y_ts & u2r.Y_ts == 0)];
    FP.u2r.combined = find(h ~= u2r.Y_ts & u2r.Y_ts == 0);
    FN.u2r.combined = find(h ~= u2r.Y_ts & u2r.Y_ts == 1);
    fp.u2r.combined = error.u2r.combined(4);
    fn.u2r.combined = error.u2r.combined(3);
    
    [u2r.fp_slmc u2r.fn_slmc] = errorAnalysis(FP.u2r, FN.u2r, error.u2r, time.u2r);
    
    fprintf('\nProblematic Attacks\n')
    
    fprintf('buffer_overflow: %.1f\n',size(strmatch('buffer_overflow.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('loadmodule: %.1f\n',size(strmatch('loadmodule.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('perl: %.1f\n',size(strmatch('perl.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('ps: %.1f\n',size(strmatch('ps.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('rootkit: %.1f\n',size(strmatch('rootkit.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('sqlattack: %.1f\n',size(strmatch('sqlattack.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    fprintf('xterm: %.1f\n',size(strmatch('xterm.',original_test.u2r.label(u2r.fn_slmc,:)),1));
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   Remote to Local
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\nREMOTE TO LOCAL\n')
    
    r2l.ALL.X_tr = normc(double(r2l.ALL.X_tr));
    r2l.svm.X_tr = normc(double(r2l.svm.X_tr));
    r2l.lgp.X_tr = normc(double(r2l.lgp.X_tr));
    r2l.mars.X_tr = normc(double(r2l.mars.X_tr));
    r2l.combined.X_tr = normc(double(r2l.combined.X_tr));
    
    r2l.ALL.X_ts = normc(double(r2l.ALL.X_ts));
    r2l.svm.X_ts = normc(double(r2l.svm.X_ts));
    r2l.lgp.X_ts = normc(double(r2l.lgp.X_ts));
    r2l.mars.X_ts = normc(double(r2l.mars.X_ts));
    r2l.combined.X_ts = normc(double(r2l.combined.X_ts));
    
    r2l.Y_tr = r2l.Y_tr.label;
    r2l.Y_ts = r2l.Y_ts.label;
    
    %   ALL
    %%%%%%%%%%%%%%%
    tic
    r2l.model_ALL = ClassificationTree.fit(r2l.ALL.X_tr,r2l.Y_tr);
    time.r2l.ALL.training = toc;
    tic
    h = predict(r2l.model_ALL,r2l.ALL.X_ts);
    time.r2l.ALL.test = toc;
    error.r2l.ALL = [sum(h == r2l.Y_ts & r2l.Y_ts == 1),sum(h == r2l.Y_ts & r2l.Y_ts == 0),sum(h ~= r2l.Y_ts & r2l.Y_ts == 1),sum(h ~= r2l.Y_ts & r2l.Y_ts == 0)];
    FP.r2l.ALL = find(h ~= r2l.Y_ts & r2l.Y_ts == 0);
    FN.r2l.ALL = find(h ~= r2l.Y_ts & r2l.Y_ts == 1);
    fp.r2l.all = error.r2l.ALL(4);
    fn.r2l.all = error.r2l.ALL(3);
    
    %   SVM
    %%%%%%%%%%%%%%
    
    tic
    r2l.model_svm = ClassificationTree.fit(r2l.svm.X_tr,r2l.Y_tr);
    time.r2l.svm.training = toc;
    tic
    h = predict(r2l.model_svm,r2l.svm.X_ts);
    time.r2l.svm.test = toc;
    error.r2l.svm = [sum(h == r2l.Y_ts & r2l.Y_ts == 1),sum(h == r2l.Y_ts & r2l.Y_ts == 0),sum(h ~= r2l.Y_ts & r2l.Y_ts == 1),sum(h ~= r2l.Y_ts & r2l.Y_ts == 0)];
    FP.r2l.svm = find(h ~= r2l.Y_ts & r2l.Y_ts == 0);
    FN.r2l.svm = find(h ~= r2l.Y_ts & r2l.Y_ts == 1);
    fp.r2l.svm = error.r2l.svm(4);
    fn.r2l.svm = error.r2l.svm(3);
    
    %   LGP
    %%%%%%%%%%%%%
    
    tic
    r2l.model_lgp = ClassificationTree.fit(r2l.lgp.X_tr,r2l.Y_tr);
    time.r2l.lgp.training = toc;
    tic
    h = predict(r2l.model_lgp,r2l.lgp.X_ts);
    time.r2l.lgp.test = toc;
    error.r2l.lgp = [sum(h == r2l.Y_ts & r2l.Y_ts == 1),sum(h == r2l.Y_ts & r2l.Y_ts == 0),sum(h ~= r2l.Y_ts & r2l.Y_ts == 1),sum(h ~= r2l.Y_ts & r2l.Y_ts == 0)];
    FP.r2l.lgp = find(h ~= r2l.Y_ts & r2l.Y_ts == 0);
    FN.r2l.lgp = find(h ~= r2l.Y_ts & r2l.Y_ts == 1);
    fp.r2l.lgp = error.r2l.lgp(4);
    fn.r2l.lgp = error.r2l.lgp(3);
    
    %   MARS
    %%%%%%%%%%%%%
    
    tic
    r2l.model_mars = ClassificationTree.fit(r2l.mars.X_tr,r2l.Y_tr);
    time.r2l.mars.training = toc;
    tic
    h = predict(r2l.model_mars,r2l.mars.X_ts);
    time.r2l.mars.test = toc;
    error.r2l.mars = [sum(h == r2l.Y_ts & r2l.Y_ts == 1),sum(h == r2l.Y_ts & r2l.Y_ts == 0),sum(h ~= r2l.Y_ts & r2l.Y_ts == 1),sum(h ~= r2l.Y_ts & r2l.Y_ts == 0)];
    FP.r2l.mars = find(h ~= r2l.Y_ts & r2l.Y_ts == 0);
    FN.r2l.mars = find(h ~= r2l.Y_ts & r2l.Y_ts == 1);
    fp.r2l.mars = error.r2l.mars(4);
    fn.r2l.mars = error.r2l.mars(3);
    
    %   COMBINED
    %%%%%%%%%%%%%
    
    tic
    r2l.model_combined = ClassificationTree.fit(r2l.combined.X_tr,r2l.Y_tr);
    time.r2l.combined.training = toc;
    tic
    h = predict(r2l.model_combined,r2l.combined.X_ts);
    time.r2l.combined.test = toc;
    error.r2l.combined = [sum(h == r2l.Y_ts & r2l.Y_ts == 1),sum(h == r2l.Y_ts & r2l.Y_ts == 0),sum(h ~= r2l.Y_ts & r2l.Y_ts == 1),sum(h ~= r2l.Y_ts & r2l.Y_ts == 0)];
    FP.r2l.combined = find(h ~= r2l.Y_ts & r2l.Y_ts == 0);
    FN.r2l.combined = find(h ~= r2l.Y_ts & r2l.Y_ts == 1);
    fp.r2l.combined = error.r2l.combined(4);
    fn.r2l.combined = error.r2l.combined(3);
    
    [r2l.fp_slmc r2l.fn_slmc] = errorAnalysis(FP.r2l, FN.r2l, error.r2l, time.r2l);
    
    fprintf('\nProblematic Attacks\n')
    
    fprintf('ftp_write: %.1f\n',size(strmatch('ftp_write.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('guess_passwd: %.1f\n',size(strmatch('guess_passwd.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('httptunnel: %.1f\n',size(strmatch('httptunnel.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('imap: %.1f\n',size(strmatch('imap.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('multihop: %.1f\n',size(strmatch('multihop.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('named: %.1f\n',size(strmatch('named.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('xsnoop: %.1f\n',size(strmatch('xsnoop.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('phf: %.1f\n',size(strmatch('phf.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('sendmail: %.1f\n',size(strmatch('sendmail.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('snmpgetattack: %.1f\n',size(strmatch('snmpgetattack.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('snmpguess: %.1f\n',size(strmatch('snmpguess.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('warezmaster: %.1f\n',size(strmatch('warezmaster.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('worm: %.1f\n',size(strmatch('worm.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    fprintf('xlock: %.1f\n',size(strmatch('xlock.',original_test.r2l.label(r2l.fn_slmc,:)),1));
    
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   Probe
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\nPROBE\n')
    
    probe.ALL.X_tr = normc(double(probe.ALL.X_tr));
    probe.svm.X_tr = normc(double(probe.svm.X_tr));
    probe.lgp.X_tr = normc(double(probe.lgp.X_tr));
    probe.mars.X_tr = normc(double(probe.mars.X_tr));
    probe.combined.X_tr = normc(double(probe.combined.X_tr));
    
    probe.ALL.X_ts = normc(double(probe.ALL.X_ts));
    probe.svm.X_ts = normc(double(probe.svm.X_ts));
    probe.lgp.X_ts = normc(double(probe.lgp.X_ts));
    probe.mars.X_ts = normc(double(probe.mars.X_ts));
    probe.combined.X_ts = normc(double(probe.combined.X_ts));
    
    probe.Y_tr = probe.Y_tr.label;
    probe.Y_ts = probe.Y_ts.label;
    
    %   ALL
    %%%%%%%%%%%%%%%
    tic
    probe.model_ALL = ClassificationTree.fit(probe.ALL.X_tr,probe.Y_tr);
    time.probe.ALL.training = toc;
    tic
    h = predict(probe.model_ALL,probe.ALL.X_ts);
    time.probe.ALL.test = toc;
    error.probe.ALL = [sum(h == probe.Y_ts & probe.Y_ts == 1),sum(h == probe.Y_ts & probe.Y_ts == 0),sum(h ~= probe.Y_ts & probe.Y_ts == 1),sum(h ~= probe.Y_ts & probe.Y_ts == 0)];
    FP.probe.ALL = find(h ~= probe.Y_ts & probe.Y_ts == 0);
    FN.probe.ALL = find(h ~= probe.Y_ts & probe.Y_ts == 1);
    fp.probe.all = error.probe.ALL(4);
    fn.probe.all = error.probe.ALL(3);
    
    %   SVM
    %%%%%%%%%%%%%%
    
    tic
    probe.model_svm = ClassificationTree.fit(probe.svm.X_tr,probe.Y_tr);
    time.probe.svm.training = toc;
    tic
    h = predict(probe.model_svm,probe.svm.X_ts);
    time.probe.svm.test = toc;
    error.probe.svm = [sum(h == probe.Y_ts & probe.Y_ts == 1),sum(h == probe.Y_ts & probe.Y_ts == 0),sum(h ~= probe.Y_ts & probe.Y_ts == 1),sum(h ~= probe.Y_ts & probe.Y_ts == 0)];
    FP.probe.svm = find(h ~= probe.Y_ts & probe.Y_ts == 0);
    FN.probe.svm = find(h ~= probe.Y_ts & probe.Y_ts == 1);
    fp.probe.svm = error.probe.svm(4);
    fn.probe.svm = error.probe.svm(3);
    
    %   LGP
    %%%%%%%%%%%%%
    
    tic
    probe.model_lgp = ClassificationTree.fit(probe.lgp.X_tr,probe.Y_tr);
    time.probe.lgp.training = toc;
    tic
    h = predict(probe.model_lgp,probe.lgp.X_ts);
    time.probe.lgp.test = toc;
    error.probe.lgp = [sum(h == probe.Y_ts & probe.Y_ts == 1),sum(h == probe.Y_ts & probe.Y_ts == 0),sum(h ~= probe.Y_ts & probe.Y_ts == 1),sum(h ~= probe.Y_ts & probe.Y_ts == 0)];
    FP.probe.lgp = find(h ~= probe.Y_ts & probe.Y_ts == 0);
    FN.probe.lgp = find(h ~= probe.Y_ts & probe.Y_ts == 1);
    fp.probe.lgp = error.probe.lgp(4);
    fn.probe.lgp = error.probe.lgp(3);
    
    %   MARS
    %%%%%%%%%%%%%
    
    tic
    probe.model_mars = ClassificationTree.fit(probe.mars.X_tr,probe.Y_tr);
    time.probe.mars.training = toc;
    tic
    h = predict(probe.model_mars,probe.mars.X_ts);
    time.probe.mars.test = toc;
    error.probe.mars = [sum(h == probe.Y_ts & probe.Y_ts == 1),sum(h == probe.Y_ts & probe.Y_ts == 0),sum(h ~= probe.Y_ts & probe.Y_ts == 1),sum(h ~= probe.Y_ts & probe.Y_ts == 0)];
    FP.probe.mars = find(h ~= probe.Y_ts & probe.Y_ts == 0);
    FN.probe.mars = find(h ~= probe.Y_ts & probe.Y_ts == 1);
    fp.probe.mars = error.probe.mars(4);
    fn.probe.mars = error.probe.mars(3);
    
    %   COMBINED
    %%%%%%%%%%%%%
    
    tic
    probe.model_combined = ClassificationTree.fit(probe.combined.X_tr,probe.Y_tr);
    time.probe.combined.training = toc;
    tic
    h = predict(probe.model_combined,probe.combined.X_ts);
    time.probe.combined.test = toc;
    error.probe.combined = [sum(h == probe.Y_ts & probe.Y_ts == 1),sum(h == probe.Y_ts & probe.Y_ts == 0),sum(h ~= probe.Y_ts & probe.Y_ts == 1),sum(h ~= probe.Y_ts & probe.Y_ts == 0)];
    FP.probe.combined = find(h ~= probe.Y_ts & probe.Y_ts == 0);
    FN.probe.combined = find(h ~= probe.Y_ts & probe.Y_ts == 1);
    fp.probe.combined = error.probe.combined(4);
    fn.probe.combined = error.probe.combined(3);
    
    [probe.fp_slmc probe.fn_slmc] = errorAnalysis(FP.probe, FN.probe, error.probe, time.probe);
    
    fprintf('\nProblematic Attacks\n')
    
    fprintf('ipsweep: %.1f\n',size(strmatch('ipsweep.',original_test.probe.label(probe.fn_slmc,:)),1));
    fprintf('mscan: %.1f\n',size(strmatch('mscan.',original_test.probe.label(probe.fn_slmc,:)),1));
    fprintf('nmap: %.1f\n',size(strmatch('nmap.',original_test.probe.label(probe.fn_slmc,:)),1));
    fprintf('portsweep: %.1f\n',size(strmatch('portsweep.',original_test.probe.label(probe.fn_slmc,:)),1));
    fprintf('saint: %.1f\n',size(strmatch('saint.',original_test.probe.label(probe.fn_slmc,:)),1));
    fprintf('satan: %.1f\n',size(strmatch('satan.',original_test.probe.label(probe.fn_slmc,:)),1));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   Denial of Service
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\nDENIAL OF SERVICE\n')
    
    dos.ALL.X_tr = normc(double(dos.ALL.X_tr));
    dos.svm.X_tr = normc(double(dos.svm.X_tr));
    dos.lgp.X_tr = normc(double(dos.lgp.X_tr));
    dos.mars.X_tr = normc(double(dos.mars.X_tr));
    dos.combined.X_tr = normc(double(dos.combined.X_tr));
    
    dos.ALL.X_ts = normc(double(dos.ALL.X_ts));
    dos.svm.X_ts = normc(double(dos.svm.X_ts));
    dos.lgp.X_ts = normc(double(dos.lgp.X_ts));
    dos.mars.X_ts = normc(double(dos.mars.X_ts));
    dos.combined.X_ts = normc(double(dos.combined.X_ts));
    
    dos.Y_tr = dos.Y_tr.label;
    dos.Y_ts = dos.Y_ts.label;
    
    %   ALL
    %%%%%%%%%%%%%%%
    tic
    dos.model_ALL = ClassificationTree.fit(dos.ALL.X_tr,dos.Y_tr);
    time.dos.ALL.training = toc;
    tic
    h = predict(dos.model_ALL,dos.ALL.X_ts);
    time.dos.ALL.test = toc;
    error.dos.ALL = [sum(h == dos.Y_ts & dos.Y_ts == 1),sum(h == dos.Y_ts & dos.Y_ts == 0),sum(h ~= dos.Y_ts & dos.Y_ts == 1),sum(h ~= dos.Y_ts & dos.Y_ts == 0)];
    FP.dos.ALL = find(h ~= dos.Y_ts & dos.Y_ts == 0);
    FN.dos.ALL = find(h ~= dos.Y_ts & dos.Y_ts == 1);
    fp.dos.all = error.dos.ALL(4);
    fn.dos.all = error.dos.ALL(3);
    
    %   SVM
    %%%%%%%%%%%%%%
    
    tic
    dos.model_svm = ClassificationTree.fit(dos.svm.X_tr,dos.Y_tr);
    time.dos.svm.training = toc;
    tic
    h = predict(dos.model_svm,dos.svm.X_ts);
    time.dos.svm.test = toc;
    error.dos.svm = [sum(h == dos.Y_ts & dos.Y_ts == 1),sum(h == dos.Y_ts & dos.Y_ts == 0),sum(h ~= dos.Y_ts & dos.Y_ts == 1),sum(h ~= dos.Y_ts & dos.Y_ts == 0)];
    FP.dos.svm = find(h ~= dos.Y_ts & dos.Y_ts == 0);
    FN.dos.svm = find(h ~= dos.Y_ts & dos.Y_ts == 1);
    fp.dos.svm = error.dos.svm(4);
    fn.dos.svm = error.dos.svm(3);
    
    %   LGP
    %%%%%%%%%%%%%
    
    tic
    dos.model_lgp = ClassificationTree.fit(dos.lgp.X_tr,dos.Y_tr);
    time.dos.lgp.training = toc;
    tic
    h = predict(dos.model_lgp,dos.lgp.X_ts);
    time.dos.lgp.test = toc;
    error.dos.lgp = [sum(h == dos.Y_ts & dos.Y_ts == 1),sum(h == dos.Y_ts & dos.Y_ts == 0),sum(h ~= dos.Y_ts & dos.Y_ts == 1),sum(h ~= dos.Y_ts & dos.Y_ts == 0)];
    FP.dos.lgp = find(h ~= dos.Y_ts & dos.Y_ts == 0);
    FN.dos.lgp = find(h ~= dos.Y_ts & dos.Y_ts == 1);
    fp.dos.lgp = error.dos.lgp(4);
    fn.dos.lgp = error.dos.lgp(3);
    
    %   MARS
    %%%%%%%%%%%%%
    
    tic
    dos.model_mars = ClassificationTree.fit(dos.mars.X_tr,dos.Y_tr);
    time.dos.mars.training = toc;
    tic
    h = predict(dos.model_mars,dos.mars.X_ts);
    time.dos.mars.test = toc;
    error.dos.mars = [sum(h == dos.Y_ts & dos.Y_ts == 1),sum(h == dos.Y_ts & dos.Y_ts == 0),sum(h ~= dos.Y_ts & dos.Y_ts == 1),sum(h ~= dos.Y_ts & dos.Y_ts == 0)];
    FP.dos.mars = find(h ~= dos.Y_ts & dos.Y_ts == 0);
    FN.dos.mars = find(h ~= dos.Y_ts & dos.Y_ts == 1);
    fp.dos.mars = error.dos.mars(4);
    fn.dos.mars = error.dos.mars(3);
    
    %   COMBINED
    %%%%%%%%%%%%%
    
    tic
    dos.model_combined = ClassificationTree.fit(dos.combined.X_tr,dos.Y_tr);
    time.dos.combined.training = toc;
    tic
    h = predict(dos.model_combined,dos.combined.X_ts);
    time.dos.combined.test = toc;
    error.dos.combined = [sum(h == dos.Y_ts & dos.Y_ts == 1),sum(h == dos.Y_ts & dos.Y_ts == 0),sum(h ~= dos.Y_ts & dos.Y_ts == 1),sum(h ~= dos.Y_ts & dos.Y_ts == 0)];
    FP.dos.combined = find(h ~= dos.Y_ts & dos.Y_ts == 0);
    FN.dos.combined = find(h ~= dos.Y_ts & dos.Y_ts == 1);
    fp.dos.combined = error.dos.combined(4);
    fn.dos.combined = error.dos.combined(3);
    
    [dos.fp_slmc dos.fn_slmc] = errorAnalysis(FP.dos, FN.dos, error.dos, time.dos);
    
    fprintf('\nProblematic Attacks\n')
    
    fprintf('mailbomb: %.2f\n',size(strmatch('mailbomb.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('back: %.2f\n',size(strmatch('back.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('land: %.2f\n',size(strmatch('land.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('apache2: %.2f\n',size(strmatch('apache2.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('neptune: %.2f\n',size(strmatch('neptune.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('pod: %.2f\n',size(strmatch('pod.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('processtable: %.2f\n',size(strmatch('processtable.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('smurf: %.2f\n',size(strmatch('smurf.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('teardrop: %.2f\n',size(strmatch('teardrop.',original_test.dos.label(dos.fn_slmc,:)),1));
    fprintf('udpstorm: %.2f\n',size(strmatch('udpstorm.',original_test.dos.label(dos.fn_slmc,:)),1));
    
    unique(original_training.dos.label)
    unique(original_test.dos(:,42))
    
end
    

end
        


