function [ output ] = eff_landscape( filename, cycle )

%% Remove background
bg_color = imread('data_4/effect4_bg_color.png');
bg_color = imresize(bg_color, [500 500]);
a= figure;

%%  inpurt photos
% initial size = 500*500
[img, map, alpha]= imread(filename);
img= imresize(img, [500 500]);
alpha= imresize(alpha, [500 500]);
x=imshow(img, 'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;

%% Remove background
%{
global ImageHandle;
global color_pen;
color_pen = [1 1 1]; 
ImageHandle = im2double(img) ;
draw();
pause ;
scribble_F = ImageHandle;
color_pen = [0 0 0];
draw();
pause;
scribble = ImageHandle;
scribbleMap = sum(abs(im2double(img) - scribble), 3);
scribbleMap = (scribbleMap > 0);
FMap = rgb2gray(scribble).*scribbleMap;
alpha = getAlpha(im2double(img), scribbleMap, FMap);
%figure;imshow(alpha); title('Alpha Matte');

[F,B] = reconstructFB(im2double(img), alpha);
% figure; 
% imshow(F); 
% title('Foreground');

%}
%% input background & combine
backg = imread(strcat('data_4/bg_scene', num2str(cycle), '.png'));
backg= imresize(backg, [500 500]);
hold on;
z= imshow(bg_color,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;
x= imshow(img,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;
y= imshow(backg,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;


%% cut the outline & reduce the transparency
set(y, 'AlphaData', alpha*0.6);
set(x, 'AlphaData', alpha*0.9);

%% Save image
saveas(a,'result4.png');

%imwrite(a, 'effect4.png');
output = imread('result4', 'png');
%figure(2);
output=imresize(output,[500 500]);
%imshow(output);
end