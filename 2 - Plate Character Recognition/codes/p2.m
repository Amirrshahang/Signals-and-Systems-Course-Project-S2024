clc
close all;
clear;
%% SELECTING THE TEST DATA
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture=imread(s);

figure
subplot(1,2,1)
imshow(picture)
title('picture')

%% resize
picture=imresize(picture,[300 500]);

subplot(1,2,2)
imshow(picture)
title('Resize picture')


%% RGB2GRAY
picture = mygrayfun(picture);

figure
subplot(1,2,1)
imshow(picture)
title('gray picture')

%% CONVERSION TO A BINARY IMAGE

threshold = graythresh(picture);
picture =~imbinarize(picture,threshold);

subplot(1,2,2)
imshow(picture)
title('binary picture')

%% Removing the small objects

picture = Myremovecom(picture,500);

picture2 = picture ; %-background;
figure
subplot(1,2,1)
imshow(picture2)
title('BoundedBox picture')


%% Labeling connected components

[L,Ne] = mysegmentation(picture2);
subplot(1,2,2)
imshow(picture2)
title('Removed small objects picture')

%% Loading the mapset
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



%% Printing the plate
file = fopen('number_PlateF.txt', 'wt', 'n', 'UTF-8');
fprintf(file,'%s\n',final_output);
fclose(file);
system('open number_PlateF.txt');
clc
close all;