function [ F, B ] = reconstructFB( img, alpha )

for t = 1:3
    F(:,:,t) = img(:,:,t).*alpha;
    B(:,:,t) = img(:,:,t).*(1-alpha);
end