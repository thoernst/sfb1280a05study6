function func_readRunQuestionnaires(fp_s,fp_d)

  fprintf('\n%s\n%s - reading digital questionnaires data to tables \n',...
    repmat('=',72,1),datestr(now,'yyyy-mm-dd hh:MM:ss'))

  subdirLogs  = 'stimlogs';
  suffix_mat  = '_logdataQuestionnaires.mat';
  
  protocol_labels = {
    'after acquisition (ses-1_run-2)'
    'after extinction (ses-2_run-1)' 
    'after habituation (ses-1_run-1)'
    'after recall (ses-3_run-1)'      
    'after volatile (ses-3_run-2)'   };
%     'Day 1: After Acquisition (Brain Stimulation)'
%     'Day 1: After Extinction (Brain Stimulation)' 
%     'Day 1: After Habituation (Fear)'             
%     'Day 1: After Acquisition (Fear)'                 
%     'Day 1: After Extinction (Fear)'                  
%     'Day 2: After Recall (Fear)'                  };
   
   
  %protocols_bs = protocol_labels (1:2);
  protocols_fc = protocol_labels;
  protocols_temporalOrder = protocol_labels([3,1,2,4,5]);
  
  offset_lickertScale = 1; %lickert scale in questionnaires scales from 0 to 8 instead of 1 to 9

  %fn_bs_tsv = fullfile(fp_d,'phenotype','questions_brainstimulation.tsv');
  fn_fc_tsv = fullfile(fp_d,'phenotype','questions_fearconditioning.tsv');
  
  fn_ptab = fullfile(fp_d,'participants.tsv');
  tsv_param = {'filetype','text','delim','tab','treat','n/a'};
  ptab = readtable(fn_ptab,tsv_param{:});

  %% first loop over all protocol files and read to table tab0
  tab0 = [];
  for i=1:size(ptab,1)
    pID = ptab.participant_id{i};
    ses = struct2cell(dir(fullfile(fp_d,pID,'ses-*')));
    ses = ses(1,:);
    if isempty(ses)
      ses = {''};
    end
    for j=1:numel(ses)
      sID = ses{j};
      fn = fullfile(fp_s,pID,sID,subdirLogs,...
        strrep([pID '_' sID suffix_mat],'__','_'));
      if exist(fn,'file')~=2
        warning('file does not exist: %s',fn)
        break
        %continue
      end
      clearvars logdata;
      load(fn,'logdata');
      fin = fieldnames(logdata);
      for k=1:numel(fin)
        
        if ~isfield(logdata.(fin{k}),'questList')
          continue
        end
        pID2 = logdata.(fin{k}).('participant_id');
        if ~isequal(strfind(pID2,'sub-'),1)
          pID2 = ['sub-' pID2]; %#ok<AGROW>
        end
        if ~isequal(pID,pID2)
          warning('participant ID mismatch: %s %s %s',pID,pID2,fn);
          continue
        end
        tmp = logdata.(fin{k}).('questList');
        tmp = tmp(~ismember(lower(tmp.Result),{'info','skipped',''}),:);
        tmp = tmp(~contains(lower(tmp.Label),...
          {'comments','trainingtrial'}),:);
        tmp.participant_id = repmat({pID},size(tmp,1),1);
        tmp.session = repmat({sID},size(tmp,1),1);
        tmp.time =  repmat({logdata.(fin{k}).('datetime')},size(tmp,1),1);
        tmp.protocol = repmat({logdata.(fin{k}).('protocol')},...
          size(tmp,1),1);
        
        tmp = tmp(:,[end-3:end,1:end-4]);
        if iscell(tmp.TrialN) 
          tmp.TrialN= str2double(tmp.TrialN);
        end
        %removefirst answers to repeated questions and questions skipped
        %after step back
        ind2rm = false(size(tmp,1),1);
        for l=1:size(tmp,1)-1
          if tmp.TrialN(l)>= min(tmp.TrialN(l+1:end))
            ind2rm(l)=true;
          end
        end
        tmp = tmp(~ind2rm,:);
        if isempty(tab0)
          tab0 = tmp;
        else
          tab0 = [tab0;tmp]; %#ok<AGROW>
        end
      end
    end
  end
  tab0.Result = str2double(tab0.Result);
  
  
  
  %% double check questionniare presence
  pIDs = unique(tab0.participant_id);
  for i=1:numel(pIDs)
    pID = pIDs{i};
    ind = ismember(tab0.participant_id,pID);
    tmp = unique(tab0(ind,1:4));
    %tmp = unique(tab0(ind,1:3));
    ind2 = ismember(protocol_labels,tmp.protocol);
    if prod(ind2)==0
      warning('protocols missing for %s :',pID)
      disp(protocol_labels(~ind2));
      disp(tmp)
    elseif ~isequal(tmp.protocol,protocols_temporalOrder)
      warning('temporal order messed up for %s :',pID)
      tmp2 = table(tmp.protocol,protocols_temporalOrder);
      tmp2.Properties.VariableNames = {'detected_order','should_be'};
      disp(tmp2);
      disp(tmp)
    end
  end
  
  
%   %% now identify unique field names for brainstim questionnaires
%   % keep order of question and label approriately
%   for i=1:numel(protocols_bs)
%     ind =ismember( tab0.protocol,protocols_bs(i));
%     mylabels = unique(cellfun(@(x,y) sprintf('%02.0f_%s',x,y),...
%       num2cell(tab0.TrialN(ind)),tab0.Label(ind),'uni',0));
%     mylabels0 = cellfun(@(x) x(4:end), mylabels,'uni',0);
%     for j=1:numel(mylabels0)
%       mylabels{j} = sprintf('bs%d_q%02.0f_%s',i,j,mylabels0{j});
%       ind2 = ismember(tab0.Label,mylabels0{j});
%       tab0.question(ind & ind2) = mylabels(j);
%     end    
%   end
%   ind = ismember( tab0.protocol,protocols_bs);
%   tab1 = tab0(ind,:);
%   pIDs = unique(tab1.participant_id);
%   qIDs = unique(tab1.question);
%   tab_bs = [table(pIDs),array2table(nan(numel(pIDs),numel(qIDs)))];
%   tab_bs.Properties.VariableNames = ['participant_id'; qIDs];
%   for i=1:numel(pIDs)
%     pID = pIDs{i};
%     for j=1:numel(qIDs)
%       qID = qIDs{j};
%       ind1 = find(ismember(tab1.participant_id,pID) & ...
%         ismember(tab1.question,qID));
%       % questions can ba answered twice or more, use the very last answer
%       % only
%       ind1 = ind1(end);
%       if numel(ind1)==1
%         tab_bs.(qID)(i) = tab1.Result(ind1) + offset_lickertScale;
%       else
%         warning('mismatch')
%       end
%     end
%   end
%   % now check wether information is different from previous table, if it is
%   % write to phenotype folder
%   if exist(fn_bs_tsv,'file')==2
%     tab_bs0 = readtable(fn_bs_tsv,tsv_param{:});
%   else
%     tab_bs0 = [];
%   end
%   if ~isequaln(tab_bs,tab_bs0)
%     if ~isfolder(fileparts(fn_bs_tsv))
%       mkdir(fileparts(fn_bs_tsv));
%     end
%     writetable(tab_bs,fn_bs_tsv,tsv_param{1:4});
%     % rename NaN to n/a to comply with BIDS standard
%     txt = fileread(fn_bs_tsv);
%     txt2 = strrep(txt,'NaN','n/a');
%     if ~isequal(txt,txt2)
%       fid = fopen(fn_bs_tsv,'w');
%       fprintf(fid,txt2);
%       fclose(fid);
%     end
%     fprintf('Updated file: %s\n',fn_bs_tsv);
%   end
    
  %% now do the same for fear conditioning questionnaires
  for i=1:size(tab0,1)
    tmp = regexp(tab0.protocol{i},'run-[0-9]*','match');
    try
      tab0.run{i} = tmp{1};
    catch
      tab0.run{i} = '';
    end
  end
  for i=1:size(tab0,1)
    mylabels{i} = regexp(tab0.protocol{i},'run-[0-9]*','match');
    try
      tab0.run{i} = tmp{1};
    catch
    end
  end
  
  
  tab0.run = cellfun(@(x) x{1},tab0.run,'uni',0)
  for i=1:numel(protocols_fc)
    ind =ismember( tab0.protocol,protocols_fc(i));
    mylabels = unique(cellfun(@(x,y) sprintf('%02.0f_%s',x,y),...
      num2cell(tab0.TrialN(ind)),tab0.Label(ind),'uni',0));
    mylabels0 = cellfun(@(x) x(4:end), mylabels,'uni',0);
    for j=1:numel(mylabels0)
      mylabels{j} = sprintf('ses%d_q%02.0f_%s',i,j,mylabels0{j});
      ind2 = ismember(tab0.Label,mylabels0{j});
      tab0.question(ind & ind2) = mylabels(j);
    end    
  end
  ind = ismember( tab0.protocol,protocols_fc);
  tab1 = tab0(ind,:);
  pIDs = unique(tab1.participant_id);
  qIDs = unique(tab1.question);
  tab_fc = [table(pIDs),array2table(nan(numel(pIDs),numel(qIDs)))];
  tab_fc.Properties.VariableNames = ['participant_id'; qIDs];
  for i=1:numel(pIDs)
    pID = pIDs{i};
    for j=1:numel(qIDs)
      qID = qIDs{j};
      ind1 = find(ismember(tab1.participant_id,pID) & ...
        ismember(tab1.question,qID));
      % questions can be answered twice or more, use the very last answer
      % only
      if numel(ind1)==0
        continue
      end
      ind1 = ind1(end);
      if numel(ind1)==1
        if contains(qID,{'StimReceived' 'StimNumber' 'PercStimAfter' 'Contingency'})
          tab_fc.(qID)(i) = tab1.Result(ind1);
        else
          tab_fc.(qID)(i) = tab1.Result(ind1) +offset_lickertScale ;
        end
      else
        warning('mismatch')
      end
    end
  end
  
  % now check wether information is different from previous table, if it is
  % write to phenotype folder
  if exist(fn_fc_tsv,'file')==2
    tab_fc0 = readtable(fn_fc_tsv,tsv_param{:});
  else
    tab_fc0 = [];
  end
  if ~isequaln(tab_fc,tab_fc0)
    if ~isfolder(fileparts(fn_fc_tsv))
      mkdir(fileparts(fn_fc_tsv));
    end
    writetable(tab_fc,fn_fc_tsv,tsv_param{1:4});
    % rename NaN to n/a to comply with BIDS standard
    txt = fileread(fn_fc_tsv);
    txt2 = strrep(txt,'NaN','n/a');
    if ~isequal(txt,txt2)
      fid = fopen(fn_fc_tsv,'w');
      fprintf(fid,txt2);
      fclose(fid);
    end
    fprintf('Updated file: %s\n',fn_fc_tsv);
  end
  
 
  
  
end

    


