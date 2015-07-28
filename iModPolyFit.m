function [yInput] = iModPolyFit(x, y, n)
% Implements an improved modified multi-polynomial fit method as 
% described in the article by Zhao, Lui, McLean, and Zeng (Applied
% Spectroscopy, Vol. 61, Number 11, 2007).

    xInput = x;
    yInput = y;
    
    % DEV_PREV is the standard deviation residuals for the last
    % iteration of polyfit. Set initially to 0.
    dev_prev = 0;
    
    first_iter = true;
    
    % The criteria for stopping the interative improvement of the
    % modpolyfit is |DEV_CURR - DEV_PREV|/ DEV_CURR < 5%
    criteria_met = false;
    
    while not(criteria_met)
       % paramVector is an array with the coefficients for the fitted
       % polynomial
       paramVector = polyfit(xInput, yInput, n);
       
       % MOD_POLY is the column vector of y values associated with the 
       % fitted polynomial function. makeDesignM returns the design
       % matrix (see makeDesignM.m for details).
       mod_poly = makeDesignM(xInput, n) * transpose(paramVector);
       
       residual = mod_poly - yInput;
       
       % DEV_CURR is the standard deviation of residuals for the current 
       % iteration.
       dev_curr = std(residual);
       
       % For the first iteration, remove the peaks.
        if first_iter
            toRemove = [];
            for i = 1:size(yInput, 1)
                if yInput(i) > mod_poly(i) + dev_curr
                    toRemove(end+1) = i;
                end
            end
            yInput = removerows(yInput, 'ind', toRemove);
            xInput = removerows(xInput, 'ind', toRemove);
            mod_poly = removerows(mod_poly, 'ind', toRemove);
            first_iter = false;
        end
       
        
       % Updates YINPUT according to the reconstruction model detailed in
       % the paper cited above.
       for j = 1:size(yInput,1)
           if mod_poly(j) + dev_curr > yInput(j)
               yInput(j) = yInput(j);
           else
               yInput(j) = mod_poly(j);
           end
       end
       
       criteria_met = abs((dev_curr - dev_prev)/dev_curr) <= 0.05;
       
       if criteria_met
           yInput = makeDesignM(x, n) * transpose(paramVector);
       end
       
       dev_prev = dev_curr;
       
    end

end

