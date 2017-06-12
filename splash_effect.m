function [ output ] = splash_effect( photo, splash, threshold, move )

photo = imguidedfilter(photo);
photo = imsharpen(photo);
gray = rgb2gray(photo);

[spl_w, spl_h] = size(splash);
[pho_w, pho_h] = size(gray);

photo_ink = binarize( gray, threshold, 0, 255 );

trans_w = floor(spl_w/2 - pho_w/2) + move(1);
trans_h = floor(spl_h/2 - pho_h/2) + move(2);

if trans_w <= 0, trans_w = 1; end
if trans_h <= 0, trans_h = 1; end
if trans_w+pho_w-1 >= spl_w, trans_w = spl_w-pho_w+1; end
if trans_h+pho_h-1 >= spl_h, trans_h = spl_h-pho_h+1; end
sub = splash(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1);
%figure(10);imshow(sub)

for i = 1 : pho_w
    for j = 1 : pho_h
        if photo_ink(i, j) >= 255
            splash(trans_w+i-1, trans_h+j-1) = photo_ink(i, j);
        else
            splash(trans_w+i-1, trans_h+j-1) = sub(i, j);
        end
    end
end

sub = splash(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1);
%figure(11);imshow(sub);

output = splash;

end

