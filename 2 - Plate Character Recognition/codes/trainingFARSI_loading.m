
clc;
clear;
close all;

dirPath = '/Users/amir/Desktop/untitled folder/Farsi_mapset';
files = dir(fullfile(dirPath, '*.bmp'));
len = length(files);

TRAIN = cell(2, len);

for i = 1:len
   filePath = fullfile(dirPath, files(i).name);
   img = imread(filePath);
   resizedImg = imresize(img, [100,80]); 
   TRAIN{1, i} = resizedImg;
   TRAIN{2, i} = files(i).name(1);
end

saveDir = '/Users/amir/Desktop/untitled folder';
saveFilePath = fullfile(saveDir, 'TRAININGSET3.mat');

save(saveFilePath, 'TRAIN');
clear;
