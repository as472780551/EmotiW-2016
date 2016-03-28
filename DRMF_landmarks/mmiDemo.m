function mmiDemo(start_num, end_num)
addpath(genpath('.'));
    
% ------------------------------------------------%
% % % 
% % % Choose Face Detector
% % % 0: Tree-Based Face Detector (p204);
% % % 1: Matlab Face Detector (or External Face Detector);
% % % 2: Use Pre-computed Bounding Boxes
% % % 
% % % NOTES:
% % % [a]   Option '0' is very accurate and suited for faces in the 'wild';
% % %       But it is EXTREMELY slow!!!
% % % [b]   Option '1' supports the functionality for incorporating
% % %       YOUR OWN FACE DETECTOR WITH DRMF FITTING;
% % %       Simply modify the function External_Face_Detector.m
% % % 

bbox_method = 0;
%------------------------------------------------%


%------------------------------------------------%
% % % Choose Visualize
% % % 0: Do Not Display Fitting Results;
% % % 1: Display Fitting Results and Pause of Inspection)
% % % 

visualize=0;
%------------------------------------------------%


%------------------------------------------------%
% % % Load Test Images
dir='/media/datadisk/database/MMI/';
image_path = strcat(dir,'Sessions_each/');
saveLandmark_path=strcat(dir,'MMIdata/landmarks/');
imglistPath=strcat(image_path,'imglist.txt');
img_list = importdata(imglistPath);
imgnum=size(img_list,1);
start_num=794;
end_num=872;
%img_list=dir([image_path,'*.png']);
step=1;
clm_model='model/DRMF_Model.mat';
load(clm_model);
bdbox=[];
flatrote=0;
for t=start_num:step:min(end_num,imgnum)
    tic;
    imgstr=img_list{t};
    strcurimgnum = imgstr(end-6:end-4);
    strcursubnum = imgstr(1:end-9);
    intsubnum=str2num(strcursubnum);
    intimgnum=str2num(strcurimgnum);
    if(intimgnum==1||t==start_num)
        bbox_method=0;
        initi_bdbox=[];
    else
        bbox_method=2;
        initi_bdbox=bdbox;
    end
    
    for j=t:min(t+step-1,end_num)
        i=j-t+1;
        data(i).name = strcat(image_path,img_list{j});
          image=imread(data(i).name);
         [row,col,~]=size(image);
         if(intsubnum>1800)
             image=imrotate(image,270);
             %imshow(image);
         end
%         resize_image=imresize(image,[row,col]/2);
%         data(i).img = im2double(resize_image);
        data(i).img = im2double(image);
%         if(intimgnum~=1)
%             cropimg=imcrop(image,initi_bdbox);
%             imshow(cropimg);
%         end
        
        
        % % % Required Only for bbox_method = 2;
        data(i).bbox = initi_bdbox; % Face Detection Bounding Box [0;0;col;row]
        
        % % % Initialization to store the results
        data(i).points = []; % MAT containing 66 Landmark Locations
        data(i).pose = []; % POSE information [Pitch;Yaw;Roll]
    end
    
    %------------------------------------------------%
    %------------------------------------------------%
    %Run Demo 
    data=DRMF(clm_model,data,bbox_method,visualize);
    
    for j=t:min(t+step-1,end_num)
        i=j-t+1;
        landmarks=data(i).points;
      
        landmarkfile=strrep(img_list{j},'.png','.txt');
        curLdmkPath=strcat(saveLandmark_path,landmarkfile);
        cur_dir=fileparts(curLdmkPath);
        if(exist(cur_dir,'dir')==0)
        mkdir(cur_dir);
        end
        dlmwrite(curLdmkPath,landmarks,'delimiter',' ');
    end
    if(intimgnum==1||t==start_num)
        bdbox=calculatebox(landmarks,row,col);
    end
    
    
    toc
    %t=t+step;
end
%------------------------------------------------%

