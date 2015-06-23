% script file: Parallel test.
% Run 2D datasets using parfor.

close all
clc

mac_path_to = '~/Documents/propio/PhD/ISBI/ISBI_Challenge/TrainingDatasets/';
%linux_path_to = '~/Documents/PhD/ISBI/CHALLENGE/';

A = struct('one', struct('name','Fluo-C2DL-MSC','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'two', struct('name','Fluo-N2DH-GOWT1','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'three', struct('name','Fluo-N2DH-SIM','labels',6,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'four',struct('name','Fluo-N2DH-SIM+','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'five',struct('name','Fluo-N2DL-HeLa','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]));
    
disp('Doing 2D datasets');

fields = fieldnames(A);
N = length(fields);
for i=1:N
    disp(A.(fields{i}).name);
    NAME = A.(fields{i}).name;
    M = A.(fields{i}).labels;
    seg = [];
    tra = [];
    tot = [];
    mB = [];
    parfor j=1:M
        H = mainPhagoSight(strcat(mac_path_to,NAME),strcat('0',num2str(j)));
        [seg(j),tra(j)] = evaluationSoftware(strcat(path_to,NAME),...
                strcat('0',num2str(j)));
        tot(j) = seg(j)+tra(j);
        mB(j) = H.minBlob;
    end
    A.(fields{i}).seg = seg;
    A.(fields{i}).tra = tra;
    A.(fields{i}).tot = tot;
    A.(fields{i}).mB = mB;
    
    disp('');
    disp('Results [mB;total]');
    disp([mB;tot]);
    disp('');
end

%% 3D
% 
close all
clc

s = cputime;

% 3D directories
B = struct('one', struct('name','Fluo-C3DH-H157','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'two', struct('name','Fluo-C3DL-MDA231','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'three', struct('name','Fluo-N3DH-CE','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'four',struct('name','Fluo-N3DH-CHO','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'five',struct('name','Fluo-N3DH-SIM','labels',6,...
        'mB',[],'seg',[],'tra',[], 'tot',[]),...
        'six',struct('name','Fluo-N3DH-SIM+','labels',2,...
        'mB',[],'seg',[],'tra',[], 'tot',[]));
    
mac_path_to = '~/Documents/propio/PhD/ISBI/ISBI_Challenge/TrainingDatasets/';
%linux_path_to = '~/Documents/PhD/ISBI/CHALLENGE/';

disp('Doing 3D datasets');
fields = fieldnames(B);
N = length(fields);
for i=1:N
    disp(B.(fields{i}).name);
    NAME = B.(fields{i}).name;
    M = B.(fields{i}).labels;
    seg = [];
    tra = [];
    tot = [];
    parfor j=1:M
        H = mainPhagoSight(strcat(mac_path_to,NAME),strcat('0',num2str(j)));
        [seg(j),tra(j)] = evaluationSoftware(strcat(mac_path_to,NAME),...
                strcat('0',num2str(j)));
        tot(j) = seg(j)+tra(j);
        mB(j) = H.minBlob;
    end
    B.(fields{i}).seg = seg;
    B.(fields{i}).tra = tra;
    B.(fields{i}).tot = tot;
    B.(fields{i}).mB = mB;
end
s = cputime - s;
