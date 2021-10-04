function cursorUpDown (direction)
  %% Init variables
    global out
    i = out.i;

    %% Get position of eda 
    pos = get(out.handles.listbox2,'Value');
    
    %% Get number of items in listbox
    N = numel(get(out.handles.listbox2, 'String'));
    if N > 0

        switch direction
            case 1
              if(pos-1 > 0)
                set(out.handles.listbox2,'Value', pos-1);
              end
            case -1
                if(pos+1 <= N)
                set(out.handles.listbox2,'Value', pos+1);

            end
        end
end