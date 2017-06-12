function [ splash_out ] = eff_ink(img_foreground, idx)

file = {'data_3/paint-splatter-2.png', 'data_3/paint-splatter-7.png', 'data_3/paint-splatter-8.png', 'data_3/paint-splatter-13.png'};

[splash, color, alpha] = imread(file{idx}, 'png');
splash = imresize(splash, [456 825]);
splash = rgb2gray(splash);

photo = imread(img_foreground);

p = size(photo, 1) / 1218;
photo_splash = [0.35/p 0.282/p 0.32/p 0.35/p];

photo = imresize(photo, photo_splash(idx));
if size(photo, 1) >= 456 || size(photo, 2) >= 825
    photo = imresize(photo, [456 825]);
end
move = [0 0; 20 150; 10 40; -40 40];

splash_out = splash_effect(photo, splash, 150, move(idx,:));

%figure(1);imshow(splash_out)
%figure(2);imshow(splash)
%[456 825]
end
