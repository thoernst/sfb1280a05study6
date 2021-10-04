function res = computeEDA(data, time, maskWindow, maxVal, stimTime, filterNumerator)
% Computes tha EDA

% Tobias Otto
% 1.6
% 24.03.2015

% 18.09.2012, Tobias: first draft
% 19.09.2012, Tobias: added more robust time windows
% 21.11.2012, Tobias: new relative maxima computation
% 22.11.2012, Tobias: new output 
% 23.11.2012, Tobias: deleted text infos -> now handled by listbox
% 26.11.2012, Tobias: added amplitude to output struct, no command window output
% 24.03.2015, Tobias: added round to avoide error messages in command window
%                     bugfix: sampling rate was still hard coded in one line

%% Init variables
global out;
orig = data;

%% Filter and compute data
% Filter data
data = filter(filterNumerator, 1, data);

% Remove time shift due to filtering in the beginning
% Remove additional data in the end
data(1:round(length(filterNumerator)/2)) = [];
data(end-(round(length(filterNumerator)/2))+1:end) = [];

%% Compute EDA
% Get maxima and minima
L           = extr(data);
maxima      = find(L{1});
minima      = find(L{2});

% disp(['Minima: ' num2str(minima')])
% disp(['Maxima: ' num2str(maxima')])

% Check vectors
if(minima(1) == 1)
    minima(1)   = [];
    maxima(1)   = [];
%     disp('Deleted minima(1) AND maxima(1)');
elseif(maxima(1) == 1)
    maxima(1)   = [];
%     disp('Deleted maxima(1)');
end

% local minimum required at first extrema
if isempty(maxima) || isempty(minima)
    minima   = [];
    maxima   = [];
elseif(length(minima) > length(maxima) && minima(1) < maxima(1))
    minima(end) = [];
%     disp('Deleted minima(end)');
end

if isempty(maxima) || isempty(minima) %Modified at 22.11.18 by Thomas Ernst
    minima   = [];
    maxima   = [];
elseif(length(maxima) > length(minima) && maxima(1) < minima(1))
    maxima(1) = [];
%     disp('Deleted maxima(1)');
end

% Only use these extrema where the y value between max and min is bigger
% than defined in "minimal Y"
index   = abs(data(maxima)-data(minima)) > maxVal;
maxima  = maxima(index);
minima  = minima(index);

% Only use these extrema where the x value between local min and local max
% is bigger than defined in "minimal X"
index   = (maxima-minima)/out.sampRate > maskWindow;
maxima  = maxima(index);
minima  = minima(index);

% disp(['Minima: ' num2str(minima')])
% disp(['Maxima: ' num2str(maxima')])

%% Remap index to time
if(~isempty(minima) || ~isempty(maxima))
    minTime     = time(minima);
    maxTime     = time(maxima);
    minData     = orig(minima);
    maxData     = orig(maxima);
else
    minTime     = [];
    maxTime     = [];
    maxData     = [];
    minData     = [];
end

%% Create output struct
res.minTime     = minTime;
res.maxTime     = maxTime;
res.minData     = minData;
res.maxData     = maxData;
res.amplitude   = maxData-minData;
res.stimOnset   = stimTime;
res.edaTimeRes  = res.minTime-res.stimOnset;     % Start time of EDA peak with reference to stimulus onset
res.reload      = 0;
