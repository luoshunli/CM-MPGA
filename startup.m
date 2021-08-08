function [pthHere,pthData] = startup()

pthHere = fileparts(mfilename('fullpath'));
addpath(pthHere)

addpath(fullfile(pthHere,'mex'))
addpath(fullfile(pthHere,'helpers'))
addpath(fullfile(pthHere,'maincode'))

addpath(fullfile(fullfile(pthHere,'third_party'),'genetic'))

addpath(genpath([pthHere '\third_party\MaxConTreeSearch']))

pthRoot = fileparts(pthHere);
pthData = fullfile(pthRoot,'data');

run([pthHere '\\\\third_party\vlfeat-0.9.20\vlfeat-0.9.20\toolbox\vl_setup']);

end

