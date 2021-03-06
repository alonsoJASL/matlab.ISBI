% script file: PARTICLE SWARM OPTIMIZATION
% Used for the ISBI Challenge. This test will be done on the
% "Fluo-C3DL-MDA231" dataset for both 01 ans 02 labels. The output
% will give us a clue on the feasibility to have a more sound
% approach to looking for the (alpha,beta) parameters.
%
% We read the global parameters (alpha,beta) computed for the 2D
% challenge and initialise the particles close to this global
% points. Then, we take the previously calculated OTSU parameters
% and 
%
clear all
close all
clc

% 3D directories
B = struct('one', struct('name','Fluo-C3DH-H157','labels',2,...
        'tol',0.8,'maxIt',5,'LTHTmB',[],'bestV',[]),...
        'two', struct('name','Fluo-C3DL-MDA231','labels',2,...
        'tol',0.6,'maxIt',5,'LTHTmB',[],'bestV',[]),...
        'three', struct('name','Fluo-N3DH-CE','labels',2,...
        'tol',0.8,'maxIt',5,'LTHTmB',[],'bestV',[]),...
        'four',struct('name','Fluo-N3DH-CHO','labels',2,...
        'tol',0.1,'maxIt',5,'LTHTmB',[],'bestV',[]),...
        'five',struct('name','Fluo-N3DH-SIM','labels',6,...
        'tol',0.6,'maxIt',5,'LTHTmB',[],'bestV',[]),...
        'six',struct('name','Fluo-N3DH-SIM+','labels',2,...
        'tol',0.8,'maxIt',5,'LTHTmB',[],'bestV',[]));
    
disp('Doing 3D datasets');
% 
% % 2D directories
% A = struct('one', struct('name','Fluo-C2DL-MSC','labels',2,...
%         'tol',0.8,'maxIt',5,'LTHTmB',[],'bestV',[]),...
%         'two', struct('name','Fluo-N2DH-GOWT1','labels',2,...
%         'tol',0.3,'maxIt',5,'LTHTmB',[],'bestV',[]),...
%         'three', struct('name','Fluo-N2DH-SIM','labels',6,...
%         'tol',0.1,'maxIt',5,'LTHTmB',[],'bestV',[]),...
%         'four',struct('name','Fluo-N2DH-SIM+','labels',2,...
%         'tol',0.2,'maxIt',5,'LTHTmB',[],'bestV',[]),...
%         'five',struct('name','Fluo-N2DL-HeLa','labels',2,...
%         'tol',0.6,'maxIt',5,'LTHTmB',[],'bestV',[]));
%     
% disp('Doing 2D datasets');

% actual program
fields = fieldnames(B);
s = cputime;
for i=1:length(fields)
    fname = strcat('~/Documents/PhD/ISBI/TRAINING/',...
            B.(fields{i}).name);
    tol = B.(fields{i}).tol;
    maxi = B.(fields{i}).maxIt;
    for j=1:B.(fields{i}).labels
        clc
        disp(B.(fields{i}).name);
        label = strcat('0',num2str(j));
        disp(label);
        [LTHTmB, bestVal,failC] = pso(fname,label,tol,maxi);
        
        B.(fields{i}).LTHTmB(:,j) = LTHTmB;
        B.(fields{i}).bestV(j) = bestVal;
    end
    B.(fields{i}).LTHTmB(:,j+1) = mean(B(fields{i}).LTHTmB);
end
s = (cputime-s)/3600;