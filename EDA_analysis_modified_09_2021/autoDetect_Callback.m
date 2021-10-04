function autoDetect_Callback(hObject, eventdata, handles)
%% Init variables
    global out
    i = out.i;
    
    %% Get number of EDAs 
    N = numel(out.edaRes(i).amplitude);
    if N >= 1
       
        %% Get EDA start times
        EDAstartTimes =  out.edaRes(i).minTime(:);
        
        %% find EDAs start times of which are beyond the second marker and remove them
        lateEDAs = find(EDAstartTimes > out.sPosTime(i,2));
        for l=numel(lateEDAs):-1:1
            %% Delete EDAs from struct
        out.edaRes(i).minTime(lateEDAs(l))      = [];
        out.edaRes(i).maxTime(lateEDAs(l))      = [];
        out.edaRes(i).minData(lateEDAs(l))      = [];
        out.edaRes(i).maxData(lateEDAs(l))      = [];
        out.edaRes(i).edaTimeRes(lateEDAs(l))   = [];
        out.edaRes(i).amplitude(lateEDAs(l))    = [];
        end
        plotData;
        
        %% leave maximum from remaining (more than 1) EDAs 
        N = numel(out.edaRes(i).amplitude);
        if N > 1
            [~,max_idx] = max(out.edaRes(i).amplitude(:));
            for l=N:-1:1
                %% remove every EDA except for MAX one
                if l ~= max_idx
                    out.edaRes(i).minTime(l)      = [];
                    out.edaRes(i).maxTime(l)      = [];
                    out.edaRes(i).minData(l)      = [];
                    out.edaRes(i).maxData(l)      = [];
                    out.edaRes(i).edaTimeRes(l)   = [];
                    out.edaRes(i).amplitude(l)    = [];
                end                       
            end       
        plotData; 
        end
    end
end
