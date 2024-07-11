function Actions = getActions(cStates,statesIdx,MP)

%Action is row vector
if (cStates(statesIdx).h == MP.mdpUpperH || cStates(statesIdx).oVy == MP.mdpUpperVy)
    Actions(1) = 0;
    Actions(2) = 4;
    return
end

if (cStates(statesIdx).h == -MP.mdpUpperH || cStates(statesIdx).oVy == -MP.mdpUpperVy)
    Actions(1) = 0;
    Actions(2) = 3;
    return
end

if (cStates(statesIdx).ra == 0)
    Actions(1) = 0;
    Actions(2) = 1;
    Actions(3) = 2;
    return
end

if (cStates(statesIdx).ra == 1)
    Actions(1) = 0;
    Actions(2) = 1;
    Actions(3) = 4;
    Actions(4) = 5;
    return
end

if (cStates(statesIdx).ra == 2)
    Actions(1) = 0;
    Actions(2) = 2;
    Actions(3) = 3;
    Actions(4) = 6;
    return
end

if (cStates(statesIdx).ra == 3)
    Actions(1) = 0;
    Actions(2) = 3;
    Actions(3) = 4;
    Actions(4) = 5;
    return
end

if (cStates(statesIdx).ra == 4)
    Actions(1) = 0;
    Actions(2) = 3;
    Actions(3) = 4;
    Actions(4) = 6;
    return
end

if (cStates(statesIdx).ra == 5)
    Actions(1) = 0;
    Actions(2) = 3;
    Actions(3) = 4;
    Actions(4) = 5;
    return
end

if (cStates(statesIdx).ra == 6)
    Actions(1) = 0;
    Actions(2) = 3;
    Actions(3) = 4;
    Actions(4) = 6;
    return
end

disp('getAction Wrong!')
return

end

