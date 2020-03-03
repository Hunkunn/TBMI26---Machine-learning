%% Hyper-parameters
clear
clc
% Number of randomized Haar-features
nbrHaarFeatures = 100;
% Number of training images, will be evenly split between faces and
% non-faces. (Should be even.)
nbrTrainImages = 800;
% Number of weak classifiers
nbrWeakClassifiers = 100;

%% Load face and non-face data and plot a few examples
load faces;
load nonfaces;
faces = double(faces(:,:,randperm(size(faces,3))));
nonfaces = double(nonfaces(:,:,randperm(size(nonfaces,3))));

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

%% Generate Haar feature masks
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

%% Create image sets (do not modify!)

% Create a training data set with examples from both classes.
% Non-faces = class label y=-1, faces = class label y=1
trainImages = cat(3,faces(:,:,1:nbrTrainImages/2),nonfaces(:,:,1:nbrTrainImages/2));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainImages/2), -ones(1,nbrTrainImages/2)];

% Create a test data set, using the rest of the faces and non-faces.
testImages  = cat(3,faces(:,:,(nbrTrainImages/2+1):end),...
                    nonfaces(:,:,(nbrTrainImages/2+1):end));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,size(faces,3)-nbrTrainImages/2), -ones(1,size(nonfaces,3)-nbrTrainImages/2)];

% Variable for the number of test-data.
nbrTestFaces = sum(yTest(:) == 1);
nbrTestNonFaces = sum(yTest(:) == -1);
nbrTrainFaces = sum(yTrain(:) == 1);
nbrTrainNonFaces = sum(yTrain(:) == -1);
nbrTestImages = length(yTest);

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError
%weights
D = ones(1,size(xTrain, 2))/size(xTrain, 2);
for weightindex = 1:nbrWeakClassifiers
    Emin = inf;
    for feature = 1:nbrHaarFeatures
          P = 1;
            for threshold = 1:size(xTrain,2)
            
                T = xTrain(feature,threshold);
                C = WeakClassifier(T, P, xTrain(feature,:));
                E = WeakClassifierError(C, D, yTrain);
                if E > 0.5
                    P = -P;
                    E = 1 - E;    
                    C = -C;
                end

                if E < Emin(1) 
                    Emin(1) = E;
                    Emin(2)=feature;
                    Emin(3)=T;
                    Emin(4)=P;
                    Cmin=C;
                end
            end
    end
    alpha_t=(1/2)*log((1-Emin(1))/Emin(1));
    h(weightindex,:) = [alpha_t Emin];
    D=D.*exp(-alpha_t*(yTrain.*Cmin));
    D = D/sum(D);
    
end

%% Evaluate your strong classifier here
%  Evaluate on both the training data and test data, but only the test
%  accuracy can be used as a performance metric since the training accuracy
%  is biased.
testMat = zeros(nbrHaarFeatures,nbrTestImages);
eachTestIteration = zeros(1, nbrWeakClassifiers);
eachTrainIteration = zeros(1, nbrWeakClassifiers);
for classifier = 1:nbrWeakClassifiers
    A = h(classifier,1)*( WeakClassifier(h(classifier,4), h(classifier,5), xTest(h(classifier,3),:)));
    C = h(classifier,1)*( WeakClassifier(h(classifier,4), h(classifier,5), xTrain(h(classifier,3),:)));
    testMat(classifier,:) = A;
    trainMat(classifier,:) = C;
    B = sum(sign(sum(testMat))~= yTest);
    D = sum(sign(sum(trainMat))~= yTrain);
    eachTestIteration(classifier) = B/nbrTestImages;
    eachTrainIteration(classifier) = D/nbrTrainImages;
end
Accuracy = 1 - eachTestIteration(end)


%% Plot the error of the strong classifier as a function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.
figure(4);
hold on;
plot(1:nbrWeakClassifiers,eachTestIteration, 'r')
plot(1:nbrWeakClassifiers,eachTrainIteration, 'b')
legend('test data', 'training data')
xlabel('Number of weak classifiers')
ylabel('Error')
hold off;

%% Plot some of the misclassified faces and non-faces
%  Use the subplot command to make nice figures with multiple images.

result = sign(sum(testMat));
missclassified = find(result ~= yTest);
randompics = randi(size(yTest),[1,9]);
figure(5);
colormap gray;

for imagenr = 1:9
    subplot(3,3,imagenr), imagesc(testImages(:,:,randompics(imagenr)));
    axis image;
    axis off;
end



%% Plot your choosen Haar-features
%  Use the subplot command to make nice figures with multiple images.
figure(6);
colormap gray;

for i=1:25
    subplot(5,5,i), imagesc(haarFeatureMasks(:,:,h(i,3)),[-1 2]);    
    axis image;
    axis off;
end
