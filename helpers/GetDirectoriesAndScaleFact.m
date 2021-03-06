% compute/load matches and scaleFact
function [exampleDir,GPMResultDir,MCTSResultDir,namePrefix,nameSuffix,scaleFact] = ...
    GetDirectoriesAndScaleFact(name,runName,siftMethod,noiseName,img1Filename)


if isequal(name(1:4),'USAC')
    matchfileName1 = strrep(img1Filename,'im1.jpg','orig_pts.txt');
    
    fid = fopen(matchfileName1);
    nMatches = fscanf(fid,'%d',1);
    allMatches = fscanf(fid,'%f %f %f %f',4*nMatches);
    allMatches = reshape(allMatches,4,nMatches)';
    x1 = [allMatches(:,1:2)' ; ones(1,nMatches)];
    x2 = [allMatches(:,3:4)' ; ones(1,nMatches)];
    stat = fclose(fid);
    
    % dirs
    namePrefix = name(1:strfind(name,'example')-2);
    nameSuffix = name(strfind(name,'example'):end);
    exampleDir = ['../results/Usac/' siftMethod '/' noiseName '/' namePrefix '/' nameSuffix '/'];
    GPMResultDir = [exampleDir 'GPM_' runName '/'];
    MCTSResultDir = [exampleDir 'MaxConTreeSearch/'];
    if ~exist(GPMResultDir,'dir'), mkdir(GPMResultDir), end
    if ~exist(MCTSResultDir,'dir'), mkdir(MCTSResultDir), end
    scaleFact = 4.5; % TEMPORARILY HERE!!
    
else % Miko data
    
    % dirs
    namePrefix = name(1:end-3);
    nameSuffix = name(end-2:end);
    exampleDir = ['../results/Miko/' siftMethod '/' noiseName '/' namePrefix '/' nameSuffix '/'];
    GPMResultDir = [exampleDir 'GPM_' runName '/'];
    MCTSResultDir = [exampleDir 'MaxConTreeSearch/'];
    if ~exist(GPMResultDir,'dir'), mkdir(GPMResultDir), end
    if ~exist(MCTSResultDir,'dir'), mkdir(MCTSResultDir), end
    scaleFact = 4.1; % TEMPORARILY HERE!!
    
end
