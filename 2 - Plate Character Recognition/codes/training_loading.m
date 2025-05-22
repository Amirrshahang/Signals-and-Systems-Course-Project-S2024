clc;
clear;
close all;

dirPath = '/Users/amir/Desktop/untitled folder/Map Set';
files = dir(fullfile(dirPath, '*.bmp'));
len = length(files);

TRAIN = cell(2, len);

for i = 1:len
   filePath = fullfile(dirPath, files(i).name);
   TRAIN{1, i} = imread(filePath);
   TRAIN{2, i} = files(i).name(1);
end

saveDir = '/Users/amir/Desktop/untitled folder';
saveFilePath = fullfile(saveDir, 'TRAININGSET.mat');

save(saveFilePath, 'TRAIN');
clear;