%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
% SMT - Single Molecule Tracking                  %
% ==================================              %
%                                                 %
%    Copyright (C) 2011 Fredrik Persson           %
%    Email: freddie.persson@gmail.com             %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%    This file is part of SMT - Single Molecule Tracking.
%
%     SMT is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     SMT is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with SMT.  If not, see <http://www.gnu.org/licenses/>.



%%%%%%%%%%%%%%%%%%
% Main functions %
% ============== %
%%%%%%%%%%%%%%%%%%


function vargout = DetectMoleculesWavelet(varargin)

clear all
try
    close(findobj('Tag', 'hDET'));
catch
end

% Add Tools directory
dir0=pwd;
addpath(genpath([dir0 filesep '..' filesep '..' filesep 'Tools']))

f1 = figure('Visible','off');

% Create main figure
hFig = figure(...
    'Units','pixels',...
    'Tag','hDET',...
    'MenuBar','none',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'Visible','off',...
    'Position',[0 0 1 1],...
    'Resize','off',...
    'Colormap',hot);

% Font and font size
font = 'Ariel';
fontsize = 13;

if ispc || isunix
    fontsize = fontsize*(72/96);
end

%Draw all the panes etc
drawContent(hFig, font, fontsize);

% Load Data to GUI
LoadNewData;

% Set window visible
% 	movegui(hFig,'north');
set(hFig,'Visible','on');

close(f1)
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw GUI content functions %
% ========================== %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function drawContent(hObject,varargin)

% Delete previous content
delete(get(hObject,'Children'));

% Set name of window
set(hObject,'Name','SMT_DetectWavelet - Detect Molecule Positions from ROI using Wavelets');


% Dimensions
pw = 450; axh = 450 - 20;

sh = 30;

th = 20;

brh = 47;

roiSelH = 20 + axh + sh + 10;
dataInfoH = 20 + 7*(th + 5) + 5;

filtH = 20 + 8*(th+5) + 5;

rH = brh + 10 + filtH + 20;
lH = brh + 10 + dataInfoH + 10 + roiSelH + 20;

h = max(rH,lH);
w = 20 + pw + 20 + pw + 20;

if (rH > lH)
    dataInfoH = dataInfoH + (rH-lH);
elseif (rH < lH)
    filtH = filtH + (lH-rH);
end

yl1 = h - (20 + roiSelH);
yl2 = yl1 - (10 + dataInfoH);

x1 = 20;
x2 = x1 + pw + 20;

set(hObject,'Position',[0 0 w h]);

%System font
font = varargin{1};
fontsize = varargin{2};

% Button Row Panel
hButtonPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','DETECT_panel_buttonRow',...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'visible','on',...
    'BorderType','none',...
    'Position',[0 0 w brh]);
uiButtonRowPanel(hButtonPanel, 0, fontsize, font);

% ROI Selection Panel
hROISelectionPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','DETECT_panel_roiSelection',...
    'Title','Select Region Of Interest (ROI)',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x1 yl1 2*pw+20 roiSelH]);
uiROISelectionPanel(hROISelectionPanel, 0, fontsize, font);

% Info Panel
hDataInfoPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','DETECT_panel_dataInfo',...
    'Title','Info',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x1 yl2 pw dataInfoH]);
uiDataInfoPanel(hDataInfoPanel, 0, fontsize, font);

% Filtering Panel
hFilteringPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','DETECT_panel_hProj',...
    'Title','Filtering',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x2 yl2 pw dataInfoH]);
uiFilterPanel(hFilteringPanel, 0, fontsize, font);

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Panel construction functions %
% ============================ %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function uiButtonRowPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

w = pos(3);
h = pos(4);

bw = 90; bh = 25;

% Close button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Close',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[w-(bw+20) 10 bw bh],...
    'Callback',{@CloseButton});

% Load TIF
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Load new file.',...
    'String','Load new TIF',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[w-(3*bw+20) 10 2*bw bh],...
    'Callback',{@LoadTIFButton});

	% About button
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'TooltipString','Brings up an About box.',...
		'String','About',...
		'Position',[w-(5*bw+20) 10 bw bh],...
		'Callback',{@aboutButton});
    
    % Run Batch button
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'TooltipString','Lets you select and run multiple files. No possibility to align etc.',...
		'String','Run Batch',...
		'Position',[w-(6*bw+20) 10 bw bh],...
		'Callback',{@BatchButton});

% Edit field to set max # of black frames to replace empty frames.
uicontrol(...
    'Parent',hObject,...
    'Tag','DETECT_save_blackFrames_0',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Style','edit',...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Max number of black empty frames in a row.',...
    'String','3',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Visible', 'off',...
    'Position',[20 30 0.5*bw bh]);

uicontrol(...	% Note
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Max number of black frames in a row.',...
    'FontName', varargin{end} ,...
    'Visible', 'off',...
    'Position',[20+0.5*bw 30 1.5*bw bh]);

% Save TIF stack without "empty frames" button.
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Save TIF stack without "empty frames" according to the set thresholding.',...
    'String','Save TIF without empty frames',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[20 5 2*bw bh],...
    'Visible', 'off',...
    'Callback',{@SaveTIFButton});


% Save MAT struct with "position frames" in between.
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Save MAT struct with peakmarked frames between, according to the set thresholding.',...
    'String','Save MAT incl pos frames',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[20+2*bw 10 2*bw bh],...
    'Callback',{@SaveMATButton, 1});

end

function uiROISelectionPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

w = pos(3);
h = pos(4);

axw = 450 - 20; axh = 450 - 20;

bw = 90; bh = 25;

sh = 30;

x1 = 10;
x2 = x1 + axw;

y1 = h - (20 + axh);
y2 = y1 - (sh);
y3 = y2 - (sh);

% Calculate Variables
stackSize = 2;
frameNumber = 1;
detectedDots = 0;
original = rand(10);
current = original;

% ROI Selection Axes
hAx = axes(...
    'Parent',hObject,...
    'Units','pixels',...
    'Position',[x1 y1 axw*2+35 axh],...
    'Visible','on');
hImsc = imagesc(current,[min(min(current)) max(max(current))]);
set(hImsc,'Parent',hAx,...
    'Tag','DETECT_imgsc_roiSelection',...
    'CDataMapping','scaled',...
    'Visible','on');
axis(hAx,'off','tight','xy');

%Set Pixel value Info tool
hPixelValPanel = impixelinfo;
set(hPixelValPanel, 'Position', [30 270 150 20]);

% Add selection tool to main axes
so = size(current);
selection = round([.4*so(2) .4*so(1) .2*so(2) .2*so(1)]);

roiSelTool = imrect(hAx,selection);
addNewPositionCallback(roiSelTool,@ROISelectionChange);

fcn = makeConstrainToRectFcn('imrect',[1 so(2)],[1 so(1)]);
setPositionConstraintFcn(roiSelTool,fcn);
clear so;

% Scroll bar and Label
uicontrol(...	% Scrollbar
    'Parent',hObject,...
    'Tag','DETECT_scrollbar_frameNumber',...
    'Style','slider',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontName', varargin{end} ,...    
    'FontSize',varargin{end-1},...
    'Max',stackSize,...
    'Min',1,...
    'SliderStep',[1 10] / (stackSize-1),...
    'Value',1,...
    'Position',[x1 y2 axw*2+35 sh],...
    'Callback',{@ScrollImage},...
    'Enable','on');
% 	uicontrol(...	% Label
% 		'Parent',hObject,...
% 		'Style','text',...
% 		'Units','pixels',...
% 		'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
% 		'FontSize',10,...
% 		'HorizontalAlignment','center',...
% 		'String','Change current frame number by using scrollbar',...
% 	   'Position',[x1 y2-5 axw 20]);
uicontrol(...	% Label
    'Parent',hObject,...
    'Tag','DETECT_label_FrameNumber',...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String',sprintf('Current frame: %g',frameNumber),...
    'FontName', varargin{end} ,...
    'Position',[x1+(axw-120) y1-35 120 18]);

uicontrol(...	% Label
    'Parent',hObject,...
    'Tag','DETECT_label_DetectedDots',...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String',sprintf('Number of detected dots: %g',detectedDots),...
    'FontName', varargin{end} ,...
    'Position',[x2+200 y1-35 240 18]);

% Store gui data
data.DETECT.stackSize = stackSize;
data.DETECT.frameNumber = frameNumber;
data.DETECT.detectedDots = detectedDots;
data.DETECT.original = original;
data.DETECT.current = current;

data.DETECT.roiSelTool = roiSelTool;

data.DETECT.selection = selection;

guidata(findobj('Tag','hDET'),data);

end

function uiDataInfoPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

w = pos(3);
h = pos(4);

bw = 150; bh = 25;

lw = 100; lh = 20;

tw = round(w/2) - (10 + lw + 5 + 5);

x1 = 10;
x2 = x1 + lw + 5;
x3 = round(w/2)+25;
x4 = x3 + lw + 5;

y1 = h - (20 + lh);
y2 = y1 - (lh + 15);
y3 = y2 - (lh + 5);
y4 = y3 - (lh + 5);
y5 = y4 - (lh + 5)-10;
y6 = y5 - (lh + 5);
y7 = y6 - (lh + 5);

% Load Data
data = guidata(findobj('Tag','hDET'));

%	filename = data.DETECT.filename;
original = data.DETECT.original;
stackSize = data.DETECT.stackSize;
selection = data.DETECT.selection;

% Calculate variables
filename = '-';

% LABEL - Filename
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Filename:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',filename,...
    'FontName', varargin{end} ,...
    'Position',[x2 y1-10 w-(x2+10) lh+10],...
    'Tag','DETECT_label_filename');

% LABEL - Stack Size
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Stack Size:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('%g',stackSize),...
    'FontName', varargin{end} ,...
    'Position',[x2 y2 tw lh],...
    'Tag','DETECT_label_stackSize');

% LABEL - Frame Size
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Frame Size:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('[%g,%g]',size(original)),...
    'FontName', varargin{end} ,...
    'Position',[x2 y3 tw lh],...
    'Tag','DETECT_label_frameSize');

% LABEL - ROI Data
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','ROI Data:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y5 lw 2*lh+5]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('x = %g\t\ty = %g\nw = %g\t\th = %g',selection),...
    'FontName', varargin{end} ,...
    'Position',[x2 y5 tw 2*lh+5],...
    'Tag','DETECT_label_roi');


% Which wavelet plane to detect in
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(hObject,'BackgroundColor'),...
    'Units','pixels',...
    'HorizontalAlignment','left',...
    'String','Wavelet for detection:',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x3 y2 bw bh]);
uicontrol(...	% Popup meny
    'Parent',hObject,...
    'Style','popup',...
    'Tag','DETECT_popup_detectPlane_0',...
    'BackgroundColor',get(hObject,'BackgroundColor'),...
    'Units','pixels',...
    'TooltipString','First refers to the noise, unsensitive to dark/bright areas. Actual is unsensitive to general intensity SNR changes.',...
    'String','2|3|sum',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Callback',{},...
    'Enable', 'on',...
    'Position',[x3 y2-15 bw/1.5 bh]);


% Which wavelet threshold
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(hObject,'BackgroundColor'),...
    'Units','pixels',...
    'HorizontalAlignment','left',...
    'String','Wavelet thresholding:',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x3 y3-15 bw bh]);
uicontrol(...	% Popup meny
    'Parent',hObject,...
    'Style','popup',...
    'Tag','DETECT_popup_noisePlane_0',...
    'BackgroundColor',get(hObject,'BackgroundColor'),...
    'Units','pixels',...
    'TooltipString','First refers to the noise, unsensitive to dark/bright areas. Actual is unsensitive to general intensity SNR changes.',...
    'String','actual|first|simNoise',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Callback',{},...
    'Enable', 'on',...
    'Position',[x3 y3-30 bw/1.5 bh]);
% Edit box to set the max
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_edit_threshold_0',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Set the threshold value for the analysis.',...
    'String','2.5',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x4+30 y3-11 50 lh]);




% BUTTON - Use global intensity scaling
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String', 'Global Scaling',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x3-20 y5 bw bh],...
    'Callback', {@IntensScaleButton},...
    'Tag','DETECT_label_intensScale_0',...
    'Enable','on');
% Edit box to set the max
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_label_intensScale_1',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Set the max value of global scaling manually',...
    'String','0',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x4+30 y5+4 50 lh]);


% BUTTON - Process current frame
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String', 'Process frame',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'TooltipString','Processes one frame (unfiltered data) according to the settings',...
    'Position',[x3-20 y5-(bh+10) bw bh],...
    'Callback', {@ProcessFrameButton},...
    'Enable','on');


guidata(findobj('Tag','hDET'),data);

end

function uiFilterPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

% Global positions
w = pos(3);	h = pos(4);

% Label height/width
lw = 120; lh = 23;

% Edit box height/width
ew = 50; eh = lh;

% Note height/width
nw = w - (10 + lw + ew + ew + 10); nh = lh;

% Start positions
x1 = 10;
x2 = x1 + lw;
x3 = x2 + ew;
x4 = x3 + ew;

y1 = h - (20 + lh);
y2 = y1 - (lh + 5);
y3 = y2 - (lh + 5);
y4 = y3 - (lh + 5);
y5 = y4 - (lh + 5);
y6 = y5 - (lh + 5);
y7 = y6 - (lh + 5);

% Titles
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Filter type:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','(1)',...
    'FontName', varargin{end} ,...
    'Position',[x2 y1 ew lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','(2)',...
    'FontName', varargin{end} ,...
    'Position',[x3 y1 ew lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Notes',...
    'FontName', varargin{end} ,...
    'Position',[x4 y1 nw lh]);

% Lorentzian of Gaussian
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric LoG filter of size (1), and standard deviation (2)',...
    'String','MexiHat',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh],...
    'Callback',{@AdjustImage,'gaussian'},...
    'Tag','DETECT_filt_log_0',...
    'Enable','on');
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_filt_log_1',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric filter LoG of size (1), and standard deviation (2)',...
    'String','9',...
    'FontName', varargin{end} ,...
    'Callback',{@AdjustImage,'log'},...
    'Position',[x2 y2 ew lh]);
uicontrol(...	% Sigma
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_filt_log_2',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric LoG filter of size (1), and standard deviation (2)',...
    'String','1.3',...
    'FontName', varargin{end} ,...
    'Callback',{@AdjustImage,'log'},...
    'Position',[x3 y2 ew lh]);
uicontrol(...	% Note
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1}-2,...
    'HorizontalAlignment','left',...
    'String','Rotationally symmetric LoG filter of size (1), and standard deviation (2)',...
    'FontName', varargin{end} ,...
    'Position',[x4 y2 nw lh]);

% Gaussian
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric Gaussian lowpass filter of size (1), and standard deviation (2)',...
    'String','Gaussian',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh],...
    'Callback',{@AdjustImage,'gaussian'},...
    'Tag','DETECT_filt_gauss_0',...
    'Enable','on');
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_filt_gauss_1',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric Gaussian lowpass filter of size (1), and standard deviation (2)',...
    'String','7',...
    'FontName', varargin{end} ,...
    'Callback',{@AdjustImage,'gaussian'},...
    'Position',[x2 y3 ew lh]);
uicontrol(...	% Sigma
    'Parent',hObject,...
    'Style','edit',...
    'Tag','DETECT_filt_gauss_2',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric Gaussian lowpass filter of size (1), and standard deviation (2)',...
    'String','1',...
    'FontName', varargin{end} ,...
    'Callback',{@AdjustImage,'gaussian'},...
    'Position',[x3 y3 ew lh]);
uicontrol(...	% Note
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hDET'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1}-2,...
    'HorizontalAlignment','left',...
    'String','Rotationally symmetric Gaussian lowpass filter of size (1), and standard deviation (2)',...
    'FontName', varargin{end} ,...
    'Position',[x4 y3 nw lh]);

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button callback functions %
% ========================= %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function aboutButton(~,~,varargin)
	
    msgbox(sprintf(...
['\nSMTrack, DetectMolecules.m \n\n' 'Copyright (C) 2011 Fredrik Persson \n\n' ...
 'This program comes with ABSOLUTELY NO WARRANTY. \n' ...
 'This is free software, and you are welcome to redistribute it \n' ...
 'under certain conditions. See license.txt for details. \n\n ']));
	
end

function CloseWindow(varargin)

close(varargin{3});

end

function BatchButton(~, varargin)


[filename, pathname] = uigetfile({'*.stk; *.tif', 'Images (*.tif,*.stk)'; '*.tif',  'TIF files (*.tif)'; '*.stk', 'STK files (*.stk)'; '*.*', 'All Files (*.*)'}, 'Select image file (STK or TIF)', 'MultiSelect', 'on');

switch iscell(filename)
    case 1
        if cellfun('isempty', filename)
            disp('Error! No (or wrong) file selected!')
            return
        end
    case 0
            disp('Batch means that you should choose MULTIPLE files.')
            return
end


for fileNum = 1:length(filename)
    fileNum
    LoadNewData({pathname, filename{fileNum}});
    SaveMATButton('fast', 'fast'); 
end

disp('All files saved sucessfully');
end

function IntensScaleButton(hObject,varargin)

% Load data structure
data = guidata(findobj('Tag','hDET'));

% Update button text and decide whether to continue
switch data.DETECT.toggleScaling
    case true
        set(hObject,'String','Global Scaling');
        data.DETECT.toggleScaling = false;
        guidata(findobj('Tag','hDET'), data);
        UpdateAxes;
        return
    case false
        set(hObject,'String','Frame scaling');
        data.DETECT.toggleScaling = true;
end


if str2double(get(findobj('Tag','DETECT_label_intensScale_1'),'String')) == 0

% Get File Data
selection = data.DETECT.selection;
filtData = data.DETECT.rawData;

filterNames = {...
    'log';...
    'gaussian'};
filterTypes = {...
    'DETECT_filt_log_0';...
    'DETECT_filt_gauss_0'};

% Filter the whole stack
for i = 1 : length(filterNames)
    
    if (get(findobj('Tag',filterTypes{i}),'Value'))
        
        switch filterTypes{i}
            
            case 'DETECT_filt_log_0'
                
                p(1) = str2double(get(findobj('Tag','DETECT_filt_log_1'),'String'));
                p(2) = str2double(get(findobj('Tag','DETECT_filt_log_2'),'String'));
                
                mask = -1*fspecial(filterNames{i},p(1),p(2));
                enhFact = 60/max(max(mask));
                mask = enhFact*mask;
                filtData = imfilter(filtData, mask, 'symmetric', 'conv');
                
                %Put negative values to zero
                ind = find(filtData<0);
                filtData(ind) = 0;
                
            case 'DETECT_filt_gauss_0'
                
                p(1) = str2double(get(findobj('Tag','DETECT_filt_gauss_1'),'String'));
                p(2) = str2double(get(findobj('Tag','DETECT_filt_gauss_2'),'String'));
                
                mask = fspecial(filterNames{i},p(1),p(2));
                enhFact = 60/max(max(mask));
                mask = enhFact*mask;
                filtData = imfilter(filtData, mask, 'symmetric', 'conv');
                
        end
        
    end
    
end


s = round(selection);

% Calculate global max (av of 20 brightest) and min intensity.
maxVals = max(max(filtData(s(2):s(2)+s(4)-1,s(1):s(1)+s(3)-1,:)));
sortmaxVals = sort(maxVals);
dataMax = mean(sortmaxVals(:, :, end-20:end));
data.DETECT.roiIntensMax = dataMax;
dataMin = min(min(min(filtData(s(2):s(2)+s(4)-1,s(1):s(1)+s(3)-1,:))));
data.DETECT.roiIntensMin = dataMin;

else
   dataMax = str2double(get(findobj('Tag','DETECT_label_intensScale_1'),'String')); 
   dataMin = min(min(data.DETECT.current));
   data.DETECT.roiIntensMax = dataMax;
   data.DETECT.roiIntensMin = dataMin;
end

guidata(findobj('Tag','hDET'),data);

% Adjust Images
AdjustImage();


end

function LoadTIFButton(~, varargin)

LoadNewData;

end

function SaveMATButton(~, varargin)

% Filter and prep the whole stack
AdjustImage('all');

% Load data structure
data = guidata(findobj('Tag','hDET'));

% Get File Data
filtData = data.DETECT.filtData;
rawData = data.DETECT.rawData;
s = data.DETECT.selection;
stackSize = data.DETECT.stackSize;
oldFNr = data.DETECT.frameNumber;
filename_raw = data.DETECT.filename;
path_raw = data.DETECT.pathname;

%Modify name and path
filename = strcat('SMT3_LOCinput_', filename_raw);
filename(end-2:end) = 'mat';

% If needed, make a subfolder called SMT
subFold = 'SMT/';
path = strcat(path_raw, subFold);

if exist(path, 'dir') ~= 7
    mkdir(subFold);
end

if ~isstr(varargin{1})
    % Show save dialogue
    oldFolder=cd(path)
    [filename, path] = uiputfile('*.mat', 'Select .mat file to save', filename);
    cd(oldFolder)
end

full_filename = [path filename];
full_filename_raw = [path_raw filename_raw];

% Overwrite
if exist(full_filename) == 2
    delete(full_filename);
end


% Get ROI selected data region
roi = filtData(s(2):s(2)+s(4)-1,s(1):s(1)+s(3)-1, :);

ind = 1;
detPos = cell(1, size(filtData, 3));

tic
% Find detection conditions
val = get(findobj('Tag', 'DETECT_popup_detectPlane_0'),'Value');
if val == 1
    detectPlane = 2;
elseif val == 2
    detectPlane = 3;
elseif val == 3
    detectPlane = 0;
end

val = get(findobj('Tag', 'DETECT_popup_noisePlane_0'),'Value');
if val == 1
    noisePlane = 'actualPlaneNoise';
elseif val == 2
    noisePlane = 'firstPlaneNoise';
elseif val == 3
    noisePlane = 'simNoise';
end

TH = str2num(get(findobj('Tag', 'DETECT_edit_threshold_0'),'String'));
if isfield(data.DETECT, 'pHandles')
    data.DETECT=rmfield(data.DETECT, 'pHandles');
end
% Run through all frames
for outFrame = 1 : data.DETECT.stackSize
    outFrame
    current = data.DETECT.filtData(:, :, outFrame);
    
    [mask, numPoints]=SMT_spotDetect(current, noisePlane, 'noiseTH', TH, 'Plane', detectPlane);
    
    if numPoints>0
        
        stats = regionprops(mask, current, 'Area', 'Centroid', 'WeightedCentroid', 'BoundingBox', 'MeanIntensity');
        posFrame = zeros(size(filtData, 1), size(filtData, 2));
        posFrame(end,end) = outFrame;
        for ind=1:numel(stats)
            coord=stats(ind).WeightedCentroid;
            detPos{outFrame} = [detPos{outFrame}; ind, coord(2), coord(1)];

        end
    else
        detPos{outFrame} = [0 0 0];
    end
end
clear 'coord' 'stats';
toc

DETECT = struct('full_filename_raw', full_filename_raw, 'detectedPositions', {detPos}, 'timeBetweenFrames', num2str(data.DETECT.timeBetweenFrames), 'relIntTh', num2str(1),...
    'intTh', TH, 'gaussian', zeros(1, 2), 'mexiHat', zeros(1, 2), 'globalScale', num2str(data.DETECT.toggleScaling), 'detectionPlane', num2str(detectPlane), 'thresholdPlane', noisePlane);
toc
if (get(findobj('Tag','DETECT_filt_gauss_0'),'Value'))
    p(1) = str2double(get(findobj('Tag','DETECT_filt_gauss_1'),'String'));
    p(2) = str2double(get(findobj('Tag','DETECT_filt_gauss_2'),'String'));
else
    p = [0, 0];
end
    DETECT.gaussian = p;


if (get(findobj('Tag','DETECT_filt_log_0'),'Value'))
    p(1) = str2double(get(findobj('Tag','DETECT_filt_log_1'),'String'));
    p(2) = str2double(get(findobj('Tag','DETECT_filt_log_2'),'String'));
else
    p = [0, 0];
end
    DETECT.mexiHat = p;

% Save the .mat file
save(full_filename, 'DETECT');

%Put back old parameters
data.DETECT.frameNumber = oldFNr;

guidata(findobj('Tag','hDET'), data);

end

function SaveTIFButton(~,varargin)

% Filter and prepp the whole stack
AdjustImage('all');

% Load data structure
data = guidata(findobj('Tag','hDET'));

% Get File Data
filtData = data.DETECT.filtData;
rawData = data.DETECT.rawData;
s = data.DETECT.selection;
stackSize = data.DETECT.stackSize;
oldFNr = data.DETECT.frameNumber;

filename = strcat('SMT_DETECT_noEmpty_', data.DETECT.filename);


% If needed, make a subfolder called SMT
subFold = 'SMT/';
path = data.DETECT.pathname;
path = strcat(path, subFold);

if exist(path, 'dir') ~= 7
    mkdir(subFold);
end

full_filename = [path filename];

if exist(full_filename) == 2
    delete(full_filename);
end

% Get ROI selected data region
roi = filtData(s(2):s(2)+s(4)-1,s(1):s(1)+s(3)-1, :);

% Get peaks region and data intervall
if data.DETECT.toggleScaling
    dataMin = data.DETECT.roiIntensMin*ones(1, 1, size(filtData, 3));
    dataMax = data.DETECT.roiIntensMax*ones(1, 1, size(filtData, 3));
else
    dataMin = min(min(roi));
    dataMax = max(max(roi));
end
dataInterval = dataMax - dataMin;
intTh = (data.DETECT.relIntTh) * dataInterval + dataMin;

darkInd = 1;

% Go through all frames
tic
for outFrame = 1 : data.DETECT.stackSize
    outFrame
    
    % See if the frame contains anything above the threshold
    emptyFrame = isempty(find(roi(:, :, outFrame) > intTh(:, :, outFrame)));
    
    if ~emptyFrame
        
  
            %Write the raw data frame
            imwrite(uint16(rawData(:, :, outFrame)), full_filename, 'tif', 'Compression', 'none', 'WriteMode', 'append');
            
            %Reset darkframe count
            darkInd = 1;

        
    elseif darkInd <= str2double(get(findobj('Tag','DETECT_save_blackFrames_0'),'String'))
        frame1 = min(min(rawData(:, :, outFrame)))*ones(size(rawData(:, :, outFrame)));
        frame1(10, 10) = min(min(rawData(:, :, outFrame)))+100;
        imwrite(uint16(frame1), full_filename, 'tif', 'Compression', 'none', 'WriteMode', 'append');
        darkInd = darkInd+1;
    end
    
end
toc

%Put back old parameters
data.DETECT.frameNumber = oldFNr;

guidata(findobj('Tag','hDET'), data);

end

function CloseButton(~,varargin)

close(findobj('Tag','hDET'));

end

function ProcessFrameButton(hObject,varargin)

% Load data struct
data = guidata(findobj('Tag','hDET'));
current = data.DETECT.current;

val = get(findobj('Tag', 'DETECT_popup_detectPlane_0'),'Value');
if val == 1
    detectPlane = 2;
elseif val == 2
    detectPlane = 3;
elseif val == 3
    detectPlane = 0;
end

val = get(findobj('Tag', 'DETECT_popup_noisePlane_0'),'Value');
if val == 1
    noisePlane = 'actualPlaneNoise';
elseif val == 2
    noisePlane = 'firstPlaneNoise';
elseif val == 3
    noisePlane = 'simNoise';
end

TH = str2num(get(findobj('Tag', 'DETECT_edit_threshold_0'),'String'));

[mask, numPoints]=SMT_spotDetect(current, noisePlane, 'noiseTH', TH, 'Plane', detectPlane);

        stats = regionprops(mask);
if isfield(data.DETECT, 'pHandles')
    pHandles = data.DETECT.pHandles;
    delete(pHandles);
    data.DETECT=rmfield(data.DETECT, 'pHandles');
end
pHandles = zeros(1, length(stats));
        for ind2=1:length(stats)
        hold on
        coord=stats(ind2).Centroid;
        pHandles(ind2)=circle(coord(1), coord(2), 5);
        end
        hold off
set(findobj('Tag','DETECT_label_DetectedDots'),'String',sprintf('Number of detected dots: %g',numPoints));
data.DETECT.pHandles = pHandles;
clear 'coord' 'stats';

% Store all GUI data
guidata(findobj('Tag','hDET'),data);

% Set filter and image
AdjustImage();

end




%%%%%%%%%%%%%%%%%%%%%%
% Callback functions %
% ================== %
%%%%%%%%%%%%%%%%%%%%%%


function ROISelectionChange(pos)

% Get and rename position of selection
pos = round(pos);
x = pos(1); y = pos(2); w = pos(3); h = pos(4);

% Update position label
set(findobj('Tag','DETECT_label_roi'),'String',...
    sprintf('x = %g\t\tw = %g\ny = %g\t\th = %g',x,w,y,h));

% Load data struct
data = guidata(findobj('Tag','hDET'));

% Write data
data.DETECT.selection = pos;

% Store all GUI data
guidata(findobj('Tag','hDET'),data);

% Update images
AdjustImage();

end

function ScrollImage(hObject,~,varargin)

% Get scroll value and set frame number label
frame = get(hObject,'Value');
frame = round(frame);
set(hObject,'Value',frame);
set(findobj('Tag','DETECT_label_FrameNumber'),'String',sprintf('Current frame: %g',frame));

% Load data structure
data = guidata(findobj('Tag','hDET'));

% Write data
data.DETECT.frameNumber = frame;

% Update images
data.DETECT.current = data.DETECT.rawData(:, :, frame);

% if isfield(data.DETECT, 'pHandles')
%     pHandles = data.DETECT.pHandles;
%     delete(pHandles);
%     data.DETECT=rmfield(data.DETECT, 'pHandles');
% end

% Store all GUI data
guidata(findobj('Tag','hDET'),data);
ProcessFrameButton(hObject);
% Set filter and image
AdjustImage();

end

function AdjustImage(varargin)


filterNames = {...
    'log';...
    'gaussian'};
filterTypes = {...
    'DETECT_filt_log_0';...
    'DETECT_filt_gauss_0'};

% Load data struct
data = guidata(findobj('Tag','hDET'));
selection = data.DETECT.selection;
frameN = data.DETECT.frameNumber;
current = data.DETECT.rawData(:, :, frameN);
if ~isempty(varargin) && strncmp(varargin(end), 'all', 3)
    filtData = data.DETECT.rawData;
end

% Add filters
for i = 1 : length(filterNames)
    
    if (get(findobj('Tag',filterTypes{i}),'Value'))
        
        switch filterTypes{i}
            
            case 'DETECT_filt_log_0'
                
                p(1) = str2double(get(findobj('Tag','DETECT_filt_log_1'),'String'));
                p(2) = str2double(get(findobj('Tag','DETECT_filt_log_2'),'String'));
                
                mask = -1*fspecial(filterNames{i},p(1),p(2));
%                 enhFact = 60/max(max(mask));
%                 mask = enhFact*mask;
                if ~isempty(varargin) && strncmp(varargin(end), 'all', 3)
                    filtData = imfilter(filtData, mask, 'symmetric');%, 'conv');
                    ind = find(filtData<0);
                    filtData(ind) = 0;
                else
                    current = imfilter(current, mask, 'symmetric', 'conv');
                    
                    %Put negative values to zero
                ind = find(current<0);
                current(ind) = 0;
                end
                
                
                
            case 'DETECT_filt_gauss_0'
                
                p(1) = str2double(get(findobj('Tag','DETECT_filt_gauss_1'),'String'));
                p(2) = str2double(get(findobj('Tag','DETECT_filt_gauss_2'),'String'));
                
                mask = fspecial(filterNames{i},p(1),p(2));
%                 enhFact = 60/max(max(mask));
%                 mask = enhFact*mask;
                if ~isempty(varargin) && strncmp(varargin(end), 'all', 3)
                    filtData = imfilter(filtData, mask, 'symmetric');%, 'conv');
                    data.DETECT.filtData = filtData;
                    guidata(findobj('Tag','hDET'),data);
                    return
                else
                    current = imfilter(current, mask, 'symmetric');%, 'conv');
                end
        end
        
    end
    
end


% Write data
data.DETECT.current = current;

% Store all GUI data
guidata(findobj('Tag','hDET'),data);

% Update all axes
UpdateAxes;

end


%%%%%%%%%%%%%%%%%%%
% Other functions %
% =============== %
%%%%%%%%%%%%%%%%%%%


function SetAxes(varargin)

% Load data structure
data = guidata(findobj('Tag','hDET'));

selection = data.DETECT.selection;

% ROI Selection Axes
axis(get(findobj('Tag','DETECT_imgsc_roiSelection'),'Parent'),...
    'xy','tight');

end

function UpdateSelectionTools(varargin)

% Load data structure
data = guidata(findobj('Tag','hDET'));

roiSelTool = data.DETECT.roiSelTool;
stackSize = data.DETECT.stackSize;

% Calc new varables
so = size(data.DETECT.current);
newROI = round([1 1 .2*so(2) .2*so(1)]);

% Update constrain functions
fcn = makeConstrainToRectFcn('imrect',[1 so(2)],[1 so(1)]);
setPositionConstraintFcn(roiSelTool,fcn);

% Update positions
setPosition(roiSelTool,newROI);

% Frame number scrollbar
set(findobj('Tag','DETECT_scrollbar_frameNumber'),...
    'Max',stackSize,...
    'Min',1,...
    'SliderStep',[1 10] / (stackSize-1),...
    'Value',1)

end

function UpdateAxes(varargin)

% Load data structure
data = guidata(findobj('Tag','hDET'));

% Get Data
frame = data.DETECT.frameNumber;
selection = data.DETECT.selection;
current = data.DETECT.current;
relIntTh = data.DETECT.relIntTh;
% hSelThH = data.DETECT.hSelThH;
% hSelThV = data.DETECT.hSelThV;

% Get ROI data
s = round(selection);
roi = current(s(2):s(2)+s(4)-1,s(1):s(1)+s(3)-1);

% Calculate peaks region data
if data.DETECT.toggleScaling
    dataMin = data.DETECT.roiIntensMin;
    dataMax = data.DETECT.roiIntensMax;
else
    dataMin = min(min(roi));
    dataMax = max(max(roi))+1;
end

dataInterval = dataMax - dataMin;

% Main axes
set(findobj('Tag','DETECT_imgsc_roiSelection'),...
    'CData', current,...
    'Visible','on');
set(get(findobj('Tag','DETECT_imgsc_roiSelection'),'Parent'),...
    'Clim',[dataMin dataMax]);

drawnow;

end

function ResetLabels(varargin)

% Load Data
data = guidata(findobj('Tag','hDET'));

filename = data.DETECT.filename;
original = data.DETECT.original;
stackSize = data.DETECT.stackSize;
selection = data.DETECT.selection;

% Data Info Panel
set(findobj('Tag','DETECT_label_filename'),'String',filename);
set(findobj('Tag','DETECT_label_stackSize'),'String',sprintf('%g',stackSize));
set(findobj('Tag','DETECT_label_frameSize'),'String',sprintf('[%g,%g]',size(original)));
set(findobj('Tag','DETECT_label_roi'),'String',sprintf('x = %g\t\ty = %g\nw = %g\t\th = %g',selection));
%Button
set(findobj('Tag','DETECT_label_intensScale_0'),'String', 'Global Scaling');

end

function LoadNewData(varargin)

% Load data struct
data = guidata(findobj('Tag','hDET'));
if isfield(data.DETECT, 'pathname')
    cd(data.DETECT.pathname);
end

if nargin == 1
    name = varargin{1};
    pathname = name{1};
    filename = name{2}; 
else
    % Get filename and path with "uigetfile"
    [filename, pathname] = uigetfile({'*.stk; *.tif', 'Images (*.tif,*.stk)'; '*.tif',  'TIF files (*.tif)'; '*.stk', 'STK files (*.stk)'; '*.*', 'All Files (*.*)'}, 'Select image file (STK or TIF)');
    if ( filename == 0 )
        disp('Error! No (or wrong) file selected!')
        filename = 0;
        pathname = 0;
        return
    end
    
end

full_filename = [ pathname, filename ];


if ~isempty(strfind(filename, '.tif'))
    
    % Calc. new variables
    imInfo = imfinfo(full_filename);
    imWidth = imInfo(1).Width;
    imHeight = imInfo(1).Height;
    stackSize = numel(imInfo);
    
    rawData = zeros(imHeight, imWidth, stackSize);
    
    t = Tiff(full_filename, 'r');
    for inFrame = 1:stackSize
        inFrame
        rawData(:, :, inFrame) = t.read();
        if inFrame<stackSize
            t.nextDirectory();
        end
    end
    t.close();
    data.DETECT.timeBetweenFrames = 0;
    
else
    [rawData, timeBetweenFrames] = readSTK(full_filename);
    stackSize = size(rawData, 3);
    data.DETECT.timeBetweenFrames = timeBetweenFrames;
end

if stackSize==1
    rawData(:, :, 2) = zeros(size(rawData(:, :, 1)));
    stackSize = 2;
end

filtData = rawData;
frameNumber = 1;
original = rawData(:, :, frameNumber);
current = original;

toggleScaling = false;
roiIntensMax = 1;
roiIntensMin = 0;

% Store all GUI data
data.DETECT.filename = filename;
data.DETECT.pathname = pathname;
data.DETECT.stackSize = stackSize;
data.DETECT.rawData = rawData;
data.DETECT.filtData = filtData;
data.DETECT.frameNumber = frameNumber;
data.DETECT.original = original;
data.DETECT.current = current;
data.DETECT.toggleScaling = toggleScaling;
data.DETECT.roiIntensMax = roiIntensMax;
data.DETECT.roiIntensMin = roiIntensMin;
data.DETECT.relIntTh = 1;

guidata(findobj('Tag','hDET'),data);


if nargin == 1
    ResetLabels;
else
    % Set Axes to new data and update twice to let it go through
    for i = 1:2
        UpdateSelectionTools;
        UpdateAxes;
        SetAxes;
        AdjustImage();
        ResetLabels;
    end
end
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Discarded functions    %
% ========================= %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
