% script file: Test intensity distributions.
%
% 
% clear all
% close all 
% clc
% 
% unix('../../ISBI/TRAINING/removealltests.sh');
% 
% dSets ={{'Fluo-C2DL-MSC'}
%     {'Fluo-N2DH-GOWT1'}
%     {'Fluo-N2DH-SIM'}
%     {'Fluo-N2DH-SIM+'}
%     {'Fluo-N2DL-HeLa'}};
% for i=1:length(dSets)
%     path_to_dset = strcat('../../ISBI/TRAINING/',char(dSets{i}));
%     mainPhagoSight(path_to_dset,'01');
%     % always check where are the output files being stored.
%     st = strcat(path_to_dset,'/01thresholds.txt');
%     F = fopen(st,'r');
%     linea = fgets(F);
%     fclose(F);
%     FF = fopen('~/Desktop/normalisedThresholds','a');
%     fprintf(FF,'%s;%s\n',char(dSets{i}),linea);
% end

%% Testing manually 

%clear all
close all
clc

unix('../../ISBI/TRAINING/removealltests.sh');

dSets ={{'Fluo-C2DL-MSC'} % Has 01, 02
    {'Fluo-N2DH-GOWT1'}   % Has 01, 02
    {'Fluo-N2DH-SIM'}     % Has 01, 02, 03, 04, 05, 06
    {'Fluo-N2DH-SIM+'}    % Has 01, 02
    {'Fluo-N2DL-HeLa'}};  % has 01, 02

a = 1; % So the directory to try will be easily chosen.

path_to_dset = strcat('../../ISBI/TRAINING/',char(dSets{a}));
mainPhagoSight(path_to_dset, '02');
 