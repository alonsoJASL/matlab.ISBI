% Script file: Manual Training
% This script file presents the results for the manual training conducted 
% by the SW/BASH/fullTraining.sh script file that was used to produce the
% ISBI/TRAINING/fullmanualoutput.csv file. 
% 
% We'll try and present the results so that we may find a range for the 
% parameters $(\alpha, \beta)$ parameters to try a new training set. After
% it, we'll do a full "double run" to verify which of the approaches is
% best for each dataset. The approaches are:
% 
%                   + BY LABEL : $(\alpha, \beta)_{label}$
%                   + BY DATASET : $(\alpha, \beta)_{DS}$
%                   + GLOBALLY : (\alpha, \beta)_{G}
% 
% We would expect a better result from the LABEL approach, but this can
% vary depending on the dataset. It will also have the highest variance and
% least reliability. Note that this script depends heavily on the
% structure of the file. 
%
% Jose Alonso Solis-Lemus
% February 12th, 2015
%

clear all
close all
clc

format shortg
str = '~/Documents/PhD/ISBI/TRAINING/';
M = csvread(strcat(str, 'fullmanualoutput.csv'), 1,1);
% COLUMNS: access them with M(:,k) where k={1,2,...,8}
% | LABEL | LT | HT | MIN | MODE | SEG | TRA | TIME |
% |   0N  | oL | oH | MIN | MODE | oSE | oTR | oTIM | indx
% |   0N  | nL | nH | MIN | MODE | nSE | nTR | nTIM | indx+1
% 
% Note that we have 8 datasets:
dSets = struct('FluoC2DLMSC',[],... % Has 01, 02
    'FluoN2DHGOWT1',[],...   % Has 01, 02
    'FluoN2DHSIM', [],...     % Has 01, 02, 03, 04, 05, 06
    'FluoN2DHSIMplus', [],...    % Has 01, 02
    'FluoN2DLHeLa',[]);  % has 01, 02
fields = fieldnames(dSets);
lab_per_dSet = [2;2;6;2;2];

indx = 1;
 str = strcat('          LABEL        LT           HT          MIN     ',...
     '        MODE           SEG          TRA         TIME');
 disp(str);
for i=1:length(fields)
    data = struct('alpha',[],'beta',[],'time',[],'grade', []);
    for k=1:lab_per_dSet(i)
        disp([M(indx,:);M(indx+1,:)]);
        data.alpha(k) = (M(indx+1,2)-M(indx,5))/(M(indx,2)-M(indx,4));
        data.beta(k) = (M(indx+1,3)-M(indx,5))/(M(indx,3)-M(indx,4));
        data.time(k) = M(indx+1,8);
        data.grade(k) = M(indx+1,6)+M(indx+1,7);
        if indx < length(M(:,1))-1
            indx = indx + 2;
        end
    end
    data.alpha(k+1) = mean(data.alpha);
    data.beta(k+1) = mean(data.beta);
    dSets.(fields{i}) = data;
end

alpha_G = mean([dSets.FluoC2DLMSC.alpha(end);...
            dSets.FluoN2DHGOWT1.alpha(end);...
            dSets.FluoN2DHSIM.alpha(end);...
            dSets.FluoN2DHSIMplus.alpha(end);...
            dSets.FluoN2DLHeLa.alpha(end)]);

        
beta_G = mean([dSets.FluoC2DLMSC.beta(end)...
            dSets.FluoN2DHGOWT1.beta(end)...
            dSets.FluoN2DHSIM.beta(end)...
            dSets.FluoN2DHSIMplus.beta(end)...
            dSets.FluoN2DLHeLa.beta(end)]);
mB = 250;

clear i data k indx str M
save alphabeta.mat;
format short

% Save data on the LOCAL/DATASET/GLOBAL files
str = '~/Documents/PhD/ISBI/TRAINING/';
names ={{'Fluo-C2DL-MSC'}
     {'Fluo-N2DH-GOWT1'}
     {'Fluo-N2DH-SIM'}
     {'Fluo-N2DH-SIM+'}
     {'Fluo-N2DL-HeLa'}};
for i=1:length(fields)
    n = lab_per_dSet(i);
    for j = 1:n+1
	if j<=n
	  % F is local (Dataset_label)
	  F = fopen(strcat(str,char(names{i}), '/0',...
			   num2str(j),'localAB.txt'), 'w');
	else
	  % F is the average of the dataset
	  F = fopen(strcat(str,char(names{i}),...
			   '/datasetAB.txt'), 'w');
	end
	fprintf(F,'%f;%f\n',...
		dSets.(fields{i}).alpha(j),...
		dSets.(fields{i}).beta(j));
	fclose(F);
    end
end

F = fopen(strcat(str,'/globalAB.txt'), 'w');
fprintf(F,'%f;%f\n',alpha_G, beta_G);
fclose(F);
