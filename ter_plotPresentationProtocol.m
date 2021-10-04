function ter_plotPresentationProtocol(fn_csv)
  
  if ischar(fn_csv)
    fn_csv = cellstr(fn_csv);
  end
  fn_out = fullfile(fileparts(fn_csv{1}),'protocol_plot.ps');
  hfig = figure();
  
  for k=1:numel(fn_csv)
  
    t1 = readtable(fn_csv{k});
    myXlim = [min([0,t1.TrialStart(1)]), ...
      (max(t1.TrialStart + t1.TrialDuration)+2000)]./1e3;

    vn = t1.Properties.VariableNames;
    chanOns   = vn(contains(lower(vn),'_onset'));
    chanDur   = strrep(chanOns,'Onset','Duration');
    chanLabel = strrep(chanOns,'_Onset','');
    chanDesc   = cell(size(chanOns));
    vn2 = vn(~ismember(vn,chanDur) & ~ismember(vn,chanOns));
    for i=1:numel(chanDesc)
      tmp = vn2(contains(vn2,chanLabel{i}));
      if ~isempty(tmp)
        chanDesc(i)=tmp;
      end
    end

    my_x = [t1.TrialStart,t1.TrialStart+t1.TrialDuration];
    my_x = my_x(:,[1 1 2 2])';
    my_x = [myXlim(1);my_x(:)./1e3;myXlim(2)];
    my_y = [0;repmat([0;1;1;0],size(t1,1),1);0] *.9;
    myLegend = {'Trial'};
    clearvars d2p;
    d2p(1).x = my_x;
    d2p(1).y = my_y;

    c = 1;
    for i=1:numel(chanOns)
      ind = t1.(chanDur{i})>0;
      if sum(ind)==0
        continue
      end
      ons  = t1.(chanOns{i})(ind) + t1.TrialStart(ind);
      term = ons + t1.(chanDur{i})(ind); 
      if isempty(chanDesc{i})
        ind_kinds = ones(size(ons));
      else
        tmp = unique(t1.(chanDesc{i})(ind));
        ind_kinds = zeros(size(ons));
        for j=1:numel(tmp)
          ind_kinds(ismember(t1.(chanDesc{i})(ind),tmp(j)))=j;
        end
      end
      kinds = unique(ind_kinds);
      if isequal(kinds,1)
        myLegend = [myLegend;chanLabel(i)]; %#ok<AGROW>
      else
        for j=1:numel(kinds)
          myLegend = [myLegend; sprintf('%s_%d',chanLabel{i},j)];%#ok<AGROW>
        end
      end
      for j=1:numel(kinds)
        c = c+1;
        my_x = [ons(ind_kinds==j) , term(ind_kinds==j)];
        my_x = my_x(:,[1 1 2 2])';
        my_x = [myXlim(1);my_x(:)./1e3;myXlim(2)];
        my_y = [0;repmat([0;1;1;0],sum(ind_kinds==j),1);0] *.9 + c-1;
        d2p(c).x = my_x;%#ok<AGROW>
        d2p(c).y = my_y;%#ok<AGROW>
      end
    end

    subplot(numel(fn_csv),1,k);
    for i=1:numel(d2p)
      plot(d2p(i).x,d2p(i).y);
      hold on;
    end
    legend(myLegend,'Interpreter','none');
    xlim(myXlim.*[1,1.4]);
    ylim([0,c*1.25]);
    xlabel('time [s]');
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    [~,fn] = fileparts(fn_csv{k});
    title(fn,'Interpreter','none');
  end
  %print(hfig','-dpsc','-append','-fillpage','plots.ps')
  print(hfig','-dpsc','-fillpage',fn_out);
  if ismac()
    eval(sprintf('system(''pstopdf %s'')',fn_out));
  elseif isunix
    eval(sprintf('system(''ps2pdf %s'')',fn_out));
  elseif ispc()
    %still2do
  end
    
end