function [ output ] = eff_landscape( filename )

%% Remove background
bg_color = imread('effect4_bg_color.png');
bg_color = imresize(bg_color, [500 500]);
a= figure;


%%  inpurt photos
% initial size = 500*500
[img, map, alpha]= imread(filename);
img= imresize(img, [500 500]);
alpha= imresize(alpha, [500 500]);
x=imshow(img, 'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;


%% input background & combine
backg = imread('bg_scene.png');
backg= imresize(backg, [500 500]);
hold on;
z= imshow(bg_color,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;
x= imshow(img,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;
y= imshow(backg,'border','tight','initialmagnification','fit');set(gcf,'Position',[0,0,500,500]);axis normal;


%% cut the outline & reduce the transparency
set(y, 'AlphaData', alpha*0.5);
set(x, 'AlphaData', alpha);

%% Save image
saveas(a,'result4.png');

%imwrite(a, 'effect4.png');
output = imread('result4', 'png');
figure(2);
output=imresize(output,[500 500]);
imshow(output);
end