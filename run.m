clear all;
close all;
clc;

[filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp', ...
    'Image File (.jpg, .jpeg, .png, .bmp)'}, 'Select Image to be Segmented');

img = im2double(imread([pathname filename]));

[filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp', ...
    'Image File (.jpg, .jpeg, .png, .bmp)'}, 'Select Scribble Image');

scribble = im2double(imread([pathname filename]));

s = abs(img - scribble);
s = rgb2gray(s);
scribbleMap = (s > 0);

FMap = rgb2gray(scribble).*scribbleMap;
imshow(FMap);

tic
alpha = getAlpha(img, scribbleMap, FMap);
toc 

imshow(alpha);

[F,B] = reconstructFB(img, alpha);

figure; imshow(F);