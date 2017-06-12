function [ photo_ink ] = binarize( photo_gray, threshold, dark, light )

[pho_w, pho_h] = size(photo_gray);
A = photo_gray(:);
black = find(A < threshold);
white = find(A >= threshold);
A(black) = dark;
A(white) = light;
photo_ink = reshape(A, pho_w, pho_h);
%figure(3);imshow(gray)

end

