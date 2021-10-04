function rectangleClickCallback(hObject, eventdata, handles)
    global out
    i = out.i;
    evname = eventdata.EventName;
    source= hObject.Tag;
    if evname == "Hit"         
        set(out.handles.listbox2,'Value', str2double(source));
    end