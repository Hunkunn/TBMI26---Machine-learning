function [ LPred ] = kNN(X, k, XTrain, LTrain)
% KNN Your implementation of the kNN algorithm
%    Inputs:
%              X      - Samples to be classified (matrix)
%              k      - Number of neighbors (scalar)
%              XTrain - Training samples (matrix)
%              LTrain - Correct labels of each sample (vector)
%
%    Output:
%              LPred  - Predicted labels for each sample (vector)

classes = unique(LTrain);

% Add your own code here
LPred  = zeros(length(X),1);
for i = 1:length(X)
    distance = zeros(length(XTrain),1);
    %disp(length(X))
    for j = 1 :size(XTrain,1)
        distance(j) = norm(X(i,:)-XTrain(j,:));
    end 
%     if size(X,2) > 2
%         for j = 1 :size(XTrain,1)
%             distance(j) = norm(X(i,:)-XTrain(j,:));
%         end
%     else
%         distance = sqrt((X(i,1)-XTrain(:,1)).^2 + (X(i,2)- XTrain(:,2)).^2);
%     end
    label = LTrain;
    %disp("distance")
    %disp(length(distance))
    %disp(length(label))
    DnL = [distance, label];
    sDnL = sortrows(DnL);
    kN = sDnL(1:k,:);
    U = unique(kN(:,2));
    H = histc(kN(:,2),U);
    mmode = U(H==max(H));
    if length(mmode) > 1
        randomIndex = randi(length(mmode), 1);
        randomClass = mmode(randomIndex);
        LPred(i) = randomClass;
    else    
        LPred(i) = mode(kN(:,2));
    end
end

end

