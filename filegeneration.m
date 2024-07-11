clc
clear all

ModelParams = getModelParams();

% mdp process
% cStates = mdpConfig(ModelParams);
% U1 = mdpVIConfig(ModelParams,cStates);
% storeQValues(cStates,U1,ModelParams);

%% mdp and dtmc are decoupled and can run independently

%dtmc process
uStates = dtmcConfig(ModelParams);
U2 = dtmcVIConfig(ModelParams,uStates);
storeValues(uStates,U2,ModelParams);
