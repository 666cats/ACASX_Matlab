function DTMCProbs = getDtmcProbs(uStates,stateIndex,sigmaPoint,MP)

transStateProb = nan(1,2);
nextStateandProb = [];

for iter = 1:length(sigmaPoint.A(:,1))
    
    ra1 = sigmaPoint.A(iter,1);
    ra2 = sigmaPoint.A(iter,2);
    sigmaP = sigmaPoint.A(iter,3);

    r = uStates(stateIndex).r;
    rv = uStates(stateIndex).rv;
    theta = uStates(stateIndex).theta;

    vel = [rv*cos(theta*pi/180),rv*sin(theta*pi/180)];
    velP(1) = max([-MP.dtmcUpperRv,min([MP.dtmcUpperRv,vel(1)+ra1])]);
    velP(2) = max([-MP.dtmcUpperRv,min([MP.dtmcUpperRv,vel(2)+ra2])]);
    if norm(velP)>MP.dtmcUpperRv
        factor = MP.dtmcUpperRv/norm(velP);
        velP = factor*velP;
    end
    rvP = norm(rvP);

    pos = [r,0];
    posP = [(pos(1)+0.5*(vel(1)+velP(1))),(pos(2)+0.5*(vel(2)+velP(2)))];
    if norm(posP)>MP.dtmcUpperR
        factor = MP.dtmcNumR/norm(posP);
        posP = factor*posP;
    end
    rP = norm(posP);

    alpha = atan2(velP(2),velP(1)) - atan2(posP(2),posP(1));
    if alpha > pi
        alpha = -2*pi + alpha;
    end
    if alpha < -pi
        alpha = 2*pi + alpha;
    end

    thetaP = alpha*180/pi;

    rIdxL = floor(rP/MP.dtmcResR);
    rvIdxL = floor(rvP/MP.dtmcResRv);
    thetaIdxL = floor(thetaP/MP.dtmcResTheta);

    for i=0:1
        rIdx = rIdxL + i;
        rIdxP = max([0,min(MP.dtmcNumR,rIdx)]);
        for j=0:1
            rvIdx = rvIdxL + j;
            rvIdxP = max([0,min([MP.dtmcNumRv,rvIdx])]);
            for k=0:1
                thetaIdx = thetaIdxL +k;
                thetaIdxP = max([-MP.dtmcNumTheta,min(MP.dtmcNumTheta,thetaIdx)]);

                nextStateOrder = rIdxP*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1)+ ...
                                 rvIdxP*(2*MP.dtmcNumTheta+1)+ ...
                                 (thetaIdxP+MP.dtmcNumTheta);

                prob = sigmaP*(1-abs(rIdx-rP/MP.dtmcResR))*(1-abs(rvIdx-rvP/MP.dtmcResRv))*(1-abs(thetaIdx-thetaP/MP.dtmcResTheta));
                nextStateandProb = [nextStateandProb;[nextStateOrder,prob]];
            end
        end
    end

end

for entry=1:length(nextStateandProb(:,1))

    nextStateOrder = nextStateandProb(entry,1);
    k = find(transStateProb(:,1) == nextStateOrder);
    isPairFound = ~isempty(k);

    if isPairFound
        transStateProb(k,2) = transStateProb(k,2) + nextStateandProb(entry,2);
    else
        transStateProb = [transStateProb;nextStateandProb(entry,:)];
    end

end
transStateProb(1,:) = [];

DTMCProbs = transStateProb;

end

