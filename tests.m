fl = ter_listFiles(pwd,'*events.tsv');
for i=1:numel(fl)
  if exist(strrep(fl{i},'events.tsv','eyetrack.tsv.gz'),'file')~=2
    continue
  end
  t1 = ter_readBidsTsv(fl{i});
  t2 = t1(not(ismember(t1.trial_type,'Trial')),:);
  if ~isequal(t2,t1)
    ter_writeBidsTsv(t2,fl{i});
  end
end








fn_et = 'sub-EN07IT24_ses-3_task-fear_run-2_eyetrack.tsv.gz';
fn_ev = 'sub-EN07IT24_ses-3_task-fear_run-2_events.tsv';
[d,t] = ter_readBidsTsv(fn_et);
e = ter_readBidsTsv(fn_ev);
e = e(not(ismember(e.trial_type,'Trial')),:);
ec = e(not(cellfun(@isempty,regexp(e.trial_type,'^CS'))),:);

d2.ps_l=lowpass(sqrt(d.pupilsize_left)./pi,6,500,'ImpulseResponse','FIR');
d2.ps_r=lowpass(sqrt(d.pupilsize_right)./pi,6,500,'ImpulseResponse','FIR');

d2.ps_l(d.blink_left==1)=nan;
d2.ps_r(d.blink_right==1)=nan;

t_ons  = ec.onset;
t_pre  = ec.onset - .3;
t_1    = t_ons + 2;
t_2    = t_ons + 4;
t_3    = t_ons + 6;
t_4    = t_ons + 8;
t_post = t_ons + 10;


ec.l_pre = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_pre,t_ons);
ec.l_w1  = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_ons,t_1)    - ec.l_pre;
ec.l_w2  = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_1  ,t_2)    - ec.l_pre;
ec.l_w3  = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_2,  t_3)    - ec.l_pre;
ec.l_w4  = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_3,  t_4)    - ec.l_pre;
ec.l_wp  = arrayfun(@(x,y) nanmean(d2.ps_l(t > x & t < y)),t_4,  t_post) - ec.l_pre;

ec.r_pre = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_pre,t_ons);
ec.r_w1  = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_ons,t_1)    - ec.r_pre;
ec.r_w2  = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_1  ,t_2)    - ec.r_pre;
ec.r_w3  = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_2,  t_3)    - ec.r_pre;
ec.r_w4  = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_3,  t_4)    - ec.r_pre;
ec.r_wp  = arrayfun(@(x,y) nanmean(d2.ps_r(t > x & t < y)),t_4,  t_post) - ec.r_pre;







fn = '/media/diskEvaluation/Evaluation/sfb1280a05study6/sourcedata/sub-EN07IT24/ses-1/eyetracking/sub-EN07IT24_ses-1_run-1_datetime-20210516T122944_eyetrack.asc';
fp_bids = '/media/diskEvaluation/Evaluation/sfb1280a05study6/rawdata/'

cfg = [];

cfg.InstitutionName             = 'University Clinic Essen';
cfg.InstitutionalDepartmentName = 'Clinic for Neurology, Experimental Neurology';
cfg.InstitutionAddress          = 'Hufelandstrasse 55, DE45147, Essen, Germany';

% required for dataset_description.json
cfg.dataset_description.Name                = 'SFB1280 A05 study6: Fear conditioning paradigm with pharmacologic interventions';
cfg.dataset_description.BIDSVersion         = 'unofficial extension';

cfg.dataset = fn;
cfg.method = 'convert';

cfg.bidsroot = fp_bids;
cfg.datatype = 'eyetrack';
cfg.sub = 'EN07IT24';
cfg.run = 1;
cfg.ses = '1';
cfg.task = 'fear';

cfg.TaskDescription       = 'fear conditioning paradigm';
cfg.Manufacturer          = 'SR Research';
cfg.ManufacturerModelName = 'Eyelink 1000';

data2bids(cfg);





