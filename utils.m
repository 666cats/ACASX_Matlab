function StateDate = utils(actionCode)

%StateDate(1)=ActionV (2)=ActionA
StateDate = zeros(2,1);

if actionCode == -1
    disp('NO DATA IN LOOP!');
    return
elseif actionCode == 0
    StateDate(1) = NaN;
    StateDate(2) = 0;
elseif actionCode == 1
    StateDate(1) = 25;
    StateDate(2) = 8;
elseif actionCode == 2
    StateDate(1) = -25;
    StateDate(2) = -8;
elseif actionCode == 3
    StateDate(1) = 25;
    StateDate(2) = 10.7;
elseif actionCode == 4
    StateDate(1) = -25;
    StateDate(2) = -10.7;
elseif actionCode == 5
    StateDate(1) = 42;
    StateDate(2) = 10.7;
elseif actionCode == 6
    StateDate(1) = -42;
    StateDate(2) = -10.7;
else
    disp('Utils Wrong!');
end

end