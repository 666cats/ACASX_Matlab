function DTMCConfig = dtmcConfig(MP)

numUStates = (MP.dtmcNumR+1)*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1);
emptyStruct = struct('r',0,'rv',0,'theta',0,'order',0);
uStates = repmat(emptyStruct,numUStates,1);

for rIdx=0:MP.dtmcNumR
    for rvIdx=0:MP.dtmcNumRv
        for thetaIdx=-MP.dtmcNumTheta:MP.dtmcNumTheta
            
            r = MP.dtmcResR*rIdx;
            rv = MP.dtmcResRv*rvIdx;
            theta = MP.dtmcResTheta*thetaIdx;

            order = rIdx*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1)+ ...
                    rvIdx*(2*MP.dtmcNumTheta+1)+ ...
                    (thetaIdx+MP.dtmcNumTheta);

            uStates(order+1).r = r;
            uStates(order+1).rv = rv;
            uStates(order+1).theta = theta;
            uStates(order+1).order = order;

        end
    end
end

