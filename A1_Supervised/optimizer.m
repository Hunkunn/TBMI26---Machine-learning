%% This script will help you test out your kNN code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 4; % Change this to load new data 

% X - Data samples
% D - Desired output from classifier for each sample
% L - Labels for each sample
[X, D, L] = loadDataSet( dataSetNr );

% You can plot and study dataset 1 to 3 by running:
%plotCase(X,D)

%% Select a subset of the training samples

numBins = 3;                    % Number of bins you want to devide your data into
numSamplesPerLabelPerBin = 100; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true;          % true = select samples at random, false = select the first features

[XBins, DBins, LBins] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom);

% Note: XBins, DBins, LBins will be cell arrays, to extract a single bin from them use e.g.

%% Use kNN to classify data
%  Note: you have to modify the kNN() function yourself.

% Set the number of neighbors
acc_store = zeros(1);
for k = 1:9
    totalacc = 0;
    for i = 1:numBins
        XTest = XBins{i};
        LTest = LBins{i};
        exclusion = 1:numBins;
        Z = exclusion(find(exclusion~=i)); 
        XTrain = combineBins(XBins, Z);
        LTrain = combineBins(LBins, Z);
        LPredTrain = kNN(XTrain, k, XTrain, LTrain);
        LPredTest  = kNN(XTest , k, XTrain, LTrain);
        cM = calcConfusionMatrix(LPredTest, LTest);
        acc = calcAccuracy(cM);
        totalacc = totalacc + acc;
    end
    accuracy = totalacc/numBins;
    acc_store(k) = accuracy;
end
[Maxacc, kbest]=max(acc_store)

%% Plot classifications
%  Note: You should not have to modify this code

if dataSetNr < 4
    plotResultDots(XTrain, LTrain, LPredTrain, XTest, LTest, LPredTest, 'kNN', [], k);
else
    plotResultsOCR(XTest, LTest, LPredTest)
end
