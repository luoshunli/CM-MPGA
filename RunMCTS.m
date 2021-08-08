%***********************************************************************
%                     Demo program for paper:
%        "Consensus Maximization Tree Search Revisited"
%         Authors: Zhipeng Cai, Tat-Jun Chin, Vladlen Koltun 
%***********************************************************************

%-----------------------------------------------------------------------
%                           WARNING:
% - This demo is free for non-commercial academic use. Any commercial use is strictly prohibited without the authors' consent. 
% Please acknowledge the authors by citing:
% @article{cai2019consensus,
%  title={Consensus Maximization Tree Search Revisited},
%  author={Cai, Zhipeng and Chin, Tat-Jun and Koltun, Vladlen},
%  journal={arXiv preprint arXiv:1908.02021},
%  year={2019}
% }
%in any academic publications that have made use of this package or part of it.
%
%
%
% - This code was tested on a 64 bit Ubuntu 14.04 with MATLAB R2018b
% - To use this demo, just run function demo() in 'demo.m'
% - The time limit for all methods can be adjusted by changing "timeLimitFund"(for fundamental matrix estimation) and "timeLimitHomo" (for homography estimation).
%----------------------------------------------------------------------- 
function resultMCTS = RunMCTS(x1,x2,resultMCTSfile)


if ~exist(resultMCTSfile,'file')
    % important settings
    %reduce the time limit to 20s/200s to make the demo finish quickly, u can adjust
    %the time limit if u want.
    timeLimitHomo = 200;
    selectedMethod = [5];

    warning('off', 'all');
    %% method list
    methodList = {'A*', 'A*-TOD', 'A*-NAPA', 'A*-NAPA-TOD', 'A*-NAPA-DIBP'};

    %% Homography estimation
    [X1, T1] = normalise2dpts(x1);
    [X2, T2] = normalise2dpts(x2);

    epsilonHomoBasic = 4; %inlier threshold

    %generate linearized data from sift matches
    [A,b,c,d] = genMatrixHomography(X1, X2);

    d1 = size(A,2);
    solInit = rand(d1,1);

    epsilonHomo = epsilonHomoBasic*T2(1,1);

    %execute each method
    for j = 1:numel(selectedMethod)
        idxMethod = selectedMethod(j);
        disp('--------------------------------------------------------');
        disp(['executing ' methodList{idxMethod} '... N = ' num2str(numel(d)) '; epsilon = ' num2str(epsilonHomoBasic) ' pixels, runtimeLimit = ' num2str(timeLimitHomo) 's']);
        [sol, outl, UniqueNodeNumber, hInit, ubInit, levelMax, NODIBP, runtime,usedmem] = pseudoConvFit(A,b,c,d,solInit,epsilonHomo,methodList{idxMethod},timeLimitHomo);
        if idxMethod == 5
            outl_DIBP = outl;
        end
        disp([methodList{idxMethod} ' finished--runtime = ' num2str(runtime) ', NUN = ' num2str(UniqueNodeNumber), ', NOBP = ' num2str(NODIBP), ', levelMax = ' num2str(levelMax)]);
        disp('--------------------------------------------------------');
    end

    disp(['number of outliers o = ' num2str(numel(outl_DIBP))] );
    inls = 1:numel(d);
    inls(outl_DIBP) = [];
    
    resultMCTS.inls = inls;
    resultMCTS.x1 = x1;
    resultMCTS.x2 = x2;
    resultMCTS.X1 = X1;
    resultMCTS.X2 = X2;
    resultMCTS.UniqueNodeNumber = UniqueNodeNumber;
    resultMCTS.NODIBP = NODIBP;
    resultMCTS.levelMax = levelMax;
    resultMCTS.outl_DIBP = outl_DIBP;
    resultMCTS.runtime = runtime;
    resultMCTS.usedmem = usedmem.MemUsedMATLAB/1024/1024/1024;
    
    save(resultMCTSfile,'resultMCTS');
else 
    load(resultMCTSfile,'resultMCTS');
end


