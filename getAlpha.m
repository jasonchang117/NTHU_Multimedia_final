function alpha = getAlpha( img, scribbleMap, FMap )

[h,w,~] = size(img);
lambda = 100;

L = getLaplacian(img,scribbleMap);
D = spdiags(scribbleMap(:),0,h*w,h*w);

alpha = (L+lambda*D) \ (FMap(:)*lambda);

alpha=max(min(reshape(alpha,h,w),1),0);