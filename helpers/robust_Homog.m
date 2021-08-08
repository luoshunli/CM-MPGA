function Hout = robust_Homog(x1,x2,wFunName)
if ~exist('wFunName','var')
    wFunName = 'bisquare';
end
assert(all(x1(3,:)==1))
assert(all(x2(3,:)==1))

x1_in = x1;
x2_in = x2;
nInliers = size(x1,2);
%% calc robust H

vec_1 = ones(nInliers,1);
vec_0 = zeros(nInliers,3);

U = x2_in(1:2,:)';

X = [x1_in(1:2,:)'   vec_1  vec_0                  [-x2_in(1,:).*x1_in(1,:) ; -x2_in(1,:).*x1_in(2,:)]';
    vec_0                   x1_in(1:2,:)'   vec_1  [-x2_in(2,:).*x1_in(1,:) ; -x2_in(2,:).*x1_in(2,:)]'  ];

Tvec = zeros(9,1);
% Tvec(1:8) = X \ U;

% this is a slightly different version of Matlab's "robustfit", where
% samples are rewighted in pairs (xy coordinates). The original version 
% will also work well (probably) but is not "correct". (Roee)
Tvec(1:8) = robustfit_local(X , U(:),wFunName,[],0);


% We assumed I = 1;
Tvec(9) = 1;

Hout = Tvec; % reshape(Tvec,3,3)';
