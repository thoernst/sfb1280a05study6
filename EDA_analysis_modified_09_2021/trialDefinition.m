%% EDA Analysis - Trial configuration file
% Use this function to control the analysis of the plotEDATrial program.
% Set start points for each trial and stimulus onsets, etc.
%
% The raw data must be in a separate *.mat file that is loaded first in the
% plotEDATrial program.
%   * The variable containing the raw EDA data has to be called 'data' and
%     has to be a n x 1 double vector
%   * The variable contain the units for the x axis has to be called xUnits
%     and has to be a string as well (e.g. 'Milliseconds')
% 	* The variable containing the for the y axis has to be called yUnits
% 	  and has to be a string (e.g. 'Volts')
%
% After loading the raw data the trial definition file has to be loaded.

% Tobias Otto
% 1.2
% 13.08.2014

% 07.12.2012, Tobias: first draft
% 31.01.2013, Tobias: added trialStart/Stop as optional trial separation
% 13.08.2014, Tobias: more user info; added support for other recording
%                     systems

%% Please never rename variables !!!

%% Enter the number of trials
numTrials = 9;

%% Trial separation
% Enter the start time of the first, second, third, ... and last trial AND
% the time when the last trial ends.
% plotEDATrial uses these values to 'cut' the recorded EDA data into trial
% pieces.
%
% If your recording started with the first trial of the presentation
% program the first entry should be 0.
%
% PLEASE don't forget the last entry: the time when the last trial ends
%
% All time entries are entered in seconds
trialSep = [0 15 30 45 60 75 90 105 120 135];

% ====>>> OR <<<====
% Use the variables trialStart and trialStop to 'cut' a long recording into
% trials or subtrials. Sometimes only special parts of a recording are
% needed for analysis. Use this two variables otherwise leave them empty.
%
% If these variables are used the variable trialSep needs to be empty !!!
% triaSep = [] !!! Otherwise an error occurs.
trialStart  = [];
trialStop   = [];


%% Stimulus onset
% Enter the time of the stimulus when it first appeared on the screen
% Stimulus presentation is presented red in the plot
%
% All time entries are entered in seconds
stimOnset = [7.4 18.3 37 49.2 61.9 77 99.9 110 128];

%% Marking positions in trials
% If you want to mark special positions in time when plotting the EDA you
% can define the time, the color of the marker and the name here.
% These entries have no influence of the EDA analysis, BUT each entry here
% will result in an extra Excel file when using exportEDA.
%
% Each marker needs three entries:
%   * Positions in time (all entries in seconds). If a marker doesn't exist
%     in a trial it has to be marked as -1 for that trial.
%   * A name of the marker
%   * Color of the marker
%               'y' --> [1 1 0] --> yellow
%               'm' --> [1 0 1] --> magenta
%               'c' --> [0 1 1] --> cyan
%               'g' --> [0 1 0] --> green
%               'b' --> [0 0 1] --> blue
%               'w' --> [1 1 1] --> white
%               'k' --> [0 0 0] --> black

% First marker: subject answer
sPos{1}.time    = [-1 18.9 38.5 50.5 65 78.5 103 111.1 -1];
sPos{1}.color   = 'g';
sPos{1}.name    = 'Answer';

% Second marker: Punishment
% sPos{2}.time    = [13.3 -1 42.3 -1 71.9 -1 104 116.3 -1];
% sPos{2}.color   = 'm';
% sPos{2}.name    = 'Punishment';

% Use sPos{3} to add markers

%% Sampling rate of your setup
% Enter sampling rate for the EDA recording in HZ
samplRate = 1000;

%% Define recording system
% This defines handling and computation of the raw data that are loaded
% into the plotEDATrial program.
%
% Use only the following entries:
% For a Biopac recording system (GSR100C)   --> 'GSR100C'
% For a BrainVision Recorder system      	--> 'VisionRecorder'
recordingSystem = 'VisionRecorder';
