% script file: Auto Neutrophil Analysis
%
% This is a test-oriented script file. It is supposed to have a lot
% of code-breaks (i.e, the double % symbols). DO NOT run it from the
% console,as it will run everything in a really futile way.
%
% On this file I pretend to automatize the input and output of the
% PhagoSight Software. At the moment, the test data I'm using as 
% input comes from the ISBI Challenge on path: 
%
%  PhD/ISBI/ISBI_Challenge/TrainingDatasets/Fluo-N2DH-GOWT1/01
%
% It has gone on the PhD/TESTS folder as a copy, so that we may use
% the ground truth evaluation software.
%
% Jose Alonso Solis-Lemus
% last modified: Jan 18th, 2015.
% 

clear all
close all
clc

%% Get the thresholds right!

% First, we're trying to check the thresholds and minBlob needed 
% to do the automized procedure.

clear all
close all
clc

s = cputime;
handles = neutrophilAnalysis('../../TESTS/01',0);
s = cputime - s;

%

%% Do it yourself! 
% Here we do the automized procedure with the thersholds handpicked before.
% 

clear all
close all
clc

LT = 20; % Low threshold
HT = 33; % High threshold
mB = 200; % min Blob.

s = cputime;
handles2 = neutrophilAnalysis('../../TESTS/01', 0,[],[LT HT], mB);
s = cputime -s;

minutes = fix(s/60);
seconds = (s/60-minutes)*60;
fprintf('\nNumber of frames: %d \nTime : %d:%f minutes\n',...
    handles2.numFrames, minutes, seconds);

% Now we 'improve' the tracks
jandles2 = joinMultipleTracks(handles2,[],50,-4,[]);

%% plot handles2 and jandles2

figure(1)

subplot(1,2,1);
plotTracks(handles2,2);
title('HANDLES');
view(90,90);
subplot(1,2,2);
plotTracks(jandles2,2);
title('JANDLES');
view(90,90);


%% Lame way to turn data into tiff
% Here we manually turn _mat_La data (i.e, one dataL per frame) into TIFF
% files to be compared by the evaluation software.
%

outputdir = '../../TESTS/01_RES/';
mkdir(outputdir);

labeledData = [];

s=cputime;
for i=1:jandles2.numFrames
    tiffstr = '';
    str2 = '';
    if fix(i/10) == 0
        tiffstr = strcat(outputdir, 'mask00', num2str(i),'.tif');
        labeledData = load(...
            strcat(jandles2.dataLa,'/T0000',num2str(i),'.mat'),'dataL'...
            );
    else
        tiffstr = strcat(outputdir, 'mask0', num2str(i),'.tif');
        labeledData = load(...
            strcat(jandles2.dataLa,'/T000',num2str(i),'.mat'),'dataL'...
            );
    end
    
    ui16image = uint16(labeledData.dataL);
    imwrite(ui16image,tiffstr);
    
end
s=cputime-s;

minutes = fix(s/60);
seconds = (s/60-minutes)*60;
fprintf(...
    '\nCreated the images on the %s directory.\nTime : %d:%f minutes\n',...
    outputdir, minutes,seconds);