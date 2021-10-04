script_init_study6
%t = readtable(fullfile(fp0,'misc','study6_serumlevel.xlsx'));
t = readtable(fullfile(fp0,'misc','study6_serumlevel_2021-08-19.xlsx'));
myUnits = table2cell(t(1,2:end));
t = t(2:end,:);
vn = t.Properties.VariableNames;

fn_ptab = fullfile(fp_d,'participants.tsv');
ptab = ter_readptab(fn_ptab);

for i=1:numel(vn)
  t.(vn{i}) =   strrep(t.(vn{i}) ,'<0,','<0.');
  ind_e = cellfun(@isempty,t.(vn{i}));
  t.(vn{i})(ind_e) = {'n/a'};
end

ind_warn1 = ismember(ptab.participant_id,t.participant_id);
ind_warn2 = ismember(t.participant_id,ptab.participant_id);
if sum(not(ind_warn1))>0
  warning('not found in serumlevel table: ')
  disp(ptab.participant_id(not(ind_warn1)))
end
if sum(not(ind_warn2))>0
  warning('not found in participant table: ')
  disp(t.participant_id(not(ind_warn2)))
end

tab_sl = table();
tab_sl.participant_id = ptab.participant_id(ind_warn1);
tab_sl.drug = ptab.drug(ind_warn1);
vn2 = vn(2:end);
for i=1:size(tab_sl,1)
  pID = tab_sl.participant_id{i};
  ind = ismember(t.participant_id,pID);
  for j=1:numel(vn2)
    tab_sl.(vn2{j})(i) = t.(vn2{j})(ind);
  end
end

fn_sl = fullfile(fp_d,'phenotype','serumlevel.tsv');
if exist(fn_sl,'file')==2
  tab_sl0 = ter_readBidsTsv(fn_sl);
  if not(isequal(tab_sl,tab_sl0))
    fprintf('updating serumlevel.tsv\n')
    delete(fn_sl)
  end
end
if exist(fn_sl,'file')~=2
  ter_writeBidsTsv(tab_sl,fn_sl)
end
fn_json = strrep(fn_sl,'.tsv','.json');
clearvars jinfo;
if exist(fn_json,'file')~=2
  for j=1:numel(vn2)
    sID = regexp(vn2{j},'ses[0-9]','match');
    sID = strrep(sID{end},'ses','');
    drug = strsplit(vn2{j},'_');
    jinfo.(vn2{j}).description = sprintf(...
      'serum level of %s after session %s',drug{end},sID);
    jinfo.(vn2{j}).Units = myUnits{j};
  end
  ter_savePrettyJson(fn_json,jinfo);
  mystr = strrep(fileread(fn_json),'\u00b5','µ');
  fid = fopen(fn_json,'w');
  fprintf(fid,mystr);
  fclose(fid);
end

