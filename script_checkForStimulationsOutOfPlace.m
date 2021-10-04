fp0 = '/media/diskEvaluation/Evaluation/sfb1280a05study6/sourcedata';
fl  = ter_listFiles(fp0,'sub-MP05KE06*_physio.mat');

t2 = struct2table(cellfun(@ter_parseFname,fl));
t2.fname = fl;
t2 = sortrows(t2,'ses');

%fl_s2 = fl(contains(fl,'ses-2'));

myYlim = [-.1,5.5];
for i=1:numel(t2.fname)
  clf
  fn = t2.fname{i};
  d1 = load(fn,'data','labels');
  data = d1.data;
  data2 = data(:,7);
  data2(data(:,8)>0)=0;
  if data2(1)>0
    data2(1:find(diff(data2)<0,1,'first'))=0;
  end

  if max(data2)>0
    finfo = ter_parseFname(fn);
    fprintf('%s : %s\n',finfo.pID,finfo.ses)  
    plot(d1.data(:,8));
    subplot(4,1,1);
    plot(data(:,5));
    ylim(myYlim);
    title('Trial');
    subplot(4,1,2);
    plot(data(:,6));
    ylim(myYlim);
    title('CS');
    subplot(4,1,3);
    plot(data(:,8));
    ylim(myYlim);
    title('US');
    subplot(4,1,4);
    plot(data(:,7));
    ylim(myYlim);
    title('digitimer output');
    suptitle([finfo.pID ' ' finfo.ses]);
    data2 = data(:,7);
    data2(data(:,8)>0)=0;
    hold on;
    plot(data2);
    pause
  end
end

