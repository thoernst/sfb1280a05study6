function exportEDA(EDAfile, timeStart, timeStop, varargin)
% Use this function to export the computed EDA's to an Excel file. Only the
% largest EDA is exported per trial.
% By default this function creates an Excel file with one EDA per trial
% and optional as many Excel files as optional positions were specified.
% These files only print EDA values for a trial, if the special position
% occured in the trial.
%
% Optional parameters can be added such as:
%
%   * trialDef  : Define each trial by numbers as an additional
%                 parameter to make the analysis easier. Please only
%                 numbers !!!
%   * path      : Define the output path for the resulting Excel files
%                 without trainling backslash!

% Tobias Otto
% 1.2
% 16.01.2013

% 13.12.2012, Tobias: first draft
% 10.01.2013, Tobias: Bugfix in timeStart, timeStop computation
% 16.01.2013, Tobias: conversioon for SPSS

%% Load data
load(EDAfile);
resPath = fileparts(EDAfile);

%% Init variables
trials      = 1:length(out.edaRes);
numSPos     = size(out.sPosTime,2);

%% Parse additional arguments
i=1;
while(i<=length(varargin))
    switch lower(varargin{i})
        case 'trialdef'
            i           = i+1;
            trialDef	= varargin{i};
            i           = i+1;
        case 'path'
            i           = i+1;
            resPath     = varargin{i};
            i           = i+1;
        otherwise
            disp('This following argument is not defined:');
            disp(varargin{i});
            i = i+1;
    end
end

%% Check input arguments
if(exist('trialDef','var') && length(trialDef) ~= out.numTrials)
    error('The length of the trial definitions doesn''t match the number of trials');
end

%% Find max EDA for each trial
for i=1:length(out.edaRes)
    % Find EDA' for the fiven time range
    index = out.edaRes(i).edaTimeRes >= timeStart & out.edaRes(i).edaTimeRes <= timeStop;
    tmpAmpl     = out.edaRes(i).amplitude(index);
    tmpTime    	= out.edaRes(i).edaTimeRes(index);
    
    if(~isempty(tmpAmpl))
        % Find the max EDA in the given time range
        [edaMax(i), pos]    = max(tmpAmpl);
        edaTime(i)          = tmpTime(pos);    % Time with reference to stimulus onset
    else
        edaMax(i)   = 0;
        edaTime(i)  = 0;
    end
end

%% Separate eda by time and trial
% Init veriables to zero
res         = zeros(1, length(out.edaRes));
tim         = zeros(1, length(out.edaRes));
resSPos     = zeros(numSPos, length(out.edaRes));
timeSPos    = zeros(numSPos, length(out.edaRes));

% Copy eda and time values for each trial
res	= edaMax;
tim	= edaTime;

% And now only trials with special Positions
for i=1:numSPos
    ind             = out.sPosTime(:,i)' >= 0;
    resSPos(i,ind)	= edaMax(ind);
    timeSPos(i,ind)	= edaTime(ind);
end

%% Save result to simple EDA file
% Write header
mat     = [{'Trial'} {'maxEda'} {'time(StimOnset)'}];
% Check for additional parameters
if(exist('trialDef','var'))
    mat = [mat {'Trial definition'}];
end

% Write to file for general EDA
j = 2;
for i=1:length(out.edaRes)
    mat(j,1:3)      = [{trials(i)}, {res(i)}, {tim(i)}];
    % Check for additional parameters
    if(exist('trialDef','var'))
        mat(j,4) = {trialDef(i)};
    end
    j = j+1;
end

% Make it look nice for SPSS
mat = mat';

% Create file name and save
filename = [resPath filesep out.edaFileName '.xls'];
disp(['Saving EDA''s for all trials to: ' filename]);
xlswrite(filename, mat);
disp('done');

%% Save result to EDA file with special positions
for k=1:length(out.sPos)
    clear mat
    % Write header
    mat     = [{'Trial'} {'maxEda'} {'time(StimOnset)'}];
    % Check for additional parameters
    if(exist('trialDef','var'))
        mat = [mat {'Trial definition'}];
    end
    
    % Write to file for general EDA
    j = 2;
    for i=1:length(out.edaRes)
        mat(j,1:3)      = [{trials(i)}, {resSPos(k,i)}, {timeSPos(k,i)}];
        % Check for additional parameters
        if(exist('trialDef','var'))
            mat(j,4) = {trialDef(i)};
        end
        j = j+1;
    end
    
    % Make it look nice for SPSS
    mat = mat';
    
    % Create file name and save
    filename = [resPath filesep out.edaFileName(1:end-4) '_' out.sPos{k}.name '.xls'];
    disp(['Saving EDA''s for all trials to: ' filename]);
    xlswrite(filename, mat);
    disp('done');
end