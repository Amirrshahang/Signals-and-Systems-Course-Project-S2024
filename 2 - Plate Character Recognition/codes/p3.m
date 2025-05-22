clc
close all;
clear;
%% Setup and Image Loading

[file, path] = uigetfile({'*.jpg;*.bmp;*.png;*.tif'}, 'Choose an image');
picture_full = imread([path, file]);


%% Preprocessing and Template Matching

ERR_MARGIN = 10;
BLUE2PLATE_RATIO = 14;

    bluestrip = imread('templateMatching1.png');
    bluestrip_big = imread('templateMatching.png');

    picture = imresize(picture_full, [NaN, 800]);
         figure
        subplot(1,2,1)
        imshow(picture)
        title('picture')

    ratio = size(picture_full, 1) / size(picture, 1);

    [corr_mix, corr_max, bbox] = templateMatching(bluestrip, picture);
    [corr_mixB, corr_maxB, bboxB] = templateMatching(bluestrip_big, picture);


     if corr_maxB > corr_max

         [corr_mix, corr_max, bbox] = deal(corr_mixB, corr_maxB, bboxB);
     end

%% Adjusting Bounding Box and Display

    left = round(bbox(1) * ratio) - ERR_MARGIN;
    top = round(bbox(2) * ratio) - ERR_MARGIN;
    width = round(bbox(3) * ratio) + 2 * ERR_MARGIN;
    height = round(bbox(4) * ratio) + 2 * ERR_MARGIN;

    bbox_full = [left,top,width,height];

    bounding_box = bbox_full;
    bounding_box(3) = BLUE2PLATE_RATIO * bbox(3) * ratio;

         subplot(1,2,2)
        imshow(picture_full)
        title('Resize picture')


        hold on

        rectangle('Position', bbox_full, 'edgecolor', 'k', 'linewidth', 2);
        rectangle('Position', bounding_box, 'edgecolor', 'g', 'linewidth', 1);
        
        if corr_max > 0.5
                title('Match Success')
        else
            disp('not Match')
            
        end
%% Image Cropping and Resizing

if ~isempty(bounding_box)
    Croppedpicture = imcrop(picture_full, bounding_box);
    figure
     subplot(1,2,1)
    imshow(Croppedpicture)
     title('Croppedpicture')

else
    disp('No bounding box found or correlation too low, cannot crop the image.');
    Croppedpicture = [];
end
    subplot(2,2,2)
       imshow(Croppedpicture)
%% p2.m

picture=imresize(Croppedpicture,[300 500]);


picture = mygrayfun(picture);
figure
subplot(1,2,1)
imshow(picture)
title('gray Croppedpicture')

threshold = graythresh(picture);
picture =~imbinarize(picture,threshold);

subplot(1,2,2)
imshow(picture)
title('binary Croppedpicture')



picture = Myremovecom(picture,500);

picture2 = picture ; %-background;
figure
subplot(1,2,1)
imshow(picture2)
title('BoundedBox picture')


[L,Ne] = mysegmentation(picture2);
subplot(1,2,2)
imshow(picture2)
title('Removed small objects picture')


load TRAININGSET3;
totalLetters=size(TRAIN,2);


figure
final_output=[];
t=[];

for n=1:Ne
    [r,c]=find(L==n);
    Y=picture2(min(r):max(r),min(c):max(c));
    imshow(Y)
    Y=imresize(Y,[100,80]);
    imshow(Y)
    pause(0.2)
    if n==7
        hg=1;
    end
ro=zeros(1,totalLetters);
    for k=1:totalLetters   
        ro(k)=corr2(TRAIN{1,k},Y);
    end
[MAXRO,pos]=max(ro);
     if MAXRO>.7

    out=cell2mat(TRAIN(2,pos));       
    final_output=[final_output out];
     end
 end

file = fopen('number_Plate3.txt', 'wt', 'n', 'UTF-8');
fprintf(file,'%s\n',final_output);
fclose(file);
system('open number_Plate3.txt');

%% 
% corr_mix  the average correlation map across the RGB channels; 
% corr_max  the maximum correlation value
% bbox      he bounding box coordinates of where the template matches in the larger image
function [corr_mix, corrMax, bbox] = templateMatching(template, pic)

    RC = normxcorr2(template(:, :, 1), pic(:, :, 1));
    GC = normxcorr2(template(:, :, 2), pic(:, :, 2));
    BC = normxcorr2(template(:, :, 3), pic(:, :, 3));
    corr_mix = (RC + GC + BC)/3;

    [corrMax, Idx] = max(abs(corr_mix(:)));

    [Y, X] = ind2sub(size(corr_mix), Idx(1));

    offset = [X - size(template, 2), Y - size(template, 1)];

    bbox = [offset(1), offset(2), size(template, 2), size(template, 1)];
end

