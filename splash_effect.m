function [ out ] = splash_effect( photo, splash, move )
%% initialize
[spl_w, spl_h] = size(splash);
[pho_w, pho_h, ~] = size(photo);
trans_w = floor(spl_w/2 - pho_w/2) + move(1);
trans_h = floor(spl_h/2 - pho_h/2) + move(2);

if trans_w <= 0, trans_w = 1; end
if trans_h <= 0, trans_h = 1; end
if trans_w+pho_w-1 >= spl_w, trans_w = spl_w-pho_w+1; end
if trans_h+pho_h-1 >= spl_h, trans_h = spl_h-pho_h+1; end
sub = splash(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1);

%% eliminate the edge and noise, and do binarization
photo = imguidedfilter(photo);
photo = imsharpen(photo);
photo = rgb2gray(photo);

%% do binarization
photo_ink = binarize_splash(photo);
%figure(10);imshow(photo_ink)

%% filter 
for i = 1 : pho_w
    for j = 1 : pho_h
        if photo_ink(i, j) >= 255
            splash(trans_w+i-1, trans_h+j-1) = photo_ink(i, j);
        else
            splash(trans_w+i-1, trans_h+j-1) = sub(i, j);
        end
    end
end
out = splash;
end

function [ photo_ink ] = binarize_splash( photo )

threshold = 120;
[pho_w, pho_h] = size(photo);
A = photo(:);
black = find(A < threshold);
white = find(A >= threshold);
A(black) = 0;
A(white) = 255;
photo_ink = reshape(A, pho_w, pho_h);
end
