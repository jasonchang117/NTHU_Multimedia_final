function output = otsu(img)
    input_size = size(img); 
    figure,
    his_img = histogram(img,256);
    his_img = his_img.Values/ ( input_size(1) * input_size(2) );
    mg = 0;

    for i = 1:256
        mg = mg + (i-1)*his_img(1,i);
    end

    p1 = zeros(1,256);
    p1(1,1) = his_img(1,1);
    m1 = zeros(1,256);
    m1(1,1) = 0 ;

    for i = 2:256
        p1(1,i) = p1(1,i-1) + his_img(1,i);
        m1(1,i) = ( p1(1,i-1)*m1(1,i-1) + (i-1)*his_img(1,i) ) / p1(1,i);  
    end

    theta = zeros(1,255);
    for i = 1:255
        theta(1,i) = p1(1,i)/(1 - p1(1,i)) *(m1(1,i)-mg)^2;
    end

    [~, argmax] = max(theta);
    output =double(argmax-min(min(img))) / 255;
end
