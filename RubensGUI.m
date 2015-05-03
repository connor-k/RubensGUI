function varargout = RubensGUI(varargin)
% RUBENSGUI MATLAB code for RubensGUI.fig
%      RUBENSGUI, by itself, creates a new RUBENSGUI or raises the existing
%      singleton*.
%
%      H = RUBENSGUI returns the handle to a new RUBENSGUI or the handle to
%      the existing singleton*.
%
%      RUBENSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUBENSGUI.M with the given input arguments.
%
%      RUBENSGUI('Property','Value',...) creates a new RUBENSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RubensGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RubensGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RubensGUI

% Last Modified by GUIDE v2.5 03-May-2015 12:40:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RubensGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RubensGUI_OutputFcn, ...
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


% --- Executes just before RubensGUI is made visible.
function RubensGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RubensGUI (see VARARGIN)

% Choose default command line output for RubensGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Create vector to hold x/y coords of clicks
global polyPoints;
polyPoints = [0 1; 0 0];

% Allow us to update the axis plot as the user adds points
set(handles.drawPolyAxis, 'NextPlot', 'replacechildren');

% Temporarily add the FourierSeries library to the path
addpath(genpath(strcat(pwd, '/FourierSeries/')))


% --- Outputs from this function are returned to the command line.
function varargout = RubensGUI_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculateSoundsButton, calculates the
% standing wave for the sound.
function calculateSoundsButton_Callback(~, ~, handles)
% hObject    handle to calculateSoundsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global polyPoints;
global soundOut;
x = polyPoints(1, :);
y = polyPoints(2, :);
% Use FSERIES to fit, use the first 10 sin|cos terms
[a, b, yfit] = Fseries(x, y, 10, false);
% Also evaluate on a finer grid to show a fit line
xfine = linspace(0, 1)';
yfine = Fseriesval(a, b, xfine);
% Plot the original points (x), corresponding fitted points (o), and fit
% curve (xfine and yfine)
plot(handles.drawPolyAxis, x, y, 'x', x, yfit, 'o', xfine, yfine)
% Prepare the sound to produce this standing wave
% Sample at 44100 Hz
fs = 44100;
% The sound will play for 5 seconds
t = 0:1/fs:5;
% The fundamental frequency (in Hz) calculated for our 5ft pipe
f0 = 111.54;
soundOut = a(1).*cos(2.*pi.*f0.*t) + b(1).*sin(2.*pi.*f0.*t);
for k = 2:length(b)
    soundOut = soundOut + a(k).*cos(2.*pi.*(f0*k).*t) + b(k).*sin(2.*pi.*(f0*k).*t);
end

% --- Executes on button press in playButton, plays generated sound.
function playButton_Callback(~, ~, ~)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global soundOut;
% Sample at 44100 Hz
fs = 44100;
sound(soundOut, fs, 16);


% --- Executes on mouse press over axes background, adds point at location.
function drawPolyAxis_ButtonDownFcn(~, ~, handles)
% hObject    handle to drawPolyAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
coord = get(handles.drawPolyAxis, 'currentpoint');
x=coord(1,1,1);
y=coord(1,2,1);
addPoint(handles.drawPolyAxis, x, y);


% --- Adds a point to polyPoints
function addPoint(axis, x, y)
global polyPoints;
% Insert new point into sorted location
index = 1;
for i = 1:length(polyPoints)
    if (x < polyPoints(1, i))
        break
    end
    index = index + 1;
end
polyPoints = [polyPoints(:, 1:index - 1) [x; y] polyPoints(:, index:end)];
plot(axis, polyPoints(1,:), polyPoints(2,:));


% --- Executes on button press in resetPointsButton, clears polynomial.
function resetPointsButton_Callback(~, ~, handles)
% hObject    handle to resetPointsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global polyPoints;
polyPoints = [0 1; 0 0];
plot(handles.drawPolyAxis, polyPoints(1,:), polyPoints(2,:));


% --- Close the GUI
function closeMenuItem_Callback(~, ~, ~)
% hObject    handle to closeMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in sineSweepButton, plays a sine sweep
function sineSweepButton_Callback(~, ~, ~)
% hObject    handle to sineSweepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Sample at 44100 Hz
fs = 44100;
% Play each step for 1 second
t = 0:1/fs:1;
% Starting frequency (in Hz)
baseFrequency = 50;
for i = 1:30
    soundOut = sin(2.*pi.*(baseFrequency*i).*t);
    sound(soundOut, fs, 16);
    pause(1);
end

% --------------------------------------------------------------------
