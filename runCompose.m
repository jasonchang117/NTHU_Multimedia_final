clear all;
close all;
clc;

[filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp', ...
    'Image File (.jpg, .jpeg, .png, .bmp)'}, 'Select Image to be Segmented');

img = im2double(imread([pathname filename]));
if(length(img(:, 1, 1)) > 900 || length(img(1, :, 1)) > 900)
    img = imresize(img, [ceil(length(img(:, 1, 1))*0.6) ceil(length(img(1, :, 1))*0.6)], 'nearest');
end

global ImageHandle;
global color_pen ;
 color_pen  = [1 1 1]; 
 ImageHandle = img ;
 draw();
  pause ;
scribble_F = ImageHandle;
 color_pen  = [0 0 0];
 draw();
 pause;
scribble =ImageHandle;
scribbleMap = sum(abs(img - scribble), 3);
scribbleMap = (scribbleMap > 0);
%figure;imshow(scribbleMap);
FMap = rgb2gray(scribble).*scribbleMap;
%figure;
%imshow(FMap);

alpha = getAlpha(img, scribbleMap, FMap);

figure;imshow(alpha); title('Alpha Matte');

[F,B] = reconstructFB(img, alpha);
figure; imshow(F); title('Foreground');

global sourceImage;
sourceImage = F;
global sourceImageMask;
sourceImageMask = alpha;

%[filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp', ...
 %   'Image File (.jpg, .jpeg, .png, .bmp)'}, 'Select Background Image');
%BG = im2double(imread([pathname filename]));
%imshow(compose( BG ,F,alpha ));

mainGui();