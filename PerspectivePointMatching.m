function PerspectivePointMatching(runName,imageNames,datasetName,minimalSiftThreshold,...
    Noise,noiseSigmaInPixels,GPMparams,USACparams)

% close all
% dbstop if error


[~,pthData] = startup;
pthInit = pwd;

InlierEstimationFiguresDir = '../InlierEstimationFigures/';
mkdir(InlierEstimationFiguresDir);


% w = warning('query','last')
warning('off','images:imshow:magnificationMustBeFitForDockedFigure')
warning('off','MATLAB:iofun:UnsupportedEncoding')
warning('off','MATLAB:MKDIR:DirectoryExists')
warning('off', 'Coder:MATLAB:singularMatrix')



doPlots = false;
debug = true;
% GPM related
if ~exist('runName','var'), runName = 'local'; end
if ~exist('GPMparams','var'), GPMparams.byPercentileAverage = 1; GPMparams.robustPercentile = 0.9; end

% SIFT related
if ~exist('minimalSiftThreshold','var'), minimalSiftThreshold = 1.3; end
if ~exist('Noise','var'), Noise = 0; end
if ~exist('noiseSigmaInPixels','var'), noiseSigmaInPixels = 0; end
if ~exist('datasetName','var'), datasetName = 'MIKO'; end

% USAC related
if ~exist('USACparams','var'), USACparams.USAC_thresh = 2.0; USACparams.USAC_LO = 1; end


noiseName = sprintf('noise_%d',noiseSigmaInPixels);

siftMethod = ['vlfeat_sifts_' num2str(minimalSiftThreshold,'%.2f')]; % 'blogs_sifts'; %
siftMethod = strrep(siftMethod,'.','_');


%% Load images

if ~exist('imageNames','var')
    imageNames = {'graf1_2'};
end


for imgInd = 1 : length(imageNames)
    
    close all
    
    %% 1] load the images and matches
    name = imageNames{imgInd};
%     if isequal(name(1:4),'USAC')
%         pthData = [pwd '\third_party\USAC\data\homog'];
%     end
    %
    [img1Filename,img2Filename,GT_homog] = LoadImages(pthData,name);
    if isempty(GT_homog) || all(GT_homog(:)==0) % this happens a lot with USAC
        GT_homog = eye(3);
    end
    
    
    % get directories and scaleFact (different whether using USAC precalculated mathces or MIKO new ones)
    [exampleDir,GPMResultDir,MCTSResultDir,namePrefix,nameSuffix,GPMparams.scaleFact] = ...
        GetDirectoriesAndScaleFact(name,runName,siftMethod,noiseName,img1Filename);
    
    % compute/load matches and
    x1 = [];
    x2 = [];
    [I1,I2,x1,x2,ordering] = ComputeOrLoadMatches(...
        siftMethod,minimalSiftThreshold,Noise,noiseSigmaInPixels,img1Filename,img2Filename,GPMResultDir); 
    
    X = unique([x1', x2'], 'rows');
    x1 = X(:, 1:3)'; 
    x2 = X(:, 4:6)'; 
    if(size(x1,2) < 8)
        fprintf('The match points are not enough!!\n');
        continue;
    end
%     showMatchedFeatures(I1,I2,x1(1:2,:)',x2(1:2,:)','montage','PlotOptions',{'b+','b+','g-'});
    %% 2] Run USAC
    % run USAC
    resultUSAC = RunUSAC(datasetName,noiseName,namePrefix,nameSuffix,...
        siftMethod,exampleDir,x1,x2,ordering,img1Filename,img2Filename,USACparams);
    
    H_usac = resultUSAC.H_usac;
    inlierInds = resultUSAC.inlierInds;
    USACx1 = x1(:,inlierInds);
    USACx2 = x2(:,inlierInds);
    
    %% 3] Evaluate the USAC and GT results
%     showMatchedFeatures(I1,I2,USACx1(1:2,:)',USACx2(1:2,:)','montage','PlotOptions',{'b+','b+','g-'});
    % image sizes
    [h1,w1,d1] = size(I1);
    [h2,w2,d2] = size(I2);
    
    % template corners
    templateCorners.x = [1,1,w1,w1];
    templateCorners.y = [1,h1,h1,1];
    targetCorners.x = [1,1,w2,w2];
    targetCorners.y = [1,h2,h2,1];
    
    % evaluate USAC
    USAC_homog = resultUSAC.H_usac;
    USAC_distances = ApplyHomographiesOnLocations_mex(reshape(USAC_homog',9,1),x1(1,:),x1(2,:),x2(1,:),x2(2,:)); % mex
    USACpercentile = resultUSAC.prctInliers;
    zVec = [-1,-1,-1,-1];
    [~,USAC_targetCornerXs,USAC_targetCornerYs] = ...
        ApplyHomographiesOnLocationsFull_mex(reshape(USAC_homog',9,1),templateCorners.x,templateCorners.y,zVec,zVec); % mex
    
    % evaluate GT
    orig_GT_distances = ApplyHomographiesOnLocations_mex(reshape(GT_homog',9,1),x1(1,:),x1(2,:),x2(1,:),x2(2,:)); % mex
    zVec = [-1,-1,-1,-1];
    [~,GT_targetCornerXs,GT_targetCornerYs] = ...
        ApplyHomographiesOnLocationsFull_mex(reshape(GT_homog',9,1),templateCorners.x,templateCorners.y,zVec,zVec); % mex
    
    
    if doPlots
        GTvsUSACpdfs_Fig = figure; hold on
        hUS = cdfplot(USAC_distances);
        hGT = cdfplot(orig_GT_distances);
        set(hGT,'color','r');
        legend([hUS,hGT],'USAC','GT');
    end
    
    %% 4] Run GPM
    resultGPMfile = [GPMResultDir 'GPM_results.mat'];
    GPMresult = RunGPM(GPMparams,x1,x2,resultGPMfile,...
    GT_targetCornerXs,GT_targetCornerYs,targetCorners,templateCorners,orig_GT_distances,I1,I2,USAC_distances);
   
    % unwrap the result
    drillBestXs = GPMresult.drillBestXs;
    drillBestYs = GPMresult.drillBestYs;
    distances_drill = GPMresult.distances_drill;
    H_drill = GPMresult.H_drill; 
    nInliers = GPMresult.nInliers;
    
    [~,sDrillInds] = sort(distances_drill);
    inlierIndsDrill = sDrillInds(1:nInliers);
    GMDx1 = x1(:,inlierIndsDrill);
    GMDx2 = x2(:,inlierIndsDrill);
    resultCompare(1,9) = GPMresult.runtime;
    resultCompare(1,12) = GPMresult.usedmem;
    
    %% 5] Run MCTS
    resultMCTSfile = [MCTSResultDir 'MCTS_results.mat'];
    Astarresult = RunMCTS(x1,x2,resultMCTSfile);
    
    AstarInds = Astarresult.inls;
    Astarx1 = x1(:,AstarInds);
    Astarx2 = x2(:,AstarInds);
    H_star = robust_Homog(Astarx1,Astarx2);
    zVec = [-1,-1,-1,-1];
    [~,Astar_targetCornerXs,Astar_targetCornerYs] = ...
        ApplyHomographiesOnLocationsFull_mex(reshape(H_star',9,1),templateCorners.x,templateCorners.y,zVec,zVec);
    resultCompare(1,10) = Astarresult.runtime;
    resultCompare(1,13) = Astarresult.usedmem;
    
    %% 6] Run MPGA

    MPGAresult = MPGA(x1,x2,templateCorners,targetCorners,GT_targetCornerXs,GT_targetCornerYs);

    if MPGAresult.status == 0
        fprintf('MPGA-GMD is failed!!\n');
    end
    tempx1 = x1;
    tempx2 = x2;
    H_opt = MPGAresult.H_opt;
    matchIndex = MPGAresult.matchIndex;
    result_x = MPGAresult.result_x;
    result_y = MPGAresult.result_y;
    resultx1 = tempx1(:,matchIndex');
    resultx2 = tempx2(:,matchIndex'); 
    tempx1(:,matchIndex') = [];
    tempx2(:,matchIndex') = [];
    outlierx1 = tempx1;
    outlierx2 = tempx2; 
    resultCompare(1,11) = MPGAresult.runtime;
    resultCompare(1,14) = MPGAresult.usedmem;
%     showMatchedFeatures(I1,I2,resultx1(1:2,:)',resultx2(1:2,:)','montage','PlotOptions',{'b+','b+','g-'});
   
    if(debug)
        
        I = [];
        padding = 0;
        [M1,N1,K1] = size(I1);
        [M2,N2,K2] = size(I2);
        N3 = N1+N2+padding;
        M3 = max(M1,M2);
        oj = N1+padding;
        oi = 0;
        I(1:M3, 1:N3, 1) = 255; I(1:M3, 1:N3, 2) = 255; I(1:M3, 1:N3, 3) = 255;
        I(1:M1,1:N1,:) = I1;
        I(oi+(1:M2),oj+(1:N2),:) = I2;
        figure;
        imshow(uint8(I)); hold on;
        
        temp1 = [];
        temp2 = [];
        temp1 = resultx1; 
        temp2 = resultx2;
        tx1 = [];
        ty1 = [];
        tx2 = [];
        ty2 = [];
        n = size(temp1,2);  
        tx1(1,1:n) = temp1(1,:);
        ty1(1,1:n) = temp1(2,:);
        n = size(temp2,2);  
        tx2(1,1:n) = temp2(1,:);
        ty2(1,1:n) = temp2(2,:);
        plot(tx1,ty1, 'b+','MarkerSize',4, 'linewidth', 1.2);
        plot(oj+tx2,ty2, 'b+','MarkerSize',4, 'linewidth', 1.2);
        for i = 1:n
            line([temp1(1,i) temp2(1,i)+oj], [temp1(2,i) temp2(2,i)], 'Color', 'g');
        end
        
%         temp1 = [];
%         temp2 = [];
%         temp1 = outlierx1; 
%         temp2 = outlierx2;
%         tx1 = [];
%         ty1 = [];
%         tx2 = [];
%         ty2 = [];
%         n = size(temp1,2);  
%         tx1(1,1:n) = temp1(1,:);
%         ty1(1,1:n) = temp1(2,:);
%         n = size(temp2,2);  
%         tx2(1,1:n) = temp2(1,:);
%         ty2(1,1:n) = temp2(2,:);
%         plot(tx1,ty1, 'b+','MarkerSize',4, 'linewidth', 1.2);
%         plot(oj+tx2,ty2, 'b+','MarkerSize',4, 'linewidth', 1.2);
%         for i = 1:n
%             line([temp1(1,i) temp2(1,i)+oj], [temp1(2,i) temp2(2,i)], 'Color', 'r');
%         end
%         figure;
%         hold on;
%         showMatchedFeatures(I1,I2,resultx1(1:2,:)',resultx2(1:2,:)','montage','PlotOptions',{'b+','b+','g-'});
        ps = [];
%         plot([targetCorners.x targetCorners.x(1)],[targetCorners.y targetCorners.y(1)],'m','linewidth',5);
        ps(end+1) = plot([GT_targetCornerXs'+w1 GT_targetCornerXs(1)+w1],[GT_targetCornerYs' GT_targetCornerYs(1)],'g','linewidth',5);
        ps(end+1) = plot(drillBestXs([1:4 1])+w1,drillBestYs([1:4 1]),'r','linewidth',3);
        ps(end+1) = plot(USAC_targetCornerXs([1:4 1])+w1,USAC_targetCornerYs([1:4 1]),'c','linewidth',3);
%         ps(end+1) = plot(Astar_targetCornerXs([1:4 1])+w2,Astar_targetCornerYs([1:4 1]),'g','linewidth',3);
        ps(end+1) = plot(result_x([1:4 1])+w1,result_y([1:4 1]),':b','linewidth',3);
        legend(ps,{'GT','GMD','USAC','Ours'});
%         legend(ps,{'GMD','USAC','Astar','Ours'});
    end

    %% 5] Post processing - (mainly: 3 figures) 
%     num1 = size(USACx1,2);
%     num2 = size(GMDx1,2);
%     num3 = size(Astarx1,2);
%     num4 = size(resultx1,2);
%     
%     distance1 = homSampsonerr(reshape(H_usac',9,1),USACx1(1:2,:),USACx2(1:2,:));
%     distance2 = homSampsonerr(H_drill,GMDx1(1:2,:),GMDx2(1:2,:));
%     distance3 = homSampsonerr(H_star,Astarx1(1:2,:),Astarx2(1:2,:));
%     distance4 = homSampsonerr(H_opt,resultx1(1:2,:),resultx2(1:2,:));
%     
%     resultCompare(1,1) = sum(distance1)/num1;
%     resultCompare(1,2) = sum(distance2)/num2;
%     resultCompare(1,3) = sum(distance3)/num3;
%     resultCompare(1,4) = sum(distance4)/num4;
%     
%     resultCompare(1,5) = num1/size(x1,2);
%     resultCompare(1,6) = num2/size(x1,2);
%     resultCompare(1,7) = num3/size(x1,2);
%     resultCompare(1,8) = num4/size(x1,2);
%     resultCompare
    iiii=1;
    % sorting all distances
%     [sDistances_drill,sDrillInds] = sort(distances_drill);
%     [sGT_distances,sGTInds] = sort(orig_GT_distances);
%     [sUSAC_distances,sUSACInds] = sort(USAC_distances);
%     
%     inlierIndsDrill = sDrillInds(1:nInliers);
    
    %% Fig 0: matches on images (each of GPM and USAC, compared to GT)
%     if doPlots
%         N2show = 200;
%         outlierIndsDrill = setdiff((1:length(x1))',inlierIndsDrill);
%         fact = max(length(inlierIndsDrill),length(outlierIndsDrill))/N2show;
%         if fact < 1, fact = 1; end
%         inlierInds = inlierIndsDrill(randsample(length(inlierIndsDrill),ceil(length(inlierIndsDrill)/fact)));
%         outlierInds = outlierIndsDrill(randsample(length(outlierIndsDrill),ceil(length(outlierIndsDrill)/fact)));
%         
%         % subplots 1-2: GPM
%         allResultsOnImg_1 = figure; imshow(I1); hold on;
%         plot(x1(1,inlierInds),x1(2,inlierInds),'.b','markersize',15);
%         plot(x1(1,outlierInds),x1(2,outlierInds),'.r','markersize',15);
%         % title(['I1: "GPM" inliers(' num2str(pStar,'%.1f') '% - BLUE) outliers (RED), with error: ' num2str(drillBestDist,'%.1f')]);
%         legend({'Inliers','Outliers'});
%         allResultsOnImg_2 = figure; imshow(I2); hold on;
%         plot(x2(1,outlierInds),x2(2,outlierInds),'.r','markersize',15);
%         plot(x2(1,inlierInds),x2(2,inlierInds),'.b','markersize',15);
%         ps = [];
%         ps(end+1) = plot(GT_targetCornerXs([1:4 1]),GT_targetCornerYs([1:4 1]),'g','linewidth',4);
%         ps(end+1) = plot(drillBestXs([1:4 1]),drillBestYs([1:4 1]),'m','linewidth',4);
%         % ps(end+1) = plot(USAC_targetCornerXs([1:4 1]),USAC_targetCornerYs([1:4 1]),'r','linewidth',2);
%         legend(ps,{'GT','GMD'});
%         % legend(ps,{'GT','GPM','USAC'});
%         % title(['I2: "GPM" inliers(' num2str(pStar,'%.1f') '% - BLUE) outliers (RED), with error: ' num2str(drillBestDist,'%.1f')]);
%         %
%         
%         saveas(allResultsOnImg_1,[OutputDir 'results_on_imgs_1.eps'],'epsc');
%         saveas(allResultsOnImg_1,[OutputDir 'results_on_imgs_1.fig']);
%         saveas(allResultsOnImg_1,[OutputDir 'results_on_imgs_1.png']);
%         saveas(allResultsOnImg_2,[OutputDir 'results_on_imgs_2.eps'],'epsc');
%         saveas(allResultsOnImg_2,[OutputDir 'results_on_imgs_2.fig']);
%         saveas(allResultsOnImg_2,[OutputDir 'results_on_imgs_2.png']);
%     end
% 
%     
%     
%     %% Fig 1: matches on images (each of GPM and USAC, compared to GT)
%     
%     allResultsOnImg = figure;
%     % subplots 1-2: GPM
%     subplot 221; imshow(MPGAparams.I1); hold on;
%     plot(x1(1,:),x1(2,:),'.r');
%     plot(x1(1,inlierIndsDrill),x1(2,inlierIndsDrill),'.b');
%     title(['I1: "GPM" inliers(' num2str(pStar,'%.1f') '% - BLUE) outliers (RED), with error: ' num2str(drillBestDist,'%.1f')]);
%     subplot 222; imshow(MPGAparams.I2); hold on;
%     plot(x2(1,:),x2(2,:),'.r');
%     plot(x2(1,inlierIndsDrill),x2(2,inlierIndsDrill),'.b');
%     ps = [];
%     ps(end+1) = plot(GT_targetCornerXs([1:4 1]),GT_targetCornerYs([1:4 1]),'g','linewidth',2);
%     ps(end+1) = plot(drillBestXs([1:4 1]),drillBestYs([1:4 1]),'b','linewidth',2);
%     ps(end+1) = plot(USAC_targetCornerXs([1:4 1]),USAC_targetCornerYs([1:4 1]),'r','linewidth',2);
%     legend(ps,{'GT','GPM','USAC'});
%     title(['I2: "GPM" inliers(' num2str(pStar,'%.1f') '% - BLUE) outliers (RED), with error: ' num2str(drillBestDist,'%.1f')]);
%     %
%     
%     
%     % subplots 1-2: USAC
%     inlierIndsUSAC = resultUSAC.inlierInds;
%     subplot 223; imshow(MPGAparams.I1); hold on;
%     plot(x1(1,:),x1(2,:),'.r');
%     plot(x1(1,inlierIndsUSAC),x1(2,inlierIndsUSAC),'.b');
%     title(['I1: "GT" inliers(' num2str(USACpercentile,'%.1f') '% - BLUE) outliers (RED), with error: 2']);
%     subplot 224; imshow(MPGAparams.I2); hold on;
%     plot(x2(1,:),x2(2,:),'.r');
%     plot(x2(1,inlierIndsUSAC),x2(2,inlierIndsUSAC),'.b');
%     ps = [];
%     ps(end+1) = plot(GT_targetCornerXs([1:4 1]),GT_targetCornerYs([1:4 1]),'g','linewidth',2);
%     ps(end+1) = plot(drillBestXs([1:4 1]),drillBestYs([1:4 1]),'b','linewidth',2);
%     ps(end+1) = plot(USAC_targetCornerXs([1:4 1]),USAC_targetCornerYs([1:4 1]),'r','linewidth',2);
%     legend(ps,{'GT','GPM','USAC'});
%     title(['I2: "USAC" inliers(' num2str(USACpercentile,'%.1f') '% - BLUE) outliers (RED), with error: 2']);
%     
%     % draw different inliers:
%     diffInds = setdiff(inlierIndsDrill,inlierIndsUSAC);
%     subplot 221; plot(x1(1,diffInds),x1(2,diffInds),'oc','markersize',12,'linewidth',2);
%     subplot 222; plot(x2(1,diffInds),x2(2,diffInds),'oc','markersize',12,'linewidth',2);
%     diffInds = setdiff(inlierIndsUSAC,inlierIndsDrill);
%     subplot 223; plot(x1(1,diffInds),x1(2,diffInds),'oc','markersize',12,'linewidth',2);
%     subplot 224; plot(x2(1,diffInds),x2(2,diffInds),'oc','markersize',12,'linewidth',2);
%     
%     %% Fig 2: histogram over our pecent of inliers
%     if doPlots        
%         figure; hist([sGT_distances(1:nInliers) sDistances_drill(1:nInliers) sUSAC_distances(1:nInliers)],100);
%         legend('GT distances','GPM distances','USAC distances');
%     end
%     %% Fig 3: cdf of distances
%     h_cdfs = figure; hold on
%     hGT = cdfplot(sGT_distances); set(hGT,'color','g','linewidth',3,'displayname','GT');
%     hGPM = cdfplot(sDistances_drill); set(hGPM,'color','b','linewidth',3,'displayname','GPM');
%     hUSC = cdfplot(sUSAC_distances); set(hUSC,'color','r','linewidth',3,'displayname','USAC');
% %     hUsedGpmDists = plot(used_distances_drill',(1/length(x1):1/length(x1):1),'b:','linewidth',2,'displayname','GPM used dists');
% %     hUsedGtDists = plot(used_GT_distances',(1/length(x1):1/length(x1):1),'g:','linewidth',2,'displayname','GT used dists');
% %     hUsedUsacDists = plot(used_USAC_distances',(1/length(x1):1/length(x1):1),'r:','linewidth',2,'displayname','USAC used dists');
%     pGPM = plot([0,max(sGT_distances)],[0.01*pStar,0.01*pStar],'--k','linewidth',3,'displayname','GPM Inlier rate');
% %     pGPM_rob = plot([0,max(sGT_distances)],[0.01*pStarRobust,0.01*pStarRobust],'--b','linewidth',2,'displayname','GPM robust inlier rate');
% %     errorGPM = plot([drillBestDist,drillBestDist],[0,1],':b','linewidth',3,'displayname','GPM lowest error');
%     legend('show','location','east');
%     xlim([-0.5,min(40,drillBestDist*8)]);
%     ylim([-0.05,1]);
%     title(sprintf('GPM - robust error (%.2f) , robust pStar (%.1f) , pStar (%.1f)',drillBestDist,pStarRobust,pStar))
%     
%     
%     %% Saving figures and workspace in an m-file
%     
%     if ishandle(GPM_result_fig), saveas(GPM_result_fig,[OutputDir 'GPM_result_fig.png']);end
%     if ishandle(allResultsOnImg),saveas(allResultsOnImg,[OutputDir 'results_on_imgs.fig']); end
%     if ishandle(h_cdfs),saveas(h_cdfs,[OutputDir 'cdf_comparisons.fig']);end
%     % save some of our results in a mat-file
%     save([OutputDir 'GPM_results.mat'],'GPMresult','GT_targetCornerXs','GT_targetCornerYs',...
%         'drillBestXs','drillBestYs','drillBestDist','lowerBound',...
%         'H_drill','GT_homog','pStar','BnBlevels',...
%         'sDistances_drill','sDrillInds','nInliers','inlierIndsDrill');
    
    
end % loop over image pairs

%%
return


