function [designM] = makeDesignM(x, n)
% [designM] = makeDesignM(x, n)
% Creates the design matrix DESIGNM for the Nth degree polynomial fit based on
% the values from the X column vector
%          | 1 | x | x^2 | ... | x^n|  
% where | x | denotes denotes the column of x values.

designM = [];

for i = n:-1:0
    designM = [designM x.^i];
end

end

