% --- Executes on button press in mergeEDA.
function mergeEDA_Callback(hObject, eventdata, handles)
% hObject    handle to mergeEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Tobias Otto
% 1.2
% 28.11.2012

% 23.11.2012, Tobias: first draft
% 26.11.2012, Tobias: Set focus back to previous eda
% 28.11.2012, Tobias: deleting entry in out.edaRes(i).amplitude(pos) as well

%% Init variables
global out
i = out.i;

%% Get position of eda that has to be deleted
pos = get(out.handles.listbox2,'Value');

%% Start deleting
if(pos == 1)
    h = warndlg('The EDA''s are merged with the previous result. Please choose the second EDA!');
    waitfor(h)
else
    out.edaRes(i).minTime(pos)      = [];
    out.edaRes(i).maxTime(pos-1)    = [];
    out.edaRes(i).minData(pos)      = [];
    out.edaRes(i).maxData(pos-1)    = [];
    out.edaRes(i).edaTimeRes(pos)	= [];
    out.edaRes(i).amplitude(pos)    = [];
    % Set focus back to first entry
    set(out.handles.listbox2,'Value', 1);
end

%% Call to plotData to plot the result
plotData;
