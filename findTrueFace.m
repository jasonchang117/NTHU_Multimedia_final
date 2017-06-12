function [faceIdx] = findTrueFace(bBox)
    blockSz = bBox(:, 3);
    faceIdx = find(blockSz==max(blockSz));
    
end

