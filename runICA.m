function ICAComp = runICA(ALLEEG, dataFolder,inputDataFileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script runICA.m 
% Runs ICA on 1Hz highpass filtered data and gets the ICA outputs to map to 
% 0.01Hz highpass filtered data.
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))


EEG = pop_runica(EEG, 'extended',1,'interupt','on');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder, inputDataFileName),'gui','off');
ICAComp.icawinv = EEG.icawinv;
ICAComp.icasphere = EEG.icasphere;
ICAComp.icaweights = EEG.icaweights;
ICAComp.icachansind = EEG.icachansind;
