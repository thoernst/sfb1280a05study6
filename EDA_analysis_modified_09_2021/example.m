%% Examle for exportEDA

% Define result file from plotEDATrial for VP11
% Define result file from experiment (MUST match with the EDA result file!!)
% Set time window from 4s to 8s after stimulus onset
EDAfile     = 'Y:\Julia Schmid\Experimente\Auswertung\Pilot_Lernen_Ton vs Schmerz\EDA-Analysis2\23_ac_EDA.mat';
timeStart   = 1;
timeStop    = 3.999999999999999;
% Start processing
exportEDA(EDAfile, timeStart, timeStop, 'path', 'Y:\Julia Schmid\Experimente\Auswertung\Pilot_Lernen_Ton vs Schmerz\EDA-Analysis2\Results_Acq');


EDAfile     = 'Y:\Julia Schmid\Experimente\Auswertung\Pilot_Lernen_Ton vs Schmerz\EDA-Analysis2\23_ac_EDA.mat';
timeStart   = 4;
timeStop    = 9.999999999999999;
% Start processing
exportEDA(EDAfile, timeStart, timeStop, 'path', 'Y:\Julia Schmid\Experimente\Auswertung\Pilot_Lernen_Ton vs Schmerz\EDA-Analysis2\Results_TS');



%% Again an example, but now with optional parameters
% The parameter 'trialDef' adds one column to the Excel sheet for a better
% analysis of the trials in other programs.
% EDAfile     = 'D:\Temp\EDA\3163CM\EDA\3163CM_rec_999_EDA.mat';
% timeStart   = 4;
% timeStop    = 8;
% exportEDA(EDAfile, 2, 6, 'trialDef', [2 1 7 2 1 4 3 2 1]);

%% Again an example, with optional parameters
% The parameter 'trialDef' adds one column to the Excel sheet for a better
% analysis of the trials in other programs.
% EDAfile     = 'D:\Temp\EDA\3163CM\EDA\3163CM_rec_999_EDA.mat';
% timeStart   = 4;
% timeStop    = 8;
% exportEDA(EDAfile, 1, 7, 'trialDef', [1 1 2 2 2 1 1 3 3], 'path', 'D:\Temp\EDA\3163CM\EDA');