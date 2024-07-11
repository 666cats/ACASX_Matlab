function ModelParams = getModelParams()

ModelParams.timeHorizon = 20;%生成表的时间步长

ModelParams.dtmcCollisionR = 500;

ModelParams.dtmcUpperR = 12200;
ModelParams.dtmcUpperRv = 610;
ModelParams.dtmcUpperTheta = 180;

ModelParams.dtmcNumR = 61;
ModelParams.dtmcNumRv = 61;
ModelParams.dtmcNumTheta = 36;

ModelParams.dtmcResR = ModelParams.dtmcUpperR/ModelParams.dtmcNumR;
ModelParams.dtmcResRv = ModelParams.dtmcUpperRv/ModelParams.dtmcNumRv;
ModelParams.dtmcResTheta = ModelParams.dtmcUpperTheta/ModelParams.dtmcNumTheta;

ModelParams.dtmcWhiteNoise = 3;

%% mdp Params

ModelParams.mdpUpperH = 600;
ModelParams.mdpUpperVy = 70;

ModelParams.mdpNumH = 10;
ModelParams.mdpNumOvy = 7;
ModelParams.mdpNumIvy = 7;
ModelParams.mdpNumRa = 7;

ModelParams.mdpResH = ModelParams.mdpUpperH/ModelParams.mdpNumH;
ModelParams.mdpResOvy = ModelParams.mdpUpperVy/ModelParams.mdpNumOvy;
ModelParams.mdpResIvy = ModelParams.mdpUpperVy/ModelParams.mdpNumIvy;

ModelParams.mdpWhiteNoise = 3;

end
