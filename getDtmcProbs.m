function DTMCProbs = getDtmcProbs(uStates,stateIndex,sigmaPoint,MP)

transStateProb = nan(1,2);
nextStateandProb = [];

for iter = 1:length(sigmaPoint.A(:,1))
    