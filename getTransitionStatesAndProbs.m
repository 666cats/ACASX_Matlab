function SP = getTransitionStatesAndProbs(cStates,statesIdx,actionCode,sigmaPoint,MP)

stateDate = utils(actionCode);
targetV = stateDate(1);
accel = stateDate(2);

nextStateandProbabilities = [];
transStateProb = nan(1,2);

if ((accel>0 && targetV>cStates(statesIdx).oVy && cStates(statesIdx).oVy<MP.mdpUpperVy) || ...
        (accel<0 && targetV<cStates(statesIdx).oVy && cStates(statesIdx).oVy>-MP.mdpUpperVy))

    for iter = 1:length(sigmaPoint.A(:,1))
        oAy = accel;
        iAy = sigmaPoint.A(iter,2);
        sigmaP = sigmaPoint.A(iter,3);

        hP = cStates(statesIdx).h + (cStates(statesIdx).iVy - cStates(statesIdx).oVy) + 0.5*(iAy - oAy);
        oVyP = max([- MP.mdpUpperVy , min([MP.mdpUpperVy , cStates(statesIdx).oVy + oAy])]);
        iVyP = max([- MP.mdpUpperVy , min([MP.mdpUpperVy , cStates(statesIdx).iVy + iAy])]);
        raP = actionCode;

        hIdxL = floor(hP/MP.mdpResH);
        oVyIdxL = floor(oVyP/MP.mdpResOvy);
        iVyIdxL = floor(iVyP/MP.mdpResIvy);

        for i=0:1
            hIdx = hIdxL + i;
            hIdxP = max([- MP.mdpNumH , min([MP.mdpNumH , hIdx])]);
            for j=0:1
                oVyIdx = oVyIdxL + j;
                oVyIdxP = max([- MP.mdpNumOvy , min([MP.mdpNumOvy , oVyIdx])]);
                for k=0:1
                    iVyIdx = iVyIdxL + k;
                    iVyIdxP = max([- MP.mdpNumIvy , min([MP.mdpNumIvy , iVyIdx])]);

                    a = hIdxP + MP.mdpNumH;
                    b = oVyIdxP + MP.mdpNumOvy;
                    c = iVyIdxP + MP.mdpNumIvy;

                    nextStateOrder = a*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                     b*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                     c*MP.mdpNumRa+ ...
                                     raP;

                    probability = sigmaP*(1-abs(hIdx - hP/MP.mdpResH))*(1-abs(oVyIdx - oVyP/MP.mdpResOvy))*(1-abs(iVyIdx - iVyP/MP.mdpResIvy));
                    nextStateandProbabilities = [nextStateandProbabilities;[nextStateOrder , probability]];
                
                end
            end
        end
    end
else
    for iter = 1:length(sigmaPoint.B(:,1))
        oAy = sigmaPoint.B(iter,1);
        iAy = sigmaPoint.B(iter,2);
        sigmaP = sigmaPoint.B(iter,3);

        hP = cStates(statesIdx).h + (cStates(statesIdx).iVy - cStates(statesIdx).oVy) + 0.5*(iAy - oAy);
        oVyP = max([- MP.mdpUpperVy , min([MP.mdpUpperVy , cStates(statesIdx).oVy + oAy])]);
        iVyP = max([- MP.mdpUpperVy , min([MP.mdpUpperVy , cStates(statesIdx).iVy + iAy])]);
        raP = actionCode;

        hIdxL = floor(hP/MP.mdpResH);
        oVyIdxL = floor(oVyP/MP.mdpResOvy);
        iVyIdxL = floor(iVyP/MP.mdpResIvy);

        for i=0:1
            hIdx = hIdxL + i;
            hIdxP = max([- MP.mdpNumH , min([MP.mdpNumH , hIdx])]);
            for j=0:1
                oVyIdx = oVyIdxL + j;
                oVyIdxP = max([- MP.mdpNumOvy , min([MP.mdpNumOvy , oVyIdx])]);
                for k=0:1
                    iVyIdx = iVyIdxL + k;
                    iVyIdxP = max([- MP.mdpNumIvy , min([MP.mdpNumIvy , iVyIdx])]);

                    a = hIdxP + MP.mdpNumH;
                    b = oVyIdxP + MP.mdpNumOvy;
                    c = iVyIdxP + MP.mdpNumIvy;

                    nextStateOrder = a*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                     b*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                     c*MP.mdpNumRa+ ...
                                     raP;

                    probability = sigmaP*(1-abs(hIdx - hP/MP.mdpResH))*(1-abs(oVyIdx - oVyP/MP.mdpResOvy))*(1-abs(iVyIdx - iVyP/MP.mdpResIvy));
                    nextStateandProbabilities = [nextStateandProbabilities;[nextStateOrder , probability]];

                end
            end
        end
    end
end

for entry=1:length(nextStateandProbabilities(:,1))

    nextStateOrder = nextStateandProbabilities(entry,1);
    % prob = nextStateandProbabilities(entry,2);
    k = find(transStateProb(:,1) == nextStateOrder);
    isPairFound = ~isempty(k);

    if isPairFound
        transStateProb(k,2) = transStateProb(k,2) + nextStateandProbabilities(entry,2);
    else
        transStateProb = [transStateProb;nextStateandProbabilities(entry,:)];
    end

end
transStateProb(1,:) = [];

SP = transStateProb;
    

end