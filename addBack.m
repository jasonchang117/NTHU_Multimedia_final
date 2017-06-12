function output = addBack(input, background)

    res = input .* background;
    color = repmat(res(:, :, 1)+res(:, :, 2)+res(:, :, 3), 1, 1, 3);
    output = res;
    output(color==0) = 1;
    % figure, imshow(output)
end

