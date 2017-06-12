clear all;
close all;
clc;

[filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp', ...
    'Image File (.jpg, .jpeg, .png, .bmp)'}, 'Select Image to be Segmented');

img = im2double(imread([pathname filename]));

scribble_F = drawscribble(img,[1 1 1]);
scribble = drawscribble(scribble_F,[0 0 0]);
 
scribbleMap = sum(abs(img - scribble), 3);
scribbleMap = (scribbleMap > 0);
FMap = rgb2gray(scribble).*scribbleMap;

tic
alpha = getAlpha(img, scribbleMap, FMap);
toc

figure;imshow(alpha);

[F,B] = reconstructFB(img, alpha);

figure; imshow(F);