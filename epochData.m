function epochData(ALLEEG, dataFolder,inputDataFileName,eventList,eventOnset,eventOffset)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script epochData.m 
% Epochs th data based on the event list and eventOnset and eventOfset
% inputs.
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))


%% Load filtred data
EEG = pop_loadset('filename',inputDataFileName,'filepath',dataFolder);

%% select events
EEG = pop_selectevent( EEG, 'type',eventList,'deleteevents','on');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8,'savenew',fullfile(dataFolder,inputDataFileName),'gui','off');


%% epoch events
EEG = pop_epoch( EEG, eventList, [eventOnset           eventOffset], 'newname',  sprintf('%s_epoched', blockNames{blockNum}), 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,inputDataFileName),'gui','off');
EEG = eeg_checkset( EEG );

%% Baseline corrections
EEG = pop_rmbase( EEG, [eventOnset   0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,inputDataFileName),'gui','off');