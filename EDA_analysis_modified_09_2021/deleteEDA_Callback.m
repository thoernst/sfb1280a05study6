% --- Executes on button press in deleteEDA.
function deleteEDA_Callback(hObject, eventdata, handles)
% hObject    handle to deleteEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Deletes the selected eda

% Tobias Otto
% 1.2
% 27.11.2012

% 22.11.2012, Tobias: first draft
% 26.11.2012, Tobias: set marked list box entry to previous one
% 27.11.2012, Tobias: delete amplitude as well

%% Init variables
global out
i = out.i;

%% Get position of eda that has to be deleted
pos = get(out.handles.listbox2,'Value');

% Set to previous position
if(pos-1 > 0)
    set(out.handles.listbox2,'Value', pos-1);
else
    set(out.handles.listbox2,'String', 'No EDA');
    set(out.handles.listbox2,'Value', 1);
end

%% Delete eda from struct
try
    out.edaRes(i).minTime(pos)      = [];
    out.edaRes(i).maxTime(pos)      = [];
    out.edaRes(i).minData(pos)      = [];
    out.edaRes(i).maxData(pos)      = [];
    out.edaRes(i).edaTimeRes(pos)   = [];
    out.edaRes(i).amplitude(pos)    = [];
catch ME
    warning ('No EDA to delete');
end
%% Plot data again
plotData;
