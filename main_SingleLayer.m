%% This script will help you test your single layer neural network code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 1; % Change this to load new data 

% X - Data samples
% D - Desired output from classifier for each sample
% L - Labels for each sample
[X, D, L] = loadDataSet( dataSetNr );

%% Select a subset of the training samples

numBins = 2;                    % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true;          % true = select samples at random, false = select the first features

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
XTest  = XBins{2}; %changes
DTest  = DBins{2};
LTest  = LBins{2};

%% Modify the X Matrices so that a bias is added
%  Note that the bias must be the last feature for the plot code to work

% The training data
XTrain = [ones(1,size(XTrain,2));XTrain]; 

%The test data
XTest = [ones(1,size(XTest,2));XTest];

%% Train your single layer network
%  Note: You need to modify trainSingleLayer() and runSingleLayer()
%  in order to train the network

numIterations = 10000;  % Change this, number of iterations (epochs)
learningRate  = 0.0001; % Change this, your learning rate
W0 = 0; % Change this, initialize your weight matrix W

% Run training loop
tic;
[W, ErrTrain, ErrTest] = trainSingleLayer(XTrain, DTrain, XTest, DTest, W0, numIterations, learningRate);
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
title('Training and Test Errors, Single Layer');
legend('Training Error', 'Test Error', 'Min Test Error');
xlabel('Epochs');
ylabel('Error');

%% Calculate the Confusion Matrix and the Accuracy of the data
%  Note: you have to modify the calcConfusionMatrix() and calcAccuracy()
%  functions yourself.

tic;
[~, LPredTrain] = runSingleLayer(XTrain, W);
[~, LPredTest ] = runSingleLayer(XTest , W);
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
    plotResultDots(XTrain, LTrain, LPredTrain, XTest, LTest, LPredTest, 'single', {W}, []);
else
    plotResultsOCR(XTest, LTest, LPredTest);
end
