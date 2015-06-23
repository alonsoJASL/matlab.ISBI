% script file: Parameter search results
%
% This file is intended to present the results from the bash script;
%
%              SW/BASH/fullOptimizationSearch.sh
%
% It will plot the results so that the best parameters can be used.
% 
% Jose Alonso Solis-Lemus February 3rd, 2015
%

clear all;
close all;
clc;

filename = '../BASH/fullParameterSearch.csv';
M = csvread(filename,1,0);

LT = M(:,1);
lows = unique(LT);
HT = M(:,2);
alpha = [7.5;10;12.5;15;17.5];
mB = M(:,3);
blobs = unique(mB);
SEG = M(:,4);
TRA = M(:,5);
TOTAL = M(:,6);
TIME = M(:,7);

Nb = length(blobs);
Nlt = length(unique(LT));
Nht = length(alpha);

[~,maxScore] = max(TOTAL);
[~,minTIME] = min(TIME);
[~,minScore] = min(TOTAL);
[~,maxTIME] = max(TIME);

for i=1:Nb
    lt = LT(mB==blobs(i));
    ht = HT(mB==blobs(i));
    total = TOTAL(mB==blobs(i));
    time = TIME(mB==blobs(i));
      
    mattot = zeros(Nlt,Nht);
    mattime = zeros(Nlt, Nht);
    
    for j=1:Nlt
       
        total1 = total(lt==lows(j));
        time1 = time(lt==lows(j));
        for k=1:Nht
            mattot(j,k) = total1(k);
            mattime(j,k) = time1(k);
        end
    end

    fieldtot = strcat('SCORE - Blob = ', num2str(blobs(i)));
    fieldtime = strcat('TIME - Blob = ', num2str(blobs(i)));
    axX = unique(lt);
    axY = alpha;
    
    figure(1)
    subplot(2,Nb,i)
    imagesc(axX,axY,mattot);
    colorbar;
    title(fieldtot);
    subplot(2,Nb,4+i);
    imagesc(axX, axY,mattime);
    colorbar;
    title(fieldtime);
end
[~,I] = sort(TIME);

gradetime = (555-TIME)./387.5; % setting 195 as 8 and 350 as 4.
gradescore = TOTAL/2;

GRADE = 7.5*gradescore + 2.5*gradetime;

figure(2)
plot(TIME(I),10*gradescore(I),'*-', TIME(I), GRADE(I),'.-');
grid on;
xlabel('Computing time (s)')
ylabel('Overall Score (out of two)');
legend('SEG+TRA', 'COMPLETE SCORE')

headerstr = strcat('    LT         HT         mB        SEG      TRA',...
                    '       TOTAL  TIME(s)     GRADE');
disp('The ones that were done in the least TIME.');
%     12.7782   25.2782  350.0000    0.4583    0.7438    1.2020  193.5327
disp(headerstr);
disp([M(TIME<200,:) GRADE(TIME<200)]);

disp('The ones that were done with the best OUTPUT.');
%     12.7782   25.2782  350.0000    0.4583    0.7438    1.2020  193.5327
disp(headerstr);
[gr, igr] = max(GRADE);
disp([M(TOTAL>1.35,:) GRADE(TOTAL>1.35)]);
disp('Best time:');
disp([M(minTIME,:) GRADE(minTIME)]);
disp('Best score:');
disp([M(maxScore,:) GRADE(maxScore)]);
disp('Best grade:');
disp([M(igr,:) gr]);
           