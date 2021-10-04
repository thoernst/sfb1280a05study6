function func_prepareEda4rub(fp_d,fp_de)

fprintf(['\n%s\n%s - Preparing data for RUB EDA evaluation\n'...
  '%sThis might take 5 min or more per new participant\n'],...
  repmat('=',72,1),datestr(now,'yyyy-mm-dd hh:MM:ss'),repmat(' ',22,1))

dir_EDAeval = fullfile(fp_de,'EDAevaluation');

%ptab = readtable(fullfile(fp_d,'participants.tsv'),'filetype','text',...
%  'delim','tab');
fn_ptab = fullfile(fp_d,'participants.tsv');
ptab    = ter_readptab(fn_ptab);

for i=1:size(ptab,1)
  pID = ptab.participant_id{i};
  if ~isfolder(fullfile(fp_d,pID))
    fprintf('\nNo rawdata present for %s\n',pID);
    continue
  end
  fl_physgz = ter_listFiles(fullfile(fp_d,pID),[pID '*_physio.tsv.gz']);
  fl_physgz = fl_physgz(~contains(fl_physgz,'task-rest'));
  if isempty(fl_physgz)
    fprintf('\nNo physio data present for %s\n',pID);
    continue
  end
  fl_events = strrep(fl_physgz,'physio.tsv.gz','events.tsv');
  
  % read event list and verify that CS+ and Cs- have been identified
  el = cellfun(@(x) readtable(x,'filetype','text','delim','tab'),...
    fl_events,'uni',0);
  if ismember(1,cellfun(@(x) max(ismember(x.trial_type,{'US','CS'})),el))
    fprintf(['Skipping BIDS2RUBeval for %s\n'... 
      'At least one session not fully identified.\n'],pID)
    continue
  end
 
  ter_skinconductanceBids2RUBeval(fl_physgz,dir_EDAeval);
 
end