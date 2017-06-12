function [ photo_bg ] = brush_effect( photo, bg )

photo = imguidedfilter(photo);
photo = imsharpen(photo);
gray = rgb2gray(photo);
[pho_w, pho_h] = size(gray);

photo_ink = binarize(gray, 175);
%photo_ink = gray;

[bg_w, bg_h, ~] = size(bg);

trans_w = floor(bg_w/2 - pho_w/2);
trans_h = floor(bg_h/2 - pho_h/2);

bg_R = bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 1);
bg_G = bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 2);
bg_B = bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 3);
A = photo_ink(:);
black = find(A == 0);
A(black) = bg_R(black);
photo_bg_R = reshape(A, pho_w, pho_h);
A(black) = bg_G(black);
photo_bg_G = reshape(A, pho_w, pho_h);
A(black) = bg_B(black);
photo_bg_B = reshape(A, pho_w, pho_h);
photo_bg = cat(3, photo_bg_R, photo_bg_G, photo_bg_B);

end

