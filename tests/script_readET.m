fp0 = '/media/diskEvaluation/Evaluation/sfb1280a05study6/misc/Logs';
fl = ter_listFiles(fp0,'*.asc',0);
fl = fl(contains(fl,'sub-EN07IT24'));


%for i=1:numel(fl)
  i=1;
  txtET = fileread(fl{i});
  
  % example: "SAMPLES	GAZE	LEFT	RIGHT	RATE	 500.00"
  tmp = regexp(txtET,'SAMPLES\t\s*GAZE[A-Z\s]*(?<sf>[0-9\.]*)','names');
  et_info.SamplingFrequency = str2double(tmp.sf);
  et_info.StartTime = nan;
  et_info.Manufacturer = "SR-Research";
  et_info.ManufacturerModelName = "Eyelink 1000";
  et_info.Columns = {
    'position_horizontal_left';
    'position_vertical_left';
    'pupilsize_left';
    'position_horizontal_right';
    'position_vertical_right';
    'pupilsize_right';
    'flags'
    'fixation_left'
    'fixation_right'
    'sacchade_left'
    'sacchade_right'
    'blink_left'
    'blink_right'
    };
  
  tmp = regexp(txtET,'START\t(?<starttime>[0-9]*)','names');
  starttime = str2double(tmp.starttime);
  tmp = regexp(txtET,['\n'...
    '(?<time>[0-9]*)\t\s*'...
    '(?<xpl>[\-0-9\.]*)\t\s*'...
    '(?<ypl>[\-0-9\.]*)\t\s*'...
    '(?<psl>[\-0-9\.]*)\t\s*'...
    '(?<xpr>[\-0-9\.]*)\t\s*'...
    '(?<ypr>[\-0-9\.]*)\t\s*'...
    '(?<psr>[\-0-9\.]*)\t\s*'...
    '(?<flags>[I\.][C\.][R\.][C\.][R\.])'],'names');
  ettab = struct2table(tmp);
  f2d = {'time','xpl','ypl','psl','xpr','ypr','psr'};
  for j=1:numel(f2d)
    ettab.(f2d{j}) = str2double(ettab.(f2d{j}));
  end
  
  %a=regexp(txt0,'SFIX');
  %b=regexp(txt0,'EFIX');
  %if numel(a)~= numel(b)    
  %  warning('number of fixation starts and ends not equal')
  %end
  
  ev2query = {
    'fixL' 'EFIX\s*L\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
    'fixR' 'EFIX\s*R\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
    'sacL' 'ESACC\s*L\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
    'sacR' 'ESACC\s*R\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
    'blkL' 'EBLINK\s*L\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
    'blkR' 'EBLINK\s*R\s*(?<tstart>[\-0-9\.]*)\s*(?<tstop>[\-0-9\.]*)';
  };
  for j=1:size(ev2query,1)
    tmp = struct2table(regexp(txtET,ev2query{j,2},'names'));
    tmp.tstart = str2double(tmp.tstart); 
    tmp.tstop  = str2double(tmp.tstop);
    ettab.(ev2query{j,1}) = zeros(size(ettab,1),1);
    for k=1:numel(tmp.tstart)
      ind = ettab.time >= tmp.tstart(k) & ettab.time <= tmp.tstop(k);
      ettab.(ev2query{j,1})(ind)=1;
    end
  end
  ettab.time = ettab.time./1e3; % transfer time in seconds
  
  % gether the events
  tmp =regexp(txtET,'\nMSG	(?<onset>[0-9]*) TRIALID TRIAL (?<trialindex>[0-9]*)','names');
  events = struct2table(tmp);
  events.onset = str2double(events.onset)/1e3;
  tmp = regexp(txtET,'\nMSG	(?<trialendtime>[0-9]*) SYNCTIME_End','names');
  tmp = struct2table(tmp);
  tmp.trialendtime = str2double(tmp.trialendtime)/1e3;  
  events.duration = (tmp.trialendtime-events.onset);
  

  et = readtable('/media/diskEvaluation/Evaluation/sfb1280a05study6/rawdata/sub-EN07IT24/ses-1/beh/sub-EN07IT24_ses-1_task-fear_run-1_events.tsv',...
    'filetype','text','delim','tab','treat','n/a')
  et1 = et(ismember(et.trial_type,'Trial'),:)
  

  relTimes = events.onset-starttime/1e3-et1.onset;
  resTemp = 1/et_info.SamplingFrequency; %  temporal resolution in seconds
  relTime = mean( relTimes((relTimes>= median(relTimes)-5* resTemp) & ...
    (relTimes<= median(relTimes)+5* resTemp)));
  relTime = round(relTime/resTemp)*resTemp;
  
  et_info.StartTime = relTime;
  
  ter_savePrettyJson(fn_json,et_info);
  ettab.time = [];
  writetable(ettab,fn_tsv,'fileType','text',...
      'delim','tab','writeVar',0);
  txt1 = fileread(fn_tsv);
  txt2 = strrep(txt1,'NaN','n/a');
  if not(isequal(txt1,txt2))
    fid=fopen(fn_tsv,'w');
    fprintf(fid,txt2);
    fclose(fid);
  end
  
  
  times = (starttime:2:max(tmp.time))';
  times = times(not(ismember(times,tmp.time)));
  ind2 = size(tmp,1) + (1:numel(times))';
  tmp.time(ind2) = times;
  tmp.left_pos_h(ind2) = nan(numel(times),1);
  tmp.left_pos_v(ind2) = nan(numel(times),1);
  tmp.left_parea(ind2) = nan(numel(times),1);
  tmp.right_pos_h(ind2) = nan(numel(times),1);
  tmp.right_pos_v(ind2) = nan(numel(times),1);
  tmp.right_parea(ind2) = nan(numel(times),1);
  tmp.right_parea(tmp.right_parea==0) = nan;
  tmp.left_parea(tmp.left_parea==0) = nan;
  tmp=sortrows(tmp,'time');
  plot(tmp.time,tmp.right_parea);hold on;
  plot(tmp.time,tmp.left_parea);hold on;
  
  clf
  plot(tmp.left_pos_h,tmp.left_pos_v);hold on
  plot(tmp.right_pos_h,tmp.right_pos_v)
  
  eyedata = tmp;
  
  
  tmp =regexp(txtET,'\nMSG	(?<onset>[0-9]*) TRIALID TRIAL (?<trialindex>[0-9]*)','names');
  events = struct2table(tmp);
  events.onset = str2double(events.trialtime)/1e3;
  tmp = regexp(txtET,'\nMSG	(?<trialendtime>[0-9]*) SYNCTIME_End','names');
  tmp = struct2table(tmp);
  tmp.trialendtime = str2double(tmp.trialendtime)/1e3;  
  events.duration = (tmp.trialendtime-events.onset);
  
  tmp = struct2table(regexp(txtET,...
    '\nMSG\s*\d*\s*SYNCTIME_StartIn50ms_TRIAL\d*_(?<triallabel>[a-zA-Z0-9\.\_\-]*)',...
    'names'));
  
  %\nSYNCTIME_StartIn50ms_TRIAL3_ses-1_run-1_acq-habituation_trial-3_CSmOnly
  events.trial_type = tmp.triallabel;
  
  
  el = logdata.(strrep(fn,'-','_')).eventList;
  el = el(not(ismember(el.Code,{'','1'})));
  ind_tstart = find(ismember(el.Code,'trial start'));
  ind_cs     = ind_tstart + 1 ;
  
  
  
  resTemp = 0.002; % 2 ms temporal resoulution 
  relTime = mean( relTimes((relTimes>= median(relTimes)-5* resTemp) & ...
    (relTimes<= median(relTimes)+5* resTemp)));
  relTime = round(relTime/resTemp)*resTemp;
  round(mean( relTime((relTime>= median(relTime)-5* resTemp) & ...
    (relTime<= median(relTime)+5*resTime.002) )))
  
  events.onset-starttime/1e3
  
  
  
  %% flags
  %first character is "I" if sample was interpolated 
  %second character is "C" if LEFT CR missing     
  %third  character  is  "R"  if LEFT CR recovery in progress  
  %fourth character is "C" if RIGHT CR missing      
  %fifth character is "R" if RIGHT CR recovery in progress
  
  