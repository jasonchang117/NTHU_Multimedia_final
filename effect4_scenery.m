clear
close all
clc
%% Remove background

%%  inpurt photos
% initial size = 500*500
[img, map, alpha]= imread('photo', 'png');
img= imresize(img, [500 500]);
alpha= imresize(alpha, [500 500]);
x=imshow(img, map);

%% input background & combine
backg = imread('bg_scene.png');
backg= imresize(backg, [500 500]);
hold on;
y=imshow(backg);

%% cut the outline & reduce the transparency
set(y, 'AlphaData', alpha*0.5);
set(x, 'AlphaData', alpha);

%% example