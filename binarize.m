function [ photo_ink ] = binarize( photo_gray, threshold )

[pho_w, pho_h] = size(photo_gray);
A = photo_gray(:);
black = find(A < threshold);
white = find(A >= threshold);
A(black) = 0;
A(white) = 255;
photo_ink = reshape(A, pho_w, pho_h);
%figure(3);imshow(gray)

end

