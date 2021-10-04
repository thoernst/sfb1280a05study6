function fIDs = ter_parseFname(fname,varargin)

  fl = {
    'pID' 'sub-[0-9a-zA-Z]*';
    'ses' 'ses-[0-9a-zA-Z]*';
    'run' 'run-[0-9]*';
    'acq' 'acq-[a-zA-Z0-9]*';
    'date' 'date-[0-9]*';
    'datetime' 'datetime-[0-9T]*';
  };
 
  for i=1:size(fl,1)
    tmp = regexp(fname,fl{i,2},'match');
    if not(isempty(tmp))
      fIDs.(fl{i,1}) = tmp{end};
    end
  end
  
  [~,fn,fe] = fileparts(fname);
  if strcmpi(fe,'.gz')
    [~,fn,fe_tmp] = fileparts(fn);
    fe = [fe_tmp,fe];
  end
  tmp = strsplit(fn,'_');
  if not(contains(tmp{end},'-'))
    fIDs.suffix = tmp{end};
  end
  fIDs.extension = fe;