% script file: script file for Outside testing
%
% This is a script file that has the intention of being ran from
% the MATLAB console, or even from outside of MATLAB itself. It 
% doesn't contain any code-breaks (those double comment symbols (%%) 
% that causes to break the code.
% 
% SEE ALSO script_AutoAnalysis.m
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
% last modified: Jan 27th, 2015.
% 

clear all
close all
clc

LT = 10; % Low threshold
HT = 25; % High threshold
mB = 1500; % min Blob.

s = cputime;
handles2 = neutrophilAnalysis('../../TESTS/01', 0,[],[LT HT], mB);
s = cputime -s;

minutes = fix(s/60);
seconds = (s/60-minutes)*60;
fprintf('\nNumber of frames: %d \nTime : %d:%2.1f minutes\n',...
    handles2.numFrames, minutes, seconds);

% Now we 'improve' the tracks
%jandles2 = joinMultipleTracks(handles2,[],50,-4,[]);

% Here we manually turn _mat_La data (i.e, one dataL per frame) into TIFF
% files to be compared by the evaluation software.
%

% we're going to save the original dataL matrices as well. 
outputdir = '../../TESTS/01_RES/';
outputdir2 = strcat(outputdir,'PSoriginal/');
mkdir(outputdir);
mkdir(outputdir2);

labeledData = [];

s=cputime;

% Now we take into account the SEG and TRA testing!

% Next, we're building timedFinalNetwork, a finalNetwork-like matrix
% that takes into account timeframes. 
% 
% It will have a zero if a track is not present at such timeframe, and
% the track identifier if it does.
% 

% We do everything in th following loop

nodeNet = handles2.nodeNetwork;
finalNet = handles2.finalNetwork;

[~, numOfTracks] = size(finalNet);
filename = strcat(outputdir,'res_track.txt');
timedFinalNetwork = zeros(size(finalNet));

F = fopen(filename,'w');

for i=1:numOfTracks
    l = nodeNet(i,6); % Label = Unique ID of Neotrophil
    
    times = nodeNet(finalNet(finalNet(:,i)>0,i),5)-1;
    startL = times(1);
    finishL = times(end);
    parent = 0;
    
    timedFinalNetwork(times+1,i) = l;
    
    fprintf(F,'%d %d %d %d\n', l,startL, finishL, parent);
    
end 

fclose(F);

% For each frame
for i=1:handles2.numFrames
    str2 = '';
    if i < 11
        tiffstr = strcat(outputdir, 'mask00', num2str(i-1),'.tif');
        tiffstrPS = strcat(outputdir2, 'mask00', num2str(i-1),'.tif');
        if i<10
            labeledData = load(...
                strcat(handles2.dataLa,'/T0000',num2str(i),'.mat'),'dataL'...
                );
        else
            labeledData = load(...
                strcat(handles2.dataLa,'/T000',num2str(i),'.mat'),'dataL'...
                );
        end
    else
        
        tiffstr = strcat(outputdir, 'mask0', num2str(i-1),'.tif');
        tiffstrPS = strcat(outputdir2, 'mask0', num2str(i-1),'.tif');
        
        labeledData = load(...
            strcat(handles2.dataLa,'/T000',num2str(i),'.mat'),'dataL'...
            );
    end
    
    % Before saving the image, we must first assign the correct labels to
    % the dataL matrices. We're going to take the dataL matrix and exchange
    % the label set by bwlabeln with the timedFinalNetwork labels.
    
    VV = zeros(size(labeledData.dataL));
    V = unique(labeledData.dataL);
    V(1) = []; % we remove the first entry, which is a zero.
   
    t = timedFinalNetwork(i,timedFinalNetwork(i,:)>0);
    
    nt = length(t);
    nV = length(V);
    
    for k=1:nV
        if k<=nt
            % i.e if we're on the "good labels"
                VV(labeledData.dataL==V(k)) = t(k);x
        end
    end
    
    ui16image = uint16(VV);
    imwrite(ui16image,tiffstr);
    
    % now we save the original images:
    ui16imagePS = uint16(labeledData.dataL);
    imwrite(ui16imagePS,tiffstrPS);

%     %
%     % Here we'll check with a PAUSE command whether the allocation of 
%     % neutrophils labels can be easily fixed so that the Evaluation 
%     % Software doesn't cry a lot.
%     %
%     hSurf = imagesc(labeledData.dataL);
%     set(hSurf, 'CData',labeledData.dataL);
%     axis image
%     axis off
%     colormap jet
%     title(num2str(i));
%     colorbar
%     drawnow;
%     disp(timedFinalNetwork(i,timedFinalNetwork(i,:)>0));
%     
%     % pause
%     %
%     
%     f = getframe;
%     if i==1
%         [im,mapGIF] = rgb2ind(f.cdata,256,'nodither');
%         im(1,1,1,handles2.numFrames) = 0;
%     else
%         im(:,:,1,i) = rgb2ind(f.cdata,mapGIF);
%     end
    
end

% fname = strcat(outputdir,'DancingPeaks.gif');
% imwrite(im,mapGIF,fname,...
%         'DelayTime',0,'LoopCount',inf) %g443800

s=cputime-s;



minutes = fix(s/60);
seconds = (s/60-minutes)*60;
fprintf('\n Created the images for the SEG testing,');
fprintf('\n as well as the TXT file for TRA testing.');
fprintf('\n Time : %2d:%2.1f minutes\n', minutes,seconds);