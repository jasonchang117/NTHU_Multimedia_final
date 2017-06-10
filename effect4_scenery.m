clear
close all
clc

%%  inpurt photos
img = imresize(imread('photo.png'), 1);
[M, N, P] = size(img);
backg = imresize(im2single(imread('bg_scene.png')), 1);
backg = backg(1:M, 1:N, :);

%% cut the face

%% reduce the transparency and combine
figure;
image(backg);
hold on;
head=image(img);
set(head,'AlphaData',0.5);
