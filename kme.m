function outputImage = kme(inputMat)
X = inputMat;

[M, N, P] = size(X);
index = reshape(1:M*N*P, M*N, 3)';
data = double(X(index));
maxI = 1;

for i = 1:maxI
    centerNum = 2^i;
%     fprintf('i=%d/%d: no. of centers=%d\n', i, maxI, centerNum);
    [ind,minIndex] = kmeans(data', centerNum);
    X2 = reshape(ind, M, N);
    map = minIndex/255;
end

img_2 = map(X2, :);
img_2 = reshape(img_2, M, N, 3);
% figure; imshow(img_2);

img_q = rgb2gray(img_2);
outputImage = single(imbinarize(img_q, graythresh(img_q)));
% figure; imshow(outputImage);
% outputImage = imguidedfilter(outputImage, X, 'DegreeOfSmoothing', .000001);

