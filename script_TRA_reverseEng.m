% script file: TRA test "Reverse Engineering"
%
% This file is meant to check the TRACKS and how the information is
% supposed to be presented in our results. Hopefully, we'll see which
% labels are present and how they are presented.
%
% Jose Alonso Solis-Lemus
% last modified: Jan 21th, 2015.
%

clear all
close all

PATH_ = '../../TESTS/';
TO_ = '01_';
GT = 'GT/TRA/*.tif';
RES = 'RES/*.tif';

PATH_TO_GT = strcat(PATH_,TO_,GT);
PATH_TO_RES = strcat(PATH_,TO_,RES);
PATH_TO_PS = strcat(PATH_,TO_,'RES/PSoriginal/*.tif');

dGT = dir(PATH_TO_GT);
dRES = dir(PATH_TO_RES);
dPS = dir(PATH_TO_PS);

namesGT = {dGT.name};
namesRES = {dRES.name};
namesPS = {dPS.name};

N = length(namesGT);

fgt = fopen('./reveng_GT_OUR.txt','w');
fres = fopen('./reveng_RES_OUR.txt','w');

fprintf(fgt, 'Data for GT');
fprintf(fres, 'Data for RES');

fprintf('We"re checking the following directories: \n\t%s\n\t%s\n',...
    PATH_TO_GT, PATH_TO_RES);

for i=1:N
    
    A = imread([PATH_TO_GT(1:end-5) namesGT{i}]);
    B = imread([PATH_TO_RES(1:end-5) namesRES{i}]);
    C = imread([PATH_TO_PS(1:end-5) namesPS{i}]);
    
    subplot(1,3,1);
    imagesc(A);
    axis off
    colorbar
    title('Original');
    subplot(1,3,2);
    imagesc(B);
    axis off
    colorbar
    title('Result (VV)');
    subplot(1,3,3);
    imagesc(C);
    axis off
    colorbar
    title('PhagoSight');
    
    fprintf('\n ORIGINAL:   ');
    disp(unique(A)');
    fprintf('\n  RESULT (VV):    ');
    disp(unique(B)');
    fprintf('\n  PHAGOSIGHT:    ');
    disp(unique(C)');
    
    % We only want to check 10 times.
    if i<=10
        pause
    end
    
    a = unique(A);
    b = unique(B);
    
    for j=1:length(a)
        if j==1
            fprintf(fgt,'\n%d ',a(j));
        else
            fprintf(fgt,'%d ',a(j));
        end
    end
    for j=1:length(b)
        if j==1
            fprintf(fres,'\n%d ',b(j));
        else
            fprintf(fres,'%d ',b(j));
        end
    end
    
    
end

fclose(fgt);
fclose(fres);