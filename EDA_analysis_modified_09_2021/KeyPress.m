   function KeyPress(hobj, EventData, ~)    
      switch EventData.Key
          case 'leftarrow'
              prevNextTrial(-1);
          case 'rightarrow'
              prevNextTrial(1);       
          case 'd'
              deleteEDA_Callback;
          case 'r'
              computeData2Plot;       
          case 'm'
              mergeEDA_Callback; 
          case 'a'
              autoDetect_Callback; 
          case 's'
              splitEDA_Callback;
          case 'uparrow'
              cursorUpDown(1);
          case 'downarrow'
              cursorUpDown(-1);
end
    