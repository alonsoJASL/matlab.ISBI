% script file:  Build TRA test
%
% For the ISBI challenge, the segmentation are not the only problems.
% It is also necessary to build an acyclic graph with our output into 
% a TXT file to be tested by the algorithm. The tasks we have to do are:
%
%       - Identyfy each track (Labeling).
%       - Set the beginning frame of each track (starting at 0)
%       - Set the ending of each track (0-based labeling)
%       - Set the parent of the tracks (in case of mitosis)
% 
% Here we build such TXT file, so that later it can be included in 
% the PhagoSight software as an output. We're putting it first on the 
% script_OutsideTest.m file, so that a proper test can be performed 
% alongside the SEG test. 
% 
% Jose Alonso Solis-Lemus
% last modified: Jan 18th, 2015.
% 

clear all 
close all
clc

load ../../TESTS/01_mat_Ha/handles.mat

% first, I'll sort out some problems I've encountered.
nodeNet = handles.nodeNetwork;
finalNet = handles.finalNetwork;

[~, numOfTracks] = size(finalNet);
filename = '../../TESTS/01_RES/res_track.txt';
F = fopen(filename,'w');

for i=1:numOfTracks
    l = nodeNet(i,6); % Label = Unique ID of Neotrophil
    
    times = nodeNet(finalNet(finalNet(:,i)>0,i),5)-1;
    startL = times(1);
    finishL = times(end);
    parent = 0;
    
    fprintf(F,'%d %d %d %d\n', l,startL, finishL, parent);
    
end 

fclose(F);

% % % % % THIS ADDRESSES A PROBLEM, COME TO IT LATER % % % % % % % 
% % 
% %                   Jan 18th 2015     
% %
% % first we identify which of the neutrophils start a track, i.e which
% % of them has a Parent==0 (nodeNetwork column 7) this can be done with
% % nodeNet(:,7) = 0. First I'll do a basidID.
% 
% basicID = (1:length(nodeNet(:,1)))'; % 1:N rows of NodeNetwork
% 
% % So, time frame at which the various tracks start (nodeNetwork 
% % column 5)
% startTimeframe = nodeNet(nodeNet(:,7)==0,5);
% 
% % And the track ids of the beginners (nodeNetwork column 13), this 
% % should give us an idea of the number of tracks.
% tracksIDs = nodeNet(nodeNet(:,7)==0,13);
% 
% % We try with the FinalLabel (nodeNetwork column 14)
% finalIDs = nodeNet(nodeNet(:,7)==0,14);
% 
% % Some preliminary results:
% disp('        [basicID tracksIDs finalIDs startTimeframe]');
% disp([basicID(nodeNet(:,7)==0) tracksIDs finalIDs ...
%     startTimeframe]);
% 
% % Notice how there are labels=0 for some tracks. this should not 
% % be happening, as each of the labels showed are simply not being
% % labeled.
