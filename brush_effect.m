function [ out ] = brush_effect( photo, photo_bg, color_bg, pattern )
%% initialize
[pho_w, pho_h, ~] = size(photo);
[bg_w, bg_h, ~] = size(color_bg);

trans_w = floor(bg_w/2 - pho_w/2);
trans_h = floor(bg_h/2 - pho_h/2);
if trans_w <= 0, trans_w = 1; end
if trans_h <= 0, trans_h = 1; end
if trans_w+pho_w-1 >= bg_w, trans_w = bg_w-pho_w+1; end
if trans_h+pho_h-1 >= bg_h, trans_h = bg_h-pho_h+1; end

%% eliminate the edge and noise, and do binarization
photo = imguidedfilter(photo);
photo = imsharpen(photo);
photo = rgb2gray(photo);
photo_ink = binarize(photo, 0.6, 0, 1);

%% change the pattern to gray scale image, and do padding
pattern = rgb2gray(pattern);
if pho_w-size(pattern,1) > 0 &&  pho_h--size(pattern,2) > 0
    pattern = padarray(pattern, [pho_w-size(pattern,1), pho_h--size(pattern,2)], 'symmetric');
end

%% add pattern to the background
%photo_bg = rgb2gray(photo_bg);
photo_bg_mix = addPattern(photo_bg, pattern);

%% fetch color
bg_R = color_bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 1);
bg_G = color_bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 2);
bg_B = color_bg(trans_w:trans_w+pho_w-1, trans_h:trans_h+pho_h-1, 3);

%% filter
A = photo_ink(:);
black = find(A == 0);
A(black) = bg_R(black);
out_R = reshape(A, pho_w, pho_h);
A(black) = bg_G(black);
out_G = reshape(A, pho_w, pho_h);
A(black) = bg_B(black);
out_B = reshape(A, pho_w, pho_h);
out_fore = cat(3, out_R, out_G, out_B);

%% make the color of background be gradient
X = ones(pho_w, pho_h);
X = X(:);
BG = 1 * photo_bg_mix(:);
r = bg_R(:);
g = bg_G(:);
b = bg_B(:);
B_R = BG .* r;
B_G = BG .* g;
B_B = BG .* b;
out_R = reshape(B_R, pho_w, pho_h);
out_G = reshape(B_G, pho_w, pho_h);
out_B = reshape(B_B, pho_w, pho_h);
out = cat(3, out_R, out_G, out_B);

%% merge foreground and background
out = merge(out_fore, photo_bg, out);
end

%% add pattern
function [ bg ] = addPattern( photo_bg, pattern )

[pho_w, pho_h] = size(photo_bg);
bg = zeros(pho_w, pho_h);
out = ones(pho_w, pho_h);
for i = 1 : pho_w
    for j = 1 : pho_h
        if photo_bg(i, j) <= 0.2
            bg(i, j) = 1 - pattern(i, j);
        end
    end
end
end

%% merge foreground and background
function [ out ] = merge(photo_fg, photo_bg, photo_bg_mix)

[pho_w, pho_h, ~] = size(photo_fg);
photo_bg = ones(pho_w, pho_h) - photo_bg;
for i = 1 : pho_w
    for j = 1 : pho_h
        % background
        if photo_bg(i, j) >= 0.8
            out(i, j, 1) = photo_bg_mix(i, j, 1);
            out(i, j, 2) = photo_bg_mix(i, j, 2);
            out(i, j, 3) = photo_bg_mix(i, j, 3);
            
            % if background is still black
            if out(i, j, 1) < 0.05 && out(i, j, 2) < 0.05 && out(i, j, 3) < 0.05
                out(i, j, 1) = 1;
                out(i, j, 2) = 1;
                out(i, j, 3) = 1;
            end
        % foreground
        else
            out(i, j, 1) = photo_fg(i, j, 1);
            out(i, j, 2) = photo_fg(i, j, 2);
            out(i, j, 3) = photo_fg(i, j, 3);
        end
    end
end
end
