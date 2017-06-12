function [ output_args ] = compose(x, y, bgImage ,FImage,alpha )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%imshow(bgImage);
%[x , y] = ginput(1);
%x = round(x);y =round(y);
%disp([x y]);

for t = 1:3
    
    bgImage(y:y+size(FImage,1)-1,x:x+size(FImage,2)-1,t) = FImage(:,:,t).*alpha + bgImage(y:y+size(FImage,1)-1,x:x+size(FImage,2)-1,t).*(1-alpha);
  
end


output_args = bgImage ; 

end

