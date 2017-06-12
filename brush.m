function [ photo_bg ] = brush()

photo = imread('photo_burned.png');
photo = imresize(photo, 0.3);

bg = imread('wallpaper_1.jpg');
bg = imresize(bg, 0.3);

flower = imread('Free-Floral-Vector-Brush-Pack.jpg');
%flower = rgb2gray(flower);
%imshow(flower)
flower = imresize(flower, 1.2);
threshold = 175;

null_size = abs(size(photo) - size(flower));
n1 = zeros(floor(null_size(1)/2), floor(null_size(1)/2));
n2 = zeros(ceil(null_size(1)/2), ceil(null_size(1)/2));

photo_bg = brush_effect( photo, bg );

%imshow(photo_bg)

%imshow(photo_ink)