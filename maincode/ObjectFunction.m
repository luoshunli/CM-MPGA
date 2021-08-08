function obj=ObjectFunction(X,x1,x2,templateCorners)
%% ���Ż���Ŀ�꺯��
% X��ÿ��Ϊһ������
    NetOfQuadrilaterals = X';
    H = SquaresToHomography(templateCorners.x', templateCorners.y',double(NetOfQuadrilaterals(1:2:end,:)),double(NetOfQuadrilaterals(2:2:end,:)));
    distance = ApplyHomographiesOnLocations_mex(H,x1(1,:),x1(2,:),x2(1,:),x2(2,:));
    temp = sum(distance);
    temp = -1*temp;
    obj = temp';
end
