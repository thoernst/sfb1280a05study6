% --- Executes on button press in splitEDA.
function splitEDA_Callback(hObject, eventdata, handles)
% hObject    handle to splitEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 04.01.2013, Tobias: first draft
% 15.04.2013, Tobias: added check if window for splitting still exists; 
%                     added try, catch for ginput to avoid error message

%% Init variables
global out
i           = out.i;
sampRate    = out.sampRate;
minXDist    = out.edaMaskWindow(i);

% Get position of eda that has to be deleted
pos = get(out.handles.listbox2,'Value');

%% Get data of selected EDA
try 
    startInd    = round(out.edaRes(i).minTime(pos)*sampRate);
    stopInd     = round(out.edaRes(i).maxTime(pos)*sampRate);
    data        = out.trialData{i}(startInd:stopInd);
    time        = out.trialTime{i}(startInd:stopInd);
catch ME
    warning ('No EDA to split');
    return
end

%% Plot data
fid = figure;
set(fid,'Menubar','none', 'Name', 'Split selected EDA','Numbertitle', 'off','PaperUnits', 'normalized')
plot(time,data)
text(0.65*time(round((stopInd-startInd))) , 0.95*(max(data)-min(data)) , 'Please click on the EDA to split','Fontsize', 14)
grid on
hold on

%% Get data
try
    x = ginput(1);
    x = x(1);   % We need the x component only
catch
    warning('EDA wasn''t split, because the window was closed !');
end

%% Check, if Windows still exists
if(ishandle(fid))
    %% Compute new two new EDAs
    % Compute new start and stop TIME points for the new EDA'a
    % Separate EDA's by the given time window (set up in GUI)
    newStart1   = out.edaRes(i).minTime(pos);
    newStop1    = x - minXDist/4;
    newTimeRes1 = newStart1 - out.edaRes(i).stimOnset;
    
    newStart2   = x + minXDist/4+(1/sampRate);
    newStop2    = out.edaRes(i).maxTime(pos);
    newTimeRes2 = newStart2 - out.edaRes(i).stimOnset;
    
    % Compute new max and min DATA points for the two new EDA's
    data1   = out.trialData{i}(round(newStart1*sampRate:newStop1*sampRate));
    % time1   = linspace(newStart1, newStop1,length(data1));
    newMin1 = min(data1);
    newMax1 = max(data1);
    ampl1   = newMax1 - newMin1;
    
    data2   = out.trialData{i}(round(newStart2*sampRate:newStop2*sampRate));
    % time2   = linspace(newStart2, newStop2,length(data2));
    newMin2 = min(data2);
    newMax2 = max(data2);
    ampl2   = newMax2 - newMin2;
    
    % Plot separation -> visual feedback
    % plot(time1,data1,'r')
    % plot(time2,data2,'r')
    
    %% Copy result to global struct
    % First copy entries after pos to actual position.
    % But only if position is not the last one
    if(length(out.edaRes(i).minTime) > pos)
        out.edaRes(i).minTime(pos+2:end+1)      = out.edaRes(i).minTime(pos+1:end);
        out.edaRes(i).maxTime(pos+2:end+1)      = out.edaRes(i).maxTime(pos+1:end);
        out.edaRes(i).minData(pos+2:end+1)      = out.edaRes(i).minData(pos+1:end);
        out.edaRes(i).maxData(pos+2:end+1)      = out.edaRes(i).maxData(pos+1:end);
        out.edaRes(i).amplitude(pos+2:end+1)    = out.edaRes(i).amplitude(pos+1:end);
        out.edaRes(i).edaTimeRes(pos+2:end+1)	= out.edaRes(i).edaTimeRes(pos+1:end);
    end
    
    % Copy new entries
    out.edaRes(i).minTime(pos)      = newStart1;
    out.edaRes(i).maxTime(pos)      = newStop1;
    out.edaRes(i).minData(pos)      = newMin1;
    out.edaRes(i).maxData(pos)      = newMax1;
    out.edaRes(i).amplitude(pos)    = ampl1;
    out.edaRes(i).edaTimeRes(pos)   = newTimeRes1;
    
    out.edaRes(i).minTime(pos+1)   	= newStart2;
    out.edaRes(i).maxTime(pos+1)  	= newStop2;
    out.edaRes(i).minData(pos+1)  	= newMin2;
    out.edaRes(i).maxData(pos+1) 	= newMax2;
    out.edaRes(i).amplitude(pos+1)	= ampl2;
    out.edaRes(i).edaTimeRes(pos+1) = newTimeRes2;
    
    %% Plot again and close window
    close(fid)
    plotData
end