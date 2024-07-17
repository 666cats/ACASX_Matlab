clc
clear all

load("/home/yu/codetest/ACASX_FileStore/actionFile.mat");
load("/home/yu/codetest/ACASX_FileStore/indexFile.mat");
load("/home/yu/codetest/ACASX_FileStore/costFile.mat");
load("/home/yu/codetest/ACASX_FileStore/entryTimeDistributionFile.mat");
MP = getModelParams();

ownshipLoc = [0,500,0];
ownshipvel = [203,0,0];
intruderLoc = [4034,547,0];
intruderVel = [-185,0,0];

numUStates = (MP.dtmcNumR+1)*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1);
numCStates = (2*MP.mdpNumH+1)*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa;


for lastRA=0:6

    entryTimeDistribution = nan(1,2);

    horDistVector = [intruderLoc(1)-ownshipLoc(1),intruderLoc(3)-ownshipLoc(3)];
    horVelVector = [intruderVel(1)-ownshipvel(1),intruderVel(3)-ownshipvel(3)];
    r = norm(horDistVector);
    rv = norm(horVelVector);
    h = intruderLoc(2) - ownshipLoc(2);
    alpha = atan2(horVelVector(2),horVelVector(1)) - atan2(horDistVector(2),horDistVector(1));
    if alpha > pi
        alpha = -2*pi + alpha;
    end
    if alpha < -pi
        alpha = 2*pi + alpha;
    end
    theta = 180*alpha/pi;


    if abs(h)<=MP.mdpUpperH && r<=MP.dtmcUpperR

        rRes = MP.dtmcResR;
        rvRes = MP.dtmcResRv;
        thetaRes = MP.dtmcResTheta;

        nr = MP.dtmcNumR;
        nrv = MP.dtmcNumRv;
        ntheta = MP.dtmcNumTheta;

        entryTimeMapProbs = [];

        rIdxL = floor(r/MP.dtmcResR);
        rvIdxL = floor(rv/MP.dtmcResRv);
        thetaIdxL = floor(theta/MP.dtmcResTheta);
        
        for i=0:1
            rIdx = rIdxL + i;
            rIdxP = max([0,min([nr,rIdx])]);
            for j=0:1
                rvIdx = rvIdxL + j;
                rvIdxP = max([0,min([nrv,rvIdx])]);
                for k=0:1
                    thetaIdx = thetaIdxL + k;
                    thetaIdxP = max([-ntheta,min(ntheta,thetaIdx)]);
    
                    approxUstateOrder = rIdxP*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1)+ ...
                                        rvIdxP*(2*MP.dtmcNumTheta+1)+ ...
                                        (thetaIdxP+MP.dtmcNumTheta);
    
                    prob = (1-abs(rIdx - r/rRes))*(1-abs(rvIdx - rv/rvRes))*(1-abs(thetaIdx - theta/thetaRes));

                    for t=0:MP.timeHorizon
                        temp = prob*entryTimeDistributionFileWriter(t*(numUStates) + approxUstateOrder + 1);
                        entryTimeMapProbs = [entryTimeMapProbs;[t,temp]];
                    end
                end
            end
        end

        entryTimeLessProb = 0;
        for entryTimeProb = 1:length(entryTimeMapProbs(:,1))
            stateOrder = entryTimeMapProbs(entryTimeProb,1);
            k = find(entryTimeDistribution(:,1) == stateOrder);
            isPairFound = ~isempty(k);

            if isPairFound
                entryTimeDistribution(k,2) = entryTimeDistribution(k,2) + entryTimeMapProbs(entryTimeProb,2);
            else
                entryTimeDistribution = [entryTimeDistribution;entryTimeMapProbs(entryTimeProb,:)];
            end
        end
        
        entryTimeDistribution(1,:) = [];
        entryTimeLessProb = sum(entryTimeDistribution(:,2));
        entryTimeDistribution = [entryTimeDistribution;[MP.timeHorizon+1 , 1-entryTimeLessProb]];


%% Calculate Q ValuesMaps
        
        h = intruderLoc(2) - ownshipLoc(2);
        oVy = ownshipvel(2);
        iVy = intruderVel(2);

        hRes = MP.mdpResH;
        oVRes = MP.mdpResOvy;
        iVRes = MP.mdpResIvy;
        nh = MP.mdpNumH;
        noVy = MP.mdpNumOvy;
        niVy = MP.mdpNumIvy;

        qValueMap = nan(1,2);
        
        hIdxL = floor(h/hRes);
        oVyIdxL = floor(oVy/oVRes);
        iVyIdxL = floor(iVy/iVRes);

        actionMapValues = [];

        for i=0:1
            hIdx = hIdxL + i;
            hIdxP = max([-nh , min([nh , hIdx])]);
            for j=0:1
                oVyIdx = oVyIdxL + j;
                oVyIdxP = max([-noVy,min([noVy , oVyIdx])]);
                for k=0:1
                    iVyIdx = iVyIdxL + k;
                    iVyIdxP = max([-niVy , min([niVy , iVyIdx])]);

                    a = hIdxP + nh;
                    b = oVyIdxP + noVy;
                    c = iVyIdxP + niVy;

                    approxCStateOrder = a*(2*noVy+1)*(2*niVy+1)*MP.mdpNumRa+ ...
                                        b*(2*niVy+1)*MP.mdpNumRa+ ...
                                        c*MP.mdpNumRa+ ...
                                        lastRA;

                    prob = (1-abs(hIdx - h/MP.mdpResH))*(1-abs(oVyIdx - oVy/MP.mdpResOvy))*(1-abs(iVyIdx - iVy/MP.mdpResIvy));

                    for entryTime=1:length(entryTimeDistribution(:,1))
                        t = entryTimeDistribution(entryTime,1);
                        entryTimeProb = entryTimeDistribution(entryTime,2);
                        index = indexFileWrite(t*numCStates + approxCStateOrder +1);
                        numAction = indexFileWrite(t*numCStates + approxCStateOrder +2) - index;

                        for n=0:numAction - 1
                            qValue = costFileWrite(index+n+1);
                            actionCode = actionFileWrite(index+n+1);
                            actionMapValues = [actionMapValues;[actionCode,prob*entryTimeProb*qValue]];
                        end
                    end
                end
            end
        end

        for ac = 1:length(actionMapValues(:,1))
            action = actionMapValues(ac,1);
            k = find(qValueMap(:,1) == action);
            isPairFound = ~isempty(k);

            if isPairFound
                qValueMap(k,2) = qValueMap(k,2) + actionMapValues(ac,2);
            else
                qValueMap = [qValueMap;[actionMapValues(ac,:)]];
            end

        end

        qValueMap(1,:) = [];
    else
        nowRA = 0;
    end

    maxQValue = qValueMap(1,2);
    bestActionCode = qValueMap(1,1);

    for entry=1:length(qValueMap(:,1))
        value = qValueMap(entry,2);
        if value - maxQValue >= 0.0001
            maxQValue = value;
            bestActionCode = qValueMap(entry,1);
        end
    end

    nowRA = bestActionCode;

    fprintf("bestActionCode is %d\n",nowRA);

end








