function [fileName1,fileName2,GT_homog,useprctile,scaleFact] = LoadImages(pthData,name)

switch name
       
    case 'graf1_2';
        fileName1 = fullfile(pthData,'miko\graf\img1.ppm');
        fileName2 = fullfile(pthData,'miko\graf\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\graf\H1to2p'));
        scaleFact = 2;
        
    case 'graf1_3';
        fileName1 = fullfile(pthData,'miko\graf\img1.ppm');
        fileName2 = fullfile(pthData,'miko\graf\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\graf\H1to3p'));
        scaleFact = 2;
        
    case 'graf1_4';
        fileName1 = fullfile(pthData,'miko\graf\img1.ppm');
        fileName2 = fullfile(pthData,'miko\graf\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\graf\H1to4p'));
        scaleFact = 2;
        
    case 'graf1_5';
        fileName1 = fullfile(pthData,'miko\graf\img1.ppm');
        fileName2 = fullfile(pthData,'miko\graf\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\graf\H1to5p'));
        scaleFact = 3;
        
    case 'graf1_6';
        fileName1 = fullfile(pthData,'miko\graf\img1.ppm');
        fileName2 = fullfile(pthData,'miko\graf\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\graf\H1to6p'));
    
    case 'wall1_2';
        fileName1 = fullfile(pthData,'miko\wall\img1.ppm');
        fileName2 = fullfile(pthData,'miko\wall\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\wall\H1to2p'));
        
    case 'wall1_3';
        fileName1 = fullfile(pthData,'miko\wall\img1.ppm');
        fileName2 = fullfile(pthData,'miko\wall\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\wall\H1to3p'));
        
    case 'wall1_4';
        fileName1 = fullfile(pthData,'miko\wall\img1.ppm');
        fileName2 = fullfile(pthData,'miko\wall\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\wall\H1to4p'));
        
    case 'wall1_5';
        fileName1 = fullfile(pthData,'miko\wall\img1.ppm');
        fileName2 = fullfile(pthData,'miko\wall\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\wall\H1to5p'));
        
    case 'wall1_6';
        fileName1 = fullfile(pthData,'miko\wall\img1.ppm');
        fileName2 = fullfile(pthData,'miko\wall\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\wall\H1to6p'));
        
    case 'trees1_2';
        fileName1 = fullfile(pthData,'miko\trees\img1.ppm');
        fileName2 = fullfile(pthData,'miko\trees\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\trees\H1to2p'));
        
    case 'trees1_3';
        fileName1 = fullfile(pthData,'miko\trees\img1.ppm');
        fileName2 = fullfile(pthData,'miko\trees\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\trees\H1to3p'));
        
    case 'trees1_4';
        fileName1 = fullfile(pthData,'miko\trees\img1.ppm');
        fileName2 = fullfile(pthData,'miko\trees\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\trees\H1to4p'));
        
    case 'trees1_5';
        fileName1 = fullfile(pthData,'miko\trees\img1.ppm');
        fileName2 = fullfile(pthData,'miko\trees\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\trees\H1to5p'));
        
    case 'trees1_6';
        fileName1 = fullfile(pthData,'miko\trees\img1.ppm');
        fileName2 = fullfile(pthData,'miko\trees\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\trees\H1to6p'));
        
    case 'bark1_2';
        fileName1 = fullfile(pthData,'miko\bark\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bark\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bark\H1to2p'));
        
    case 'bark1_3';
        fileName1 = fullfile(pthData,'miko\bark\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bark\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bark\H1to3p'));
        
    case 'bark1_4';
        fileName1 = fullfile(pthData,'miko\bark\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bark\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bark\H1to4p'));
        
    case 'bark1_5';
        fileName1 = fullfile(pthData,'miko\bark\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bark\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bark\H1to5p'));
        
    case 'bark1_6';
        fileName1 = fullfile(pthData,'miko\bark\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bark\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bark\H1to6p'));
        
    case 'bikes1_2';
        fileName1 = fullfile(pthData,'miko\bikes\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bikes\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bikes\H1to2p'));
        
    case 'bikes1_3';
        fileName1 = fullfile(pthData,'miko\bikes\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bikes\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bikes\H1to3p'));
        
    case 'bikes1_4';
        fileName1 = fullfile(pthData,'miko\bikes\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bikes\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bikes\H1to4p'));
        
    case 'bikes1_5';
        fileName1 = fullfile(pthData,'miko\bikes\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bikes\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bikes\H1to5p'));

        
    case 'bikes1_6';
        fileName1 = fullfile(pthData,'miko\bikes\img1.ppm');
        fileName2 = fullfile(pthData,'miko\bikes\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\bikes\H1to6p'));
    
    case 'leuven1_2';
        fileName1 = fullfile(pthData,'miko\leuven\img1.ppm');
        fileName2 = fullfile(pthData,'miko\leuven\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\leuven\H1to2p'));
        
    case 'leuven1_3';
        fileName1 = fullfile(pthData,'miko\leuven\img1.ppm');
        fileName2 = fullfile(pthData,'miko\leuven\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\leuven\H1to3p'));
        
    case 'leuven1_4';
        fileName1 = fullfile(pthData,'miko\leuven\img1.ppm');
        fileName2 = fullfile(pthData,'miko\leuven\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\leuven\H1to4p'));
        
    case 'leuven1_5';
        fileName1 = fullfile(pthData,'miko\leuven\img1.ppm');
        fileName2 = fullfile(pthData,'miko\leuven\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\leuven\H1to5p'));
        
    case 'leuven1_6';
        fileName1 = fullfile(pthData,'miko\leuven\img1.ppm');
        fileName2 = fullfile(pthData,'miko\leuven\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\leuven\H1to6p'));
        
    case 'ubc1_2';
        fileName1 = fullfile(pthData,'miko\ubc\img1.ppm');
        fileName2 = fullfile(pthData,'miko\ubc\img2.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\ubc\H1to2p'));
        
    case 'ubc1_3';
        fileName1 = fullfile(pthData,'miko\ubc\img1.ppm');
        fileName2 = fullfile(pthData,'miko\ubc\img3.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\ubc\H1to3p'));
        
    case 'ubc1_4';
        fileName1 = fullfile(pthData,'miko\ubc\img1.ppm');
        fileName2 = fullfile(pthData,'miko\ubc\img4.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\ubc\H1to4p'));
        
    case 'ubc1_5';
        fileName1 = fullfile(pthData,'miko\ubc\img1.ppm');
        fileName2 = fullfile(pthData,'miko\ubc\img5.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\ubc\H1to5p'));
        
    case 'ubc1_6';
        fileName1 = fullfile(pthData,'miko\ubc\img1.ppm');
        fileName2 = fullfile(pthData,'miko\ubc\img6.ppm');
        GT_homog = dlmread(fullfile(pthData,'miko\ubc\H1to6p'));

    case 'USAC_test1';
        fileName1 = fullfile(pthData,'USAC\test1\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test1\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test2';
        fileName1 = fullfile(pthData,'USAC\test2\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test2\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test3';
        fileName1 = fullfile(pthData,'USAC\test3\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test3\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test4';
        fileName1 = fullfile(pthData,'USAC\test4\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test4\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test5';
        fileName1 = fullfile(pthData,'USAC\test5\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test5\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test6';
        fileName1 = fullfile(pthData,'USAC\test6\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test6\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test7';
        fileName1 = fullfile(pthData,'USAC\test7\im2.jpg');
        fileName2 = fullfile(pthData,'USAC\test7\im1.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test8';
        fileName1 = fullfile(pthData,'USAC\test8\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test8\im2.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test9';
        fileName1 = fullfile(pthData,'USAC\test9\im2.jpg');
        fileName2 = fullfile(pthData,'USAC\test9\im1.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test10';
        fileName1 = fullfile(pthData,'USAC\test10\im2.jpg');
        fileName2 = fullfile(pthData,'USAC\test10\im1.jpg');
        GT_homog = eye(3);
        
    case 'USAC_test11';
        fileName1 = fullfile(pthData,'USAC\test11\im1.jpg');
        fileName2 = fullfile(pthData,'USAC\test11\im2.jpg');
        GT_homog = eye(3);
        
    case 'adam';
        fileName1 = fullfile(pthData,'Lebeda\adam\img1.png');
        fileName2 = fullfile(pthData,'Lebeda\adam\img2.png');
        GT_homog = eye(3);
        
    case 'city';
        fileName1 = fullfile(pthData,'Lebeda\city\img1.png');
        fileName2 = fullfile(pthData,'Lebeda\city\img2.png');
        GT_homog = eye(3);
        
   case 'Bost';
        fileName1 = fullfile(pthData,'Lebeda\Boston\img1.jpg');
        fileName2 = fullfile(pthData,'Lebeda\Boston\img2.jpg');
        GT_homog = eye(3); 
        
   case 'Brus';
        fileName1 = fullfile(pthData,'Lebeda\Brussels\img1.jpg');
        fileName2 = fullfile(pthData,'Lebeda\Brussels\img2.jpg');
        GT_homog = eye(3); 
       
   case 'Brug';
        fileName1 = fullfile(pthData,'Lebeda\BruggeTower\img1.png');
        fileName2 = fullfile(pthData,'Lebeda\BruggeTower\img2.png');
        GT_homog = eye(3); 
   
   case 'test';
        fileName1 = fullfile(pthData,'Lebeda\test\1.jpg');
        fileName2 = fullfile(pthData,'Lebeda\test\2.jpg');
        GT_homog = eye(3); 
        
    otherwise
        error('LoadImages: no such case!');
        
end