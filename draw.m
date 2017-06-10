function varargout = draw(varargin)
  global ImageHandle;
  global color_pen ;

  figureHandle=figure(1),imshow(ImageHandle);

       set(figureHandle, 'WindowButtonDownFcn', @MouseDown);
       set(figureHandle, 'WindowButtonMotionFcn', @MouseMove);
       set(figureHandle, 'WindowButtonUpFcn', @MouseUp);
       

end
function MouseMove(object, eventdata)
    global color_pen ;
    r = 10 ;
    global ButtonPressed;
    global ImageHandle;
    [h, w, ~] = size(ImageHandle);
    % Check if Mouse button is down.
    if ButtonPressed
        
        % Get current Mouse location.
        C = get(gca, 'CurrentPoint');
        t = linspace(0, 2*pi+1);
        x = C(1,1)+r*cos(t);
        y = C(1,2)+r*sin(t);
          axis equal
            hold on
%         scatter( x, y, 25, 'MarkerEdgeColor', color_pen, 'LineWidth',10 );    
        fill(x,y, color_pen);
        line(x,y ,'Color', color_pen, 'LineWidth',5 ); 
        
    [imgX,imgY] = meshgrid(1:h,1:w);
	imgXY = imgX;
	imgXY(:,:,2) = imgY;
	imgPixN = h*w;
	imgXYList = reshape(imgXY, [ imgPixN, 2 ]);
	isInShape = inpolygon( imgXYList(:,2), imgXYList(:,1), x, y) ;
        for pixI = 1 : imgPixN
            if isInShape(pixI)
			xCoord = imgXYList(pixI,2);
			yCoord = imgXYList(pixI,1);
            disp([yCoord xCoord]);
          	ImageHandle( yCoord, xCoord, : ) = color_pen;
            end
        end
        isInShape =[] ;
    end
end   
        
    

% Move button down callback function.
function MouseDown(object, eventdata)

     global ButtonPressed;
    
    % Reflect current Mouse button state in gble.
   ButtonPressed = true;

end
% Move button up callback function.
function MouseUp(object, eventdata)
    global figureHandle ;
    global ButtonPressed;
    
    % Reflect current Mouse button state in global variable.
   ButtonPressed = false;

end