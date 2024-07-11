clc
clear all

ModelParams = getModelParams();

% mdp process
cStates = mdpConfig(ModelParams);
U = mdpVIConfig(ModelParams,cStates);
storeQValues(cStates,U,ModelParams);

%% mdp and dtmc are decoupled and can run independently

%dtmc process

dtmcConfig(ModelParams);