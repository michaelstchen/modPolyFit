Author: Michael Stephen Chen

Original Algorithm:
Jianhua Zhao, Harvey Lui, David I. McLean, and Haishan Zeng, "Automated Autofluorescence Background Subtraction
Algorithm for Biomedical Raman Spectroscopy," Appl. Spectrosc. 61, 1225-1232 (2007)

Description:
This is a simple MATLAB GUI implementaion of the original algorithm as described by Zhao et. al. (2007).
In short the algorithm subtracts the broad fluorescence background in Raman spectra, leaving only
the peaks of interest.

To Run:
  1. If MATLAB (only tested on R2013A) is installed, initialize the GUI by running the ModPolyFit_GUI.m file.
  2. Select a Raman spectrum file (.txt or .spc file with first column = shifts (cm-1), second column = intensity).
  3. Input spectral range of interest and degree polynomial to fit to background.
  4. Optionally, can choose to smooth with Savitzky-Golay
  5. Plot
  
Notes:
  - Top spectrum displays the result of subtracting the background.
  - Bottom spectrum shows the subtracted background overlaid on the original spectrum
  - Left click on the spectrum will display the coordinates of the clicked point at the top left
   of the plot (crosshairs indicate position clicked).
  - Mouse wheel scroll is used to zoom in and out, centered about the point where the current crosshairs are
   set on.
