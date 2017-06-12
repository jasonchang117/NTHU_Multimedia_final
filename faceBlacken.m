function output = faceBlacken(input, faceCenter, intensity)
    [H, W] = size(input);
    distance = sqrt(faceCenter(1)^2 + faceCenter(2)^2);
    output = uint8(zeros(size(input)));

    for i = 1:H
        for j = 1:W
            y_dis = abs( i - faceCenter(1));
            x_dis = abs( j - faceCenter(2));
            output(i,j) = input(i,j)*(1-intensity) + ...
                 sqrt( x_dis^2+y_dis^2 ) / distance*intensity * input(i,j);
        end
    end
end