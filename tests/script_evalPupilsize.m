
clearvars -except data
%pID = 'sub-RG11LD22';
pID = 'sub-TE05TH12'
fp_d = '/media/diskEvaluation/Evaluation/sfb1280a05study6/rawdata';
fl = ter_listFiles(fp_d,[pID '*_eyetrack.tsv.gz']);


for i=1:numel(fl)
  [et_data{i},et_time{i}] = ter_readBidsTsv(fl{i});
  et_ev{i} = ter_readBidsTsv(strrep(fl{i},'eyetrack.tsv.gz','events.tsv'));

  ind_CS = find(cellfun(@(x) ~isempty(regexp(x,'^CS','match')),...
    et_ev{i}.trial_type));
  et_ev{i}.reinforced = false(size(et_ev{i},1),1);
  for j=1:numel(ind_CS)
    if ind_CS(j)<size(et_ev{i},1)
      et_ev{i}.reinforced(ind_CS(j)) = ...
        ~isempty(regexp(et_ev{i}.trial_type{ind_CS(j)+1},'^US'));
    end
  end
  et_ev{i} = et_ev{i}(ind_CS,:);
  
  et_ev{i}.csplus = cellfun(@(x) ~isempty(regexp(x,'^CSplus','match')),...
    et_ev{i}.trial_type);
  
  % baseline
  et_ev{i}.bl_l = nan(size(et_ev{i},1),1);
  et_ev{i}.w1_l = nan(size(et_ev{i},1),1);
  et_ev{i}.w2_l = nan(size(et_ev{i},1),1);
  et_ev{i}.w3_l = nan(size(et_ev{i},1),1);
  et_ev{i}.w4_l = nan(size(et_ev{i},1),1);
  et_ev{i}.bl_r = nan(size(et_ev{i},1),1);
  et_ev{i}.w1_r = nan(size(et_ev{i},1),1);
  et_ev{i}.w2_r = nan(size(et_ev{i},1),1);
  et_ev{i}.w3_r = nan(size(et_ev{i},1),1);
  et_ev{i}.w4_r = nan(size(et_ev{i},1),1);
  
  et_data{i}.pd_l = 2*sqrt(et_data{i}.pupilsize_left)/pi;
  et_data{i}.pd_r = 2*sqrt(et_data{i}.pupilsize_right)/pi;
  
  et_data{i}.pd_l(et_data{i}.blink_left==1) = nan;
  et_data{i}.pd_r(et_data{i}.blink_right==1) = nan;
  for j=1:size(et_ev{i},1)
    ind_bl = et_time{i}<= et_ev{i}.onset(j) & ...
      et_time{i}>= et_ev{i}.onset(j) - 0.300;
    et_ev{i}.bl_l(j) = nanmean(et_data{i}.pd_l(ind_bl));
    et_ev{i}.bl_r(j) = nanmean(et_data{i}.pd_l(ind_bl));
    
    ind_w1 = et_time{i}<= et_ev{i}.onset(j) +2 & ...
      et_time{i}>= et_ev{i}.onset(j);
    et_ev{i}.w1_l(j) = nanmean(et_data{i}.pd_l(ind_w1));
    et_ev{i}.w1_r(j) = nanmean(et_data{i}.pd_l(ind_w1));
    
    ind_w2 = et_time{i}<= et_ev{i}.onset(j) +4 & ...
      et_time{i}>= et_ev{i}.onset(j)+2;
    et_ev{i}.w2_l(j) = nanmean(et_data{i}.pd_l(ind_w2));
    et_ev{i}.w2_r(j) = nanmean(et_data{i}.pd_l(ind_w2));
    
    ind_w3 = et_time{i}<= et_ev{i}.onset(j) +6 & ...
      et_time{i}>= et_ev{i}.onset(j)+4;
    et_ev{i}.w3_l(j) = nanmean(et_data{i}.pd_l(ind_w3));
    et_ev{i}.w3_r(j) = nanmean(et_data{i}.pd_l(ind_w3));
    
    ind_w4 = et_time{i}<= et_ev{i}.onset(j) +8 & ...
      et_time{i}>= et_ev{i}.onset(j)+6;
    et_ev{i}.w4_l(j) = nanmean(et_data{i}.pd_l(ind_w4));
    et_ev{i}.w4_r(j) = nanmean(et_data{i}.pd_l(ind_w4));
  end
  
end
clf
hfig = figure();
plot(et_time{i},et_data{i}.pd_l)



fprintf('Participant: %s\n\n',pID);
for i=1:numel(et_ev)
  x1_l = et_ev{i}.w3_l(et_ev{i}.csplus) - et_ev{i}.bl_l(et_ev{i}.csplus);
  x2_l = et_ev{i}.w3_l(~et_ev{i}.csplus) - et_ev{i}.bl_l(~et_ev{i}.csplus);
  x1_r = et_ev{i}.w3_r(et_ev{i}.csplus) - et_ev{i}.bl_r(et_ev{i}.csplus);
  x2_r = et_ev{i}.w3_r(~et_ev{i}.csplus) - et_ev{i}.bl_r(~et_ev{i}.csplus);
  
  acq = regexp(et_ev{i}.trial_type{i},'acq-[a-zA-Z0-0]*','match');
  acq = acq{1}(5:end);
  [~,~,~,stat_l] = ttest(x1_l,x2_l);
  [~,~,~,stat_r] = ttest(x1_r,x2_r);
  
  fprintf('Phase: %s\n\n   left:\n',acq)
  disp(stat_l);
  fprintf('   right:\n')
  disp(stat_r);
  
end


data.(strrep(pID,'-','_')).et_ev = et_ev;
data.(strrep(pID,'-','_')).et_time = et_time;
data.(strrep(pID,'-','_')).et_data = et_data;



fprintf('Participant: %s\n\n',pID);
for i=1:numel(et_ev)

  
  x1_l = et_ev{i}.w3_l(et_ev{i}.csplus) - et_ev{i}.bl_l(et_ev{i}.csplus);
  x2_l = et_ev{i}.w3_l(~et_ev{i}.csplus) - et_ev{i}.bl_l(~et_ev{i}.csplus);
  x1_r = et_ev{i}.w3_r(et_ev{i}.csplus) - et_ev{i}.bl_r(et_ev{i}.csplus);
  x2_r = et_ev{i}.w3_r(~et_ev{i}.csplus) - et_ev{i}.bl_r(~et_ev{i}.csplus);
  
  acq = regexp(et_ev{i}.trial_type{i},'acq-[a-zA-Z0-0]*','match');
  acq = acq{1}(5:end);
  [sts_l,p_l,~,stat_l] = ttest(x1_l,x2_l);
  [sts_r,p_r,~,stat_r] = ttest(x1_r,x2_r);
  
  fprintf('Phase: %s\n\n   left: ',acq)
  if sts_l == 0 
    fprintf('not ')
  end
  fprintf('significant\n    p: %5.4f\n',p_l);
  disp(stat_l);
  fprintf('   right: ')
  if sts_r == 0 
    fprintf('not ')
  end
  fprintf('significant\n    p: %5.4f\n',p_r);
  disp(stat_r);
  
end
