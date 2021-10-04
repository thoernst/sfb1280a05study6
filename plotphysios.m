fl = ter_listFiles(fp_d,'*_physio.tsv.gz');
t1 = struct2table(cellfun(@ter_parseFname,fl));
t1.fname = fl;
t1 = sortrows(t1,{'ses','run','pID'});

fl = ter_listFiles(fp_d,'*_eyetrack.tsv.gz');
t2 = struct2table(cellfun(@ter_parseFname,fl));
t2.fname = fl;
t2 = sortrows(t2,{'ses','run','pID'});

t3 = t2%[t1;t2];

fn_out = fullfile(fp0,'misc','physioplot_et');
for i=1:size(t3,1)
  hfig = ter_plotBidsPhysioTsv(t3.fname{i});
%  export_fig(hfig, fullfile(fp0,'misc','physioplot.ps'));
  %export_fig(fn_out,hfig,'-append')
  print(fn_out,'-dpsc','-append','-fillpage')
  close(hfig);
end
system(sprintf('ps2pdf %s.ps %s.pdf',fn_out,fn_out))