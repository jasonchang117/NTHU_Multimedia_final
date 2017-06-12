function [noseIdx] = findTrueNose(bBox, faceCenter)
    noseCenters = bBox(:, [2 1]) + bBox(:, 3:4)/2;
    y = (noseCenters(:, 1) - faceCenter(1)).^2;
    x = (noseCenters(:, 2) - faceCenter(2)).^2;
    dis = sqrt(x+y);
    
    noseIdx = find(dis==min(dis));
end

