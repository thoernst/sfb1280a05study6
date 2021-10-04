clearvars
addpath /opt/MATLAB/toolbox_ter/
fp0 = '/media/diskEvaluation/Evaluation/sfb1280a05study6/derivatives/EDAevaluation';
flist = ter_listFiles(fullfile(fp0,''),'*_EDA_EDA.mat');

 warning('off',    'MATLAB:xlswrite:AddSheet');
 fname = fullfile(fp0,strcat('EDAresults_', date, '.xlsx'));
 edaRes_all = []; 
 
 
 
for i=1:numel(flist)
  [~,subject,~] = ter_fparts(flist{i},3);
  [~,currentfile,~] = ter_fparts(flist{i},1);
  fprintf('Reading file %d od %d (%s)...\n',i,numel(flist), currentfile);
  clearvars edaRes out
  load(flist{i},'out');
  [fp,fn,~] = fileparts(flist{i});
 
  
  edaRes    = struct2table(out.edaRes(1:numel(out.trialStart)));
  
    %clearing extra variables from table
  edaRes.minTime = [];
  edaRes.minData = [];
  edaRes.maxData = [];
  edaRes.maxTime = [];
  edaRes.reload = [];
  edaRes.edaTimeRes = [];
  edaRes.stimOnset = [];
  
  
  
  
  try
  edaRes.amplitude(cellfun(@isempty,edaRes.amplitude)) = {0};
  catch ME
     
      edaRes.amplitude = num2cell(edaRes.amplitude);
      edaRes.amplitude(cellfun(@isempty,edaRes.amplitude)) = {0};
  end
  nAmp = cellfun(@numel,edaRes.amplitude);
  ind_multi = find(nAmp>1);
  if ~isempty(ind_multi)
    warning('Multiple aplitudes detetected in these trials:');
    disp(ind_multi)
    continue 
  end
  try
    edaRes.amplitude = cell2mat(edaRes.amplitude);
  catch ME
      edaRes.amplitude = zeros(height(edaRes),1);
      disp("No Eda");
  end
  edaRes.log_amp   = log(edaRes.amplitude+1);
  load(strrep(flist{i},'_EDA_EDA.mat','_eventTable.mat'),'eventtable');
  edaRes = [eventtable edaRes]; %#ok<AGROW>
  

  
  
  %adding phase, subject and specific events to the table
  
  %removing brainstim trigger
  if eventtable.event_label(1) == "TIR_BrainStimTrig"
      eventtable(1,:) = [];
      edaRes(1,:) = []; 
  end
  
  try
  event=split(eventtable.event_label,"_phase-");
  PicAndPhase = split(event(:,2),"_");
  phase = PicAndPhase(:,1);
  pic = PicAndPhase(:,2);
  
  CS = split(event(:,1),"_");
  CS = CS(:,2);
 
  pic = split(PicAndPhase(:,2),"stim-Pic");
  pic = pic(:,2);
  catch ME
      CS = [];
      context = [];
      phase = [];
     
      disp('some event labels do not contain full info');
      for i1=1:numel(eventtable.event_label)
        if contains(eventtable.event_label(i1),"phase")
            event=split(eventtable.event_label(i1),"_phase-");
            contextAndPhase = split(event(2),"_");
            phase = vertcat(phase,contextAndPhase(1));
            context= vertcat(context, contextAndPhase(2));
            CS_ = split(event(1),"_");
            CS = vertcat(CS,CS_(2));
        
        else
            %since it's context A cs minus is missing from recall and reinstatement end-1 trial, fixing that
            CS = vertcat(CS,"CSminus");
            context = vertcat(context,"Context A");
            phase = vertcat(phase,phase(end));
        end
      end
  end
  edaRes{:,'Phase'} = string(phase);
  edaRes{:,'CS'} = string(CS);
  edaRes{:,'Picture'} = string(pic);
  edaRes{:,'Subject'} = string(subject);
  edaRes{:,'Event'} = cellfun(@(s)s(1:3),eventtable.event_label,'UniformOutput',false);
    
  
  
  edaRes_all = vertcat(edaRes_all, edaRes);
end
 fprintf('writing results to file:\n   %s\n',fname)
  writetable(edaRes_all,fname,'Sheet','EDAresults');
warning('on',    'MATLAB:xlswrite:AddSheet');