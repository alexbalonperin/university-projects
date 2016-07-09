function cv2(X, y, lambda, input_layer_size,hidden_layer_size,num_labels)

index = randsample(size(X,1),size(X,1));
size_CV = floor(size(X,1)/10);

options = optimset('MaxIter', 50);

for i = 1:10
        
    i_ts = (((i-1)*size_CV+1):(i*size_CV));
    i_tr = setdiff(index,i_ts);

    y_tr = y(i_tr);
    y_cv = y(i_ts);

    X_tr = X(i_tr,:);
    X_cv = X(i_ts,:);

    initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
    initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

    % Unroll parameters
    initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

    %  You should also try different values of lambda
    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X_tr, y_tr, lambda);

    % Now, costFunction is a function that takes in only one argument (the
    % neural network parameters)
    [nn_params ~] = fmincg(costFunction, initial_nn_params, options);
    
    % Obtain Theta1 and Theta2 back from nn_params
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

    pred.tr = predict(Theta1, Theta2, X_tr);
    pred.cv = predict(Theta1, Theta2, X_cv);

    accuracy.tr(i) = mean(double(pred.tr == y_tr)) * 100;
    fprintf('\nTraining Set Accuracy: %f\n', accuracy.tr(i));
    accuracy.cv(i) = mean(double(pred.cv == y_cv)) * 100;
    fprintf('\nCross-Validation Set Accuracy: %f\n', accuracy.cv(i));
end

plot(1:10,accuracy.tr,1:10,accuracy.cv)
xlabel('Fold number')
ylabel('Error')
legend('Train', 'Cross Validation')
title('Error Analysis')


end