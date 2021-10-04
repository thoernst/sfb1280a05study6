% --- Executes on button press in loadEDAData.
function loadEDAData_Callback(hObject, eventdata, handles)
% hObject    handle to loadEDAData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Tobias Otto
% 1.0
% 07.12.2012

% 07.12.2012, Tobias: first draft
% 2020-01-13: TME: clearing global variable out set right

%% Get access to global struct and clear content
% We start new here !!!
%global out
%clear out
clear('global','out')

%% Load data
[f,p] = uigetfile(pwd);
try
    load([p,f]);
catch ME;
    warning ('Please select correct file');
    return;
end

% Restore handles
out.handles = handles;

% %edit by thomas
% set(handles.figure1, 'units', 'normalized', 'position', [0.0 0.0 1.5 1.5])

% Plot new data
plotData;