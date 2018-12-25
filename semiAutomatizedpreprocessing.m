%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% semiAutomatizedpreprocessing.m
% This scrips loads raw data from BrainVision recordings,
% converts it to EEGLAB .set file.
%
% Some of the preprocessing steps in this script followed the pipeline
% described in https://sccn.ucsd.edu/wiki/Makoto's_preprocessing_pipeline.
% Highpass filtering was applied to the data as it was recommended in
% Tanner, D., Morgan-Short, K., & Luck, S. J. (2015). How inappropriate
% high-pass filters can produce artifactual effects and incorrect
% conclusions % in ERP studies of language and cognition. Psychophysiology,
% 52, 997-1009.
%
% This script follows a semi-automatic preprocessing pipeline. It requires
% visual inspection of the data for the noisy channels, noisy epochs and
% artifactual ICA components.
%
% The scripts calls following functions
%   convertRawDataFormat.m
%   initialPreprocessing.m
%   filterData.m
%   epochData.m
%   removeNoisyEpochs.m
%   runICA.m
%   mapICAweights.m
%
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;


%% Set Parameters
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b')) %% Add eeglab to the path
subjectPool={'01','02','03','04','05','06','07','08','09','10'};
pwd = ' '; % Add a main folder path
eventList = {'S101', 'S102'}; % list your data markers
numOfChannels = 63;
eventOnset = -0.2;
eventOffset = 0.8;
filterOrder_1Hz= 414; % set the filter order based on your sampling rate
highPassFilter_1Hz=2;
highPassName_1Hz = '_1Hz.set';
filterOrder_01Hz = 41250; % set the filter order based on your sampling rate
highPassFilter_01Hz =0.02;
highPassName_01Hz = '_01Hz.set';
rawDataName = 'rawFile';

% Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; 

%% Convert All Subjects' Raw data to EEGLAB format
convertRawDataFormat(subjectPool,pwd);


%% Manual Loop Starts
subjectNum = 1; % Manuel loop for visual inspection

mainSubjectFolder =  fullfile(pwd, sprinf('Subject%s',subjectPool{subjectNum}));
dataFolder =fullfile(mainSubjectFolder,'rawDataFolder');

% Load EEG data
EEG = pop_loadset('filename',strcat(rawDataName,'.set'),'filepath',dataFolder);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );


%% Visual Inspection: Choose the noisy channels
pop_eegplot( EEG, 1, 1, 1);
channel2interpolate =  [ ]; % list noisy channels


%% Initial Cleaning: Interpolate the noisy channels, remove ECG channel, Re-reference, Downsample
inputDataFileName = strcat(rawDataName,'.set');
outputDataFileName = strcat(rawDataName,'_initprep.set');
[EEG, ALLEEG] =initialPreprocessing(channel2interpolate, dataFolder,inputDataFileName, outputDataFileName);


%% Prepare 1 Hz Filtered Data and run ICA on 1 Hz filtred data
inputDataFileName = strcat(rawDataName,'_initprep.set');

[EEG,ALLEEG]= filterData(ALLEEG, dataFolder,inputDataFileName,rawDataName, highPassFilter_1Hz, filterOrder_1Hz,highPassName_1Hz);


% Epoch 1 Hz Filtred Data
inputDataFileName =  strcat(rawDataName,'_1Hz.set');
epochData(ALLEEG, dataFolder,inputDataFileName,eventList,eventOnset,eventOffset);


% Visual Inspection: Choose the noisy epochs to remove
pop_eegplot( EEG, 1, 1, 1);
epochs2remove =[]; % the list of noisy epochs

% Remove noisy epochs
if ~isempty(epochs2remove)
    removeNoisyEpochs(ALLEEG, dataFolder,inputDataFileName,epochs2remove);
end

% Run ICA
ICAComp = runICA(ALLEEG, dataFolder,inputDataFileName);


%% Prepare 0.01 Hz filtered data

% Filter the raw data to 0.01 Hz
inputDataFileName = strcat(rawDataName,'.set');
filterData(ALLEEG, dataFolder,inputDataFileName, rawDataName, highPassFilter_01Hz, filterOrder_01Hz,highPassName_01Hz);

% Remove the noisy epochs were found before
inputDataFileName =  strcat(rawDataName,'_01Hz.set');
if ~isempty(epochs2remove)
    removeNoisyEpochs(ALLEEG, dataFolder,inputDataFileName,epochs2remove);
end

% Map ICA weights of 1 Hz data to 0.01 Hz Data
[ALLEEG EEG] = mapICAweights(ALLEEG, dataFolder,inputDataFileName,ICAComp);


%% Visual Inspection: Choose Artifactual ICs
pop_selectcomps(EEG, [1:numOfChannels] ) % plot ICA components
pop_eegplot( EEG, 0, 1, 1); % plot component timecourses
pop_eegplot( EEG, 1, 1, 1); % plot data

components2remove =[ ];

% Remove noise components
if ~isempty(components2remove)
    outputFileName = strcat(rawDataName,'_01Hz_cleane.set')
    EEG = pop_subcomp( EEG,components2remove, 0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(dataFolder, outputFileName),'gui','off');
end

%% Visual Inspection: After ICA cleaning look at the data plot again and if necessary remove more components
pop_eegplot( EEG, 0, 1, 1);
pop_selectcomps(EEG, [1:numOfChannels-size(components2remove,2)] );
