function varargout = plotEDATrial(varargin)

% PLOTEDATRIAL MATLAB code for plotEDATrial.fig
%      PLOTEDATRIAL, by itself, creates a new PLOTEDATRIAL or raises the existing
%      singleton*.

%
%      H = PLOTEDATRIAL returns the handle to a new PLOTEDATRIAL or the handle to
%      the existing singleton*.
%
%      PLOTEDATRIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTEDATRIAL.M with the given input arguments.
%
%      PLOTEDATRIAL('Property','Value',...) creates a new PLOTEDATRIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotEDATrial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotEDATrial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotEDATrial

% Last Modified by GUIDE v2.5 08-Apr-2021 13:51:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plotEDATrial_OpeningFcn, ...
    'gui_OutputFcn',  @plotEDATrial_OutputFcn, ...
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

%% 06.2021 added key bindings and automatic calculation option

%% 16.09.2021 rectangles are interactive. Mouse click selects respective EDA in listbox

% --- Executes just before plotEDATrial is made visible.
function plotEDATrial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotEDATrial (see VARARGIN)

% Choose default command line output for plotEDATrial
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotEDATrial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotEDATrial_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in trialMinus.
function trialMinus_Callback(hObject, eventdata, handles)
% hObject    handle to trialMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prevNextTrial (-1);

% --- Executes on button press in trialPlus.
function trialPlus_Callback(hObject, eventdata, handles)
% hObject    handle to trialPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prevNextTrial (1);



% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all
clear all



function maxVal_Callback(hObject, eventdata, handles)
% hObject    handle to maxVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxVal as text
%        str2double(get(hObject,'String')) returns contents of maxVal as a double


% --- Executes during object creation, after setting all properties.
function maxVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskTime_Callback(hObject, eventdata, handles)
% hObject    handle to maskTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskTime as text
%        str2double(get(hObject,'String')) returns contents of maskTime as a double


% --- Executes during object creation, after setting all properties.
function maskTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refreshButton.
function refreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to refreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Call "plot function"
computeData2Plot;


% --- Executes on selection change in timeWindowSelect.
function timeWindowSelect_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns timeWindowSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeWindowSelect
computeData2Plot;

% --- Executes during object creation, after setting all properties.
function timeWindowSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeWindowSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function timeWindowStart_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowStart as text
%        str2double(get(hObject,'String')) returns contents of timeWindowStart as a double


% --- Executes during object creation, after setting all properties.
function timeWindowStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeWindowStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeWindowStop_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowStop as text
%        str2double(get(hObject,'String')) returns contents of timeWindowStop as a double


% --- Executes during object creation, after setting all properties.
function timeWindowStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeWindowStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveResult.
function saveResult_Callback(hObject, eventdata, handles)
% hObject    handle to saveResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global out

% Remove handles from struct!
% In new MATLAB versions (>2012) all figures will be saved as well which
% confuses users while loading the data
out = rmfield(out, 'handles');

% Save the data (without handles)
uisave('out',[pwd filesep out.edaFileName(1:end-4) '_EDA.mat'])

% Restore handles again to work with the GUI
out.handles = handles;
