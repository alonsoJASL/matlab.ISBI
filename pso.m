function [LTHTmB, bestValue, failCount] = pso(fullpath, folderlabel, tol, maxIt)
%       PARTICLE SWARM OPTIMIZATION
%
% A function that performs the Particle Swarm Optimization (PSO) for the
% ISBI Cell tracking Challenge. It receives the dataset name and the label
% that wants to be done.
% 

if nargin < 3
    tolerance = 0.5;
    maxIter = 10;
elseif nargin < 4 
    tolerance = tol;
    maxIter = 10;
else
    tolerance = tol;
    maxIter = maxIt;
end

if fullpath(end) ~= '/'
    fullpath = strcat(fullpath,'/');
end
rmmat = ['rm',32,'-rf',32,fullpath,'*mat*'];
rmRES = ['rm',32,'-rf',32,fullpath,'*RES*'];

unix(rmmat);
unix(rmRES);

F = fopen(strcat(fullpath,folderlabel,'Dthresholds.txt'),'r');
linea = fgets(F);
fclose(F);
C = strsplit(linea,';');

LT = str2double(char(C{3}));
HT = str2double(char(C{4}));
MIN =  str2double(char(C{1}));
MODE = str2double(char(C{2}));

F = fopen('../../ISBI/TRAINING/globalAB.txt','r');
linea = fgets(F);
fclose(F);
C = strsplit(linea,';');

alpha_G = str2double(char(C{1}));
beta_G = str2double(char(C{2}));

N = 5; % number of particles

% Initialize particles
x(1,:) = alpha_G + (0.25)*rand(N,1); % alpha
x(2,:) = beta_G + (0.25)*rand(N,1); % beta
x(3,:) = randi([100 400],N,1);  % mB

v = zeros(size(x));

gBest = 0;
pBest = zeros(size(x));
pBestValue = zeros(N,1);
c1 = 0.5;
c2 = 1;
seg = zeros(N,1);
tra = zeros(N,1);

count = 0;
failc = 0;
while (2-gBest) > tolerance && count <= maxIter
    for i=1:N
        unix(rmmat);
        unix(rmRES);
        lt = MODE + x(1,i)*(LT - MIN);
        ht = MODE + x(2,i)*(HT - MIN);
        while lt > ht % feasibility
            x(1,i) = alpha_G + (0.5)*rand;
            x(2,i) = beta_G + (0.5)*rand;
            lt = MODE + x(1,i)*(LT - MIN);
            ht = MODE + x(2,i)*(HT - MIN);
        end
          
        mb = x(3,i);
        disp('---');
        mainPhagoSight(fullpath,folderlabel, lt, ht, mb);
        [segux ,traux] = evaluationSoftware(fullpath,folderlabel);
        disp('---');
        seg(i) = segux;
        tra(i) = traux;
        
        evalRes = seg(i)+tra(i);
        if pBestValue(i) < evalRes
            pBest(:,i)=x(:,i);
            pBestValue(i) = evalRes;
        end
    end
    [gBest, whoBest] = max(pBestValue);
    for i=1:N
        v(:,i) = v(:,i) + c1*rand*(pBest(:,i)-x(:,i)) + ...
                c2*rand*(x(:,whoBest)-x(:,i));
        x(:,i) = x(:,i) + v(:,i);
        
        if x(1,i) <= 0
            failc = failc+1;
            x(1,i) = alpha_G + 0.5*rand;
        end
        if x(2,i) <= 0
            failc = failc+1;
            x(2,i) = beta_G + 0.5*rand;
        end
        if x(3,i) <= 0
            failc = failc+1;
            x(3,i) = randi([100 400]);
        end
    end
    disp([count gBest]);
    count = count + 1;
end

LTHTmB = x(:,whoBest);
bestValue = gBest;
failCount = failc;