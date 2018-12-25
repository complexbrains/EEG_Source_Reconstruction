function filterData(ALLEEG, dataFolder,inputDataFileName,rawDataName, highPassFilter, filterOrder,highPassName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script filterData.m
% Highpass, lowpass and notch filter the data (50Hz) and saves. The filter
% order for both highpass and lowpass filters are designed regarding the 
% data sampling rate. The user should change the filter order regarding 
% the sampling rate of the current data. 
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
outputDataFileName =  strcat(rawDataName,highPassName);


% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))

%% Load unfiltred raw data
EEG = pop_loadset('filename',inputDataFileName,'filepath',dataFolder);


%% High pass filter the data - filter order depends on the sampling rate
EEG = pop_eegfiltnew(EEG, highPassFilter,[],filterOrder , 0, [], 0);


[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');


%% Low pass filter the data at 80 Hz - filter order depends on the sampling rate
EEG = pop_eegfiltnew(EEG, [], 90, 40, 0, [], 0)
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');



%% Notch filter at 50 Hz - filter order depends on the sampling rate
EEG = pop_eegfiltnew( EEG, 47.5, 52.5, [], 1 );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder,outputDataFileName),'gui','off');

