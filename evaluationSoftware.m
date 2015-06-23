function [seg, tra] = evaluationSoftware(fname, folderlabel)
%                   EVALUATION SOFTWARE 
% 
% Calls the bash script test_sum_store.sh and then reads the SEG
% and TRA software output saving it to the [seg, tra] variables. 
%
% Jose Alonso Solis-Lemus
%

% we adjust the ending of the directory so that there are no
% problems. 
if fname(end) ~= '/'
    fname = strcat(fname,'/');
end

fullpath = strcat(fname,folderlabel,'segtra.txt');
fullinstruction_linux = ['~/Documents/PhD/SW/BASH/test_sum_store.sh',...
                   32,fname,32, folderlabel];
% fullinstructon_mac = ['~/Documents/propio/PhD/SW/BASH/test_sum_store.sh',...
%                    32,fname,32, folderlabel]
unix(fullinstruction_linux);

F = fopen(fullpath,'r');
linea = fgets(F);
fclose(F);

C = strsplit(linea, ';');

if isempty(C{1})
    seg = 0;
else
    seg = str2double(char(C{1}));
end
if isempty(C{2})
    tra = 0 ;
else
    tra = str2double(char(C{2}));
end