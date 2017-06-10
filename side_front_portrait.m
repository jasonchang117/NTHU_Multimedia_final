function [output_image] = side_front_portrait(front, side)

front = im2double(imread(front));
side = im2double(imread(side));

if(length(side(:, 1, 1)) > 900 || length(side(1, :, 1)) > 900)
    side = imresize(side, [ceil(length(side(:, 1, 1))*0.6) ceil(length(side(1, :, 1))*0.6)], 'nearest');
end

global ImageHandle;
global color_pen;
color_pen = [1 1 1]; 
ImageHandle = side ;
draw();
pause ;
scribble_F = ImageHandle;
color_pen  = [0 0 0];
draw();
pause;
scribble =ImageHandle;
scribbleMap = sum(abs(side - scribble), 3);
scribbleMap = (scribbleMap > 0);
FMap = rgb2gray(scribble).*scribbleMap;
alpha = getAlpha(side, scribbleMap, FMap);
figure;imshow(alpha); title('Alpha Matte');

[F,B] = reconstructFB(side, alpha);
figure; imshow(F); title('Foreground');

%%

%{
front_gray = rgb2gray(front);
side_gray = rgb2gray(side);

kernel = dlmread('nose_kernel.txt');

imshow(side);
[x, y] = ginput(4);
left_bound = floor(min(x))
right_bound = ceil(max(x))
up_bound = floor(min(y))
down_bound = ceil(max(y))


% full search (similar to motion estimation)
h = length(kernel(:, 1));
w = length(kernel(1, :));
mean_error = 1000000000;
target_i = 1;
target_j = 1;

for i = up_bound:down_bound-h
    for j = left_bound:right_bound-w
        temp = kernel-side_gray(i:i+h-1, j:j+w-1);
        disp(sqrt(sum(sum(abs(temp)))))
        if( sqrt(sum(sum(abs(temp)))) < mean_error)
            mean_error = sum(sum(abs(temp)));
            target_i = i;
            target_j = j;
        end
    end
end

target_i
target_j
imshow(side_gray(target_i:target_i+h-1, target_j:target_j+w-1));
%}
