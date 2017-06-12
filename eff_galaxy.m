function [ mask ] = eff_galaxy( filename )
% clear;close all;clc;
%filename='photo.png';

%% input bg & photo
bg_galaxy = imread('bg_galaxy.png');
bg_galaxy = imresize(bg_galaxy, [512 512]);
bg_galaxy = im2double(bg_galaxy);
[img, map, alpha]= imread(filename);
img= imresize(img, [512 512]);
alpha= imresize(alpha, [512 512]);

%% gray scale
img = imsharpen(img);
img = rgb2gray(img);
img = im2double(img);

%% set threshold
img(img==0)=1;
threshold=0.55;
img(img<threshold)=0;
img(img>=threshold)=1;

%% overlay
mask(:,:,1)=img(:, :);
mask(:,:,2)=img(:, :);
mask(:,:,3)=img(:, :);
mask(mask==0)=bg_galaxy(mask==0);

end