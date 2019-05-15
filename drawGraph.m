function [xOut, yOut, yBase] = drawGraph(x, y, minShift, maxShift, polyDegStr,...
                                  kstr, fstr, plot1, plot2)
% Helper function to draw GUI graph

    DrawErr = false;

    minIndex = 1;
    maxIndex = size(x, 1);
    for i = 1:size(x,1)
        if x(i) >= minShift
            minIndex = i;
            break;
        end
    end
    for i = size(x,1):-1:1
        if x(i) <= maxShift
            maxIndex = i;
            break;
        end
    end
    x = x(minIndex:maxIndex);
    y = y(minIndex:maxIndex);
    
    xOut = x;
    yOut = y;
    
    if isempty(polyDegStr) == 0
        polyDeg = str2double(polyDegStr);
        
        % creates baseline using an Improved Modified PolyFit function (described
        % in paper
        yBase = iModPolyFit(x,y,polyDeg);

        % subtracts baseeline from original to obtain "pure" (ideally) peak values
        yOut = y - yBase;
    end
    
    if and(isempty(kstr) == 0, isempty(fstr) == 0)
        k = str2double(kstr);
        f = str2double(fstr);
        
        if k >= f
            msgbox('Smoothing degree needs to be less than box width', 'ERROR');
            DrawErr = true;
        elseif mod(f, 2) == 0
            msgbox('Box width must be an odd integer', 'ERROR');
            DrawErr = true;
        else
            yOut = sgolayfilt(double(yOut), k, f);
        end
    end
    
    if DrawErr == false
        plotaxes1 = plot(plot1, xOut, yOut);
        set(plotaxes1, 'HitTest', 'off');
        if isempty(polyDegStr) == 0
            plotaxes2 = plot(plot2,x,y,x,yBase);
            set(plotaxes2, 'HitTest', 'off');
        else
            plot2handle = plot(plot2,xOut,yOut);
            delete(plot2handle);
        end
    end
    
end

