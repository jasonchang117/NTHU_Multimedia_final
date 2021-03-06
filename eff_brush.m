function [ brush_out ] = eff_brush(img_foreground, img_background, pattern_idx)
%% read and resize the photoes
maxSize = 512;

[img_foreground, color, alpha] = imread(img_foreground, 'png');
[img_background, color, alpha] = imread(img_background, 'png');
photo = im2single(img_foreground);
photo_bg = im2single(img_background);

a = size(photo, 1); 
b = size(photo, 2);
max = a;
if a >= b
    max = a;
else
    max = b;
end
r = maxSize / max;

photo = imresize(photo, r);
photo_bg = imresize(photo_bg, r);

%% read and resize the brush and pattern

gradient_file = {'data_2/purple.png'};
color_bg = im2single(imread(gradient_file{1}));
color_bg = imresize(color_bg, 0.3);
if size(photo_bg, 1)-size(color_bg, 1) > 0 && size(photo_bg, 2)-size(color_bg, 2) > 0
    color_bg = padarray(color_bg, [size(photo_bg, 1)-size(color_bg, 1), size(photo_bg, 2)-size(color_bg, 2)], 'symmetric');
end

pattern_file = {'data_2/brush_4.png', 'data_2/brush_3.png', 'data_2/brush_1.jpg', 'data_2/Free-Floral-Vector-Brush-Pack.jpg'};
pattern = im2single(imread(pattern_file{pattern_idx}));
pattern = imresize(pattern, 1);
if size(photo_bg, 1)-size(color_bg, 1) > 0 && size(photo_bg, 2)-size(color_bg, 2) > 0
    pattern = padarray(pattern, [size(photo_bg, 1)-size(pattern, 1), size(photo_bg, 2)-size(pattern, 2)], 'symmetric');
end

%% apply effect
brush_out = brush_effect( photo, photo_bg, color_bg, pattern );

%figure(1);imshow(brush_out)