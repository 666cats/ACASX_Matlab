function MDPConfig = mdpConfig(MP)

numCstates = (2*MP.mdpNumH+1)*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa;
emptyStruct = struct('h',0,'oVy',0,'iVy',0,'ra',0,'order',0);
cStates = repmat(emptyStruct,numCstates,1);

for hIdx = -MP.mdpNumH:MP.mdpNumH
    for oVyIdx = -MP.mdpNumOvy:MP.mdpNumOvy
        for iVyIdx = -MP.mdpNumIvy:MP.mdpNumIvy
            for raIdx = 0:MP.mdpNumRa-1

                h = MP.mdpResH*hIdx;
                oVy = MP.mdpResOvy*oVyIdx;
                iVy = MP.mdpResIvy*iVyIdx;
                ra = raIdx;

                a = hIdx + MP.mdpNumH;
                b = oVyIdx + MP.mdpNumOvy;
                c = iVyIdx + MP.mdpNumIvy;

                order = a*(2*MP.mdpNumOvy+1)*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                        b*(2*MP.mdpNumIvy+1)*MP.mdpNumRa+ ...
                        c*MP.mdpNumRa+ ...
                        ra;

                cStates(order+1).h = h;
                cStates(order+1).oVy = oVy;
                cStates(order+1).iVy = iVy;
                cStates(order+1).ra = ra;
                cStates(order+1).order = order;



            end
        end
    end
end

MDPConfig = cStates;
end