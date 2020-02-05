function [Wout,Vout,ErrTrain,ErrTest] = trainMultiLayer(XTrain,DTrain,XTest,DTest,W0,V0,numIterations,learningRate)
% TRAINMULTILAYER Trains the multi-layer network (Learning)
%    Inputs:
%                X* - Training/test samples (matrix)
%                D* - Training/test desired output of net (matrix)
%                V0 - Initial weights of the output neurons (matrix)
%                W0 - Initial weights of the hidden neurons (matrix)
%                numIterations - Number of learning steps (scalar)
%                learningRate  - The learning rate (scalar)
%
%    Output:
%                Wout - Weights after training (matrix)
%                Vout - Weights after training (matrix)
%                ErrTrain - The training error for each iteration (vector)
%                ErrTest  - The test error for each iteration (vector)

% Initialize variables
ErrTrain = nan(numIterations+1, 1);
ErrTest  = nan(numIterations+1, 1);
NTrain   = size(XTrain, 1);
NTest    = size(XTest , 1);
NClasses = size(DTrain, 2) - 1;
Wout = W0;
Vout = V0;

% Calculate initial error
[YTrain,~,U] = runMultiLayer(XTrain, W0, V0);
[YTest,~,U]  = runMultiLayer(XTest , W0, V0);
ErrTrain(1) = sum(sum((YTrain - DTrain).^2)) / (NTrain * NClasses);
ErrTest(1)  = sum(sum((YTest  - DTest ).^2)) / (NTest  * NClasses);

for n = 1:numIterations
    % Add your own code here
    grad_v = 2*U'*(YTrain - DTrain)/NTrain; % Gradient for the output layer
    grad_w = 2*XTrain'*(((YTrain - DTrain)*Vout(1:end-1,:)').*tanhprim(U(:,1:end-1)))/NTrain; % And the input layer
    % Take a learning step
    Vout = Vout - learningRate * grad_v;
    Wout = Wout - learningRate * grad_w;
    
    % Evaluate errors
    [YTrain,~,U] = runMultiLayer(XTrain, Wout, Vout);
    [YTest,~,U]  = runMultiLayer(XTest , Wout, Vout);
    ErrTrain(1+n) = sum(sum((YTrain - DTrain).^2)) / (NTrain * NClasses);
    ErrTest(1+n)  = sum(sum((YTest  - DTest ).^2)) / (NTest  * NClasses);
end

end
