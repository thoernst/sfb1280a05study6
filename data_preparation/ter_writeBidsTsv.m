function ter_writeBidsTsv(myTable,fn_table)

writetable(myTable,fn_table,'filetype','text','delim','tab');
txt0 = fileread(fn_table);
txt = strrep(txt0,'NaN','n/a');
if not(isequal(txt0,txt))
  fid = fopen(fn_table,'w');
  fprintf(fid,txt);
  fclose(fid);
end