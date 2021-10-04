function plotData
% This function only plots data to the current axis

% Tobias Otto
% 1.7
% 24.03.2015

% 22.11.2012, Tobias: first draft
% 23.11.2012, Tobias: plotting all settings and data now from global out struct
% 26.11.2012, Tobias: axes scaling -> nicer view to data
% 28.11.2012, Tobias: set focus to list box on first entry
% 29.11.2012, Tobias: changed y label
% 04.01.2013, Tobias: added check for optional argument sPos
% 18.08.2014, Tobias: x and ylabel now more flexible (defined in trialDefintion)
% 24.03.2015, Tobias: adjustments in y axis for markers

%% Init variables
global out

i           = out.i;
trialData   = out.trialData{i};
trialTime   = out.trialTime{i};
edaTime     = out.edaTime{i};
edaData     = out.edaData{i};
edaMinTime  = out.edaRes(i).minTime;
edaMaxTime  = out.edaRes(i).maxTime;
stimTime    = out.stimPresTime(i);
% Compute y range for markers
% Compute y range for markers
minDat  = min(trialData);
maxDat  = max(trialData);

if(minDat > 0)
    yRangeMarker    = [minDat*0.9 maxDat*1.05];
    YLim            = [minDat*0.1 maxDat*1.5];
else
    yRangeMarker    = [minDat*0.9 maxDat*1.1];
    YLim            = [minDat+minDat*0.1 maxDat*1.5];
end


if(~isempty(out.trialSep))
    maxTrials = length(out.trialSep)-1;
elseif(~isempty(out.trialStart))
    maxTrials = length(out.trialStart);
end

%% Plot
% Plot complete trial
plot(trialTime, trialData);
hold on
% Plot only data used to compute EDA
plot(edaTime, edaData,'r')
grid on
set(out.handles.textTrial,'String',['Trial: ' num2str(i) ' von ' num2str(maxTrials) '  '])
xlabel(['Time in ' out.xlabel]);
ylabel(out.ylabel);
% Stimulus is plotted in red
line([stimTime stimTime], yRangeMarker, 'Color', 'r', 'LineWidth', 2);   % Plot stimulus
text(stimTime*1.01, yRangeMarker(2), ['Stimulus | ' num2str(stimTime) 's'],'color','r')

%% Set global time entries
set(out.handles.textGlobalStartTime,'String', sprintf('%.2f',(out.globalTrialStartTime(i))));
set(out.handles.textGlobalStopTime,'String', sprintf('%.2f',out.globalTrialStopTime(i)));

%% Set entries for EDA parameters
set(out.handles.maxVal,'String', num2str(out.edaMaxVal(i)));            % Maximum value on y axis that is needed to set a EDA as valid
%set(out.handles.maskTime,'String', num2str(out.edaMaskWindow(i)));      % Masking time that is needed to compute "Sattelpunk"
set(out.handles.maskTime,'String', 1.1);

set(out.handles.timeWindowStart,'String', num2str(out.timeWindowStart(i)));
set(out.handles.timeWindowStop,'String', num2str(out.timeWindowStop(i)));

%% Plot box for each result
if(~isempty(edaMinTime))
    for j=1:length(edaMinTime)
 
        %Plot the answer, set callback function for mouse click
        rectangle('Position', [edaMinTime(j) min(trialData) edaMaxTime(j)-edaMinTime(j)...
            max(trialData)-min(trialData)  ], 'EdgeColor', 'k', 'LineWidth', 2, ...
            'Tag', string(j), 'ButtonDownFcn',@rectangleClickCallback);
    end
end

%% Mark special events
if(~isempty(out.sPos))
    for j=1:length(out.sPos)
        % In case they are valid for the current trial
        if(out.sPosTime(i,j) >= 0)
            line([out.sPosTime(i,j) out.sPosTime(i,j)], yRangeMarker, 'Color', out.sPos{j}.color, 'LineWidth', 2);
            text(out.sPosTime(i,j)*1.01, yRangeMarker(2), [out.sPos{j}.name ' | ' num2str(out.sPosTime(i,j)) 's'],'color',out.sPos{j}.color)
        end
    end
end
%% Set axes to have a nice view
set(gca,'XLim', [0 trialTime(end)]);
% Use markers as reference for the max height in y direction
if(yRangeMarker(2) > 0)
    set(gca,'YLim', [YLim(1) yRangeMarker(2)*1.1]);
else
    set(gca,'YLim', [YLim(1) yRangeMarker(2)*0.9]);
end
hold off

%% Set filename
set(out.handles.textFilename, 'String', out.edaFileName)

%% Add eda's to list box
% Create string
for j=1:length(out.edaRes(i).edaTimeRes)
    listStr{j} = sprintf('(%02d) | %.3fs | %.3fs | %.3fV', j, out.edaRes(i).edaTimeRes(j), out.edaRes(i).maxTime(j)-out.edaRes(i).minTime(j), out.edaRes(i).amplitude(j));
end
% Set focus to first entry in list box
set(out.handles.listbox2,'Value', 1);

% Fill listbox with life ;)
if(~isempty(out.edaRes(i).edaTimeRes))
    set(out.handles.listbox2,'String',listStr)
else
    set(out.handles.listbox2,'String',{'No result'})
end



set(out.handles.figure1,'WindowKeyPressFcn',@KeyPress, 'Tag', 'MainGUI');