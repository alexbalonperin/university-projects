 trainingset.r2l = dataset('File','kddcup_r2l.data','ReadVarNames',true,'delimiter',',');
 trainingset.normal = dataset('File','kddcup_normal.data','ReadVarNames',true,'delimiter',',');
 trainingset.probe = dataset('File','kddcup_probe.data','ReadVarNames',true,'delimiter',',');
 trainingset.dos = dataset('File', 'kddcup_dos.data', 'ReadVarNames',true,'delimiter',',');
 trainingset.u2r = dataset('File','kddcup_u2r.data','ReadVarNames',true,'delimiter',',');

testset.r2l = dataset('File','test_r2l.data','ReadVarNames',true,'delimiter',',');
testset.normal = dataset('File','test_normal.data','ReadVarNames',true,'delimiter',',');
testset.probe = dataset('File','test_probe.data','ReadVarNames',true,'delimiter',',');
testset.dos = dataset('File', 'test_dos.data', 'ReadVarNames',true,'delimiter',',');
testset.u2r = dataset('File','test_u2r.data','ReadVarNames',true,'delimiter',',');