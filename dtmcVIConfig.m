function DTMCVIConfig = dtmcVIConfig(MP,uStates)

numUstates = (MP.dtmcNumR+1)*(MP.dtmcNumRv+1)*(2*MP.dtmcNumTheta+1);
U = zeros(MP.timeHorizon+2,numUstates);

for i=1:numUstates
    if uStates(i).r<=MP.dtmcCollisionR
        U(1,i) = 1;
    else
        U(1,i) = 0;
    end
end

sigmaPoint.A(1,:) = [0,0,1/3];
sigmaPoint.A(1,:) = [sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.A(1,:) = [-sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.A(1,:) = [0,sqrt(3)*2*MP.dtmcWhiteNoise,1/6];
sigmaPoint.A(1,:) = [0,-sqrt(3)*2*MP.dtmcWhiteNoise,1/6];

sigmaPoint.B(1,:) = [0,0,1/3];
sigmaPoint.B(1,:) = [sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.B(1,:) = [-sqrt(3)*2*MP.dtmcWhiteNoise,0,1/6];
sigmaPoint.B(1,:) = [0,sqrt(3)*2*MP.dtmcWhiteNoiseAngle,1/6];
sigmaPoint.B(1,:) = [0,-sqrt(3)*2*MP.dtmcWhiteNoiseAngle,1/6];

for iteration=2:MP.timeHorizon+1
    fprintf('The mdpVI iteration is %d\n',iteration-1);
    for i=1:numUstates
        prob = 0;
        if uStates(i).r > MP.dtmcCollisionR
            SP = getDtmcProbs(uStates,i,sigmaPoint,MP);