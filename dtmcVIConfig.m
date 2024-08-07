function DTMCVIConfig = dtmcVIConfig(MP,uStates)

numUstates = (MP.dtmcNumR+1)*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1);
U = zeros(MP.timeHorizon+2,numUstates);
Utemp = zeros(1,numUstates);

for i=1:numUstates
    if uStates(i).r<=MP.dtmcCollisionR
        U(1,i) = 1;
    else
        U(1,i) = 0;
    end
end

sigmaPoint.A(1,:) = [0,0,1/3];
sigmaPoint.A(2,:) = [sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.A(3,:) = [-sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.A(4,:) = [0,sqrt(3)*2*MP.dtmcWhiteNoise,1/6];
sigmaPoint.A(5,:) = [0,-sqrt(3)*2*MP.dtmcWhiteNoise,1/6];

sigmaPoint.B(1,:) = [0,0,1/3];
sigmaPoint.B(2,:) = [sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.B(3,:) = [-sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.B(4,:) = [0,sqrt(3)*2*MP.dtmcWhiteNoiseAngle,1/6];
sigmaPoint.B(5,:) = [0,-sqrt(3)*2*MP.dtmcWhiteNoiseAngle,1/6];

for iteration=2:MP.timeHorizon+1
    fprintf('The dtmcVI iteration is %d\n',iteration-1);
    parfor i=1:numUstates
        prob = 0;
        if uStates(i).r > MP.dtmcCollisionR
            SP = getDtmcProbs(uStates,i,sigmaPoint,MP);
            for entry=1:length(SP(:,1))
                nextStateOrder = SP(entry,1);
                prob = prob + SP(entry,2)*U(iteration-1,nextStateOrder+1);
            end
        end
        % Utemp(iteration,i) = prob;
        Utemp(i) = prob;
    end
    U(iteration,:) = Utemp;
end

DTMCVIConfig = U;
end