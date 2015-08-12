function varargout = ModPolyFit_GUI(varargin)
%MODPOLYFIT_GUI M-file for ModPolyFit_GUI.fig
%      MODPOLYFIT_GUI, by itself, creates a new MODPOLYFIT_GUI or raises the existing
%      singleton*.
%
%      H = MODPOLYFIT_GUI returns the handle to a new MODPOLYFIT_GUI or the handle to
%      the existing singleton*.
%
%      MODPOLYFIT_GUI('Property','Value',...) creates a new MODPOLYFIT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ModPolyFit_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MODPOLYFIT_GUI('CALLBACK') and MODPOLYFIT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MODPOLYFIT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModPolyFit_GUI

% Last Modified by GUIDE v2.5 13-Jul-2015 16:16:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModPolyFit_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ModPolyFit_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ModPolyFit_GUI is made visible.
function ModPolyFit_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ModPolyFit_GUI
handles.output = hObject;

handles.validPlot = false;
handles.linesDrawn1 = false;
handles.linesDrawn2 = false;
handles.PATH = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModPolyFit_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModPolyFit_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [horizLine, vertLine] = drawCross(x, y, currplot)
plot_xlim = xlim(currplot);
plot_ylim = ylim(currplot);

set(currplot, 'NextPlot', 'add');
horizLine = plot(currplot, [plot_xlim(1), plot_xlim(2)], [y, y]);
vertLine = plot(currplot, [x, x], [plot_ylim(1), plot_ylim(2)]);
set(horizLine, 'Color', 'red');
set(vertLine, 'Color', 'red');
set(currplot, 'NextPlot', 'replacechildren');


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
if handles.validPlot == false
    return
end

if handles.linesDrawn1 ~= false
    
    x = handles.xClick1;
    y = handles.yClick1;

    plot_xlim1 = xlim(handles.OutputPlot1);
    plot_ylim1 = ylim(handles.OutputPlot1);

    xMin1 = plot_xlim1(1); xMax1 = plot_xlim1(2);
    yMin1 = plot_ylim1(1); yMax1 = plot_ylim1(2);

    plotaxes = findobj(handles.OutputPlot1, 'Type', 'axes');
    cP = get(plotaxes, 'CurrentPoint');
    within_xbounds1 = and(cP(1, 1) >= xMin1, cP(1, 1) <= xMax1);
    within_ybounds1 = and(cP(1, 2) >= yMin1, cP(1, 2) <= yMax1);

    if and(within_xbounds1, within_ybounds1)

        if eventdata.VerticalScrollCount < 0
            xChange = (xMax1 - xMin1) * 0.9 / 2;
            yChange = (yMax1 - yMin1) * 0.9 / 2;
        elseif eventdata.VerticalScrollCount > 0
            xChange = (xMax1 - xMin1) * 1.1 / 2;   
            yChange = (yMax1 - yMin1) * 1.1 / 2;
        else
            return;
        end

        xMin1 = x - xChange; xMax1 = x + xChange;
        yMin1 = y - yChange; yMax1 = y + yChange;

        set(handles.OutputPlot1, 'xlim', [xMin1, xMax1]);
        set(handles.OutputPlot1, 'ylim', [yMin1, yMax1]);

        if handles.linesDrawn1 == true
            delete(handles.horizline1);
            delete(handles.vertline1);
           [handles.horizline1, handles.vertline1] = drawCross(x, y, handles.OutputPlot1);
        end
    end
end

if handles.linesDrawn2 ~= false

    x = handles.xClick2;
    y = handles.yClick2;

    plot_xlim2 = xlim(handles.OutputPlot2);
    plot_ylim2 = ylim(handles.OutputPlot2);
    xMin2 = plot_xlim2(1); xMax2 = plot_xlim2(2);
    yMin2 = plot_ylim2(1); yMax2 = plot_ylim2(2);
    plotaxes = findobj(handles.OutputPlot2, 'Type', 'axes');
    cP = get(plotaxes, 'CurrentPoint');
    within_xbounds2 = and(cP(1, 1) >= xMin2, cP(1, 1) <= xMax2);
    within_ybounds2 = and(cP(1, 2) >= yMin2, cP(1, 2) <= yMax2);

    if and(within_xbounds2, within_ybounds2)

        if eventdata.VerticalScrollCount < 0
            xChange = (xMax2 - xMin2) * 0.9 / 2;
            yChange = (yMax2 - yMin2) * 0.9 / 2;
        elseif eventdata.VerticalScrollCount > 0
            xChange = (xMax2 - xMin2) * 1.1 / 2;
            yChange = (yMax2 - yMin2) * 1.1 / 2;
        end

        xMin2 = x - xChange; xMax2 = x + xChange;
        yMin2 = y - yChange; yMax2 = y + yChange;

        set(handles.OutputPlot2, 'xlim', [xMin2, xMax2]);
        set(handles.OutputPlot2, 'ylim', [yMin2, yMax2]);

        if handles.linesDrawn2 == true
            delete(handles.horizline2);
            delete(handles.vertline2);
            [handles.horizline2, handles.vertline2] = drawCross(x, y, handles.OutputPlot2);
        end

    end
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function OutputPlot1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputPlot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate OutputPlot1
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function OutputPlot1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OutputPlot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.linesDrawn1 == true
    delete(handles.horizline1);
    delete(handles.vertline1);
end

plotaxes = findobj(handles.OutputPlot1, 'Type', 'axes');
cP = get(plotaxes, 'CurrentPoint');
x = cP(1, 1); handles.xClick1 = x;
y = cP(1, 2); handles.yClick1 = y;

plot_xlim = xlim(handles.OutputPlot1);
plot_ylim = ylim(handles.OutputPlot1);

[handles.horizline1, handles.vertline1] = drawCross(x, y, handles.OutputPlot1);
handles.linesDrawn1 = true;

s = sprintf('Cursor Position: ( %.2f, %.2f)', x, y);
set(handles.CursorPos1, 'String', s);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function OutputPlot2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputPlot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate OutputPlot2
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function OutputPlot2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OutputPlot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% plotaxes = findobj(handles.OutputPlot2, 'Type', 'axes');
plotaxes = findobj(handles.OutputPlot2, 'Type', 'axes');
cP = get(plotaxes, 'CurrentPoint');
x = cP(1, 1); handles.xClick2 = x;
y = cP(1, 2); handles.yClick2 = y;

plot_xlim = xlim(handles.OutputPlot2);
plot_ylim = ylim(handles.OutputPlot2);

if handles.linesDrawn2 == true
    delete(handles.horizline2);
    delete(handles.vertline2);
end

[handles.horizline2, handles.vertline2] = drawCross(x, y, handles.OutputPlot2);
handles.linesDrawn2 = true;

s = sprintf('Cursor Position: ( %.2f, %.2f)', x, y);
set(handles.CursorPos2, 'String', s);

guidata(hObject, handles);


% --- Executes on button press in FileSelect.
function FileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to FileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% reads spectrum data from file into N x 2 array via gui interface
    if isempty(handles.PATH)
        [FileName, PathName] = uigetfile({'*.txt'; '*.spc'; '*.wxd'},...
                                         'Select File');
    else
        [FileName, PathName] = uigetfile({'*.txt'; '*.spc'; '*.wxd'},...
                                         'Select File',...
                                         strcat(handles.PATH, handles.FILE));
    end
    
    handles.PATH = PathName;
    handles.FILE = FileName;
    handles.EXT = FileName(size(FileName, 2)-3:end);
    guidata(hObject, handles);
    
    try
        if strcmpi('.txt', handles.EXT)
            origSpectralData = dlmread(strcat(PathName, FileName));
        elseif strcmpi('.spc', handles.EXT)
            SPCout = tgspcread(strcat(PathName, FileName));
            origSpectralData = [SPCout.X, SPCout.Y];
        end
    catch
        msgbox('Failed to open file', 'ERROR');
        handles.validPlot = false;
        guidata(hObject, handles);
    end
        
        origSpectralData = sortrows(origSpectralData, 1);

        % x is the column vector of raman shifts
        handles.x = origSpectralData(:,1);
        handles.xNew = origSpectralData(:,1);
        % y is the column vector of intensities
        handles.y = origSpectralData(:,2);
        handles.yNew = origSpectralData(:,2);

        plot1data = plot(handles.OutputPlot1, handles.x, handles.y);
        ylim(handles.OutputPlot1, 'auto');
        xlim(handles.OutputPlot1, 'auto');
        set(plot1data, 'HitTest', 'off');
        plot2data = plot(handles.OutputPlot2, handles.x, handles.y);
        delete(plot2data);

        handles.validPlot = true;
        handles.linesDrawn1 = false;
        handles.linesDrawn2 = false;
        guidata(hObject, handles);



function DataFrom_Callback(hObject, eventdata, handles)
% hObject    handle to DataFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataFrom as text
%        str2double(get(hObject,'String')) returns contents of DataFrom as a double
handles.minShift = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DataFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.minShift = str2double(get(hObject,'String'));
guidata(hObject, handles);


function DataTo_Callback(hObject, eventdata, handles)
% hObject    handle to DataTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataTo as text
%        str2double(get(hObject,'String')) returns contents of DataTo as a double
handles.maxShift = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DataTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.maxShift = str2double(get(hObject,'String'));
guidata(hObject, handles);



function PolyDeg_Callback(hObject, eventdata, handles)
% hObject    handle to PolyDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PolyDeg as text
%        str2double(get(hObject,'String')) returns contents of PolyDeg as a
%        double

handles.polyDegStr = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PolyDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PolyDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.polyDegStr = get(hObject,'String');
guidata(hObject, handles);



function smoothDeg_Callback(hObject, eventdata, handles)
% hObject    handle to smoothDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothDeg as text
%        str2double(get(hObject,'String')) returns contents of smoothDeg as a double
handles.k = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function smoothDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.k = get(hObject,'String');
guidata(hObject, handles);


function smoothBoxWidth_Callback(hObject, eventdata, handles)
% hObject    handle to smoothBoxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothBoxWidth as text
%        str2double(get(hObject,'String')) returns contents of smoothBoxWidth as a double
handles.f = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function smoothBoxWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothBoxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.f = get(hObject,'String');
guidata(hObject, handles);




% --- Executes on button press in plotSpectrum.
function plotSpectrum_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.validPlot == true
    try
        [handles.xNew, handles.yNew] = drawGraph(handles.x, handles.y,...
                                                 handles.minShift, handles.maxShift,...
                                                 handles.polyDegStr,...
                                                 handles.k, handles.f,...
                                                 handles.OutputPlot1, handles.OutputPlot2);
        set(handles.OutputPlot1, 'xLim', [handles.minShift, handles.maxShift]);
        ylim(handles.OutputPlot1, 'auto');
        set(handles.OutputPlot2, 'xLim', [handles.minShift, handles.maxShift]);
        ylim(handles.OutputPlot2, 'auto');
        handles.linesDrawn1 = false;
        handles.linesDrawn2 = false;
        guidata(hObject, handles);
    catch
        msgbox('Invalid parameters', 'ERROR');
    end
else
    msgbox('No valid plot loaded', 'ERROR');
end


% --- Executes on button press in saveText.
function saveText_Callback(hObject, eventdata, handles)
% hObject    handle to saveText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
correctedSpectra = [[handles.xNew] [handles.yNew]];
[FileName, PathName] = uiputfile({'*.txt'}, 'Save as',...
                                 strcat(handles.PATH, handles.FILE));
dlmwrite(strcat(PathName, FileName), correctedSpectra,...
        'delimiter', '\t', 'newline', 'pc');
