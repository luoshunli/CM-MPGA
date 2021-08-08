function [x1,x2] = ...
    GridMatch(MPGAparams,tempx1,tempx2)
    
    iM1 = MPGAparams.I1;
    iM2 = MPGAparams.I2;
    f1 = MPGAparams.f1;
    f2 = MPGAparams.f2;
    d1 = MPGAparams.d1;
    d2 = MPGAparams.d2;

    patchSize = 10;   
    gridPatchSize = 100; 

    %%%分配特征点和描述符到patchSize*patchSize像素大小的方框内
    I1row = floor(size(iM1,2)/patchSize)+1;
    I1col = floor(size(iM1,1)/patchSize)+1;
    I2row = floor(size(iM2,2)/patchSize)+1;
    I2col = floor(size(iM2,1)/patchSize)+1;
    n = size(f1,2);
    A(1:I1row,1:I1col) = 0;
    for i = 1:n
        ii = floor(f1(1,i)/patchSize)+1;
        jj = floor(f1(2,i)/patchSize)+1;
        A(ii,jj) = A(ii,jj) + 1;
        Ffea1(ii,jj,:,A(ii,jj)) = f1(:,i);
        Ddes1(ii,jj,:,A(ii,jj)) = d1(:,i);
    end
    [I1row,I1col,~,~]=size(Ffea1);
    A = [];
    n = size(f2,2);
    A(1:I2row,1:I2col) = 0;
    for i = 1:n
        ii = floor(f2(1,i)/patchSize)+1;
        jj = floor(f2(2,i)/patchSize)+1;
        A(ii,jj) = A(ii,jj) + 1;
        Ffea2(ii,jj,:,A(ii,jj)) = f2(:,i);
        Ddes2(ii,jj,:,A(ii,jj)) = d2(:,i);
    end
    [I2row,I2col,~,~]=size(Ffea2);
    xx1 = tempx1;
    xx2 = tempx2;

%%%%%%%%%%%%%%%%%%%%%%定大范围，小尺寸移动
    n = size(xx1,2);

    row1 = floor(size(iM1,2)/gridPatchSize)+1;
    col1 = floor(size(iM1,1)/gridPatchSize)+1;
    matchUsed(1:row1,1:col1) = 0;
    x1 = [0;0];
    x2 = [0;0];
    for i = 1:n
        ii1 = floor(xx1(1,i)/gridPatchSize)+1;
        jj1 = floor(xx1(2,i)/gridPatchSize)+1;
        if(matchUsed(ii1,jj1))
            continue;
        else
            ii2 = floor(xx2(1,i)/gridPatchSize)+1;
            jj2 = floor(xx2(2,i)/gridPatchSize)+1;

            sizeCount = gridPatchSize/patchSize;
            dx1 = floor((ii1*gridPatchSize - xx1(1,i))/patchSize);
            dy1 = floor((jj1*gridPatchSize - xx1(2,i))/patchSize);
            dx2 = floor((ii2*gridPatchSize - xx2(1,i))/patchSize);
            dy2 = floor((jj2*gridPatchSize - xx2(2,i))/patchSize); 
            dxx = dx2 - dx1;
            dyy = dy2 - dy1;
            xIndex1 = (ii1-1)*sizeCount+1;
            yIndex1 = (jj1-1)*sizeCount+1;
            xIndex2 = (ii2-1)*sizeCount-dxx;
            yIndex2 = (jj2-1)*sizeCount-dyy;
            [tempx1,tempx2] =  patchMatch(Ffea1,Ffea2,Ddes1,Ddes2,xIndex1,yIndex1,xIndex2,yIndex2,sizeCount,I1row,I1col,I2row,I2col);
            m = size(tempx1,2);          
            if(m>1)
                x1 = [x1 tempx1];
                x2 = [x2 tempx2];
                for colIndexPace = 1:3
                    if(ii1 + colIndexPace - 2 <1 || ii1 + colIndexPace - 2 > row1)
                        continue;
                    else
                        for rowIndexPace = 1:3
                            if(colIndexPace == 2 && rowIndexPace == 2)
                                continue;
                            end
                            if(jj1 + rowIndexPace - 2 <1 || jj1 + rowIndexPace - 2 > col1)
                                continue;
                            else
                                xIndex3 = xIndex1 - (rowIndexPace - 2)*sizeCount;
                                yIndex3 = yIndex1 - (colIndexPace - 2)*sizeCount;
                                xIndex4 = xIndex2 - (rowIndexPace - 2)*sizeCount;
                                yIndex4 = yIndex2 - (colIndexPace - 2)*sizeCount;
                                if(xIndex3 > I1row || xIndex3 < 1 || yIndex3 > I1col || yIndex3 < 1 || xIndex4 > I1row || xIndex4 < 1 || yIndex4 > I1col || yIndex4 < 1)
                                    continue;
                                else
                                    [tempx1,tempx2] =  patchMatch(Ffea1,Ffea2,Ddes1,Ddes2,xIndex3,yIndex3,xIndex4,yIndex4,sizeCount,I1row,I1col,I2row,I2col);
                                    m = size(tempx1,2);
                                    if(m > 0)
                                        x1 = [x1 tempx1];
                                        x2 = [x2 tempx2];
                                    end
                                end
                            end
                        end
                    end
                end
% % % % % % % % %  去除同一区域重复匹配               
                [~,ia1,~] = unique(x1.','rows','stable');
                x1 = x1(:,ia1);
                x2 = x2(:,ia1);
                [~,ia1,~] = unique(x2.','rows','stable');
                x1 = x1(:,ia1);
                x2 = x2(:,ia1);
            end
            matchUsed(ii1,jj1) = 1;
        end
    end
    

    x1(:,find(all(x1==0,1))) = [];
    x2(:,find(all(x2==0,1))) = []; %删除全0列
    