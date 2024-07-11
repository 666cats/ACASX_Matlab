function MDPVIConfig = mdpVIConfig(MP,cStates)

numCstates = (2*MP.mdpNumH+1)*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa;
U = zeros(MP.timeHorizon+2,numCstates);

U(MP.timeHorizon+2,:) = 0;
for i=1:numCstates
    U(1,i) = getReward(cStates,i,-1);
end

JkBar = zeros(1,numCstates);

sigmaPoint.A(1,:)=[0,0,0.5];
sigmaPoint.A(2,:)=[0,sqrt(2)*MP.mdpWhiteNoise,0.25];
sigmaPoint.A(3,:)=[0,-sqrt(2)*MP.mdpWhiteNoise,0.25];

sigmaPoint.B(1,:)=[0,0,1/3];
sigmaPoint.B(2,:)=[sqrt(3)*MP.mdpWhiteNoise,0,1/6];
sigmaPoint.B(3,:)=[-sqrt(3)*MP.mdpWhiteNoise,0,1/6];
sigmaPoint.B(4,:)=[0,sqrt(3)*MP.mdpWhiteNoise,1/6];
sigmaPoint.B(5,:)=[0,-sqrt(3)*MP.mdpWhiteNoise,1/6];


for iteration=2:MP.timeHorizon+1
    fprintf('The mdpVI iteration is %d\n',iteration-1);
    for i=1:numCstates
        actionArry = getActions(cStates,i,MP);
        aMax1 = -1e12;
        aMax2 = -1e12;
        for j = 1:length(actionArry)
            aSum1 = getReward(cStates,i,actionArry(j));
            aSum2 = getReward(cStates,i,actionArry(j));
            SP = getTransitionStatesAndProbs(cStates,i,actionArry(j),sigmaPoint,MP);

            for entry=1:length(SP(:,1))
                nextStateOrder = SP(entry,1);
                aSum1 = aSum1 + SP(entry,2)*U(iteration-1,nextStateOrder+1);
                aSum2 = aSum2 + SP(entry,2)*U(MP.timeHorizon+2,nextStateOrder+1);
            end

            aMax1 = max([aSum1,aMax1]);
            aMax2 = max([aMax2,aSum2]);
        end

        U(iteration,i) = aMax1;
        JkBar(i) = aMax2;
    end

    for i=1:numCstates
        U(MP.timeHorizon+2,i) = JkBar(i);
    end
end

MDPVIConfig = U;

end