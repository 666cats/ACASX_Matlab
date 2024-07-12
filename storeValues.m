function [] = storeValues(uStates,U,MP)

numUstates = length(uStates);
entryTimeDistributionFileWriter = [];

for i=1:MP.timeHorizon+1
    fprintf("The iter is %d\n",i);
    tempU = U(i,:)';
    entryTimeDistributionFileWriter = [entryTimeDistributionFileWriter;tempU];
end

save('/home/yu/codetest/ACASX_FileStore/entryTimeDistributionFile',"entryTimeDistributionFileWriter");
end