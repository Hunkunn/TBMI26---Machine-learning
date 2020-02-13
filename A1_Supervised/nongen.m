%% This script will help you test your multi-layer neural network code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 3; % Change this to load new data 

% X - Data samples
% D - Desired output from classifier for each sample
% L - Labels for each sample
[X, D, L] = loadDataSet( dataSetNr );

%% Select a subset of the training features

numBins = 100;                    % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true;          % true = select features at random, false = select the first features

[XBins, DBins, LBins] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: XBins, DBins, LBins will be cell arrays, to extract a single bin from them use e.g.
% XBin1 = XBins{1};
%
% Or use the combineBins helper function to combine several bins into one matrix (good for cross validataion)
% XBinComb = combineBins(XBins, [1,2,3]);

% Add your own code to setup data for training and test here
XTrain = XBins{1};%changes
DTrain = DBins{1};
LTrain = LBins{1};
XTest  = combineBins(XBins, [2:numBins]); %changes
DTest  = combineBins(DBins, [2:numBins]);
LTest  = combineBins(LBins, [2:numBins]);

%% Modify the X Matrices so that a bias is added
%  Note that the bias must be the last feature for the plot code to work

% The training data
XTrain = [XTrain, ones(size(XTrain,1), 1)]; 

%The test data
XTest = [XTest, ones(size(XTest,1), 1)];


%% Train your multi-layer network
%  Note: You need to modify trainMultiLayer() and runMultiLayer()
%  in order to train the network
% 90 15000 0.0003
%15 8000 0.01
numHidden     = 10;     % Change this, number of hidden neurons 
numIterations = 8000;   % Change this, number of iterations (epochs)
learningRate  = 0.03; % Change this, your learning rate
W0 = randn(size(XTrain,2),numHidden)/100; % Initialize your weight matrix W
V0 = randn(numHidden+1, size(DTrain,2))/100; % Initialize your weight matrix V

% Run training loop
tic;
[W,V,ErrTrain,ErrTest] = trainMultiLayer(XTrain, DTrain, XTest, DTest ,W0, V0, numIterations, learningRate);
trainingTime = toc;

%% Plot errors
%  Note: You should not have to modify this code

[minErrTest, minErrTestInd] = min(ErrTest);

figure(1101);
clf;
semilogy(ErrTrain, 'k', 'linewidth', 1.5);
hold on;
semilogy(ErrTest, 'r', 'linewidth', 1.5);
semilogy(minErrTestInd, minErrTest, 'bo', 'linewidth', 1.5);
hold off;
xlim([0,numIterations]);
grid on;
title('Training and Test Errors, Multi-layer');
legend('Training Error', 'Test Error', 'Min Test Error');
xlabel('Epochs');
ylabel('Error');

%% Calculate the Confusion Matrix and the Accuracy of the data
%  Note: you have to modify the calcConfusionMatrix() and calcAccuracy()
%  functions yourself.

tic;
[~, LPredTrain] = runMultiLayer(XTrain, W, V);
[~, LPredTest ] = runMultiLayer(XTest , W, V);
classificationTime = toc/(length(XTest) + length(XTrain));

% The confucionMatrix
cM = calcConfusionMatrix(LPredTest, LTest)

% The accuracy
acc = calcAccuracy(cM);

disp(['Time spent training: ' num2str(trainingTime) ' sec']);
disp(['Time spent classifying 1 sample: ' num2str(classificationTime) ' sec']);
disp(['Test accuracy: ' num2str(acc)]);

%% Plot classifications
%  Note: You should not have to modify this code

if dataSetNr < 4
    plotResultDots(XTrain, LTrain, LPredTrain, XTest, LTest, LPredTest, 'multi', {W,V}, []);
else
    plotResultsOCR(XTest, LTest, LPredTest);
end
