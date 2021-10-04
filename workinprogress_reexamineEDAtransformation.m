% "resample" seems to mess things up maybe, does apply filters and 
% introduces wild oszillations at start and end of dataset. maybe also 
% with US artefacts? 2do: check US artefact sites!


fl_tsv = ter_listFiles(fp_d,'*_physio.tsv.gz');
fl_eda = ter_listFiles(fp_de,'sub-*_EDA.mat');
fl_eda = fl_eda(not(contains(fl_eda,'EDA_EDA')));

for i=1:1%numel(fl)
  p1 = ter_parseFname(fl_tsv{i});
  p2 = ter_parseFname(fl_eda{i});
  if not(isequal(p1.pID,p2.pID) && isequal(p1.ses,p2.ses) && ...
      isequal(p1.run,p2.run))
    error('%d',i)
  end
  load(fl_eda{i},'data')
  
  [d,t] = ter_readBidsTsv(fl_tsv{i});
  sf = 1/unique(round(diff(t),4));
  sc = d.skinconductance;
  d1=resample(sc,1000,sf);
  d2 = ter_bandpassAnalogBiopac(d1,1000);
  try
    sc2 = (sc(1:2:end-1)+sc(2:2:end))./2;
  catch
    sc2 = (sc(1:2:end)+sc(2:2:end))./2;
  end
  d3 = ter_bandpassAnalogBiopac(sc2,1000);
  clf
  plot((1:numel(sc))./2,sc)
  hold on
  plot(data)
  %plot(data-d2)
  plot(sc2)
  plot(d1)
  plot(d2)
  plot(d3)
  legend('original','resampled','averaged','EDAmat','filtered resampled','filtered average')
  
end

[d,t] = ter_readBidsTsv('sub-AL04ED14_ses-1_task-fear_run-1_physio.tsv.gz');
sf = 1/unique(round(diff(t),4));
sc = d.skinconductance;
d1=resample(sc,1000,sf);

clf
plot(sc)
hold on
plot((1:numel(d1))*2-1,d1);



fn_tsv = '/media/diskEvaluation/Evaluation/Preterm_Fear/rawdata/sub-ER05ER24/ses-fc1/beh/sub-ER05ER24_ses-fc1_task-fear_physio.tsv.gz';
fn_eda = '/media/diskEvaluation/Evaluation/Preterm_Fear/derivatives/EDAevaluation_new/sub-ER05ER24/ses-fc1/sub-ER05ER24_ses-fc1_task-fear_EDA.mat';

[d,t] = ter_readBidsTsv(fn_tsv);
sc = d.skinconductance;
sf = 1/unique(round(diff(t),4));

clearvars data
load(fn_eda,'data')
d1=data;

d2 = ter_bandpassAnalogBiopac(sc,1000);


fn_tsv = '/media/diskEvaluation/Evaluation/Preterm_Fear/rawdata/sub-ER05ER24/ses-fc2/beh/sub-ER05ER24_ses-fc2_task-fear_physio.tsv.gz';
fn_eda = '/media/diskEvaluation/Evaluation/Preterm_Fear/derivatives/EDAevaluation_new/sub-ER05ER24/ses-fc2/sub-ER05ER24_ses-fc2_task-fear_EDA.mat';

fn_tsv1 = '/media/diskEvaluation/Evaluation/Preterm_Fear/rawdata/sub-ER03ER22/ses-fc1/beh/sub-ER03ER22_ses-fc1_task-fear_physio.tsv.gz';
fn_eda1 = '/media/diskEvaluation/Evaluation/Preterm_Fear/derivatives/EDAevaluation_new/sub-ER03ER22/ses-fc1/sub-ER03ER22_ses-fc1_task-fear_EDA.mat';
fn_tsv2 = strrep(fn_tsv1,'ses-fc1','ses-fc2');
fn_eda2 = strrep(fn_eda1,'ses-fc1','ses-fc2');

[d1,t1] = ter_readBidsTsv(fn_tsv1);
sc1 = d1.skinconductance;
sf1 = 1/unique(round(diff(t1),4));
[d2,t2] = ter_readBidsTsv(fn_tsv2);
sc2 = d2.skinconductance;
sf2 = 1/unique(round(diff(t2),4));

clearvars data
load(fn_eda1,'data')
ed1=data;
load(fn_eda2,'data')
ed2=data;

clf
plot(sc1)
hold on
plot(ed1)

clf
plot(sc2)
hold on
plot(ed2)


d2 = ter_bandpassAnalogBiopac(sc,1000);


