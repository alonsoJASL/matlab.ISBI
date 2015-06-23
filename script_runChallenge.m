% script file: Run Challenge.
%
% Scrpt file that runs all the datasets for the ISBI Cell Tracking
% Challenge. 
%
clear all
close all 
clc

mac_path_to = '~/Documents/propio/PhD/ISBI/ISBI_Challenge/ChallengeDataSets';
linux_path_to = '~/Documents/PhD/ISBI/CHALLENGE';

% Datasets.
A = struct('one', struct('name','Fluo-C2DL-MSC','labels',2),...
        'two', struct('name','Fluo-N2DH-GOWT1','labels',2),...
        'three', struct('name','Fluo-N2DH-SIM','labels',6),...
        'four',struct('name','Fluo-N2DH-SIM+','labels',2),...
        'five',struct('name','Fluo-N2DL-HeLa','labels',2),...
        'one3', struct('name','Fluo-C3DH-H157','labels',2),...
        'two3', struct('name','Fluo-C3DL-MDA231','labels',2),...
        'three3', struct('name','Fluo-N3DH-CE','labels',2),...
        'four3',struct('name','Fluo-N3DH-CHO','labels',2),...
        'five3',struct('name','Fluo-N3DH-SIM','labels',6),...
        'six3',struct('name','Fluo-N3DH-SIM+','labels',2),...
        'seven3',struct('name','Fluo-N3DL-DRO','labels',2),...
        'eigth', struct('name','PhC-C2DL-PSC', 'labels',2));
    
fields = fieldnames(A);
%% Run Datasets
for i=1:length(fields)
    disp(A.(fields{i}).name);
    dSet = strcat(linux_path_to, '/', A.(fields{i}).name);
    L = A.(fields{i}).labels;
    FN = [];
    H = [];
    indx = [];
    test = 0;
    parfor j=1:L
        label = strcat('0',num2str(j));
        H = mainPhagoSight(dSet,label);
        csvwrite(strcat(dSet,'/0',num2str(j),'finalNet.csv')...
            ,H.timedFinalNetwork);
        indx = sum(H.timedFinalNetwork,2);
        if isempty(indx)
            test = test + 1;
        end
    end
    if test == L
        fprintf('Dataset: %s is OK!\n', A.(fields{i}).name);
    else
        disp('Problems!');
    end 
end

%% Try Datasets out!
clc
for i=1:length(fields)
    L = A.(fields{i}).labels;
    test = 0;
    for j=1:L
        str = strcat(linux_path_to,'/',A.(fields{i}).name,'/0',num2str(L),...
                     'finalNet.csv');
        M = csvread(str);
        indx = find(sum(M,2) == 0);
        figure(1);
        spy(M);
        ss = strcat(A.(fields{i}).name,'/0',num2str(j));
        title(ss);
        pause(0.5);
        if ~isempty(indx)
            fprintf('Problems in: %s/0%d.\n',A.(fields{i}).name,j);
            disp(indx');
        else
            test = test + 1;
        end
    end
    if test == L
        fprintf('Dataset: %s is OK!\n', A.(fields{i}).name);
    end
end



