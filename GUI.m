function varargout = GUI(varargin)
clc;
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 13-Jun-2017 02:27:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in ch_image.
function ch_image_Callback(hObject, eventdata, handles)
% hObject    handle to ch_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
set(handles.output, 'HandleVisibility', 'off');
close all;

global input_img;
global cycle;
cycle = 0;
[input_img, user_canceled] = imgetfile;
handles.f = figure;
imshow(imresize(imread(input_img), [500 500]));
% side_front_portrait(front_image, side_image);


% --- Executes on button press in effect_1.
function effect_1_Callback(hObject, eventdata, handles)     % Galaxy
% hObject    handle to effect_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input_img;
global return_img;
set(handles.output, 'HandleVisibility', 'off');
close all;
[return_img] = eff_galaxy(input_img);
imshow(return_img);


% --- Executes on button press in effect_2.
function effect_2_Callback(hObject, eventdata, handles)     % Threshold 
% hObject    handle to effect_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input_img;
global return_img;
global cycle;
set(handles.output, 'HandleVisibility', 'off');
close all;
[back_img, user_canceled] = imgetfile;
[return_img] = eff_brush(input_img, back_img, mod(cycle, 3)+1);
cycle = cycle + 1;
imshow(return_img);

% --- Executes on button press in effect_3.
function effect_3_Callback(hObject, eventdata, handles)     % Ink Splash
% hObject    handle to effect_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input_img;
global return_img;
global cycle;
set(handles.output, 'HandleVisibility', 'off');
close all;
[return_img] = eff_ink(input_img, mod(cycle, 3)+1);
cycle = cycle + 1;
imshow(return_img);

% --- Executes on button press in effect_4.
function effect_4_Callback(hObject, eventdata, handles)     % Landscape
% hObject    handle to effect_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input_img;
global return_img;
global cycle;
set(handles.output, 'HandleVisibility', 'off');
close all;
[return_img] = eff_landscape(input_img, mod(cycle, 16) );
cycle = cycle + 1;
imshow(return_img);

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global input_img;
global return_img;
bar_value = get(hObject, 'Value');
hsv_image = rgb2hsv(return_img);
hue = hsv_image(:, :, 1);
hsv_image(:, :, 1) = mod(hue + bar_value*360, 360)/360;

% imshow(hsv2rgb(hsv_image), 'parent', handles.axes2);
imshow(hsv2rgb(hsv_image));hold on;


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
