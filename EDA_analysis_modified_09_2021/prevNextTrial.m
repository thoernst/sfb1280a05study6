function prevNextTrial (direction)
    global out
    switch direction
        case -1
          if(out.i > 1)
            out.i = out.i - 1;
            % Plot only! no new computation
            plotData;
          end
        case 1
            if(~isempty(out.trialSep))
            len = length(out.trialSep)-1;
        else
            len = length(out.trialStart);
        end

        if(out.i < len)
            out.i = out.i + 1;
            % Only compute new, if entry does not exist
            if(out.i > length(out.edaRes))
                computeData2Plot;
            else
                % Otherwise only plot, no new computation
                plotData;
            end
        end
    end
end
