function [ rbImage ] = drawscribble( rbImage , color_pen )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[h, w, ~] = size(rbImage);
figure(1),imshow(rbImage);
scatter = [];
flag = 5;
  while(flag)
        flag = flag -1 ;
    
    [input_x,input_y] = ginput(2);
    input =[input_x input_y];     
     k =-(input_x(2)-input_x(1))/(input_y(2)-input_y(1)) ;
     if abs(k) > 1 
      input =[input(1,:);input(1,1)+10 input(1,2)+10;input(2,1)+10 input(2,2)+10;input(2,:)];   
     else
     input =[input(1,:);input(1,1)+10 input(1,2)+10*k;input(2,1)+10 input(2,2)+10*k;input(2,:)];
     end
    line(input_x,input_y ,'Color', color_pen, 'LineWidth',5 ); 
    [imgX,imgY] = meshgrid(1:h,1:w);
	imgXY = imgX;
	imgXY(:,:,2) = imgY;
	imgPixN = h*w;
	imgXYList = reshape(imgXY, [ imgPixN, 2 ]);
	isInShape = inpolygon( imgXYList(:,1), imgXYList(:,2), input(:,1), input(:,2) );
        for pixI = 1 : imgPixN
            if isInShape(pixI)
			xCoord = imgXYList(pixI,1);
			yCoord = imgXYList(pixI,2);
          	rbImage( yCoord, xCoord, : ) = color_pen;
            end
        end
        isInShape =[] ;
     
 end

  figure(2),imshow(rbImage);

end

