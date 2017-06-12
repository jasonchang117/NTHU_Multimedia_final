%clear all
function [ splash_out ] = splash()

file = {'paint-splatter-2.png', 'paint-splatter-7.png', 'paint-splatter-8.png', 'paint-splatter-13.png'};
idx = 4;
scale_splash = [0.6 0.6 0.6 0.6];
[splash, color, alpha] = imread(file{idx}, 'png');
splash = imresize(splash, scale_splash(idx));
splash = rgb2gray(splash);
ori = splash;
photo = imread('photo_burned.jpg');
size(photo, 1)
p = size(photo, 1) / 1218;
photo_splash = [0.3/p 0.262/p 0.3/p 0.3/p];
photo = imresize(photo, photo_splash(idx));
splash_out = splash_effect(photo, splash, 175, idx);

%figure(1);imshow(splash_out)
%figure(2);imshow(splash)
%[456 825]
end
