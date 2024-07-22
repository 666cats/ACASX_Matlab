clc
clear all

load("/home/yu/codetest/ACASX_FileStore/actionFile.mat");
load("/home/yu/codetest/ACASX_FileStore/indexFile.mat");
load("/home/yu/codetest/ACASX_FileStore/costFile.mat");
MP = getModelParams();
Res = 1;
hLower = -MP.mdpUpperH + Res;
hHigher = MP.mdpUpperH - Res;

oVy = 0;
iVy = 0;
lastRA = 0;
stateAndBestRa = [];

numCStates = (2*MP.mdpNumH+1)*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa;

for t=0:MP.timeHorizon
    for h=hLower:Res:hHigher

        qValueMap = nan(1,2);

        hIdxL = floor(h/MP.mdpResH);
        oVyIdxL = floor(oVy/MP.mdpResOvy);
        iVyIdxL = floor(iVy/MP.mdpResIvy);

        actionMapValues = [];

        for i=0:1
            hIdx = hIdxL + i;
            hIdxP = max([-MP.mdpNumH,min([MP.mdpNumH,hIdx])]);
            for j=0:1
                oVyIdx = oVyIdxL + j;
                oVyIdxP = max([-MP.mdpNumOvy,min([MP.mdpNumOvy,oVyIdx])]);
                for k=0:1
                    iVyIdx = iVyIdxL + k;
                    iVyIdxP = max([-MP.mdpNumIvy,min([MP.mdpNumIvy,iVyIdx])]);

                    a = hIdxP + MP.mdpNumH;
                    b = oVyIdxP + MP.mdpNumOvy;
                    c = iVyIdxP + MP.mdpNumIvy;

                    approxCstateOrder = a*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                        b*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                                        c*MP.mdpNumRa+ ...
                                        lastRA;

                    prob = (1-abs(hIdx - h/MP.mdpResH))*(1-abs(oVyIdx - oVy/MP.mdpResOvy))*(1-abs(iVyIdx - iVy/MP.mdpResIvy));

                    index = indexFileWrite(t*numCStates+approxCstateOrder+1);
                    numAction = indexFileWrite(t*numCStates+approxCstateOrder+2) - index;

                    for n=0:numAction - 1
                        qValue = costFileWrite(index+n+1);
                        actionCode = actionFileWrite(index+n+1);
                        actionMapValues = [actionMapValues;[actionCode,prob*qValue]];
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

        maxQValue = qValueMap(1,2);
        bestActionCode = qValueMap(1,1);

        for entry=1:length(qValueMap(:,1))
            value = qValueMap(entry,2);
            if value - maxQValue > 0.0001
                maxQValue = value;
                bestActionCode = qValueMap(entry,1);
            end
        end

        stateAndBestRa = [stateAndBestRa;[t,h,bestActionCode]];

    end
end

hNum = 2*h/Res+1;
temp = zeros(hNum,MP.timeHorizon);
for i=1:MP.timeHorizon+1
    temp(:,i) = stateAndBestRa((i-1)*hNum+1:i*hNum,3);
end
% temp = flip(temp);

ActionColor = nan(hNum,MP.timeHorizon,3);

for i=1:MP.timeHorizon+1
    for j=1:hNum
        if temp(j,i)==0
            ActionColor(j,i,1) = 1;
            ActionColor(j,i,2) = 1;
            ActionColor(j,i,3) = 1;
        elseif temp(j,i)==1
            ActionColor(j,i,1) = 1;
            ActionColor(j,i,2) = 1;
            ActionColor(j,i,3) = 0;
        elseif temp(j,i)==2
            ActionColor(j,i,1) = 0;
            ActionColor(j,i,2) = 1;
            ActionColor(j,i,3) = 0;
        elseif temp(j,i)==3
            ActionColor(j,i,1) = 0;
            ActionColor(j,i,2) = 0;
            ActionColor(j,i,3) = 1;
        elseif temp(j,i)==4
            ActionColor(j,i,1) = 1;
            ActionColor(j,i,2) = 0;
            ActionColor(j,i,3) = 0;
        elseif temp(j,i)==5
            ActionColor(j,i,1) = 255/256;
            ActionColor(j,i,2) = 165/256;
            ActionColor(j,i,3) = 0;
        elseif temp(j,i)==6
            ActionColor(j,i,1) = 0;
            ActionColor(j,i,2) = 128/256;
            ActionColor(j,i,3) = 0;
        end
    end
end

figure(1);
ActionFig = image(ActionColor);
hold on
y_range = get(ActionFig,'YData');
x_range = get(ActionFig,'XData');
newy_range = linspace(hLower,hHigher,length(y_range));
newx_range = linspace(5,MP.timeHorizon+5,length(x_range));
set(ActionFig,'YData',newy_range);
set(ActionFig,'XData',newx_range);
ylim([-MP.mdpNumH,MP.mdpNumH]);
set(gca,'YDir','normal');
axis tight;
xlim([0,MP.timeHorizon+7]);
grid on;
xlabel(['oVy=',num2str(oVy),' iVy=',num2str(iVy),' lastRA=',num2str(lastRA)]);
hold off;