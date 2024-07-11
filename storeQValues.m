function [] = storeQValues(cStates,U,MP)

index = 0;
numCStates = length(cStates);
indexFileWrite = [];
costFileWrite = U(1,:)';
actionFileWrite = zeros(numCStates,1);

sigmaPoint.A(1,:)=[0,0,0.5];
sigmaPoint.A(2,:)=[0,sqrt(2)*MP.mdpWhiteNoise,0.25];
sigmaPoint.A(3,:)=[0,-sqrt(2)*MP.mdpWhiteNoise,0.25];

sigmaPoint.B(1,:)=[0,0,1/3];
sigmaPoint.B(2,:)=[sqrt(3)*MP.mdpWhiteNoise,0,1/6];
sigmaPoint.B(3,:)=[-sqrt(3)*MP.mdpWhiteNoise,0,1/6];
sigmaPoint.B(4,:)=[0,sqrt(3)*MP.mdpWhiteNoise,1/6];
sigmaPoint.B(5,:)=[0,-sqrt(3)*MP.mdpWhiteNoise,1/6];

for i=1:numCStates
    indexFileWrite = [indexFileWrite;index];
    index = index + 1;
end

for i=2:MP.timeHorizon+2
    fprintf("mdp store iter is %d\n",i-1);
    for j=1:numCStates
        actionArry = getActions(cStates,j,MP);
        indexFileWrite = [indexFileWrite;index];
        actionFileWrite = [actionFileWrite;actionArry'];
        for k=1:length(actionArry)
            qValue = 0;
            SP = getTransitionStatesAndProbs(cStates,j,actionArry(k),sigmaPoint,MP);
            for entry=1:length(SP(:,1)) 
                nextStateOrder = SP(entry,1);
                qValue = qValue + SP(entry,2)*U(i-1,nextStateOrder+1);
            end
            costFileWrite = [costFileWrite;qValue];
        end
        index = index + length(actionArry);
    end
end

indexFileWrite = [indexFileWrite,index];

save('indexFile.mat','indexFileWrite');
save('actionFile.mat','actionFileWrite');
save('costFile.mat','costFileWrite');

end