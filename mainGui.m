function varargout = mainGui(varargin)
% MAINGUI MATLAB code for mainGui.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGui

% Last Modified by GUIDE v2.5 21-Jan-2012 22:02:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGui_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainGui is made visible.
function mainGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGui (see VARARGIN)

% Clear console.
clc;

% Define global variable for mouse state.
global mouseButtonPressed;
mouseButtonPressed = false;

% Define global variable for source image.
global sourceImage;
%sourceImage = NaN;

% Define global variable for source image handle.
global sourceImageHandle;
sourceImageHandle = NaN;

% Define global variable for source image mask.
global sourceImageMask;
%map = (sum(sourceImage, 3) > 0.1);
%sourceImageMask = map.*ones(size(map));


% Define global variable for target image.
global targetImage;
targetImage = NaN;

% Choose default command line output for mainGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = mainGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImageButton.
function loadImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sourceImage;
global sourceImageHandle;
global sourceImageMask;
global targetImage;

% Display file picker to select image.
[fileName, pathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'; '*.*','All Files' },'Pick an Image');

% Load and display selected image.
if fileName ~= 0
    
    % Load selected image.
    image = im2double(imread([pathName fileName]));
    
    % Create and configure new figure graphics object.
    figureHandle = figure;
	set(figureHandle, 'Interruptible', 'on');
	set(figureHandle, 'BusyAction',    'queue'); %  Enable action queue (do not drop actions).
	set(figureHandle, 'Renderer',      'opengl'); % Use openGL as renderer if available.
	set(figureHandle, 'DoubleBuffer',  'on'); % Speed up rendering, prevent 'blinking' image.
	set(figureHandle, 'Menubar',       'none'); % Disable menu bar.
    set(figureHandle, 'NumberTitle',   'off'); % Do not display figure number in title.
    
    % Display selected image.
    imshow(image);
end

if isnan(sourceImage)
    % No image was loaded yet, so this is the source image.
    
    % Set title of figure.
    set(figureHandle, 'Name', 'Source Image');
    
    % Start in marker mode if no source image patch was selected yet.
    h = imfreehand();
    %h = imrect();
    
    % Store selection mask.
    sourceImageMask = h.createMask();
    
    % Store selected image patch in global variable.
    [sourceImage, sourceImageMask] = cropImage(h.getPosition(), image, sourceImageMask);
    
else
    % Source image patch was already selected.
    % Display source image on top of target image.
    
    % Set title of figure.
    set(figureHandle, 'Name', 'Target Image');
    
    % Store target image in global variable.
    targetImage = image;
    
    hold on;
    
    % Remove parts for the cropped source image that were not selected.
    %[r, g, b] = decomposeRGB(sourceImage);
    %r(~sourceImageMask) = NaN;
    %g(~sourceImageMask) = NaN;
    %b(~sourceImageMask) = NaN;
    %sourceImageWithoutBackground = composeRGB(r, g, b);
    
    % Display source image.
    sourceImageHandle = imshow(sourceImage);
    
    hold off;
    
    % Make unselected portion of selected source image transparent.
    set(sourceImageHandle, 'AlphaData', sourceImageMask);
    
    % Request mouse move events for this image window that now
    % contains both images.
    set(figureHandle, 'WindowButtonDownFcn', @mouseDown);
    set(figureHandle, 'WindowButtonMotionFcn', @mouseMove);
    set(figureHandle, 'WindowButtonUpFcn', @mouseUp);
end


% --- Executes on button press in renderImageButton.
function renderImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to renderImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sourceImage;
global sourceImageMask;
global sourceImageHandle;
global targetImage;

% Get position of souce image in target image.
x = uint16(get(sourceImageHandle,'XData'));
y = uint16(get(sourceImageHandle,'YData'));

resultImg = compose(x, y, targetImage, sourceImage, sourceImageMask);
figure; imshow(resultImg); title('Rendering Result');
imwrite(resultImg, 'compositeImg.png');
%result1 = poissonSolverSlow(sourceImage, targetImage, sourceImageMask, sourceImagePosition);
%result2 = poissonSolverFast(sourceImage, targetImage, sourceImageMask, sourceImagePosition);

%figure; imshow(result1); title('Full Space Solution');
%figure; imshow(result2); title('Reduced Space Solution');

% Calculate error between full result and approximation.
%K = imabsdiff(result1, result2);
%disp(['Mean absolute per-pixel error in source image patch: ' num2str(mean2(abs(K))/(nnz(sourceImageMask))) '/255 gray level values']);
%disp(['Max. approximation error: ' num2str(max(K(:))) '/255 gray level values']);

% Move move callback function.
function mouseMove(object, eventdata)

    global mouseButtonPressed;
    global sourceImageHandle;

    % Check if mouse button is down.
    if mouseButtonPressed
        
        % Get current mouse location.
        C = get(gca, 'CurrentPoint');
        
        % Move overlayed source image to new position.
        set(sourceImageHandle, 'XData', C(1,1));
        set(sourceImageHandle, 'YData', C(1,2));
    
        % Redraw scene immediately.
        drawnow; 
    end


% Move button down callback function.
function mouseDown(object, eventdata)

    global mouseButtonPressed;
    
    % Reflect current mouse button state in global variable.
    mouseButtonPressed = true;


% Move button up callback function.
function mouseUp(object, eventdata)

    global mouseButtonPressed;
    
    % Reflect current mouse button state in global variable.
    mouseButtonPressed = false;


function  [croppedImage, croppedMask] = cropImage(positions, image, mask)

    xValues = positions(:,1);
    yValues = positions(:,2);

    minX = min(xValues);
    maxX = max(xValues);

    minY = min(yValues);
    maxY = max(yValues);

    croppedMask = imcrop(mask, [minX - 1, minY - 1, maxX - minX + 2, maxY - minY + 2]);
    croppedImage = imcrop(image, [minX - 1, minY - 1, maxX - minX + 2, maxY - minY + 2]);


function  [r, g, b] = decomposeRGB(image)

    r = image(:, :, 1);
    g = image(:, :, 2);
    b = image(:, :, 3);


function  [image] = composeRGB(r, g, b)

    image(:, :, 1) = r;
    image(:, :, 2) = g;
    image(:, :, 3) = b;