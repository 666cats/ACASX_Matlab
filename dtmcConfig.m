function DTMCConfig = dtmcConfig(MP)

numUStates = (MP.dtmcNumR+1)*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1);
emptyStruct = struct('r',0,'rv',0,'theta',0);
uStates = repmat(emptyStruct,numUStates,1);

for rIdx=0:MP.dtmcNumR
    for rvIdx=0:MP.dtmcNumRv
        for thetaIdx=-MP.dtmcNumTheta:MP.dtmcNumTheta
            