clc;


%normal_dataset = dataset('File','kddcup_normal.data','ReadVarNames',true,'delimiter',',');
%probe_dataset = dataset('File','kddcup_probe.data','ReadVarNames',true,'delimiter',',');


training_size = 10000;

%m = 2*training_size;

probe_sample = datasample(probe_dataset,training_size,'Replace',false);



normal_sample.probe = datasample(normal_dataset,size(probe_sample,1),'Replace',false);

normal_sample.probe_Y = normal_sample.probe(:,42);
normal_sample.probe_Y.label = 2*ones(size(normal_sample.probe_Y,1),1);
normal_sample.probe = normal_sample.probe(:,1:41);

probe.ALL = probe_sample(:,1:41);
	
probe.Y = probe_sample(:,42);
probe.Y.label= ones(size(probe.Y,1),1);


probe.ALL_tr = cat(1,normal_sample.probe,probe.ALL);

probe.ALL_tr = double(probe.ALL_tr(1:(size(probe.ALL_tr,1)*(2/3)),:));
probe.ALL_cv = double(probe.ALL_tr((size(probe.ALL_tr,1)*(2/3)+1):size(probe.ALL_tr,1),:));

probe.Y_tr = cat(1,normal_sample.probe_Y,probe.Y);

probe.Y_tr = double(probe.Y_tr(1:(size(probe.Y_tr,1)*(2/3)),:));
probe.Y_cv = double(probe.Y_tr((size(probe.Y_tr,1)*(2/3)+1):size(probe.Y_tr,1),:));

m = size(probe.ALL_tr,1);


input_layer_size  = size(probe.ALL_tr,2);  
hidden_layer_size = 35;   % 25 hidden units
num_labels = 2;          % 10 labels, from 1 to 10   



cv2(probe.ALL_tr,probe.Y_tr,lambda,input_layer_size,hidden_layer_size,num_labels);


% =========== Part 7: Learning Curve =============
%  Now, you will get to experiment with polynomial regression with multiple
%  values of lambda. The code below runs polynomial regression with 
%  lambda = 0. You should try running the code with different values of
%  lambda to see how the fit and learning curve change.
%

lambda = 0;

start = 5000;
step = 2000;

figure(2);
[error_train, error_val] = ...
    learningCurve(probe.ALL_tr, probe.Y_tr, probe.ALL_cv, probe.Y_cv, lambda,input_layer_size,hidden_layer_size,num_labels,start,step);
plot(start:step:start+step*(size(error_train)-1), error_train, start:step:start+step*(size(error_train)-1), error_val);

title(sprintf('Polynomial Regression Learning Curve (lambda = %f)', lambda));
xlabel('Number of training examples')
ylabel('Error')
%axis([0 m 0 0.5])
legend('Train', 'Cross Validation')

fprintf('Polynomial Regression (lambda = %f)\n\n', lambda);
fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
for i = 1:size(error_train,1)
    fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
end

pause;

fprintf('\nInitializing Neural Network Parameters ...\n')

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


fprintf('\nTraining Neural Network... \n')

%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.
options = optimset('MaxIter', 50);

%  You should also try different values of lambda
lambda = 0;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, probe.ALL_tr, probe.Y_tr, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

pred = predict(Theta1, Theta2, probe.ALL_tr);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == probe.Y_tr)) * 100);
