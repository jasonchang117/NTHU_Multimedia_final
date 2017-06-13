function [ photo_ink ] = binarize( photo_gray, threshold, dark, light )

[pho_w, pho_h] = size(photo_gray);
A = photo_gray(:);
black = find(A < threshold);
white = find(A >= threshold);
A(black) = dark;
A(white) = light;
photo_ink = reshape(A, pho_w, pho_h);
%figure(3);imshow(gray)

[idx, C]= kmeans(photo_gray(:), 2, 'MaxIter', 100);
black = find(abs(A - C(1)) <= abs(A - C(2)));
white = find(abs(A - C(1)) > abs(A - C(2)));
A(black) = dark;
A(white) = light;
photo_ink = reshape(A, pho_w, pho_h);
%idx, black
end

