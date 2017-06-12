clear
close all
clc

%%  Tuning parameters
bi_param1_face = .4;
nose_ratio = .15;
bi_param2 = .4;
blacken_param = 0;

img = imresize(imread('photo.png'), 1);
[M, N, P] = size(img);
backg = imresize(im2single(imread('bg_galaxy.png')), 1);
backg = backg(1:M, 1:N, :);

fDetector = vision.CascadeObjectDetector();
nDetector = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
bBox_f = step(fDetector, img);
bBox_n = step(nDetector, img);

if isempty(bBox_f)
    faceCenter = [M N]/2;
    bBox_f = [faceCenter(2)-100 faceCenter(1)-100 200 200];
else
    faceIdx = findTrueFace(bBox_f);
    bBox_f = bBox_f(faceIdx, :);
    faceCenter = round(bBox_f([2 1]) + bBox_f([3 4])/2);
end

if isempty(bBox_n)
    noseCenter = faceCenter(1) + 10;
    bBox_n = [noseCenter-20 noseCenter-20 40 40];
else
    noseIdx = findTrueNose(bBox_n, faceCenter);
    bBox_n = bBox_n(noseIdx, :);
    noseCenter = round(bBox_n([2 1]) + bBox_n([3 4])/2);
end

%%  First binarization
img_guide1 = imguidedfilter(img);
img_g1 = rgb2gray(img_guide1);
img_g2 = rgb2gray(img);
% figure, imshow(img_guide1);
% figure, histogram(double(img_g1));

img_g1 = faceBlacken(img_g1, faceCenter, blacken_param);
face = img_g1(bBox_f(2):bBox_f(2)+bBox_f(3), bBox_f(1):bBox_f(1)+bBox_f(4));
nose = img_g1(bBox_n(2):bBox_n(2)+bBox_n(3), bBox_n(1):bBox_n(1)+bBox_n(4));

nose_sort = sort(nose(:));
bi_param1_nose = double(nose_sort( floor(bBox_n(3)*bBox_n(4) * nose_ratio ))) /256;

bi_param1_face = otsu(face);
% bi_param1_nose = graythresh(nose);
bi_param1_nose = bi_param1_face*.3 + bi_param1_nose*.7;
img_bi_nose = single(imbinarize(nose, bi_param1_nose));
% figure, imshow(img_bi_nose)

% figure, histogram(double(nose));
img_bi = single(imbinarize(img_g1, bi_param1_face));
img_bi(bBox_n(2):bBox_n(2)+bBox_n(3), bBox_n(1):bBox_n(1)+bBox_n(4)) = img_bi_nose;
% figure, imshow(img_g1);
% figure, imshow(img_bi)

%%  Second binarization
img_guide2 = imguidedfilter(img_bi, img_g2, 'DegreeOfSmoothing', .000001);
% figure, imshow(img_guide2);
img_guide2 = 1 - img_guide2;

img_rgb = single(imbinarize(img_guide2, bi_param2));
img_rgb = 1-repmat(img_rgb, 1, 1, 3);
% figure, imshow(img_rgb);

%%	k-means tryout
img_kme = repmat(kme(img_guide1), 1, 1, 3);
% figure, imshow(img_kme);

%%  Add background
% arg1: binary image with 3 dim.
res1 = addBack(1-img_rgb, backg);
res2 = addBack(1-img_kme, backg);
figure, imshow(res1);
figure, imshow(res2);

%%  Add Back Layer
% center is where the face is
% [res, layer] = addLayer(res1, faceCenter, .95, .8, .45);
% imshow(res);

