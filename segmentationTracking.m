function [timedFinalNetwork] = segmentationTracking(fname, folderlabel, naHandles)
%              SEGMENTATION AND TRACKING
% This function takes the output from neutrophilAnalysis.m and
% writes the required output for the SEGMENTATION and TRACKING
% tests of the ISBI Cell Tracking Challenge 2015. The output is a
% set of images with the labeled cells as well as a TXT file with
% the description of the tracks for each (a non-cyclical graph).
% 
% USAGE:
%
%    (1) segmentationTracking(fname, folderlabel, naHandles) - it
%    creates the appropriate output without output parameters. 
%
%    (2) [timedFinalNetwork] = segmentationTracking(fname,
%    folderlabel, naHandles) - it has the output of the timed
%    finalNetwork, an extension of the finalNetwork matrix created
%    by the PhagoSight software. 
% 
% INPUT:
%              fname := (string) folder where the dataset is stored
%        folderlabel := (string) label of the sub-dataset
%          naHandles := (struct) output of the PhagoSight software.
% 
% OUTPUT:
%   timeFinalNetwork := (int matrix) matrix that shows int time the
%   progression of each track.
%          
% Jose Alonso Solis-Lemus
%

    outputdir = strcat(fname,folderlabel,'_RES/');
    mkdir(outputdir);
    
    strname = strcat(fname,folderlabel,'thresholds.txt');
    finame = fopen(strname,'w');
    
    realData = load(strcat(naHandles.dataRe,'/T00001.mat'));
    minvalue = min(realData.dataR(:));
    modevalue = mode(realData.dataR(:));
    fprintf(finame,'%f;%f;%f;%f\n',...
        minvalue, modevalue, ...
        naHandles.thresLevel(1), ...
        naHandles.thresLevel(2));
    fclose(finame);
       
    % Now we take into account the SEG and TRA testing!
    
    nodeNet = naHandles.nodeNetwork;
    finalNet = naHandles.finalNetwork;
    
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
    
    % maybe there are more images than are shown.
    if length(timedFinalNetwork(:,1)) < naHandles.numFrames
        n = length(timedFinalNetwork(:,1));
        m = naHandles.numFrames;
        timedFinalNetwork = [timedFinalNetwork;...
                            zeros(m-n,length(timedFinalNetwork(1,:)))];
    end
    
    fclose(F);
    
    L = load(strcat(naHandles.dataLa,'/T00001.mat'),'dataL');
    [~,~,numIm] = size(L.dataL);
    
    for i=1:naHandles.numFrames
        if i < 11
            tiffstr = strcat(outputdir, 'mask00', num2str(i-1),'.tif');
            if i<10
                labeledData = load(...
                    strcat(naHandles.dataLa,'/T0000',num2str(i),'.mat'),...
                    'dataL');
            else
                labeledData = load(...
                    strcat(naHandles.dataLa,'/T000',num2str(i),'.mat'),...
                    'dataL');
            end
        elseif i<101
            tiffstr = strcat(outputdir, 'mask0', num2str(i-1),'.tif');
            if i<100
                labeledData = load(...
                    strcat(naHandles.dataLa,'/T000',num2str(i),'.mat'),...
                    'dataL');
            else
                labeledData = load(...
                    strcat(naHandles.dataLa,'/T00',num2str(i),'.mat'),...
                    'dataL');
            end
        else
            tiffstr = strcat(outputdir, 'mask', num2str(i-1),'.tif');
            labeledData = load(...
                strcat(naHandles.dataLa,'/T00',num2str(i),'.mat'),...
                'dataL');
        end
     
             
        % Before saving the image, we must first assign the correct labels
        % to the dataL matrices. We're going to take the dataL matrix and 
        % exchange the label set by bwlabeln with the timedFinalNetwork 
        % labels.
        
        VV = zeros(size(labeledData.dataL));
        V = unique(labeledData.dataL);
        V(1) = []; % we remove the first entry, which is a zero.
        
        t = timedFinalNetwork(i,timedFinalNetwork(i,:)>0);
        
        nt = length(t);
        nV = length(V);
        
        for k=1:nV
            if k<=nt
                % i.e if we're on the "good labels"
                VV(labeledData.dataL==V(k)) = t(k);
            end
        end
        
        ui16image = uint16(VV);
        for imCount=1:numIm
            if imCount==1
                imwrite(ui16image(:,:,imCount),tiffstr);
            else
                imwrite(ui16image(:,:,imCount),tiffstr,...
                    'WriteMode','append');
            end
        end
    end
    
    if nargout == 1
        Handlesplus = setfield(naHandles, 'timedFinalNetwork', ...
                                timedFinalNetwork);
    end