function [ output ] = splash_effect( photo, splash, threshold, idx )

photo = imguidedfilter(photo);
photo = imsharpen(photo);
gray = rgb2gray(photo);

[spl_w, spl_h] = size(splash);
[pho_w, pho_h] = size(gray);

photo_ink = binarize( gray, threshold );

move = [0 0; 20 150; 10 40; -40 40];
trans_w = floor(spl_w/2 - pho_w/2) + move(idx, 1);
trans_h = floor(spl_h/2 - pho_h/2) + move(idx, 2);

sub = splash(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1);
for i = 1 : pho_w
    for j = 1 : pho_h
        if gray(i, j) >= 250
            splash(trans_w+i-1, trans_h+j-1) = sub(i, j);
        else
            if splash(i, j) >= 5
                splash(trans_w+i-1, trans_h+j-1) = sub(i, j) + photo_ink(i, j);
            else
                splash(trans_w+i-1, trans_h+j-1) = photo_ink(i, j);
            end
        end
    end
end

output = splash;

end

