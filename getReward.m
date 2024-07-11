function Reward = getReward(cStates,statesIdx,actionCode)

if actionCode == -1 %Init
    if abs(cStates(statesIdx).h) < 100
        Reward = -10000;
        return
    else
        Reward = 0;
        return
    end
end

if actionCode == 0 %COC
    Reward = 100;
    return
end

if actionCode == 1 %CL25
    if (cStates(statesIdx).oVy > 0)
        Reward = -50;
        return
    elseif (cStates(statesIdx).oVy < 0)
        Reward = -100;
        return
    end
end

if actionCode == 2 %DES25
    if (cStates(statesIdx).oVy > 0)
        Reward = -100;
        return
    elseif (cStates(statesIdx).oVy < 0)
        Reward = -50;
        return
    end
end
%strong action
if (((cStates(statesIdx).ra == 1 || cStates(statesIdx).ra == 3) && actionCode == 5) ||...
    ((cStates(statesIdx).ra == 2 || cStates(statesIdx).ra == 4) && actionCode == 6))

    Reward = -500;
    return
end
%reverse action
if (((cStates(statesIdx).ra == 1 || cStates(statesIdx).ra == 3 || cStates(statesIdx).ra == 5) && actionCode == 4) ||...
    ((cStates(statesIdx).ra == 2 || cStates(statesIdx).ra == 4 || cStates(statesIdx).ra == 6) && actionCode == 3))

    Reward = -1000;
    return
end

Reward = 0;

end