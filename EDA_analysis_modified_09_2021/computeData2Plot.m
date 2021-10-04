function computeData2Plot
% Computes everything that is needed to plot the raw EDA trial based

% Tobias Otto
% 1.5
% 15.08.2014

% 11.09.2012, Tobias: first draft
% 19.09.2012, Tobias: added more control for analysis
% 10.12.2012, Tobias: adaptation for the general EDA analysis
% 04.01.2013, Tobias: added check for optional argument sPos
% 31.01.2013, Tobias: added optional entries trialStart and trialStop
% 15.08.2014, TObias: added additional entry for global start and stop time

%% Init variables
global out

i           = out.i;
data        = out.eda;
sampRate    = out.sampRate;
if(~isempty(out.trialSep))
    startTime   = out.trialSep(i);                  % Trial start time
    stopTime    = out.trialSep(i+1);                % Trial stop time
else
    startTime   = out.trialStart(i);
    stopTime    = out.trialStop(i);
end
stimTime    = out.stimOnset(i)-startTime;   	% Stimulus onset

%% Get filter information
% Compensate error due to filtering
% Load filter coefficients
load filterSet

% Check which filter to use depending in the sampling rate
smrt    = [filt.Fs];
smrt	= abs(smrt-sampRate);
index	= find(smrt == min(smrt));
% Now copy the coefficiants to the variables that was used before!
filterNumerator = filt(index).coeff;

filtError = length(filterNumerator)/sampRate;   % Time in seconds that has to be added at the end. (Data will be deleted in computeEDA)

%% Get data for trial
if(startTime == 0)
    % Let's set start time to 1/samplingrate to get the first sample
    startTime = 1/sampRate;
end

% Get data for special positions to plot
if(~isempty(out.sPos))
    for j=1:length(out.sPos)
        sPosTime(j)	= out.sPos{j}.time(i)-startTime;        	% Start time for special position (e.g. stimulus onset, answering time)
    end
else
    sPosTime = -99;
end
%% Get data for EDA Analysis
% Get data for trial
trialData   = data(round(startTime*sampRate) : round(stopTime*sampRate));
% Compute time (from 0 to defined time)
trialTime   = linspace(0,stopTime-startTime, length(trialData));

% Get data for EDA analysis
edaMaxVal       = str2double(get(out.handles.maxVal,'String'));     % Maximum value on y axis that is needed to set a EDA as valid
edaMaskWindow   = str2double(get(out.handles.maskTime,'String'));   % Masking time that is needed to compute "Sattelpunk"
timeWindowStart = str2double(get(out.handles.timeWindowStart,'String'));
timeWindowStop  = str2double(get(out.handles.timeWindowStop,'String'));

% Time window can't be too long, otherwise it's longer than the trial
% itself. Check and correct if necessary
if(timeWindowStop > (stopTime-startTime-stimTime))
    timeWindowStop = (stopTime-startTime-stimTime);
    set(out.handles.timeWindowStop,'String',num2str(timeWindowStop));
end

% Given time in seconds after stimulus onset
edaData     = data(round((startTime+stimTime+timeWindowStart)*sampRate) : round((startTime+stimTime+timeWindowStop)*sampRate));    % Compute eda from Stimulus presentation until the end
edaTime     = linspace(stimTime+timeWindowStart,stimTime+timeWindowStop, length(edaData));
edaDataWork = data(round((startTime+stimTime+timeWindowStart)*sampRate) : round((startTime+stimTime+timeWindowStop+filtError)*sampRate));

%% Filter and compute data
edaRes = computeEDA(edaDataWork, edaTime, edaMaskWindow, edaMaxVal, stimTime, filterNumerator);

%% Save to global struct
out.edaRes(i)           = edaRes;
out.edaData{i}          = edaData;
out.edaTime{i}          = edaTime;
out.trialData{i}        = trialData;
out.trialTime{i}        = trialTime;
out.stimPresTime(i)     = stimTime;
out.sPosTime(i,:)       = sPosTime;
out.stopTime(i)         = stopTime;
out.startTime(i)        = startTime;
out.timeWindowStart(i)  = timeWindowStart;
out.timeWindowStop(i)   = timeWindowStop;
out.edaMaxVal(i)        = edaMaxVal;
out.edaMaskWindow(i)    = edaMaskWindow;
out.globalTrialStartTime(i)	=  startTime;%(cutout of whole experiment)
out.globalTrialStopTime(i)  =  stopTime;%(cutout of whole experiment)

%% Plot data
plotData