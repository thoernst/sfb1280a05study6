script_init_study6;
fn_ptab = fullfile(fp_d,'participants.tsv');
ptab = ter_readptab(fn_ptab);
fn_out = fullfile(fp_de,'QA','eyetracks.ps');
fn_demo = fullfile(fp_d,'phenotype','demographics.tsv');
dtab = ter_readBidsTsv(fn_demo);

if ~isfolder(fileparts(fn_out))
  mkdir(fileparts(fn_out));
end


for i=1:size(ptab,1)
  pID = ptab.participant_id{i};
  fl = ter_listFiles(fullfile(fp_d,pID),'*_eyetrack.tsv.gz');
  [~,fn] = cellfun(@fileparts,fl,'uni',0);
  [~,fn] = cellfun(@fileparts,fn,'uni',0);
  fn = strrep(fn,'-','_');
  for j=1:numel(fl)
    [tmp_d,tmp_t] = ter_readBidsTsv(fl{j});
    data_et{i}.(fn{j}).data = tmp_d;
    data_et{i}.(fn{j}).time = tmp_t;
  end
end

hfig = figure;
delete(fn_out)
for i=1:numel(data_et)
  pID = ptab.participant_id{i};
  fn = fieldnames(data_et{i});
  clf
  for j=1:numel(fn)
    myTitle = strrep(fn{j},[strrep(pID,'-','_') '_'],'');
    subplot(numel(fn),2,2*(j-1)+1);
    plot(data_et{i}.(fn{j}).time,data_et{i}.(fn{j}).data.pupilsize_left);
    title([myTitle ' left'],'Interpreter','none');
    xlim([-50,1800]);
    ylim([0,10000]);
    xlabel('time [s]');
    ylabel('diameter [a.u.]');
    
    subplot(numel(fn),2,2*j)
    plot(data_et{i}.(fn{j}).time,data_et{i}.(fn{j}).data.pupilsize_right);
    title([myTitle ' right'],'Interpreter','none');
    xlim([-50,1800]);
    ylim([0,10000]);
    xlabel('time [s]');
    ylabel('diameter [a.u.]');
  end
  mySupTitle = pID;
  ind = ismember(dtab.participant_id,pID);
  if dtab.sense_eyesight(ind) == 1
    mySupTitle = [mySupTitle ' - no eyesight deficits'];%#ok<AGROW>
  else
    if isnan(dtab.sense_eyesight_prescription_left(ind))
      mySupTitle = [mySupTitle ' - left: n/a dpt'];%#ok<AGROW>
    else
      mySupTitle = [mySupTitle sprintf(' - left: %5.2f dpt',...
        dtab.sense_eyesight_prescription_left(ind))]; %#ok<AGROW>
    end
    if isnan(dtab.sense_eyesight_prescription_right(ind))
      mySupTitle = [mySupTitle ', right: n/a dpt']; %#ok<AGROW>
    else
      mySupTitle = [mySupTitle sprintf(', right: %5.2f dpt',...
        dtab.sense_eyesight_prescription_right(ind))];%#ok<AGROW>
    end
  end
  suptitle(mySupTitle);
  print(hfig,'-dpsc','-fillpage','-append',fn_out);  
end
fp_home = pwd;
cd(fileparts(fn_out))
eval(sprintf('!ps2pdf "%s"',fn_out))
cd(fp_home)
