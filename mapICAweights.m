function [ALLEEG EEG] = mapICAweights(ALLEEG, dataFolder,inputDataFileName,ICAComp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script mapICAweights.m 
% Maps ICA weights of 1Hz highpass filtered data to the weights of 
% 0.01Hz highpass filtered data.
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))

% Load 0.01Hz filtered data
EEG = pop_loadset('filename',inputDataFileName,'filepath',dataFolder);


% Map ICA weights of 1 Hz filtred data to 0.01Hz filtered data
EEG.icawinv = ICAComp.icawinv;
EEG.icasphere = ICAComp.icasphere;
EEG.icaweights = ICAComp.icaweights;
EEG.icachansind = ICAComp.icachansind;

% save the 0.01 Hz filtered data
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder, inputDataFileName),'gui','off');
        