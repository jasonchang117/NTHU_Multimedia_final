function [ photo_ink ] = binarize( photo_gray, dark, light )

%A = photo_gray(:);
%black = find(A < threshold);
%white = find(A >= threshold);
%A(black) = dark;
%A(white) = light;
%photo_ink = reshape(A, pho_w, pho_h);
%figure(3);imshow(gray)

[pho_w, pho_h] = size(photo_gray);
[idx, C]= kmeans(photo_gray(:), 2, 'MaxIter', 10);
A = photo_gray(:);
if C(1) > C(2), tmp = C(2); C(2) = C(1); C(1) = tmp; end
black = find(abs(A - C(1)) <= abs(A - C(2) - 0.3));
white = find(abs(A - C(1)) > abs(A - C(2) - 0.3));
A(black) = dark;
A(white) = light;
photo_ink = reshape(A, pho_w, pho_h);
%C
end

