% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Tobias Otto
% 2.1
% 23.03.2015

% 29.11.2012, Tobias: separate file
% 07.12.2012, Tobias: added "trial configuration" file
% 11.12.2012, Tobias: added return statement in case no file is selected
% 03.01.2013, Tobias: replaced parseTrialDefinition by run
% 04.01.2013, Tobias: added check for optional argument sPos
% 08.01.2013, Tobias: more error checking
% 31.01.2013, Tobias: added error checking for new trialStart and trialStop option
% 13.08.2014, Tobias: sample rate from trialDefinition file is used
% 23.09.2014, Tobias: multiplied Brainvision data with -1, because
%                     Brainvision uses EEG notation
% 24.09.2014, Tobias: save configFile path as well and cosmetics for
%                     loading new data
% 26.02.2015, Tobias: Adjustments due to new format in Biopac data
% 23.03.2015, Tobias: Added option to load data that's not labeled GSR100C
% 2020-01-13: TME: clearing global variable out set right, making channel
%                  name search case insensitive using lower()

%% Clear old variable to start from scratch
%global out
%clear out
clear('global','out')

% Clean axes as well
set(handles.axes1, 'XLim', [0 1], 'XTick', [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1], ...
    'YLim', [0 1], 'YTick', [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);

% %edit by thomas
% set(handles.figure1, 'units', 'normalized', 'position', [0.0 0.0 1.5 1.5])
%% Init variables
global out

go      = 1;
good    = 0;

%% Get filenames and load data
% Get EDA data
[edaFile,p] = uigetfile('*.mat', 'Select EDA file');
if(p == 0)
    return
end
load([p,edaFile])
edaFilePath = p;

% Get trial configuration file
[configFile,p] = uigetfile('*.m', 'Select result file', p);
if(p == 0)
    return
end
eval(fileread(fullfile(p,configFile)));
%run([p, configFile]);
configFilePath = p;

%% Check user input
if(~isempty(trialSep))
    if(numTrials+1 ~= length(trialSep))
        fid = warndlg(['The number of trials does NOT fit to the number of trial separators. ' ...
            ' ' ...
            'numTrials+1 bust be equal to the number of trial separators.']);
        waitfor(fid);
        go = 0;
    end
    
    % Check consistency of time entries
    if(~all(diff(trialSep) > 0))
        fid = warndlg(['Check trial separation (time entries) for consistency! ' ...
            ' ' ...
            'One or more entries are wrong. I give up! Please correct and try again.']);
        waitfor(fid);
        go = 0;
    end
end

if(~isempty(trialStart) || ~isempty(trialStop))
    if(length(trialStart) ~= length(trialStop))
        fid = warndlg(['The number of entries in trialStart and trialStop' ...
            'are not equal. I give up!']);
        waitfor(fid);
        go = 0;
    end
    
    if(length(trialStart) ~= numTrials)
        fid = warndlg(['The number of entries in trialStart and trialStop' ...
            'are not equal to the values entered in numTrials. I give up!']);
        waitfor(fid);
        go = 0;
    end
end


if((~isempty(trialStart) || ~isempty(trialStop)) && ~isempty(trialSep))
    fid = warndlg(['Please double check your trial definition file!' ...
        ' ' ...
        'The variables  trialStart, trialStop and trialSep exist. This is not valid', ...
        'Please only use trialSep and leave the others empty or use trialStart and trialStop', ...
        'and leave trialSep empty. I give up!']);
    waitfor(fid);
    go = 0;
end

% Does optional variable sPos exist?
if(exist('sPos','var') == 0)
    sPos = [];
end

%% Compute "real" value of EDA Data for BIOPAC systems
% We recorded the EDA with HP filter of 0.05Hz
% Therefore we have to adjust the measured values according to the
% guidelines described in the GSR100C handbook:
%
% In the scaling window, set the input voltages so they map to the �0.05 Hz� conductance ranges indicated by
% the sensitivity setting. For example if the GSR100C is set to a Gain of 5 ?mho/V, then 0 V will map to X
% ?mhos and 1V will map to (X+5) ?mhos. Where �X� is the mean conductance being recorded.


% EDIT TER : modified section. original reads
% if(strcmpi(recordingSystem, 'GSR100C'))
%     % First try to get the EDA data out of the MATLAB file created by
%     % AcqKnowledge. First try with string 'GSR100C', because that's what we
%     % use. 
%     for i=1:size(labels,1)
%         if(~isempty(strfind(labels(i,:), 'GSR100C')))
%             good = 1;
%             break
%         end
%     end
%     % If that still doesn't work take the first vector from the data
%     % variable!
%     if(good == 0)
%         i	= 1;
%         fid = warndlg(['No matching label "GSR100C" found in your data! ' ... 
%             'Using data with label "' labels(i,1:end-1) '" !!!']);
%         waitfor(fid);
%     end
%         
%     % Copy only the EDA data into variables
%     data = data(:,i);
%     
%     data        = data*5+mean(data);
%     xUnits      = isi_units;
%     yUnits      = units;
%     edaAdjusted = 'YES -> data*5+mean(data)';
%     go          = 1;


if (strcmpi(recordingSystem, 'EDA100C-MRI'))
    % First try to get the EDA data out of the MATLAB file created by
    % AcqKnowledge. First try with string 'GSR100C', because that's what we
    % use. 
    preferredLabels = {'eda100c_mri_bandpass','eda100c_mri',...
      'eda100c-mri-bandpass','eda100c-mri'};
    
    for j=1:numel(preferredLabels)
      for i=1:size(labels,1) %#ok<NODEF>
        if(~isempty(strfind(lower(labels(i,:)), preferredLabels{j})))
          good = 1;
          break
        end
        if good
          break
        end
      end
    end
    % If that still doesn't work take the first vector from the data
    % variable!
    if(good == 0)
        i	= 1;
        fid = warndlg(...
          ['No matching label "EDA100C-MRI" found in your data! ' ... 
            'Using data with label "' labels(i,:) '" !!!']);
        waitfor(fid);
    end
        
    % Copy only the EDA data into variables
    data = data(:,i); %#ok<NODEF>
    
    data        = data*5+mean(data);
    xUnits      = isi_units;
    yUnits      = units;
    edaAdjusted = 'YES -> data*5+mean(data)';
    go          = 1;

elseif(strcmpi(recordingSystem, 'GSR100C'))
    % First try to get the EDA data out of the MATLAB file created by
    % AcqKnowledge. First try with string 'GSR100C', because that's what we
    % use. 
    for i=1:size(labels,1)
        if(~isempty(strfind(labels(i,:), 'GSR100C')))
            good = 1;
            break
        end
    end
    % If that still doesn't work take the first vector from the data
    % variable!
    if(good == 0)
        i	= 1;
        fid = warndlg(['No matching label "GSR100C" found in your data! ' ... 
            'Using data with label "' labels(i,1:end-1) '" !!!']);
        waitfor(fid);
    end
        
    % Copy only the EDA data into variables
    data = data(:,i);
    
    data        = data*5+mean(data);
    xUnits      = isi_units;
    yUnits      = units;
    edaAdjusted = 'YES -> data*5+mean(data)';
    go          = 1;
    
elseif(strcmpi(recordingSystem, 'Visionrecorder'))
    edaAdjusted = 'NO -> only imported';
    go          = 1;

else
    fid = warndlg(['The defined recording system "' recordingSystem ...
        '" does not exist in my configuration. I give up!']);
    waitfor(fid);
    go = 0;
end

%% Check, if loaded data are valid
% Not a strong check, but better than nothing

if(~exist('data', 'var') && ~isnumeric(data))
    fid = warndlg('The MATLAB file does NOT contain valid EDA data. I give up!');
    waitfor(fid);
    go = 0;
end

if(~exist('xUnits', 'var') && ~ischar(xUnits))
    fid = warndlg('The MATLAB file does NOT contain valid xUnits data. I give up!');
    waitfor(fid);
    go = 0;
end

if(~exist('yUnits', 'var') && ~ischar(yUnits))
    fid = warndlg('The MATLAB file does NOT contain valid yUnits data. I give up!');
    waitfor(fid);
    go = 0;
end

%% Create global struct
out.numTrials       = numTrials;
out.trialSep        = trialSep;
out.trialStart      = trialStart;
out.trialStop       = trialStop;
out.stimOnset       = stimOnset;
out.sPos            = sPos;
out.sampRate        = samplRate;
out.edaFileName     = edaFile;
out.edaFilePath     = edaFilePath;
out.configFilePath  = configFilePath;
out.configFileName  = configFile;
out.eda             = data;
out.edaAdjusted     = edaAdjusted;
out.i               = 1;
out.xlabel          = xUnits;
out.ylabel          = yUnits;
out.handles         = handles;
out.edaMinTime      = [];
out.edaMaxTime      = [];
out.edaMinData      = [];
out.edaMaxData      = [];
out.edaTimeRes      = [];


%% Call "plot function" to compute first EDA
if(go == 1)
    computeData2Plot;
end