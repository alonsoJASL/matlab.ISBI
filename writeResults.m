function writeResults(handles2)
%
%
    fname = handles2.dataLa(1:end-6);
    
    outputdir = strcat(fname,'RES/');
    mkdir(outputdir);

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
        for imCount=1:handles2.levs
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