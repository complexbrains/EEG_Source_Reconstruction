function convertRawDataFormat(subjectPool,pwd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script convertRawDataFormat.m 
% Interpolates the noisy channels, remove ECG channel, Re-reference to 
% average of the channels, % downsample data to 250 Hz
% 
% Isil Bilgin 12/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;

% Add EEGLAB to path
addpath(fullfile('C:\Program Files\MATLAB\R2017a\toolbox','Software','eeglab14_1_2b'))



for subjectNum=1:size(subjectPool,2)
    mainSubjectFolder =  fullfile(pwd, sprinf('Subject%s',subjectPool{subjectNum}));
    dataFolder =fullfile(mainSubjectFolder,'rawDataFolder');
    
    
    %% Read raw data files
    theFiles=dir(fullfile(dataFolder, '*.vhdr'));
    
    %% start EEGLAB
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    %% loop over the input data files
    
    for fileIndex=1:length(theFiles)
        name{fileIndex} = strrep(theFiles(fileIndex).name, '.vhdr', '');
        
        % load rawdata BrainVision
        EEG = pop_loadbv(dataFolder,[ name{fileIndex} ,'.vhdr']);
        EEG = pop_saveset(EEG, [name{fileIndex},'.set'], dataFolder);
    end
    
end



