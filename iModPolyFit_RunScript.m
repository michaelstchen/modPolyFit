% % A script that uses the iModPolyFit algorithm to subtract a baseline
% % from the given raw spectral data. Also prompts user whether to zap
% % edges and/or smooth using Savitzky-Golay filter.

clc
clear all
close all

% reads spectrum data from file into N x 2 array via gui interface
[FileName, PathName, FilterIndex] = uigetfile('*.txt');
origSpectralData = dlmread(strcat(PathName,FileName));

origSpectralData = sortrows(origSpectralData, 1);

% x is the column vector of raman shifts
x = origSpectralData(:,1);

% y is the column vector of intensities
y = origSpectralData(:,2);

plot(x,y);

%% prompts user whether to zap or not.
prompt1 = 'Would you like to zap the edges? (y|n): ';
toZap = input(prompt1, 's');

if strcmp(toZap, 'y')
    prompt2 = 'Input min shift: ';
    prompt3= 'Input max shaft: ';
    minShift = input(prompt2);
    maxShift = input(prompt3);
    if minShift >= maxShift
        error('Your min shift is greater than your max shift!');
    end
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
end

close all;

%% prompts user for a degree to fit the polynomial baseline with.
prompt4 = 'Enter the degree of the baseline polynomial to fit: ';
polyDeg = input(prompt4);

% creates baseline using an Improved Modified PolyFit function (described
% in paper
yBase = iModPolyFit(x,y,polyDeg);

% subtracts baseeline from original to obtain "pure" (ideally) peak values
ySub = y - yBase;


% plots original spectrum and calculated baseline
subplot(2,1,1);
plot(x,y,x,yBase);

% plots the spectrum of the "pure" peaks
subplot(2,1,2);
plot(x,ySub);

%% prompts user whether to smooth output.
prompt5 = 'Do you wish to apply a Savitzky-Golay filter (y|n): ';
wantFilt = input(prompt5, 's');

if strcmp(wantFilt, 'y')
    notDoneSmoothing = true;
    while notDoneSmoothing
        display('IMPORTANT: polynomial order must be smaller than frame size and frame size must be odd\n');
        k = input('Input polynomial order: ');
        f = input('Input frame size (MUST BE ODD): ');
    
        yFilt = sgolayfilt(ySub, k, f);

        plot(x, yFilt);

        finishSmooth = input('Finished smoothing? (y|n): ', 's');

        if strcmp(finishSmooth, 'y')
            notDoneSmoothing = false;
            ySub = yFilt;
        end
        
        plot(x, ySub);
    end
end


%% prompts user whether to save output or not enter 'y' or 'n'.
prompt6 = 'Do you wish to save the output (y|n): ';
save = input(prompt6, 's');

% writes the data to a text file if user indicated 'y' when prompted
if strcmp(save, 'y')
    correctedSpectra = [[x] [ySub]];
    dlmwrite(strcat(PathName,FileName(1:size(FileName,2)-4), '_', num2str(polyDeg),'degfit.txt'), correctedSpectra, 'delimiter', '\t', 'newline', 'pc');
end