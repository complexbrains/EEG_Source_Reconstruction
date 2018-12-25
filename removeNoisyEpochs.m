function removeNoisyEpochs(ALLEEG, dataFolder,inputDataFileName,epochs2remove)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script removeNoisyEpochs.m 
% Removes the noisy epochs found in visual inspection.
%
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))

outputDataFileName = inputDataFileName; % save onto the same data

%% Load the epoched data
EEG = pop_loadset('filename',inputDataFileName,'filepath',dataFolder);

%% Remove epochs
EEG = pop_select( EEG,'notrial',epochs2remove);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder, outputDataFileName),'gui','off');
EEG = eeg_checkset( EEG );

end
