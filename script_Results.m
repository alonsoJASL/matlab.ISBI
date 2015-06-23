% script file: Results
% This script file takes the SW/BASH/optimizationOutput.csv and graphs
% it. This script should be useful in future times for sorting how the
% results might be presented before they're actually included in the
% original program.
%
% Jose Alonso Solis-Lemus 2 February 2015
%

clear all
close all

filename1 = '../BASH/beforeFilteringOutput.csv';
filename2 = '../BASH/optimizationOutput.csv';

M1 = csvread(filename1);
M2 = csvread(filename2);
[lt1, I] = sort(M1(:,1));
SEG1 = M1(I,3);
TRA1 = M1(I,4);
score1 = M1(I,5);
time1 = M1(I,6) ./ 60;

[lt2, I] = sort(M2(:,1));
SEG2 = M2(I,3);
TRA2 = M2(I,4);
score2 = M2(I,5);
time2 = M2(I,6) ./ 60;

[~,Otsu1] = max(lt1); % almost manually
[~, Otsu2] = max(lt2);

str1 = filename1(9:end-4);
str2 = filename2(9:end-4);

figure(1)
subplot(2,2,1);
hold on
plot(lt1, SEG1,'b*-', lt1, TRA1, 'r.-',lt1, score1, 'mo-');
plot(lt1(Otsu1),score1(Otsu1),'kd','LineWidth',2);
hold off
title(str1);
xlabel('Low threshold value');
legend('SEG','TRA', 'TOTAL','Otsu LT');
grid on
subplot(2,2,3);
plot(lt1, time1, 'k+--');
xlabel('Low threshold value');
ylabel('MINUTES');
legend('TIME');
grid on

subplot(2,2,2);
hold on
plot(lt2, SEG2,'b*-', lt2, TRA2, 'r.-',lt2, score2, 'mo-');
plot(lt2(Otsu2),score2(Otsu2),'kd','LineWidth',2);
hold off
title('afterFiltering (matrix size=5)');
xlabel('Low threshold value');
legend('SEG','TRA', 'TOTAL','Otsu LT');
grid on
subplot(2,2,4);
plot(lt2, time2, 'k+--');
xlabel('Low threshold value');
ylabel('MINUTES');
legend('TIME');
grid on

figure(2) % now we compare both outputs.
subplot(2,1,1);
plot(lt1,score1, 'b.-', lt2, score2, 'r*-', 'LineWidth',2);
xlabel('Low threshold value');
ylabel('Score (out of 2)');
grid on;
legend('NO filtering', 'WITH filtering');
subplot(2,1,2)
plot(lt1,time1, 'b.-', lt2, time2, 'r*-', 'LineWidth',2);
xlabel('Low threshold value');
ylabel('TIME (minutes)');
grid on;
legend('NO filtering', 'WITH filtering');
