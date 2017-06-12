function L = getLaplacian( img, scribbleMap )

epsilon = 0.0000001;

[h,w,c] = size(img);

imgIndex = 1:h*w;
imgIndex = reshape(imgIndex,h,w);
winRange = 1;
indexToBeChecked = find(1-scribbleMap);
indexToBeChecked = indexToBeChecked(:);

rowIndex = zeros(1);
colIndex = zeros(1);
value = zeros(1);

len = 0;

[I, J] = ind2sub([h,w], 1:h*w);

%length(indexToBeChecked)

for k = 1:length(indexToBeChecked)
    
    index = indexToBeChecked(k);
    i = I(index);
    j = J(index);
    minX = iff((i-winRange < 1), 1, i-winRange);
    maxX = iff((i+winRange > h), h, i+winRange);
    minY = iff((j-winRange < 1), 1, j-winRange);
    maxY = iff((j+winRange > w), w, j+winRange);
    
    winIndex = imgIndex(minX:maxX, minY:maxY);
    winIndex = winIndex(:);
    winSize = size(winIndex, 1);
    winImg = img(minX:maxX, minY:maxY, :);
    winImg = reshape(winImg, winSize, c);
    winMean = mean(winImg, 1);
    winCovar = (winImg'*winImg / winSize) - winMean'*winMean;
    winVar = winImg - repmat(winMean, winSize, 1);
    winInv = winCovar+epsilon/winSize*eye(3);
    winVal = winSize \ (1+winVar/winInv*winVar');
    
    winIndex = repmat(winIndex, 1, winSize);
    tail = len+winSize*winSize;
    rowIndex(1+len:tail) = winIndex(:);
    winIndex = winIndex';
    colIndex(1+len:tail) = winIndex(:);
    value(1+len:tail) = winVal;
    len = tail;
    
end

%[rowIndex(:) colIndex(:) value(:)]
W = sparse(rowIndex(1:len), colIndex(1:len), value(1:len), h*w, h*w);
sumW = sum(W,2);
D = spdiags(sumW(:), 0, h*w, h*w);

L = D - W;