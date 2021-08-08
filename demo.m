%%
clc
clear
close all

startup;

% 3 example image pairs
% 'USAC_test2','USAC_test3','USAC_test4','USAC_test5','USAC_test6','USAC_test8','USAC_test9',
% 'USAC_test7','USAC_test10'
%'graf1_2','graf1_3','graf1_4','graf1_5','graf1_6','wall1_2','wall1_3','wall1_4','wall1_5','wall1_6'
% 'bark1_2','bark1_3','bark1_4','bark1_5','bark1_6','trees1_2','trees1_3','trees1_4','trees1_5','trees1_6'
% 'bikes1_2','bikes1_3','bikes1_4','bikes1_5','bikes1_6','leuven1_2','leuven1_3','leuven1_4','leuven1_5','leuven1_6','ubc1_2','ubc1_3','ubc1_4','ubc1_5','ubc1_6'
% 'adam','city','Bost','Brus','Brug',
imageNames = {'wall1_6'};

Noise = 0;
noiseSigmaInPixels = 0;

GPMparams.byPercentileAverage = 1;
minimalSiftThreshold = 1.24;
% minimalSiftThreshold = 2.222;
USACparams.USAC_thresh = 30; % 2.0;  %
USACparams.USAC_LO = 1;

runName = 'MWE';
datasetName = 'Miko';

PerspectivePointMatching(runName,imageNames,datasetName,minimalSiftThreshold,Noise,noiseSigmaInPixels,GPMparams,USACparams);

keyboard