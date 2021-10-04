
function varargout = peakDetection(varargin)
% peakDetection MATLAB code for peakDetection.fig
%      peakDetection, by itself, creates a new peakDetection or raises the existing
%      singleton*.
%
%      H = peakDetection returns the handle to a new peakDetection or the handle to
%      the existing singleton*.
%
%      peakDetection('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in peakDetection.M with the given input arguments.
%
%      peakDetection('Property','Value',...) creates a new peakDetection or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before peakDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to peakDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help peakDetection

% Last Modified by GUIDE v2.5 12-Mar-2021 12:13:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @peakDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @peakDetection_OutputFcn, ...
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


% --- Executes just before peakDetection is made visible.
function peakDetection_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to peakDetection (see VARARGIN)

% Choose default command line output for peakDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%Gui adjustment for Windows UI
if ispc 
    set(handles.MinPeakHeight_Edit, 'position', [278 10.2 34 15]);
    set(handles.MaxPeakWidth_Edit, 'position', [120 10.2 34 15]);
    set(handles.MinPeakWidth_Edit, 'position', [120 34 25.9 15]);
    set(handles.MinPeakProm_Edit, 'position', [278 34 21.9 15]);
    set(handles.text7, 'position', [41.4 1.2 15.8 1.077]);
    set(handles.text3, 'position', [-0.4 1.2 15.8 1.077]);
    set(handles.text4, 'position', [40.4 3.5 16.8 1.06]);
    set(handles.MaxPeakWidth_Slider, 'position', [16.4 1 15 1.5]);
    set(handles.MinPeakWidth_Slider, 'position', [16.5 3.4 15 1.5]);
    set(handles.PPGMS, 'position', [72.6 44.87 46.5 15]);
    set(handles.wHeight, 'position', [84.6 25.5 34.5 15]);
    set(handles.relPos, 'position', [84.6 7.8 34.5 15]);
    set(handles.range, 'position', [6.75 3.3 50.25 15]);
end;
% UIWAIT makes peakDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global minpw;
global maxpw; 
global minpprom;
global minpheight;
minpw = 1.0;
set(handles.MinPeakWidth_Slider, 'value', minpw);
set(handles.MinPeakWidth_Edit,'string',minpw);
maxpw = 0.1;
set(handles.MaxPeakWidth_Slider, 'value', maxpw);
set(handles.MaxPeakWidth_Edit,'string',maxpw);
minpprom = 0;
set(handles.MinPeakProm_Edit,'string',minpprom);
set(handles.MinPeakProm_Slider, 'value', minpprom);
minpheight = 0.0;
set(handles.MinPeakHeight_Edit,'string',minpheight);
set(handles.MinPeakHeight_Slider, 'value', minpheight);
set(handles.autoCalc, 'Value', 1);
set(handles.PPGMS, 'string', "-300");

% --- Outputs from this function are returned to the command line.
function varargout = peakDetection_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function MinPeakWidth_Edit_Callback(hObject, ~, handles)
    global minpw;
    minpw=str2double(get(hObject,'String'));
    set(handles.MinPeakWidth_Slider, 'value', minpw);
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;



% --- Executes during object creation, after setting all properties.
function MinPeakWidth_Edit_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end




function MaxPeakWidth_Edit_Callback(hObject, ~, handles)
    global maxpw;
    maxpw=str2double(get(hObject,'String'));
    set(handles.MaxPeakWidth_Slider, 'value', maxpw);
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;


% --- Executes during object creation, after setting all properties.
function MaxPeakWidth_Edit_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function MinPeakProm_Edit_Callback(hObject, ~, handles)
    global minpprom;
    minpprom=str2double(get(hObject,'String'));
    set(handles.MinPeakProm_Slider, 'value', minpprom);
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;


% --- Executes during object creation, after setting all properties.
function MinPeakProm_Edit_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function ecgPlot_CreateFcn(~, ~, ~)


function openEventtable
    global eventtable;
    
    [FN,PN] = uigetfile('*_eventTable.mat','Select event file');
    try
        %load eventtable and remove all non-FIR events
        addpath(PN);
        load(fullfile(PN,FN),'eventtable');
        [I, ~] = find(cellfun(@(s) ~contains(s, 'FIR'), eventtable{:,4}));
        eventtable(I, :) = [];
    catch ME
        eventtable = [];
    end
    

% --- Executes on button press in openRaw.
function openRaw_Callback(~, ~, handles)
    global cardiodata;
    cardiodata = [];
    global PathName;
    global FileName;
    [FileName,PathName] = uigetfile('*_cardio.mat','Select physio file');
    try 
        addpath(PathName);
        load(fullfile(PathName,FileName),'cardiodata');
    catch ME
        warndlg('Error opening file');
        return 
    end

    global ECG;
    global PPG;
   
    global samplingrate;
    global nTrial;
    global windowBegin;
    global windowEnd;
    global ind_trial;
    global HBData;
    global markerPos;


 

    samplingrate = roundn(ceil(1000/median(diff(cardiodata.Time))),1);
    ECG = bandpassfilter(cardiodata.ECG, samplingrate);
    PPG=lowpass(cardiodata.PPG, 500, samplingrate);
    msg = sprintf('sampling rate is %d Hz', samplingrate);
    disp(msg);

  
    firstTrialOnset = 1;
    lastTrialEnd = length(ECG);
    index_onset_Trial = int64(firstTrialOnset:samplingrate*19:lastTrialEnd);
    windowBegin = index_onset_Trial;
    windowEnd   = index_onset_Trial+20*samplingrate;
  %with 20 1 second of a next window overlaps with a previous one
    if windowEnd(end) > lastTrialEnd
        windowEnd(end) = lastTrialEnd;
    end
 
  
    nTrial = numel(windowBegin);
    ind_trial = 1;
    HBData = 1;
    xLimits = get(gca,'XLim');
    markerPos = xLimits(1);

    %add an empty ECG peaks channel 
    ECG_Peaks = false(size(ECG,1),1);
    ECG_Peaks = array2table(ECG_Peaks);
    cardiodata=horzcat(cardiodata, ECG_Peaks);
    set(handles.fName, 'string', strcat('File:   ',PathName,FileName) );
    openEventtable;
     cardiodata.Time = cardiodata.Time / 1000;
    ter_refreshPlot();


 % --- Executes on button press in openHeartbeat.
function openHeartbeat_Callback(~, ~, handles)
    global PathName;
    global FileName;
    global ECG;
    global PPG;
    global samplingrate;
    global ind_trial;
    global HBData;
    global markerPos;
    global windowBegin;
    global windowEnd;
    global nTrial;
    global cardiodata;
    
    global minpw;
    global maxpw; 
    global minpprom;
    global minpheight;
    global offset;
    
    clearvars measurementdata cardiodata;

    [FileName,PathName] = uigetfile('*_cardiodata*.mat','Please select data table');

  
    try 
        cd(PathName);
        addpath(PathName);
        load(fullfile(PathName,FileName),'cardiodata');
        load(fullfile(PathName,FileName),'measurementdata');
    catch ME
        warndlg('Error opening file');
        return 
    end

    if exist('cardiodata','var') ~= 1
        warndlg('Cannot find the right data format');
    end
    if exist('measurementdata','var') ~= 1
        measurementdata = [];
    end
    
        
    if ~isempty(measurementdata)
        minpw = measurementdata.minpw;
        maxpw = measurementdata.maxpw;
        minpprom = measurementdata.minpprom;
        minpheight = measurementdata.minpheight;
        offset = -measurementdata.offset;      
        set(handles.MinPeakWidth_Slider, 'value', minpw);
        set(handles.MinPeakWidth_Edit,'string',minpw);
        set(handles.MaxPeakWidth_Slider, 'value', maxpw);
        set(handles.MaxPeakWidth_Edit,'string',maxpw);
        set(handles.MinPeakProm_Edit,'string',minpprom);
        set(handles.MinPeakProm_Slider, 'value', minpprom);
        set(handles.MinPeakHeight_Edit,'string',minpheight);
        set(handles.MinPeakHeight_Slider, 'value', minpheight);
        set(handles.PPGMS,'string',-offset)
        set(handles.autoCalc, 'Value', 1);
        
    end

    if ~ismember(cardiodata.Properties.VariableNames,'ECG_Peaks')
        warndlg('Please run peak detection first!');
        return;
    else  
        xLimits = get(gca,'XLim');
        markerPos = xLimits(1);
        HBData = 0;
        ind_trial = 1;
        set(handles.autoCalc, 'Value', HBData);
    end

    samplingrate = roundn(ceil(1000/median(diff(cardiodata.Time))),1);
    ECG=bandpassfilter(cardiodata.ECG, samplingrate);
    samplingrate = ceil(1000/median(diff(cardiodata.Time)));
    PPG=lowpass(cardiodata.PPG, 500, samplingrate);
    
    firstTrialOnset = 1;
    lastTrialEnd = length(ECG);
   
    index_onset_Trial = int64(firstTrialOnset:samplingrate*19:lastTrialEnd);
    windowBegin = index_onset_Trial;
    windowEnd   = index_onset_Trial+20*samplingrate;
    %with 20 1 second of a next window overlaps with a previous one
    if windowEnd(end) > lastTrialEnd
        windowEnd(end) = lastTrialEnd;
    end


    msg = sprintf('sampling rate is %d Hz', samplingrate);
    disp(msg);


    set(handles.fName, 'string', strcat('File:   ',PathName,FileName) );
    nTrial = numel(windowBegin);
    openEventtable;
    cardiodata.Time = cardiodata.Time / 1000;
    ter_refreshPlot; 
  
  

function ter_refreshPlot
    global ind_trial;
    global nTrial;
    global minpw;
    global maxpw; 
    global minpprom;
    global cardiodata; 
    global samplingrate;
    global minpheight;
    global windowBegin;
    global windowEnd;
    global markerPos;
    global tr_data;
    global indTr;
    global ind_hbeats;
    global offset;
    global ECG;
    global PPG;
    global PPG_;
    global eventtable;
    
    
    indTr = windowBegin(ind_trial):windowEnd(ind_trial);
    tr_data    = ECG(indTr);
    tr_time    = cardiodata.Time(indTr);
  
   
    xmin = tr_time(1);
    xmax = tr_time(end);
    
    % ecg plot
    handles = guidata(gcf);
    axes(handles.ecgPlot);
       
    maxV = max(tr_data);
    offset = -str2num(get(handles.PPGMS,'string'))*samplingrate/1000; 
    wheight = str2num(get(handles.wHeight,'string'));      
    relPos = str2num(get(handles.relPos,'string'));      
    PPG_    = (PPG*wheight)+maxV*relPos; 
     
    %fill out zeros in the beginning or the end of PPG channel depending
    %on the offset
    if offset < 0 
        PPG_ = [zeros(abs(offset),1); PPG];
    else
        PPG_ = [PPG(abs(offset):end); zeros(abs(offset),1)];
    end
    
     
    if get(handles.radiobutton15, 'value') == 1
        dataToAnalyze = tr_data;    
    else
        dataToAnalyze = (PPG_(indTr));
    end

     
    
    if get(handles.autoCalc,'value') == 1 || sum(cardiodata.ECG_Peaks(indTr)==1) == 0
        [~,locs,~,~] =  findpeaks(dataToAnalyze, samplingrate, 'MinPeakWidth',minpw, 'MaxPeakWidth',maxpw,'MinPeakProminence',minpprom, 'MinPeakHeight', minpheight);
        ind_hbeats = false(size(dataToAnalyze,1),1);
        peaklocations=round(locs*samplingrate); 
        ind_hbeats(peaklocations)=true;
        cardiodata.ECG_Peaks(indTr) = ind_hbeats;
    else
        ind_hbeats = cardiodata.ECG_Peaks(indTr);     
    end
 
    cla;
    ymin = floor(min(tr_data)*11)/10;
    ymax = ceil(max(tr_data)*11)/10;
    
    axis([tr_time(1) tr_time(end) ymin ymax]);
    plot(tr_time,tr_data,'color','blue');
    hold on 
    plot(tr_time(ind_hbeats),tr_data(ind_hbeats),'X','color','magenta','LineWidth',4);
 
    peaks = 0;
    for j=1:numel(ind_hbeats)     
        if ind_hbeats(j) == 1 
            peaks = peaks + 1;
            text(tr_time(j),0.70*ymax, num2str(peaks));
            xline(tr_time(j), 'LineWidth',0.5,'Color',[17 17 17]/255, 'LineStyle', '--');
        end              
    end

    xlim([tr_time(1) tr_time(end)]);
     
       
    
     
    set(gca, 'ButtonDownFcn',@ecgPlot_ButtonDownFcn);
    set(gcf, 'Pointer', 'cross');  
      
    y = ylim;
    ylabel('ecg');
    plot([markerPos,markerPos], [y(1) y(2)], 'color','red');
    plot(tr_time,PPG_(indTr)*wheight+maxV*relPos,'Color','red');
    y = ylim;
    
    
     %marking trials/stimuli onsets
     if ~isempty(eventtable)
      onset_CS = eventtable.event_onsets;
      BL_Markers = onset_CS - 4;
      End_Markers = onset_CS + 12;
      
            
      CS_Marks = interp1(tr_time, 1:length(tr_time), double(onset_CS), 'nearest');
      CS_Marks = CS_Marks(~isnan(CS_Marks));
      BL_Marks = interp1(tr_time, 1:length(tr_time), BL_Markers, 'nearest');
      BL_Marks = BL_Marks(~isnan(BL_Marks));
      End_Marks = interp1(tr_time, 1:length(tr_time), End_Markers, 'nearest');
      End_Marks = End_Marks(~isnan(End_Marks));
      xlim([tr_time(1) tr_time(end)]);
     
    
    
    
     
    
    
    
     for j=1:numel(CS_Marks)
         line([tr_time(CS_Marks(j)) tr_time(CS_Marks(j))], [y(2)*0.8 y(2)] , 'LineWidth',2.5,'Color','g', 'LineStyle', '-');
         text(tr_time(CS_Marks(j)),y(2)*0.9, 'CS Onset', 'HorizontalAlignment', 'center');
     end
       
     for j=1:numel(BL_Marks)
         line([tr_time(BL_Marks(j)) tr_time(BL_Marks(j))], [y(2)*0.8 y(2)] , 'LineWidth',2.5,'Color',[0.75, 0, 0.75], 'LineStyle', '-');
         text(tr_time(BL_Marks(j)),y(2)*0.9, 'BL Start', 'HorizontalAlignment', 'center');           
     end
       
     for j=1:numel(End_Marks)
         line([tr_time(End_Marks(j)) tr_time(End_Marks(j))], [y(2)*0.8 y(2)] , 'LineWidth',2.5,'Color',[0.75, 0, 0.75], 'LineStyle', '-');
         text(tr_time(End_Marks(j)),y(2)*0.9, 'TIR End', 'HorizontalAlignment', 'center');
     end  
       end  
    
    
    
    
    hold off
    
    
    %bpm plot    
    axes(handles.bpmPlot);
    cla; 
    ind_hbeats = find(ind_hbeats);  
    heartrate = nan(numel(tr_data),1);
    for j=2:numel(ind_hbeats)
        heartrate(ind_hbeats(j-1):ind_hbeats(j)) = 60 / ...
        (tr_time(ind_hbeats(j))-tr_time(ind_hbeats(j-1)));
    end
	heartrate = heartrate/(samplingrate/1000);
    plot(tr_time,heartrate);
    hold on 
    set(gca,'xticklabel',[])
    ylabel('bpm');
    ymin = floor(min(heartrate))-4;
    ymax = ceil(max(heartrate))+4;
    
    try 
        axis([xmin xmax ymin ymax]);
    catch ME
        if (strcmp(ME.identifier,'MATLAB:hg:shaped_arrays:LimitsWithInfsPredicate'))
        axis([53 66 44 64])
        end
    end
        
    
   plot([markerPos,markerPos],[ymin ymax],':',...
      'color','red');  
    handles.trialtext.String = ['Trial:   ' int2str(ind_trial) '/' int2str(nTrial)];
    
    set(handles.figure1,'WindowKeyPressFcn',@KeyPress, 'Tag', 'MainGUI');
   
  
 function switchstep (step)
   handles = guidata(gcf);
   switch step
       case 1
           set(handles.radiobutton1, 'Value', 1);
       case 2
           set(handles.radiobutton2, 'Value', 1);
       case 3
           set(handles.radiobutton3, 'Value', 1);
       case 4
           set(handles.radiobutton4, 'Value', 1);
end

    
    
function KeyPress(hobj, EventData, ~)    
      switch EventData.Key
          case 'leftarrow'
              prevNextTrial(-1);
          case 'rightarrow'
              prevNextTrial(1);
          case 'uparrow'
              cursorLeftRight(1);
          case 'downarrow'
              cursorLeftRight(-1);
           case '1'
              switchstep(1);
          case '2'
              switchstep(2);
          case '3'
              switchstep(3);
          case '4'
              switchstep(4);
          case 'd'
              removeMarker;
          case 'r'
              recalculate;
          case 'p'
              ppgOnOff;
          case 'a'
              addMarker;
          case 's'
              Finalize;
          case 'j'
              jumpTo;
          case 'x'
              delete(hobj);
end
    

    




% --- Executes on slider movement.
function MinPeakWidth_Slider_Callback(hObject, ~, handles)
    % hObject    handle to MinPeakWidth_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    value = get(hObject,'Value');
    set(handles.MinPeakWidth_Edit,'string',value);
    global minpw;
    minpw = value;
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;

% --- Executes during object creation, after setting all properties.
function MinPeakWidth_Slider_CreateFcn(hObject, ~, ~)
    % hObject    handle to MinPeakWidth_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function MaxPeakWidth_Slider_Callback(hObject, ~, handles)
    % hObject    handle to MaxPeakWidth_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    value = get(hObject,'Value');
    set(handles.MaxPeakWidth_Edit,'string',value);
    global maxpw;
    maxpw = value;
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;


% --- Executes during object creation, after setting all properties.
function MaxPeakWidth_Slider_CreateFcn(hObject, ~, ~)
    % hObject    handle to MaxPeakWidth_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function MinPeakProm_Slider_Callback(hObject, ~, handles)
    % hObject    handle to MinPeakProm_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    value = get(hObject,'Value');
    set(handles.MinPeakProm_Edit,'string',value);
    global minpprom;
    minpprom = value;
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;

% --- Executes during object creation, after setting all properties.
function MinPeakProm_Slider_CreateFcn(hObject, ~, ~)
    % hObject    handle to MinPeakProm_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on button press in Finalize.
function Finalize_Callback(~, ~, ~)
    % hObject    handle to Finalize (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    Finalize;

function Finalize
    global cardiodata;
    global FileName;
    global minpw;
    global maxpw; 
    global minpprom;
    global minpheight;    
    global offset;
    
    
    measurementdata = table(minpw,maxpw,minpprom,minpheight,offset);
    
    
    if ~contains (FileName, "_cardiodata")
        filename = [FileName(1:end-4) '_cardiodata.mat'];
    else    
        filename = FileName;
    end
    if isfile(filename)
        answer = string(questdlg('File already exists, overwrite?','','Yes', 'No','No' ));
        if answer == 'Yes'
            save(filename,'cardiodata', '-v7.3');
        else
          [filename,~] = uiputfile('*_cardiodata.mat','File selection');           
        end
    end
     try
            save(filename,'cardiodata','measurementdata', '-v7.3');
          catch ME
              warndlg('No proper file name given');
          end
    disp('Saved');

function MinPeakHeight_Edit_Callback(hObject, ~, handles)
    % hObject    handle to MinPeakHeight_Edit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of MinPeakHeight_Edit as text
    %        str2double(get(hObject,'String')) returns contents of MinPeakHeight_Edit as a double
    global minpheight;
    minpheight=str2double(get(hObject,'String'));
    set(handles.MinPeakHeight_Slider, 'value', minpheight);
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;

% --- Executes during object creation, after setting all properties.
function MinPeakHeight_Edit_CreateFcn(hObject, ~, ~)
    % hObject    handle to MinPeakHeight_Edit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on slider movement.
function MinPeakHeight_Slider_Callback(hObject, ~, handles)
    % hObject    handle to MinPeakHeight_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global minpheight;
    value = get(hObject,'Value');
    set(handles.MinPeakHeight_Edit,'string',value);
    minpheight = value;
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;

% --- Executes during object creation, after setting all properties.
function MinPeakHeight_Slider_CreateFcn(hObject, ~, ~)
    % hObject    handle to MinPeakHeight_Slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function filtered = bandpassfilter(ecg, fs)
    %take the raw signal for plotting later
    time_scale = length(ecg)/fs; % total time;
    %Noise cancelation(Filtering)
    f1=0.5; %cuttoff low frequency to get rid of baseline wander
    f2=45; %cuttoff frequency to discard high frequency noise
    Wn=[f1 f2]*2/fs; % cutt off based on fs
    N = 3; % order of 3 less processing
    [a,b] = butter(N,Wn); %bandpass filtering
    ecg = filtfilt(a,b,ecg);
    filtered = ecg;

% --- Executes on button press in addMarker.
function addMarker_Callback(~, ~, ~)
    % hObject    handle to addMarker (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    addMarker;

function addMarker
    global cardiodata;
    global markerPos;
    global samplingrate;
    
    %find closest value to the markerPos in Time channel 
    point= interp1(cardiodata.Time, 1:length(cardiodata.Time), markerPos, 'nearest'); 
    cardiodata.ECG_Peaks(point) = ~cardiodata.ECG_Peaks(point);
    handles = guidata(gcf);
    set(handles.autoCalc, 'Value', 0);
    ter_refreshPlot;
  
% --- Executes on button press in removeMarker.
function removeMarker_Callback(~, ~, ~)
    % hObject    handle to removeMarker (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
     removeMarker;
 
    
function removeMarker
    global ind_hbeats;
    global cardiodata;
    global indTr;
    dlgChoice = ter_deleteDialog;
    if ~isempty(dlgChoice)
        handles = guidata(gcf);
        set(handles.autoCalc, 'Value', 0);
        cardiodata.ECG_Peaks(indTr(ind_hbeats(dlgChoice))) = 0;
        ter_refreshPlot;
    end
    
function dlgChoice = ter_deleteDialog()
    global ind_hbeats;
    optionList = cellfun(@(x) sprintf('%d',x),...
      num2cell(1:numel(ind_hbeats)),'UniformOutput',false);
    global dlgChoice0;
    global dlgChoice;
    dlgChoice0 = 1;
    dlgChoice  = [];
    d = dialog('Position',[800 500 240 100],'Name','delete hb maker');
    % add buttons for ok an cancel (cancel shall return empty choice) set
    % control elements
    txt_label = uicontrol('Parent',d,...
      'Style','text',...
      'Position', [0 80 240 20] ,...
      'String','Select heartbeat marker to delete:'); %#ok<NASGU>

      % use last parameter set or a set of default values to define vars
    popup_comp = uicontrol('Parent',d,...
      'Style','popup',...
      'Position',[40 60 160 20],...
      'String',optionList,...
      'Value',find(ismember(optionList,'1')),...
      'Callback',@(es,ed) ter_setChoice0(es.Value));   %#ok<NASGU>
  
    btnCancel   = uicontrol('Parent',d,...
      'Position',[  10 10 110 40],...
      'String','Cancel',...
      'Callback',@(es,ed) delete(d)); %#ok<NASGU>
    btnOK = uicontrol('Parent',d,...
      'Position',[ 120 10 110 40],...
      'String','OK',...
      'Callback',@(es,ed) ter_setChoice(d));
  
    
    uicontrol(popup_comp);
    
    % Wait for d to close before running to completion   
    uiwait(d);
        
function ter_setChoice0(indNew)
   global dlgChoice0;
   dlgChoice0 = indNew;
    
function ter_setChoice(hDlg)
   global dlgChoice0;
   global dlgChoice;
   dlgChoice = dlgChoice0;
   delete(hDlg);
        
% --- Executes on button press in Exit.
function Exit_Callback(~, ~, ~)
    % hObject    handle to Exit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    h_obj = findall(0);
    h_obj =h_obj(2:end);
    delete(h_obj);

% --- Executes on button press in prevTrial.
function prevTrial_Callback(~, ~, ~)
    % hObject    handle to prevTrial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    prevNextTrial(-1);

% --- Executes on button press in nextTrial.
function nextTrial_Callback(~, ~, ~)
    % hObject    handle to nextTrial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    prevNextTrial(1);

function prevNextTrial (direction)
    global nTrial;
    global markerPos;
    global ind_trial;
    global windowBegin;
    global windowEnd;
    global cardiodata;
    global ECG;

    if ind_trial+ direction <= nTrial && ind_trial+direction >= 1             
        ind_trial = ind_trial + direction;
        markerPos = 1;  
        indTr = windowBegin(ind_trial):windowEnd(ind_trial);
        tr_data    = ECG(indTr);
        tr_time    = cardiodata.Time(indTr);
        if sum(cardiodata.ECG_Peaks(indTr)==1) > 0 
            handles = guidata(gcf);
            set(handles.autoCalc, 'Value', 0);
        end   
        ter_refreshPlot;   
    end

function firstLastTrial (direction)
    global nTrial;
    global markerPos;
    global ind_trial;
    global windowBegin;
    global windowEnd;
    global cardiodata;
    if direction == -1              
        ind_trial = 1;
    elseif direction == 1
    ind_trial = nTrial;
    end
    markerPos = 1;  
    indTr = windowBegin(ind_trial):windowEnd(ind_trial);
    tr_data    = cardiodata.ECG(indTr);
    tr_time    = cardiodata.Time(indTr);
    if sum(cardiodata.ECG_Peaks(indTr)==1) > 0 
        handles = guidata(gcf);
        set(handles.autoCalc, 'Value', 0);
    end
    ter_refreshPlot;   

% --- Executes on mouse press over axes background.
function ecgPlot_ButtonDownFcn(hObject, ~, ~)
    % hObject    handle to ecgPlot (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    coordinates = get(gca,'CurrentPoint'); 
    coordinates = coordinates(1,1:2);
    global markerPos;
    global cardiodata;
    global samplingrate;
    global ECG;
    global PPG_;

    hf = get(hObject,'parent');
    button = get(hf,'selectiontype');
    handles = guidata(gcf);
    cMode = get(handles.clickmode,'value');
    range = round(str2num(get(handles.range,'string'))/2)*(samplingrate/1000);
    markerPos = round(coordinates(1),3); 
    
    
    %find closest value to the markerPos in Time channel 
    index = interp1(cardiodata.Time, 1:length(cardiodata.Time), coordinates(1), 'nearest'); 
    
    if get(handles.radiobutton15, 'value') == 1
         [~,Ind] = max(ECG(index-range:index+range));
     else
         [~,Ind] = max(PPG_(index-range:index+range)); 
     end

    if cMode == 1
        set(handles.autoCalc, 'Value', 0);
         switch button
             case  'normal' %left click        
                  snippet = cardiodata.ECG_Peaks(index-range:index+range);   
                  snippet(Ind) = 1;
                  cardiodata.ECG_Peaks(index-range:index+range)=snippet;    
             case 'alt' %right click
                cardiodata.ECG_Peaks(index-range:index+range) = false(size(range*2,1),1);           
         end
    end


    ter_refreshPlot;

% --- Executes on button press in cursorLeft.
function cursorLeft_Callback(~, ~, ~)
    % hObject    handle to cursorLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    cursorLeftRight(-1);

% --- Executes on button press in cursorRight.
function cursorRight_Callback(~, ~, ~)
    % hObject    handle to cursorRight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    cursorLeftRight(1);

function cursorLeftRight(direction)
    global markerPos;
    global cardiodata;
    global samplingrate;
    handles = guidata(gcf);
    step = get(handles.radiobutton1, 'value') + ...
    get(handles.radiobutton2, 'value')* 5 + ... 
    get(handles.radiobutton3, 'value') * 10 + ...
    get(handles.radiobutton4, 'value') * 20;   
    direction = step * direction / samplingrate;  
    if markerPos+direction <= cardiodata.Time(end) && markerPos+direction >= cardiodata.Time(1)
        markerPos = markerPos + direction;    
        ter_refreshPlot;
    end
        
% --- Executes on button press in checkbox2.
function autoCalc_Callback(~, ~, ~)
    % hObject    handle to checkbox2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA) 
    ter_refreshPlot;

% --- Executes on button press in recalculate.
function recalculate_Callback(~, ~, ~)
    % hObject    handle to recalculate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    recalculate;

function recalculate
    handles = guidata(gcf);
    set(handles.autoCalc, 'Value', 1);
    ter_refreshPlot;


% --- Executes on button press in firstTrial.
function firstTrial_Callback(~, ~, ~)
    % hObject    handle to firstTrial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    firstLastTrial(-1);

% --- Executes on button press in lastTrial.
function lastTrial_Callback(~, ~, ~)
    % hObject    handle to lastTrial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    firstLastTrial(1);


% --- Executes on button press in invertChannel.
function invertChannel_Callback(~, ~, ~)
    % hObject    handle to invertChannel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global ECG;
    ECG = ECG * -1;
    ter_refreshPlot;


% --- Executes on button press in clickmode.
function clickmode_Callback(~, ~, ~)
% hObject    handle to clickmode (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(~, ~, ~)
    % hObject    handle to edit11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, ~, ~)
    % hObject    handle to edit11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function range_Callback(~, ~, ~)
    % hObject    handle to range (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, ~, ~)
    % hObject    handle to range (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end




function PPGMS_Callback(~, ~, ~)
    % hObject    handle to PPGMS (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of PPGMS as text
    %        str2double(get(hObject,'String')) returns contents of PPGMS as a double
    ter_refreshPlot;

% --- Executes during object creation, after setting all properties.
function PPGMS_CreateFcn(hObject, ~, ~)
    % hObject    handle to PPGMS (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function wHeight_Callback(~, ~, ~)
    ter_refreshPlot;



% --- Executes during object creation, after setting all properties.
function wHeight_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function relPos_Callback(~, ~, ~)
    ter_refreshPlot;


% --- Executes during object creation, after setting all properties.
function relPos_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
% --- Executes on button press in jumpto.
function jumpto_Callback(hObject, eventdata, handles)
% hObject    handle to jumpto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jumpTo;


function jumpTo
     dlgChoice = ter_jumpDialog;
     if ~isempty(dlgChoice)
            global markerPos;
            global ind_trial;
            global windowBegin;
            global windowEnd;
            global cardiodata;
            global ECG;
           ind_trial = dlgChoice;
            markerPos = 1;  
            indTr = windowBegin(ind_trial):windowEnd(ind_trial);
            tr_data    = ECG(indTr);
            tr_time    = cardiodata.Time(indTr);
            ter_refreshPlot;     
    end
    
function dlgChoice = ter_jumpDialog()
    global nTrial;
    optionList = cellfun(@(x) sprintf('%d',x),...
      num2cell(1:nTrial),'UniformOutput',false);
    
  
    global dlgChoice0;
    global dlgChoice;
    dlgChoice0 = 1;
    dlgChoice  = [];
    d = dialog('Position',[800 500 240 100],'Name','Jump to trial N');
    % add buttons for ok an cancel (cancel shall return empty choice) set
    % control elements
    txt_label = uicontrol('Parent',d,...
      'Style','text',...
      'Position', [0 80 240 20] ,...
      'String','Trial N'); %#ok<NASGU>

      % use last parameter set or a set of default values to define vars
    popup_comp = uicontrol('Parent',d,...
      'Style','popup',...
      'Position',[40 60 160 20],...
      'String',optionList,...
      'Value',find(ismember(optionList,'1')),...
      'Callback',@(es,ed) ter_setChoice0(es.Value));   %#ok<NASGU>
  
    btnCancel   = uicontrol('Parent',d,...
      'Position',[  10 10 110 40],...
      'String','Cancel',...
      'Callback',@(es,ed) delete(d)); %#ok<NASGU>
    btnOK = uicontrol('Parent',d,...
      'Position',[ 120 10 110 40],...
      'String','OK',...
      'Callback',@(es,ed) ter_setChoice(d));
  
    
    uicontrol(popup_comp);
    
    % Wait for d to close before running to completion   
    uiwait(d);


% --- Executes on button press in jumptime.
function jumptime_Callback(hObject, eventdata, handles)
% hObject    handle to jumptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samplingrate;
global cardiodata;
global markerPos;
global ind_trial;
global windowBegin;
global windowEnd;
global cardiodata;
global ECG;
           
try
    answer = str2double(inputdlg('Time (seconds)'))*samplingrate;
    currTrial = interp1(double(windowBegin+cardiodata.Time(1)*samplingrate),1:length(windowBegin),double(answer),'previous');
    markerPos = 1;  
    indTr = windowBegin(currTrial):windowEnd(currTrial);
    tr_data    = ECG(indTr);
    tr_time    = cardiodata.Time(indTr);
    ind_trial = currTrial;
    ter_refreshPlot;     
catch ME
    warndlg('Please, enter correct time');
end
