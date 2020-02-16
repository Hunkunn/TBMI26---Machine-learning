function [ cM ] = calcConfusionMatrix( LPred, LTrue )
% CALCCONFUSIONMATRIX returns the confusion matrix of the predicted labels

classes  = unique(LTrue);
NClasses = length(classes);
cM = zeros(NClasses);
% Add your own code here
%cM = confusionmat(LPred, LTrue);

for a = 1:size(LPred,1)
    cM(LPred(a),LTrue(a)) = cM(LPred(a),LTrue(a)) + 1;
end

end

