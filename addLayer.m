function [output, layer] = addLayer(input, center, upperthres, lowerthres, brightArea)
    [M, N, P] = size(input);
    sigma = 100;

    xaxis = repmat((1:M)', 1, N);
    yaxis = repmat((1:N),  M, 1);
    x = (xaxis - center(1)).^2;
    y = (yaxis - center(2)).^2;

    dis = sqrt(x+y);
    dis = 1 - (dis ./ max(dis(:))) + brightArea;

    dis(dis > upperthres) = upperthres;
    dis(dis < lowerthres) = lowerthres;
    
    % Smooth the layer
    layer = single(repmat(imgaussfilt(dis, sigma), 1, 1, 3));
    
    output = input;
    output(input==1) = layer(input==1);
end