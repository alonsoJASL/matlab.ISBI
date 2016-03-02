function writeTrackFile(handles2, fname, outputfolder)
%       WRITE ISBI TRACK FILE
% Self explanatory title:
% default fname = 'res_track.txt'
% default outputfolder := working directory.
% 

switch nargin
    case 0 
        disp('ERROR');
        disp('Need at least ond handles structure.');
        return;
    case 1
        outputfolder = './';
        fname = 'res_track.txt';
    case 2
        outputfolder = './';
    case 3
        if ~isdir(outputfolder)
        disp('ERROR');
        disp('Wrong directory name.');
        return;
        end
    otherwise
        disp('ERROR. Here is some help:');
        help;
        return;     
end

nodeNet = handles2.nodeNetwork;
finalNet = handles2.finalNetwork;

[~, numOfTracks] = size(finalNet);
filename = strcat(outputfolder,fname);
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