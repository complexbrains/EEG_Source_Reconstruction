function [EEG, ALLEEG] =initialPreprocessing(ALLEEG,channel2interpolate, dataFolder,inputDataFileName, outputDataFileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script initialPreprocessing.m 
% Epochs th data based on the event list and eventOnset and eventOfset
% inputs.
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




EEG = pop_loadset('filename',inputDataFileName,'filepath',dataFolder);


if ~isempty(channel2interpolate)
    %% Interpolate Noisy channels
    EEG = pop_interp(EEG, channel2interpolate, 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');
end

%% Remove ECG Channel

EEG = pop_select( EEG,'nochannel',{'ECG'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');



%% average reference
EEG = pop_reref( EEG, []);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');



%% resample data to %250
EEG = pop_resample( EEG, 250);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');
