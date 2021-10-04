clearvars
%% this is the full preprocessing script for the behavioral SCR data
% 
% This will transfer the pysio data (stored in mat files in a sourcedata 
% directory) into bids format in an output('rawdata') directory, identify CS
% CS events from the NeuroBS Presentation log files and add this 
% information to the events.tsv file. Then it will prepare the data for RUB
% EDA evaluation (i.e. crate EDA.mat and trialdefinition.m files) and store
% that in the drivatives/EDA folder. If output files already exist for each
% step, the repective steps are skipped. You risk nothing by running this 
% again and again.
%
% firstup a script is presented allowing to rename specific subjects. A
% safety copy will be created before renaming. Again, if the subject was
% already renamed there is nothing lost. Please just keep all the renamed 
% subjects labels listed here for easier documentation
% 
% Modifications: 
%  2020-12-22 : first implementation

%% Important paths needed later on
script_init_study6;
% fp_scr = fileparts(mfilename('fullpath'));
% if isempty(fp_scr)
%   % this happens when you do not run this as a script but step by step from
%   % console. in this case use a hardwired path, You may need to modify it
%   if ispc
%     fp_scr = 'R:\Evaluation\sfb1280a05study6\scripts';
%   else
%     fp_scr = '/media/diskEvaluation/Evaluation/sfb1280a05study6/scripts';
%   end
% end
% fp0    = fileparts(fp_scr);
% fp_d   = fullfile(fp0,'rawdata');
% fp_s   = fullfile(fp0,'sourcedata');
% fp_us  = fullfile(fp0,'sourcefiles_unsorted');
% fp_de  = fullfile(fp0,'derivatives');
% fp_dis = fullfile(fp0,'discarded');
% 
% dl2chk = {fp0,fp_d,fp_s,fp_us,fp_de,fp_dis};
% for i=1:numel(dl2chk)
%   if not(isfolder(dl2chk{i}))
%     mkdir(dl2chk{i});
%   end
% end
% 
% addpath(fullfile(fp_scr,'packages','pspm_v5.0.0'));
% addpath(fullfile(fp_scr,'packages','toolbox_ter'));
% addpath(fullfile(fp_scr,'packages','export_fig'));
% addpath(fp_scr)
% addpath(fullfile(fp_scr,'data_preparation'));


%% sort from unsorted folder
func_sortFromUnsorted(fp_us, fp_s,fp_dis,'move');
% maybe decompressing of dicom files needed here


%% firstup correct datasets were needed
func_correctDataset(fp_s,fp_dis,fp_d);


%% check for availability of python3 
% just needed for nicely formated json files, nothing more right now
func_checkForPython3Availability;


%% convert MATLAB files in sourcedata to current MATLAB version
% v7.7 MATLAB files are compressed, that's convinient for sometimes 
% rather large BIOPAC matlab files
func_convertMatTo7p3(fp_s);


% %% convert dicoms to compressed nii files and sort to BIDS format
% %script_convertDicoms2Bids;
% func_convertDicom2Bids(fp_s,fp_d);
% 
% 
% %% deface anatomicals using pydeface
% func_defaceAnatomicals(fp_d,fp_dis);

%% update ptab table
func_updatePtab(fp_s,fp_d);


%% func readsfb questionnaires
func_readSfbQuestionnaire(fp_s,fp_d);


%% again update ptab table after sfb questionnaire has been read
ptab = func_updatePtab(fp_s,fp_d);


%% read log files to "phase" and "questionnaires" mat files
func_readPresLogs(fp_s,fp_d);


%% read run questionnaires to phenotype tables
%func_readRunQuestionnaires(fp_s,fp_d);


%% convert biopac mat files to bids physio
func_readBiopacMat(fp_s,fp_d);


%% merge physio and log information
%script_convertPhysio;
func_mergePhysioAndLog(fp_d,fp_s);


%% convert eyetrack 2 physio file
func_eyetrack2physio(fp_s,fp_d);


%% remove "trial" events from events table once eyetracking data is synced
func_rmTrialFromEvents(fp_d);


%% add specific json fields to the task json files
func_addJsonFields(fp_d);


%% plot physio data to doublecheck
%ter_plotBIDSPhysData(fp_d);


%% now prepare skin conductance data for RUB EDA evaluation
% might take 5 min or more per subject
func_prepareEda4rub(fp_d,fp_de);
func_checkEDAevents(fp_de);


%% prepare cardio data for cardio eval
func_prepareCardio(fp_d,fp_de);


%% remove mp2rage files to facilitate fmriprep
%func_discardMp2rageFiles(fp_d,fp_dis);


%% set rights properly
evalc(sprintf('!chgrp -R prjsfbstudy6 %s',fp0));
evalc(sprintf('!chmod -R 770 %s',fp_d));
evalc(sprintf('!chmod -R 770 %s',fp_s));
evalc(sprintf('!chmod -R 777 %s',fullfile(fp_de,'EDAevaluation')));
evalc(sprintf('!chmod -R 777 %s',fullfile(fp_de,'cardioEval')));
evalc(sprintf('!chmod -R 777 %s',fullfile(fp0,'misc')));
evalc(sprintf('!chmod 700 %s',fullfile(fp0,'misc','study6_serumlevel.xlsx')));

ptab_tmp = ptab;
ptab_tmp.group = ptab.drug;
ter_groupreport_sexage(ptab_tmp);
clearvars ptab_tmp;
