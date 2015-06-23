% script file: Profiling our code
% This script is done to profile our software and find out where it is
% taking more time. We may be able later to figure out how to reduce our
% time consumption. This will be also developed in the context of the ISBI
% Cell Tracking Challenge 2015.
%
% Jose Alonso Solis-Lemus february 2015.
%

% Testing on a 2D dataset.
dset = '~/Documents/PhD/ISBI/TRAINING/Fluo-N2DH-SIM';% LINUX
%dset = strcat('~/Documents/propio/PhD/ISBI/',...
%        'ISBI_Challenge/TrainingDatasets/Fluo-N2DH-SIM');% MAC
Label = '01';
LT = 74.505049;
HT = 78.730665;
mB = 250;

HP=mainPhagoSight(dset,Label, LT, HT, mB);
