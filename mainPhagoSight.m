function [Handlesplus] = mainPhagoSight(fname, folderlabel,lowThres, ...
                                        highThres, miniBlob)
%
%                          MAIN - PHAGOSIGHT
%
% Runs the PhagoSight (neutrophilAnalysis.m) program in a standalone way.
% It only needs the name of the directory in which the program is going to
% run to start. It chooses the parameters (high/low thresholds and minBlob)
% and then runs the appropriate program. This program is for the ISBI
% Challenge, so that it meets the results' format.
%
% USAGE:
%   (1) mainPhagoSight() - It doesn't take anything into account. Basically
%   it runs neutrophilAnalysis as if done without input parameters.
%
%   (2) mainPhagoSight(fname, folderlabel) - If it receives the input data
%   folder, the program will run Phagosight without parameters, so
%   some user input will be necessary.
%
%   (3) mainPhagoSight(fname, folderlabel, lowThres, highThres,
%   miniBlob) - This option is used in case the user wants to specify
%   the parameters from outside. 
% 
%   (4) [HP] = mainPhagoSight(...) - (OPTIONAL) if the user wants to
%   have a way of looking into the regular output of neutrophil analysis. 
%
% INPUT:
%       *fname := (string) Name of the folder in which the data is stored.
%       Normally with the format /FULL/PATH/NAME-of-DATASET/.
%
%       *folderlabel := (string) Identifier of the subset to be processed.
%       Normally a string like "0N", where N is a number between 1 and 9.
%
%         BOTH arguments are important. the folder in which PhagoSight is
%         going to process the data at:
%
%               /FULL/PATH/NAME-of-DATASET/0N
%
%         Where (in this case):
%
%                  fname = '/FULL/PATH/NAME-of-DATASET/'
%            folderlabel = '0N'
%      
%       *lowThres := (double) Minimum value of threshold data.
%
%       *highThres := (double) Maximum value of threshold data.
%
%       *miniBlob := (double) Blobs smaller than this will be
%       considered noise.
%
% OUTPUT:
%
%       The output data will be stored in PATH/NAME-of-DATASET/0N_RES/ as
%       stated in the Challenge guidelines.
%
% SEE ALSO neutrophilAnalysis.m
%
S = strcat('Welcome to Phagosight.\n\n',...
	     'There was something wrong with yout input parameters.\n',...
	     'You have three options:\n\t+ No parameters\n\t',...
	     '+ Two parameters: folder name AND folder label(0N)\n\t',...
	     '(Some user input will be required)',...
	     '+ Five parameters: folder name, folder label, ',...
	     'high threshold value, low threshold value AND min Blob.\n');
warning('off','all');

if nargin < 1
    neutrophilAnalysis();
elseif nargin < 2
    fprintf(S);
else
    % we adjust the ending of the directory so that there are no
    % problems. 
    if fname(end) ~= '/'
        fname = strcat(fname,'/');
    end
    
    fullpath = strcat(fname,folderlabel);
    
    if nargin == 2 % i.e no threshold or minblob parameters were
		  % introduced by the user.
      noparameters = true;
            
    elseif nargin == 5
        % We have to check if the input was entered correctly, or if as
        % entered from the terminal, the input was converted to a string.
        % 
        testchar = ischar(lowThres) + ...
            10*ischar(highThres) + ...
            100*ischar(miniBlob);
        switch testchar
            case 0
                LT = lowThres;
                HT = highThres;
                mB = miniBlob;
            case 1 
                LT = str2double(lowThres);
                HT = highThres;
                mB = miniBlob;
            case 10
                LT = lowThres;
                HT = str2double(highThres);
                mB = miniBlob;
            case 11
                LT = str2double(lowThres);
                HT = str2double(highThres);
                mB = miniBlob;
            case 100
                LT = lowThres;
                HT = highThres;
                mB = str2double(miniBlob);
            case 101
                LT = str2double(lowThres);
                HT = highThres;
                mB = str2double(miniBlob);
            case 111
                LT = str2double(lowThres);
                HT = str2double(highThres);
                mB = str2double(miniBlob);
        end
        noparameters = false;
    else
	% user did something wrong.
	clc;
	fprintf(S);
	return
    end
    
    dirlist = dir(fullpath);
    filenames = {dirlist.name};
    filenames(1:2) = []; % Remove '.' and '..' from the list.
    
    if strcmp(filenames{1},'.DS_Store')
        filenames(1) = [];
    end
    
    firstfile = filenames{1};
    
    numIm = size(imfinfo(strcat(fullpath,'/',firstfile)),1);

    % Saving data to 0N_mat_Re/ 
    if ~isempty(strfind(fullpath,'PhC'))
        % we have Phase Contrast, so we do Shading Correction.
        N = length(dir(fullpath)) - 2; % remove . and ..
        mkdir(strcat(fullpath,'_mat_Re/'));
        for i=1:N
            if i < 11
               str = strcat('/t00',num2str(i-1),'.tif');
               if i<10
                   str1 = strcat('_mat_Re/T0000',num2str(i),'.mat');
               else
                   str1 = strcat('_mat_Re/T000',num2str(i),'.mat');
               end
            elseif i < 101
                str = strcat('/t0',num2str(i-1),'.tif');
                if i < 100
                    str1 = strcat('_mat_Re/T000',num2str(i),'.mat');
                else
                    str1 = strcat('_mat_Re/T00',num2str(i),'.mat');
                end
            else
                str = strcat('/t',num2str(i-1),'.tif');
                str1 = strcat('_mat_Re/T00',num2str(i),'.mat');

            end
            
            A = imread(strcat(fullpath,str));
            [dataR] = shadingCorrection(A);
            save(strcat(fullpath,str1),'dataR');
        end
        fullpath = strcat(fullpath,'_mat_Re/');
        
        if noparameters == true
            LT = 210;
            HT = 230;
            mB = 50;
            noparameters = false;
        end
    end
    
    %s = cputime;
    if noparameters == true
      % User wants to set it up himself!
      handles2 = neutrophilAnalysis(fullpath, 0, [1 numIm 0 0 0 0]);
    else 
      % User has given the parameters. Only handles Fluorescent 
      handles2 = neutrophilAnalysis(fullpath, 0, ...
                                    [1 numIm 0 0 0 0],...
                                    [LT HT], mB);
    end
    %s = cputime -s;
    
%     minutes = fix(s/60);
%     seconds = (s/60-minutes)*60;
%     fprintf('Number of frames: %d;  Time : %d:%2.1f minutes.',...
%         handles2.numFrames, minutes, seconds);
    
    outputdir = strcat(fname,folderlabel,'_RES/');
    mkdir(outputdir);
    
    %  The next code is only to do the output needed for the
    %  optimization.
%     strname = strcat(fname,folderlabel,'thresholds.txt');
%     finame = fopen(strname,'w');
%     
%     realData = load(strcat(handles2.dataRe,'/T00001.mat'));
%     minvalue = min(realData.dataR(:));
%     modevalue = mode(realData.dataR(:));
%     fprintf(finame,'%f;%f;%f;%f\n',...
%         minvalue, modevalue, ...
%         handles2.thresLevel(1), ...
%         handles2.thresLevel(2));
%     fclose(finame);
    % ----------------------------
   % labeledData = [];
    
    %s=cputime;
    
    % Now we take into account the SEG and TRA testing!
        
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
    
    % maybe there are more images than are shown.
    if length(timedFinalNetwork(:,1)) < handles2.numFrames
        n = length(timedFinalNetwork(:,1));
        m = handles2.numFrames;
        timedFinalNetwork = [timedFinalNetwork;...
                            zeros(m-n,length(timedFinalNetwork(1,:)))];
    end
    
    fclose(F);
    
    for i=1:handles2.numFrames
        if i < 11
            tiffstr = strcat(outputdir, 'mask00', num2str(i-1),'.tif');
            if i<10
                labeledData = load(...
                    strcat(handles2.dataLa,'/T0000',num2str(i),'.mat'),...
                    'dataL');
            else
                labeledData = load(...
                    strcat(handles2.dataLa,'/T000',num2str(i),'.mat'),...
                    'dataL');
            end
        elseif i<101
            tiffstr = strcat(outputdir, 'mask0', num2str(i-1),'.tif');
            if i<100
                labeledData = load(...
                    strcat(handles2.dataLa,'/T000',num2str(i),'.mat'),...
                    'dataL');
            else
                labeledData = load(...
                    strcat(handles2.dataLa,'/T00',num2str(i),'.mat'),...
                    'dataL');
            end
        else
            tiffstr = strcat(outputdir, 'mask', num2str(i-1),'.tif');
            labeledData = load(...
                strcat(handles2.dataLa,'/T00',num2str(i),'.mat'),...
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
        Handlesplus = setfield(handles2, 'timedFinalNetwork', ...
                                timedFinalNetwork);
    end
%     s=cputime-s;
%     
%     minutes = fix(s/60);
%     seconds = (s/60-minutes)*60;
%     fprintf('\nCreated the images for the SEG testing,');
%     fprintf('as well as the TXT file for TRA testing.');
%     fprintf('\nTime : %2d:%2.1f minutes\n', minutes,seconds);

disp('Finished.');
    
end
