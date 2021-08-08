function [tempx1,tempx2] =  patchMatch(Ffea1,Ffea2,Ddes1,Ddes2,xIndex1,yIndex1,xIndex2,yIndex2,sizeCount,I1row,I1col,I2row,I2col)
    tempDes1(1:128,1)=0;
    tempDes2(1:128,1)=0; 
    tempFea1(1:4,1)=0;
    tempFea2(1:4,1)=0; 
    for j = 0:sizeCount-1
        for k = 0:sizeCount-1
            if((xIndex1+j) > I1row || (xIndex1+j) < 1 || (yIndex1+k) > I1col || (yIndex1+k) < 1 )
                continue;
            else
                temp1 = Ddes1(xIndex1+j,yIndex1+k,:,:);
                n = size(temp1,3);
                m = size(temp1,4);
                temp1 = reshape(temp1,n,m);
                tempDes1 = [tempDes1 temp1];
            end
        end
    end
    for j = 0:sizeCount
        for k = 0:sizeCount
            if((xIndex2+j) > I2row || (xIndex2+j) < 1 || (yIndex2+k) > I2col || (yIndex2+k) < 1 )
                continue;
            else
                temp2 = Ddes2(xIndex2+j,yIndex2+k,:,:);
                n = size(temp2,3);
                m = size(temp2,4);
                temp2 = reshape(temp2,n,m);
                tempDes2 = [tempDes2 temp2];
            end
        end
    end
    tempDes1(:,find(all(tempDes1==0,1))) = []; 
    tempDes2(:,find(all(tempDes2==0,1))) = [];
    
    if(size(tempDes1,2)&&size(tempDes2,2))
        
        [matche, scores] = vl_ubcmatch(tempDes1,tempDes2,1.5); 

        A = matche';
        [h s]=hist(A(:,1),unique(A(:,1)));
        A(ismember(A(:,1),s(h~=1)),:)=[];

        [h s]=hist(A(:,2),unique(A(:,2)));
        A(ismember(A(:,2),s(h~=1)),:)=[];
        matche = A';

        for j = 0:sizeCount-1
            for k = 0:sizeCount-1
                if(xIndex1+j > I1row || xIndex1+j < 1 || yIndex1+k > I1col || yIndex1+k < 1 )
                    continue;
                else
                    temp1 = Ffea1(xIndex1+j,yIndex1+k,:,:);
                    n = size(temp1,3);
                    m = size(temp1,4);
                    temp1 = reshape(temp1,n,m);
                    tempFea1 = [tempFea1 temp1];
                end
            end
        end

        for j = 0:sizeCount
            for k = 0:sizeCount
                if(xIndex2+j > I2row || xIndex2+j < 1 || yIndex2+k > I2col || yIndex2+k < 1 )
                    continue;
                else
                    temp2 = Ffea2(xIndex2+j,yIndex2+k,:,:);
                    n = size(temp2,3);
                    m = size(temp2,4);
                    temp2 = reshape(temp2,n,m);
                    tempFea2 = [tempFea2 temp2];
                end
            end
        end
        tempFea1(:,find(all(tempFea1==0,1))) = [];
        tempFea2(:,find(all(tempFea2==0,1))) = [];


        tempx1 = tempFea1(1:2,matche(1,:)); 
        tempx2 = tempFea2(1:2,matche(2,:));
        m = size(tempx1,2);
        if(m>2)
            A(1:m,1:m)=0;
            for k = 1:m
                dx = tempx1(1,:) - tempx1(1,k);
                dy = tempx1(2,:) - tempx1(2,k);
                dx = dx';
                dy = dy'; 
                dx1 = tempx2(1,:) - tempx2(1,k);
                dy1 = tempx2(2,:) - tempx2(2,k);
                dx = dx*dx1;
                dy = dy*dy1;
                for l = 1:m
                    if((dx(l,l)<0)||(dy(l,l)<0))
                        A(k,l) = 1;
                    end
                end
            end
            b = sum(A);
            id = find(b>(m/2));
            tempx1(:,id)= [];
            tempx2(:,id)= [];
        else
            tempx1= [0;0];
            tempx2= [0;0];
        end
    else
        tempx1= [0;0];
        tempx2= [0;0];
    end