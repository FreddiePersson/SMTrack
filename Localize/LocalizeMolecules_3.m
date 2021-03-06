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


function LocalizeMolecules2(varargin)

clear all
try
    close(findobj('Tag', 'hLOC'));
catch
end

% Add Tools directory
dir0=pwd;
addpath(genpath([dir0 filesep '..' filesep 'Tools']))

f1 = figure('Visible','off');

% Create main figure
hFig = figure(...
    'Units','pixels',...
    'Tag','hLOC',...
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
set(hObject,'Name','SMT_Localize - Localize Detected Molecules');


% Dimensions
panelWidth = 450;
frameHeight = 450;

delim = 10;

sliderHeight = 30;

buttonRowHeight = 30;

displayHeight = frameHeight + sliderHeight + 10;
localizationHeight = displayHeight-frameHeight/4;
dataInfoHeight = frameHeight/2;
filtHeight = frameHeight/4;
trackHeight = frameHeight/2;

totHeight = buttonRowHeight + delim + dataInfoHeight + delim + displayHeight + 1*delim;

totWidth = 2*delim + panelWidth + 2*delim + panelWidth + 2*delim;


y1 = totHeight - (20 + displayHeight);
y2 = y1 - (10 + dataInfoHeight);

x1 = 20;
x2 = x1 + panelWidth + 20;

set(hObject,'Position',[0 0 totWidth totHeight]);

%System font
font = varargin{1};
fontsize = varargin{2};

% Button Row Panel
hButtonPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_buttonRow',...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'visible','on',...
    'BorderType','none',...
    'Position',[0 0 totWidth buttonRowHeight]);
uiButtonRowPanel(hButtonPanel, 0, fontsize, font);

% Display Panel
hDisplayPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_display',...
    'Title','Frame Display',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x1 y1+delim panelWidth displayHeight]);
uiDisplayPanel(hDisplayPanel, 0, fontsize, font);

% Info Panel
hDataInfoPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_dataInfo',...
    'Title','Data Info',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x1 y2+delim panelWidth dataInfoHeight]);
uiDataInfoPanel(hDataInfoPanel, 0, fontsize, font);

% Localization Panel
hLocPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_Loc',...
    'Title','Localization Parameters',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x2 y1+frameHeight/4+delim panelWidth localizationHeight]);
uiLocalizationPanel(hLocPanel, 0, fontsize, font);

% Tracking Panel
hTrackingPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_tracking',...
    'Title','Track',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x2 y2+filtHeight+delim panelWidth/2-delim trackHeight]);
uiTrackingPanel(hTrackingPanel, 0, fontsize, font);
% Disclaimer text
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',30,...
    'HorizontalAlignment','left',...
    'String','Tracking should be done through the Analyze GUI',...
    'FontName', font,...%'Brush Script MT' ,...
    'ForegroundColor', [0.55 0.55 0.55],...
    'HorizontalAlignment', 'center',...
    'Position',[x2 y2+filtHeight+delim panelWidth/2-delim trackHeight]);


% Visualise Panel
hVisualisePanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_visualise',...
    'Title','Display',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x2+panelWidth/2 y2+filtHeight+delim panelWidth/2-delim trackHeight]);
uiVisualisePanel(hVisualisePanel, 0, fontsize, font);

% Filtering Panel
hFilteringPanel = uibuttongroup(...
    'Parent',hObject,...
    'Tag','LOCALIZE_panel_filter',...
    'Title','Filtering',...
    'FontName', font ,...
    'FontSize',10,...
    'Units','pixels',...
    'BackgroundColor',get(hObject,'Color'),...
    'Position',[x2 y2+delim panelWidth filtHeight]);
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

% Load data
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Load new file.',...
    'String','Load new data',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[w-(3*bw+20) 10 2*bw bh],...
    'Callback',{@LoadButton});


	% About button
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'TooltipString','Brings up an About box.',...
		'String','About',...
		'Position',[w-(5*bw+20) 10 bw bh],...
		'Callback',{@aboutButton});

    
% Run batch
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Runs through a batch of files.',...
    'String','Run batch',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[335 10 bw bh],...
    'Callback',{@BatchButton});


% Save a .mat file with a RESULT struct.
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Saves a .mat file with a RESULT struct, no raw data.',...
    'String','Save .mat with results',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[200 10 1.5*bw bh],...
    'Callback',{@SaveResMatButton});


% Save a .mat file with a LOCALIZE struct.
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'TooltipString','Saves a .mat file with raw input data including settings used.',...
    'String','Save .mat with stack & settings',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[20 10 2*bw bh],...
    'Callback',{@SaveMatButton});



%     % Load a .mat file with the LOCALIZE struct.
% 	uicontrol(...
% 		'Parent',hObject,...
% 		'Units','pixels',...
% 		'Style','pushbutton',...
% 		'TooltipString','Saves a .mat file with the LOCALIZE struct.',...
% 		'String','Load .mat',...
%         'FontName', varargin{end} ,...
% 		'Position',[bw+20 10 bw bh],...
% 		'Callback',{@LoadMatButton, 1});

end

function uiDisplayPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

h = pos(4);

axw = 450 - 20; axh = 450 - 20;

sh = 30;

x1 = 10;

y1 = h - (20 + axh);
y2 = y1 - (sh);

% Calculate Variables
stackSize = 2;
frameNumber = 1;
original = rand(10);
current = original;

% Display Axes
hAx = axes(...
    'Parent',hObject,...
    'Units','pixels',...
    'Position',[x1 y1 axw axh],...
    'Visible','on');
hImsc = imagesc(current,[min(min(current)) max(max(current))]);
set(hImsc,'Parent',hAx,...
    'Tag','LOCALIZE_imgsc_display',...
    'CDataMapping','scaled',...
    'Visible','on');
axis(hAx,'off','tight','xy');

%Set Pixel value Info tool
hPixelValPanel = impixelinfo;
set(hPixelValPanel, 'Position', [30 280 150 20]);

% Scroll bar and Label
uicontrol(...	% Scrollbar
    'Parent',hObject,...
    'Tag','LOCALIZE_scrollbar_frameNumber',...
    'Style','slider',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontName', varargin{end} ,...    
    'FontSize',varargin{end-1},...
    'Max',stackSize,...
    'Min',1,...
    'SliderStep',[1 10] / (stackSize-1),...
    'Value',1,...
    'Position',[x1 y2 axw sh],...
    'Callback',{@ScrollImage},...
    'Enable','on');
uicontrol(...	% Label
    'Parent',hObject,...
    'Tag','LOCALIZE_label_FrameNumber',...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor','black',...
    'ForegroundColor','white',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String',sprintf('Current frame: %g',frameNumber),...
    'FontName', varargin{end} ,...
    'Position',[x1+(axw-120) y1 120 18]);

% Store gui data
data.LOCALIZE.stackSize = stackSize;
data.LOCALIZE.frameNumber = frameNumber;
data.LOCALIZE.original = original;
data.LOCALIZE.current = current;

guidata(findobj('Tag','hLOC'),data);

end

function uiDataInfoPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

w = pos(3);
h = pos(4);

lw = 100; lh = 20;

tw = round(w/2) - (10 + lw + 5 + 5);

x1 = 10;
x2 = x1 + lw + 5;
x3 = round(w/2)+5;
x4 = x3 + lw + 5;

y1 = h - (20 + lh);
y2 = y1 - (lh);
y3 = y2 - (lh + 30);

% Load Data
data = guidata(findobj('Tag','hLOC'));

original = data.LOCALIZE.original;
stackSize = data.LOCALIZE.stackSize;

% Set variables
filename = '-';
pathname = '-';

% LABEL - Filename
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Filename:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',filename,...
    'FontName', varargin{end} ,...
    'Position',[x2 y1-10 w-(x2+10) lh+10],...
    'Tag','LOCALIZE_label_filename');

% LABEL - Pathname
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Pathname:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',pathname,...
    'FontName', varargin{end} ,...
    'Position',[x2 y2-lh w-(x2+10) lh*2],...
    'Tag','LOCALIZE_label_pathname');

% LABEL - Stack Size
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Stack Size:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('%g',stackSize),...
    'FontName', varargin{end} ,...
    'Position',[x2 y3 tw lh],...
    'Tag','LOCALIZE_label_stackSize');

% LABEL - Frame Size
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Frame Size:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3-20 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('[%g,%g]',size(original)),...
    'FontName', varargin{end} ,...
    'Position',[x2 y3-20 tw lh],...
    'Tag','LOCALIZE_label_frameSize');


% Parameters from the DETECT interface

% LABEL - Gauss filter param
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Gauss:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('%g', 666),...
    'FontName', varargin{end} ,...
    'Position',[x4 y3 tw lh],...
    'Tag','LOCALIZE_label_gaussian');

% LABEL - MexiHat filter param
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','MexiHat:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3-20 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('%g', 666),...
    'FontName', varargin{end} ,...
    'Position',[x4 y3-20 tw lh],...
    'Tag','LOCALIZE_label_mexiHat');


% LABEL - relative intensity threshold param
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Rel. intens. thresh.:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3-40 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','666',...
    'FontName', varargin{end} ,...
    'Position',[x4 y3-40 tw lh],...
    'Tag','LOCALIZE_label_relIntTh');


% LABEL - intensity threshold param
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Intens. thresh.:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3-60 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','666',...
    'FontName', varargin{end} ,...
    'Position',[x4 y3-60 tw lh],...
    'Tag','LOCALIZE_label_intTh');


% LABEL - global scaling param
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Global scale:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3-80 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String',sprintf('%g', 666),...
    'FontName', varargin{end} ,...
    'Position',[x4 y3-80 tw lh],...
    'Tag','LOCALIZE_label_globalScale');

% Store gui data
guidata(findobj('Tag','hLOC'),data);

end

function uiLocalizationPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

% Global positions
h = pos(4);

% Label height/width
lw = 120; lh = 23;

% Edit box height/width
ew = 50;


% Start positions
x1 = 10;
x2 = x1 + lw;
x3 = x2 + 1.5*ew;
x4 = x3 + lw;
x5 = x4 + ew;

y1 = h - (20 + lh);
y2 = y1 - (lh + 5);
y3 = y2 - (lh + 5);
y4 = y3 - (lh + 5);
y5 = y4 - (lh + 5);
y6 = y5 - (lh + 5);
y7 = y6 - (lh + 5);
y8 = y7 - (lh + 5);
y9 = y8 - (lh + 5);
y10 = y9 - (lh + 5);
y11 = y10 - (lh + 5);
y12 = y11 - (lh + 5);
y13 = y12 - (lh + 5);
y14 = y13 - (lh + 5);
y15 = y14 - (lh + 5);
y16 = y15 - (lh + 5);
y17 = y16 - (lh + 5);



% Use photon counting
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if signal to photon factors should be calculated.',...
    'String','Photon Statistics',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh],...
    'Callback',{@LocChange,'photon'},...
    'Tag','LOCALIZE_Locset_photon_0',...
    'Value', 0,...
    'Enable','on');

%Calibration Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','CAL',...
    'TooltipString', 'Takes a stack of images: 1 dark image and arbitrary images of even illumination. All with the same settings as the experiment.',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x2 y1 ew lh],...
    'Callback',{@CalibrateEMCCDButton},...
    'Tag','LOCALIZE_Locset_cal_0',...
    'Enable','off');


% EMCCD Baseline
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','EMCCD Baseline:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh]);
uicontrol(...	% Value text
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_baseline_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','The system baseline for the camera (set by baseline clamp if used).',...
    'String','101',...
    'FontName', varargin{end} ,...
    'Position',[x2 y2 ew lh],...
    'Visible', 'off');



% EMCCD Multiplication factor
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Gain [ADU/e-]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh]);
uicontrol(...	% Value text
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_gain_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','The total system gain for the camera+readout (14 for max, 1000, EM-gain and no pregain).',...
    'String','13.9',...
    'FontName', varargin{end} ,...
    'Position',[x2 y3 ew lh],...
    'Visible', 'off');


% Minimum number of photons per dot to accept it
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Photon  threshold: ',...
    'FontName', varargin{end} ,...
    'Position',[x1 y4 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_minPhoton_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Minimum amount of photons within a fitted signal to be used. The amount is counted by integrating the fitted 2D gaussian.',...
    'String','100',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2 y4+4 ew lh],...
    'Visible', 'off');


% Pixelsize
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Scale [nm / Pixel]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y9 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_scale_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','How many nm each pixel is. Should be measured but is approx. Physical pixelsize/Magnification.',...
    'String','106.7',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2 y9+4 ew lh]);

% Fitting Window
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Fitting Window [Pixels]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y10 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_fitWindow_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Window around the coarsly detected peak that will be used to fit it to our model PSF.',...
    'String','9',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2 y10+4 ew lh]);

% Limit on xy fitting error
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Max uncert in xy [nm]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y11 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_fitError_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Maximum standard error from nlparci_FP2 (has to be modified to give it out) from the cov matrix to be displayed.',...
    'String','50',...
    'FontName', varargin{end} ,...
    'Callback',{@LimitXYRes},...
    'Position',[x2 y11+4 ew lh]);



% Use 3D astigmatism data
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose to use 3D localization based on astigmatism.',...
    'String','3D Astigmatism ',...
    'FontName', varargin{end} ,...
    'Position',[x3 y1 lw lh],...
    'Callback',{@LocChange,'3D'},...
    'Tag','LOCALIZE_Locset_3D_0',...
    'Value', 0,...
    'Enable','on');

%Calibration Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','CAL',...
    'TooltipString', 'Takes a stack of images with increasing Z-position of a single fluorescent bead (smaller than 100 nm).',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x4 y1 ew lh],...
    'Callback',{@Calibrate3DButton},...
    'Tag','LOCALIZE_Locset_3Dcal_0',...
    'Enable','off');
% Display results for individual curves
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Display the results curve by curve first.',...
    'String','Display individual calibration curves',...
    'FontName', varargin{end} ,...
    'Position',[x3 y2 lw*2 lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Locset_3Dcal_1',...
    'Value', 0,...
    'Enable','on');

% Hidden text to store 3D calibration data pathname in
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'Tag','LOCALIZE_Locset_cal3DPath_0',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','.',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3 30 lh],...
    'Visible', 'off');


% Calibration curve for width
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','X = ',...
    'FontName', varargin{end} ,...
    'Position',[x3 y3 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalX_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalX'},...
    'Position',[x3+17 y3+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z^3+',...
    'FontName', varargin{end} ,...
    'Position',[x3+50 y3 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalX_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalX'},...
    'Position',[x3+77 y3+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z^2+',...
    'FontName', varargin{end} ,...
    'Position',[x3+110 y3 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalX_3',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalX'},...
    'Position',[x3+137 y3+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z+',...
    'FontName', varargin{end} ,...
    'Position',[x3+170 y3 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalX_4',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalX'},...
    'Position',[x3+185 y3+4 35 lh],...
    'Visible', 'off');


% Calibration curve for height
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Y = ',...
    'FontName', varargin{end} ,...
    'Position',[x3 y4 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalY_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalY'},...
    'Position',[x3+17 y4+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z^3+',...
    'FontName', varargin{end} ,...
    'Position',[x3+50 y4 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalY_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalY'},...
    'Position',[x3+77 y4+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z^2+',...
    'FontName', varargin{end} ,...
    'Position',[x3+110 y4 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalY_3',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalY'},...
    'Position',[x3+137 y4+4 35 lh],...
    'Visible', 'off');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','z+',...
    'FontName', varargin{end} ,...
    'Position',[x3+170 y4 30 lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DcalY_4',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Think about it!',...
    'String','',...
    'FontName', varargin{end} ,...
    'Callback',{@LocChange,'3DcalY'},...
    'Position',[x3+185 y4+4 35 lh],...
    'Visible', 'off');



% Max Min labels
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','Min:',...
    'FontName', varargin{end},...
    'Position',[x4 y5 ew lh]);
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','Max:',...
    'FontName', varargin{end},...
    'Position',[x5 y5 ew lh]);


%Limits on Fitting PSF Width/Height
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','PSF Height/Width [nm]:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y6 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DpsfSize_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Min width of the fitted PSF.',...
    'String','200',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x4 y6+4 ew lh],...
    'Visible', 'off');
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DpsfSize_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Max width of the fitted PSF.',...
    'String','1500',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x5 y6+4 ew lh],...
    'Visible', 'off');



%Limits on z-range for the astigmatism
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Z limits [nm]:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y7 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DzRange_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Min z-value.',...
    'String','-800',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x4 y7+4 ew lh],...
    'Visible', 'off');
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DzRange_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Max z-value.',...
    'String','800',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x5 y7+4 ew lh],...
    'Visible', 'off');

%Limits on closeness to 3D calibration curves
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','"Distance" to cal. curves:',...
    'FontName', varargin{end} ,...
    'Position',[x3 y8 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Locset_3DD_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Distance to calibration curves according to Huang et al. Science 8 February 2008: Vol. 319 no. 5864 pp. 810-813.',...
    'String','5',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x5 y8+4 ew lh],...
    'Visible', 'off');




% Only fit one frame and display results
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Fit current frame only and display the results.',...
    'String','Fit current frame & display result',...
    'FontName', varargin{end} ,...
    'Position',[x3 y10 lw*2 lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Locset_fitSingle_0',...
    'Value', 0,...
    'Enable','on');

% Only use the central pixel as starting value for the final fit.
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Puts (x0, y0) = (0, 0) for fitting.',...
    'String','Central peaks',...
    'FontName', varargin{end} ,...
    'Position',[x3 y11 lw*2 lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Locset_centerPeak_0',...
    'Value', 1,...
    'Enable','off');



% Fit Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','FIT',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x4 y11 lw lh],...
    'Callback',{@fitButton},...
    'Tag','LOCALIZE_Locset_fit_0',...
    'Enable','on');


end

function uiTrackingPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

% Global positions
h = pos(4);

% Label height/width
lw = 120; lh = 23;

% Edit box height/width
ew = 50;


% Start positions
x1 = 10;
x2 = x1 + lw/2;
x3 = x2 + lw/2;
x4 = x3 + lw/2;
x5 = x4 + lw/2;
x6 = x5 + lw/2;
x7 = x6 + lw/2;

y1 = h - (20 + lh);
y2 = y1 - (lh - 2);
y3 = y2 - (lh - 2);
y4 = y3 - (lh - 2);
y5 = y4 - (lh - 2);
y6 = y5 - (lh - 2);
y7 = y6 - (lh - 2);
y8 = y7 - (lh - 2);
y9 = y8 - (lh - 2);
y10 = y9 - (lh - 2);

% Max movement
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Max. dist. [nm]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Trackset_maxDist_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Maximum distance a molecule is allowed to move between frames to still be in the same trajectory.',...
    'String','400',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2+40 y1+4 ew lh]);


% Show trajectory length histogram
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if a histogram with trajectory length should be shown.',...
    'String','Traj. hist. [bins]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Trackset_trajHist_0',...
    'Value', 0,...
    'Enable','on');


% Show MSD plot
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if MSD plot should be displayed.',...
    'String','MSD plot',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Trackset_MSD_0',...
    'Value', 0,...
    'Enable','on');


% Show CDF plot
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if CDF plot should be displayed.',...
    'String','CDF plot [steps]:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y4 lw lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Trackset_CDF_0',...
    'Value', 0,...
    'Enable','on');
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Trackset_CDF_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Number of steps to use as a unit for the CDF.',...
    'String','1',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2+40 y4 ew lh]);


% Track Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Track',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y9 lw lh],...
    'Callback',{@trackButton},...
    'Tag','LOCALIZE_Trackset_track_0',...
    'Enable','off');

% Timestep
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Timestep [ms]:',...
    'FontName', varargin{end} ,...
    'Position',[x1+5 y8 lw lh]);
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Trackset_timeStep_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Time between 2 consecutive frames.',...
    'String','5',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2+40 y8+4 ew lh]);

end

function uiVisualisePanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

% Global positions
h = pos(4);

% Label height/width
lw = 80; lh = 23;

% Edit box height/width
ew = 50;


% Start positions
x1 = 10;
x2 = x1 + lw/2;
x3 = x2 + lw/2;
x4 = x3 + lw/2;
x5 = x4 + lw/2;
x6 = x5 + lw/2;
x7 = x6 + lw/2;

y1 = h - (20 + lh);
y2 = y1 - (lh - 2);
y3 = y2 - (lh - 2);
y4 = y3 - (lh - 2);
y5 = y4 - (lh - 2);
y6 = y5 - (lh - 2);
y7 = y6 - (lh - 2);
y8 = y7 - (lh - 2);
y9 = y8 - (lh - 2);
y10 = y9 - (lh - 2);

% 2D Display Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Display 2D',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y1 lw lh],...
    'Callback',{@display2DButton},...
    'Tag','LOCALIZE_Visset_display2D_0',...
    'Enable','off');
% Overlay
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if you want to overlay the results on an image.',...
    'String','Overlay',...
    'FontName', varargin{end} ,...
    'Position',[x2+40 y1 lw lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Visset_display2D_1',...
    'Value', 0,...
    'Enable','on');


% 3D Display Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Display 3D',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y2 lw lh],...
    'Callback',{@display3DButton},...
    'Tag','LOCALIZE_Visset_display3D_0',...
    'Enable','off');
% Show Aligned
uicontrol(...	% Checkbox
    'Parent',hObject,...
    'Style','checkbox',...
    'Units','pixels',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Choose if you want to align the data to the plot axis.',...
    'String','Show aligned',...
    'FontName', varargin{end} ,...
    'Position',[x2+40 y2 lw*1.5 lh],...
    'Callback',{},...
    'Tag','LOCALIZE_Visset_align_1',...
    'Value', 0,...
    'Enable','on');

% Align Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Align',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y3 lw lh],...
    'Callback',{@alignButton},...
    'Tag','LOCALIZE_Visset_align_0',...
    'Enable','off');


% Correct Drift Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Corr XY-drift',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y4 lw lh],...
    'Callback',{@correctDriftButton},...
    'Tag','LOCALIZE_Visset_corrDrift_0',...
    'Enable','off');
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Visset_corrDrift_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','The number of points to use to determine the center in every step.',...
    'String','200',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2+40 y4 ew lh],...
    'Visible', 'on');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'Tag','LOCALIZE_Visset_corrDrift_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','points',...
    'FontName', varargin{end} ,...
    'Position',[x2+ew+45 y5-4 ew lh]);


% STORM Plot Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','STORM IT',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y5 lw lh],...
    'Callback',{@PALMPlotButton},...
    'Tag','LOCALIZE_Visset_PALMPlot_0',...
    'Enable','off');
uicontrol(...	% Value edit box
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_Visset_PALMPlot_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'TooltipString','Set the resolution in nm.',...
    'String','4',...
    'FontName', varargin{end} ,...
    'Callback',{},...
    'Position',[x2+40 y5 ew lh],...
    'Visible', 'on');
uicontrol(...	% Title
    'Parent',hObject,...
    'Style','text',...
    'Tag','LOCALIZE_Visset_PALMPlot_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','nm',...
    'FontName', varargin{end} ,...
    'Position',[x2+ew+45 y5-4 ew lh]);


% Revert Button
uicontrol(...
    'Parent',hObject,...
    'Units','pixels',...
    'Style','pushbutton',...
    'String','Revert',...
    'FontName', varargin{end} ,...
    'FontSize',varargin{end-1},...
    'Position',[x1 y9 lw lh],...
    'Callback',{@revertButton},...
    'Tag','LOCALIZE_Visset_revert_0',...
    'Enable','on');

end

function uiFilterPanel(hObject,~,varargin)

% Dimensions
pos = get(hObject,'Position');

% Global positions
w = pos(3);	h = pos(4);

% Label height/width
lw = 120; lh = 23;

% Edit box height/width
ew = 50;

% Note height/width
nw = w - (10 + lw + ew + ew + 10);

% Start positions
x1 = 10;
x2 = x1 + lw;
x3 = x2 + ew;
x4 = x3 + ew;

y1 = h - (20 + lh);
y2 = y1 - (lh + 5);
y3 = y2 - (lh + 5);


% Titles
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','left',...
    'String','Filter type:',...
    'FontName', varargin{end} ,...
    'Position',[x1 y1 lw lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','(1)',...
    'FontName', varargin{end} ,...
    'Position',[x2 y1 ew lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'Units','pixels',...
    'FontSize',varargin{end-1},...
    'HorizontalAlignment','center',...
    'String','(2)',...
    'FontName', varargin{end} ,...
    'Position',[x3 y1 ew lh]);
uicontrol(...
    'Parent',hObject,...
    'Style','text',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric LoG filter of size (1), and standard deviation (2)',...
    'String','MexiHat',...
    'FontName', varargin{end} ,...
    'Position',[x1 y2 lw lh],...
    'Callback',{@AdjustImage,'log'},...
    'Tag','LOCALIZE_filt_log_0',...
    'Enable','on');
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_filt_log_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'Tag','LOCALIZE_filt_log_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
    'FontSize',varargin{end-1},...
    'TooltipString','Rotationally symmetric Gaussian lowpass filter of size (1), and standard deviation (2)',...
    'String','Gaussian',...
    'FontName', varargin{end} ,...
    'Position',[x1 y3 lw lh],...
    'Callback',{@AdjustImage,'gaussian'},...
    'Tag','LOCALIZE_filt_gauss_0',...
    'Enable','on');
uicontrol(...	% Size
    'Parent',hObject,...
    'Style','edit',...
    'Tag','LOCALIZE_filt_gauss_1',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'Tag','LOCALIZE_filt_gauss_2',...
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
    'BackgroundColor',get(findobj('Tag','hLOC'),'Color'),...
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
['\nSMTrack, LocalizeMolecules.m \n\n' 'Copyright (C) 2011 Fredrik Persson \n\n' ...
 'This program comes with ABSOLUTELY NO WARRANTY. \n' ...
 'This is free software, and you are welcome to redistribute it \n' ...
 'under certain conditions. See license.txt for details. \n\n ']));
	
end

function CloseButton(~,varargin)

close(findobj('Tag','hLOC'));

end

function LoadButton(~,varargin)

LoadNewData;

end

function BatchButton(~, varargin)


[filename, pathname] = uigetfile({'*.mat'}, 'Select MAT files', 'MultiSelect', 'on');

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
    fitButton;
    SaveResMatButton('fast', 'fast'); 
end

disp('All files saved sucessfully');
end

function SaveMatButton(~,varargin)

% Load data struct
data = guidata(findobj('Tag','hLOC'));
filename = data.LOCALIZE.filename;
path = data.LOCALIZE.pathname;

% Change to the folder it the file was opened from
oldFolder = cd(path);

% Show save dialogue
[filename, pathname] = uiputfile('*.mat', 'Select .mat file to save', filename);
full_filename = [ pathname, filename ];

% Create outData struct & read in set parameters from GUI
LOCALIZE = struct('scale', get(findobj('Tag', 'LOCALIZE_Locset_scale_1'), 'String'),...
    'maxxyUnCert', get(findobj('Tag', 'LOCALIZE_Locset_fitError_1'), 'String'),...
    'fitWindowSize', get(findobj('Tag', 'LOCALIZE_Locset_fitWindow_1'), 'String'),...
    'use3D', get(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value'),...
    'psfLimits', [0, 0],...
    'zLimits', [0, 0],...
    'dist3D', '0',...
    'xCal3D', [0, 0, 0, 0],...
    'yCal3D', [0, 0, 0, 0],...
    'cal3DPath', '.',...
    'photons', get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value'),...
    'EMCCDBaseline', '0',...
    'EMCCDGain', '0',...
    'photonTh', '0',...
    'gaussian', data.LOCALIZE.gaussian,...
    'mexiHat', data.LOCALIZE.mexiHat,...
    'relIntTh', data.LOCALIZE.relIntTh,...
    'intTh', data.LOCALIZE.intTh,...
    'globalScale', data.LOCALIZE.globalScale,...
    'full_filename_raw', data.LOCALIZE.full_filename_raw,...
    'timeBetweenFrames', data.LOCALIZE.timeBetweenFrames);

% If 3D is activated save the variables
if get(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value');
    LOCALIZE.psfLimits = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'String'))];
    LOCALIZE.zLimits = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'String'))];
    LOCALIZE.dist3D = get(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'String');
    LOCALIZE.xCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String'))];
    LOCALIZE.yCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String'))];
    LOCALIZE.cal3DPath = data.LOCALIZE.cal3DPath;
end

% If photon stats is activated save the variables
if get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value');
    
    LOCALIZE.EMCCDBaseline = get(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'String');
    LOCALIZE.EMCCDGain = get(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'String');
    LOCALIZE.photonTh = get(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'String');
end


% Save the .mat file
save(full_filename, 'LOCALIZE');

% Change back to the old folder
cd(oldFolder);

end

function SaveResMatButton(~,varargin)
% Load data struct
data = guidata(findobj('Tag','hLOC'));
filename = data.LOCALIZE.filename;
pathname = data.LOCALIZE.pathname;

%Modify name and path
if ~isempty(strfind(filename, 'LOCinput'))
filename = strrep(filename, 'LOCinput', 'ANAinput');
else
    filename = strcat('RES_', filename);
end


% Change to the folder it the file was opened from
oldFolder = cd(pathname);

if ~isstr(varargin{1})
% Show save dialogue
[filename, pathname] = uiputfile('*.mat', 'Select .mat file to save', filename);
end

full_filename = [ pathname, filename ];

% Check if data has been cropped
if isequal(data.LOCALIZE.activeInd, 1:length(data.LOCALIZE.xDataOrig))
    data.LOCALIZE.cropped = 'No';
else
    data.LOCALIZE.cropped = 'Yes';
end

% Create outData struct & read in set parameters from GUI
LOCALIZE = struct('scale', get(findobj('Tag', 'LOCALIZE_Locset_scale_1'), 'String'),...
    'maxxyUnCert', get(findobj('Tag', 'LOCALIZE_Locset_fitError_1'), 'String'),...
    'fitWindowSize', get(findobj('Tag', 'LOCALIZE_Locset_fitWindow_1'), 'String'),...
    'use3D', get(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value'),...
    'psfLimits', [0, 0],...
    'zLimits', [0, 0],...
    'dist3D', '0',...
    'xCal3D', [0, 0, 0, 0],...
    'yCal3D', [0, 0, 0, 0],...
    'cal3DPath', '.',...
    'photons', get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value'),...
    'EMCCDBaseline', '0',...
    'EMCCDGain', '0',...
    'photonTh', '0',...
    'gaussian', data.LOCALIZE.gaussian,...
    'mexiHat', data.LOCALIZE.mexiHat,...
    'relIntTh', data.LOCALIZE.relIntTh,...
    'intTh', data.LOCALIZE.intTh,...
    'globalScale', data.LOCALIZE.globalScale,...
    'xDataOrig', data.LOCALIZE.xDataOrig,...
    'yDataOrig', data.LOCALIZE.yDataOrig,...
    'zDataOrig', data.LOCALIZE.zDataOrig,...
    'xDataCorr', data.LOCALIZE.xDataCorr,...
    'yDataCorr', data.LOCALIZE.yDataCorr,...
    'sigmaxDataOrig', data.LOCALIZE.sigmaxDataOrig,...
    'sigmayDataOrig', data.LOCALIZE.sigmayDataOrig,...
    'xDataDevOrig', data.LOCALIZE.xDataDevOrig,...
    'yDataDevOrig', data.LOCALIZE.yDataDevOrig,...
    'photonsOrig', data.LOCALIZE.photonsOrig,...
    'frameNumOrig', data.LOCALIZE.frameNumOrig,...
    'activeInd', data.LOCALIZE.activeInd,...
    'cropped', data.LOCALIZE.cropped,...    
    'aligned', data.LOCALIZE.aligned,...
    'corrected', data.LOCALIZE.corrected,...
    'timeBetweenFrames', data.LOCALIZE.timeBetweenFrames);


% If 3D is activated save the variables
if get(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value');
    LOCALIZE.psfLimits = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'String'))];
    LOCALIZE.zLimits = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'String'))];
    LOCALIZE.dist3D = get(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'String');
    LOCALIZE.xCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String'))];
    LOCALIZE.yCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String'))];
    LOCALIZE.cal3DPath = data.LOCALIZE.cal3DPath;
end

% If photon stats is activated save the variables
if get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value');
    LOCALIZE.EMCCDBaseline = get(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'String');
    LOCALIZE.EMCCDGain = get(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'String');
    LOCALIZE.photonTh = get(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'String');
end


% Save the .mat file
save(full_filename, 'LOCALIZE');

% Change back to the old folder
cd(oldFolder);

end

function CalibrateEMCCDButton(~, varargin)

% Get filename and path with "uigetfile"
[filename, pathname] = uigetfile('*.tif', 'Select image file (TIF)');
if ( filename == 0 )
    disp('Error! No (or wrong) file selected!')
    return
end
full_filename = [ pathname, filename ];

% Read in stacksize
stackSize = numel(imfinfo(full_filename));

% Read in the 1st frame: Dark
darkframe = double(imread(full_filename,1));

% Read in exposure frames
expCell = cell(1, stackSize-1);
contExp = [];
for i = 2:stackSize
    expCell{i-1} = double(imread(full_filename,i));
    if i == 2
        contExp = expCell{i-1};
    else
        % contExp is just the sumation of all exposed imageplanes to
        % flatten the images
        contExp = imadd(contExp, expCell{i-1});
    end
end

% make ContExp it into the mean plane
meanPlane = contExp/(stackSize-1);
% Subtract the entire mean value from the mean plane to get a plane that
% should be subtracted from all original image planes to flatten them but
% keeping the image and stack means the same.
flattener = meanPlane-mean(reshape(meanPlane, 1, []));


% Reshape them to 1D arrays.
darkframe = reshape(darkframe, 1, []);

exposures = [];
for i = 1:stackSize-1
    % flatten the image
    temp = expCell{i}-flattener;
    exposures = [exposures, reshape(temp, 1, [])];
end


% Calculate mean offset.
baseline = mean(darkframe);

%Dark noise
darkNoise = std(darkframe);

% Get data
data = guidata(findobj('Tag','hLOC'));

% Write data
data.LOCALIZE.darkFrameData = [baseline, darkNoise];

% Store all GUI data
guidata(findobj('Tag','hLOC'),data);


% Calculate gain according to:
% http://www.photometrics.com/resources/whitepapers/mean-variance.php
% It ignores thermal noise etc but gives a decent approximation.
diff = imsubtract(expCell{2}, expCell{1});
diff = reshape(diff, 1, []);
diffVariance = (std(diff)^2)/2;
exp1 = reshape(expCell{1}, 1, []);
exp2 = reshape(expCell{2}, 1, []);
expMean = mean([exp1-baseline, exp2-baseline]);
approxGain = 0.5 * expMean/diffVariance % The factor of 0.5 comes from the EMCCD excess noise function (approx sqrt(2))


% Create the experimental PDF
medVal = median(exposures);
maxVal = max(exposures);
binEdges = [];
binCent = [];
for i=0:1:maxVal
    binEdges = [binEdges, i];
    binCent = [binCent, i+1/2];
end
countsPDF = histc(exposures, binEdges)/length(exposures);

% Perform the fitting to the modelPDF
% options = optimset ('MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 1e-8);
% [params] = lsqcurvefit(@modelPDF, [9.134, 300], binCent, countsPDF, [0, 0], [4000, 10000], options);
stat = statset('funValCheck', 'off', 'MaxIter', 10000);
[params] = nlinfit(binCent, countsPDF, @modelPDF, [approxGain, medVal/approxGain], stat);

%Show modelparameters
gain = params(1)
photonCount = params(2)

PDFmodel = modelPDF(params, binCent);

figure;
hold on
plot(binCent, countsPDF, '-r');
plot(binCent, PDFmodel, '*b')
title('EMCCD Count PDF ');
xlabel('Counts');
ylabel('Probability');
hold off


% Set the found values in the GUI
set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'String', num2str(baseline));
set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'String', num2str(gain));

% Put the photon threshold edit box to visible
set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'Visible', 'on');

%     %If one wants to plot just a modelPDF for set parameters.
%     figure;
%     % Write data
% 	data.LOCALIZE.darkFrameData = [1000, 2.2];
%
% 	% Store all GUI data
% 	guidata(findobj('Tag','hLOC'),data);
%     temp = modelPDF([7.5, 440], [0.5:5000.5]);
%     hold on
%     plot(temp, '-g')
%     hold off
end

function Calibrate3DButton(~, varargin)


% Load data structure
data = guidata(findobj('Tag','hLOC'));

oldFolder = cd(data.LOCALIZE.cal3DPath);

[filename, pathname] = uigetfile({'*.stk'; '*.tif'}, 'Select MetaMorph file', 'MultiSelect', 'on');

switch iscell(filename)
    case 1
        if cellfun('isempty', filename)
            disp('Error! No (or wrong) file selected!')
            cd(oldFolder);
            return
        end
    case 0
        if filename == 0
            disp('Error! No (or wrong) file selected!')
            cd(oldFolder);
            return
        end
end

data.LOCALIZE.cal3DPath = pathname;
set(findobj('Tag', 'LOCALIZE_Locset_cal3DPath_0'), 'String', pathname);

%Create arrays to save z-positions and sigmas in
zPos = [];
sigmax = [];
sigmay = [];

% Read in the min and max PSF dimensions
minPSF = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'String'));
maxPSF = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'String'));

if iscell(filename)
    lastInd = length(filename);
else
    lastInd = 1;
end

for calFile = 1:lastInd
    calFile
    if lastInd > 1
        full_filename = [ pathname, filename{calFile} ];
    else
        full_filename = [ pathname, filename ];
    end
    
    % Set the expression to look for to find z-values in a MetaMorph tiff/stk
    expr = '<prop id="z-position" type="float" value="';
    
    % Open the file
    fid = fopen(full_filename);
    fileLine = fgetl(fid);
    
    zPosFile = [];
    
    % Look through and find all instances of expr in the file
    while ischar(fileLine)
        %     disp(fileLine)
        calFile = regexp(fileLine, expr, 'end');
        
        % If there is a match save the numerical z-Position value
        if ~isempty(calFile)
            % Save the z-position in nm units
            zPosFile = [zPosFile, str2double(fileLine(calFile+1:end-2))*1000];
        end
        
        fileLine = fgetl(fid);
    end
    
    % Close the file
    fclose(fid);
    
    % Read in the images
    [~, ~, ext] = fileparts(full_filename);
    if strcmp(ext, '.tif')
        newFileStruct = tiffread29(full_filename);
        rawData = [];
        stackSize = length(newFileStruct);
        for a = 1:stackSize
            rawData(:, :, a) = double(newFileStruct(a).data);
        end
    else
        [rawData, timeBetweenFrames, zPosFile] = readSTK(full_filename);
        zPosFile = zPosFile';
        stackSize = size(rawData, 3);   
    end
    
    sigmaxFile = [];
    sigmayFile = [];
    
    removeInd = [];
    newInd = 1;
    for ind2 = 1:stackSize
        
        % Fit the frame);
        fit = robustGauss2DFit(rawData(:, :, ind2));
        
        % Reject fits that yield to large sigmas
        if (fit.sigmax*2 < minPSF) || (fit.sigmax*2 > maxPSF) || (fit.sigmay*2 < minPSF) || (fit.sigmay*2 > maxPSF)
            removeInd = [removeInd, ind2];
        else
            sigmaxFile(newInd) = fit.sigmax*2;
            sigmayFile(newInd) = fit.sigmay*2;
            newInd = newInd + 1;
        end
        
    end
    
    %Remove points from z-position list
    zPosFile(removeInd) = [];
    
    % Coarsly center the data on the z position
    zPosFile = zPosFile - (min(zPosFile) + max(zPosFile))/2;
    
    % Fit 3rd degree polynomial to the data
    polyxFile = polyfit(zPosFile, sigmaxFile, 3);
    polyyFile = polyfit(zPosFile, sigmayFile, 3);
    
    if get(findobj('Tag', 'LOCALIZE_Locset_3Dcal_1'), 'Value')
        % Show the fits
        figure;
        hold on
        plot(zPosFile, sigmaxFile, '+r');
        plot(zPosFile, sigmayFile, '+b');
        x = linspace(min(zPosFile), max(zPosFile), 100);
        plot(x, polyval(polyxFile, x), '-r');
        plot(x, polyval(polyyFile, x), '-b');
        legend('Width','Height','Location','SE')
        title('3D Calibration curves');
        xlabel('Z position [nm]');
        ylabel('Width/Height [nm]');
        hold off
    end
    
    % Subtract the x and y polynomials
    polyFile = polyxFile - polyyFile;
    
    %Solve the polynomial
    rootsFile = roots(polyFile);
    
    % Choose a root and center the curve
    intersectPoint = rootsFile(3);
    zPosFile = zPosFile - intersectPoint;
    
    % Put in the total arrays
    zPos = [zPos, zPosFile];
    sigmax = [sigmax, sigmaxFile];
    sigmay = [sigmay, sigmayFile];
    
end

polyTotx = polyfit(zPos, sigmax, 3);
polyToty = polyfit(zPos, sigmay, 3);

figure;
hold on;
plot(zPos, sigmax, '+r');
plot(zPos, sigmay, '+b');
x = linspace(min(zPos), max(zPos), 100);
plot(x, polyval(polyTotx, x), '-r');
plot(x, polyval(polyToty, x), '-b');
legend('Width','Height','Location','SE')
title('3D Calibration curves');
xlabel('Z position [nm]');
ylabel('Width/Height [nm]');
hold off;


% Add data and save struct
data.LOCALIZE.xCal3D = polyTotx;
data.LOCALIZE.yCal3D = polyToty;
guidata(findobj('Tag','hLOC'), data);

% Update the edit fields for the calibration curves
set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String', num2str(polyTotx(1)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String', num2str(polyTotx(2)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String', num2str(polyTotx(3)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String', num2str(polyTotx(4)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String', num2str(polyToty(1)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String', num2str(polyToty(2)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String', num2str(polyToty(3)));
set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String', num2str(polyToty(4)));

cd(oldFolder);

end

function fitButton(~, varargin)


% Load data structure
data = guidata(findobj('Tag','hLOC'));

% Extract relevant data
stackSize = data.LOCALIZE.stackSize;
path = data.LOCALIZE.pathname;
rawData = data.LOCALIZE.rawData;
frameNr = data.LOCALIZE.frameNumber;

%Get fitting Window
fitWindow = str2double(get(findobj('Tag', 'LOCALIZE_Locset_fitWindow_1'), 'String'));

% Only do current frame analysis if set.
if get(findobj('Tag', 'LOCALIZE_Locset_fitSingle_0'), 'Value');
    startVal = frameNr;
    stopVal = startVal;
else
    startVal = 1;
    stopVal = stackSize;
end

% Create a cell to store fitresults
resultCell = cell(1, stackSize);

%Create index to keep track of cell position
cellInd = 1;

% Create arrays to store all coord in
xDataTot = [];
yDataTot = [];
zDataTot = [];
sigmaxDataTot = [];
sigmayDataTot = [];
xDataDevTot = [];
yDataDevTot = [];
photonsTot = [];
frameNumTot = [];


for frameNr = startVal:stopVal
    
    %Print which frame it is working on
    frameNr
    
    %Load the current raw data frame
    frame = rawData(:, :, frameNr);
    
    
    detPos = data.LOCALIZE.detectedPositions;
    framePos = detPos{frameNr};
    row = round(framePos(:, 2));
    col = round(framePos(:, 3));
    numFittedPoints = length(row);
    
    for i=1:numFittedPoints
        
        % Get coordinats for the fitting window
        x_min = col(i) - (fitWindow - 1)/2;
        x_max = col(i) + (fitWindow - 1)/2;
        y_min = row(i) - (fitWindow - 1)/2;
        y_max = row(i) + (fitWindow - 1)/2;
        
        %Skip the point if the fitting window reaches outside the frame
        if x_min < 1 || y_min < 1 || x_max >= size(frame, 2) || y_max >= size(frame, 1)
            numFittedPoints = numFittedPoints-1;
            continue
        end
        
        peak = imcrop(frame, [x_min, y_min, fitWindow, fitWindow]);
        
        
        % Fit data using a dual approach fitting algorithm
        if startVal == stopVal
            fit = robustGauss2DFit(peak, row(i), col(i), frameNr, 1);
        else
            fit = robustGauss2DFit(peak, row(i), col(i), frameNr);
        end
        
        % Show results if only fitting current frame
        if get(findobj('Tag', 'LOCALIZE_Locset_fitSingle_0'), 'Value');
            figure;
            hold on
            surf(peak, 'FaceAlpha', 0.7);%, 'EdgeColor', 'b', 'EdgeAlpha', 0.7, 'FaceColor', 'w',  'FaceAlpha', 0.7);
            shading interp;
            surf(fit.G, 'LineWidth', 1.5, 'EdgeColor', 'k', 'FaceColor', 'w',  'FaceAlpha', 0.3, 'EdgeAlpha', 0.3);
            
            rotate3d on;
            view(3);
            hold off
        end
        fit.G = [];
        
        % Store in cell
        resultCell{cellInd} = fit;
        % Update cell position index
        cellInd = cellInd + 1;
        
        photonsTot = [photonsTot, fit.photons];
        xDataTot = [xDataTot, fit.x0];
        yDataTot = [yDataTot, fit.y0];
        zDataTot = [zDataTot, fit.z0];
        sigmaxDataTot = [sigmaxDataTot, fit.sigmax];
        sigmayDataTot = [sigmayDataTot, fit.sigmay];
        xDataDevTot = [xDataDevTot, fit.stUncert(3)];
        yDataDevTot = [yDataDevTot, fit.stUncert(4)];
        frameNumTot = [frameNumTot, frameNr];
    end
    
    % Show a final result for entire frame if only fitting current frame
    if get(findobj('Tag', 'LOCALIZE_Locset_fitSingle_0'), 'Value');
        % Obtain coord system for entire frame
        [xcoord, ycoord] = meshgrid(1:size(frame, 2), 1:size(frame, 1));
        xcoord = xcoord(:);
        ycoord = ycoord(:);
        
        % Reconstruct model from fitted parameters
        fitFrame = zeros(size(frame));
        for i = 1:numFittedPoints
            fit = resultCell{i};
            params = [fit.amp 0 unscaled([fit.x0 fit.y0 fit.sigmax fit.sigmay])];
            fitFrame = fitFrame + reshape(pointGaussian(params',[xcoord, ycoord]), size(frame));
        end
        
        % Plot the original and modelled frames
        figure;
        subplot(1, 2, 2);
        imagesc(fitFrame);
        subplot(1, 2, 1);
        imagesc(frame);
    end
    
    % Activate show result button
    set(findobj('Tag', 'LOCALIZE_Visset_display2D_0'), 'Enable', 'on');
    set(findobj('Tag', 'LOCALIZE_Visset_display3D_0'), 'Enable', 'on');
    
end

% Find the last full cell
noVal = cellfun('isempty', resultCell);
lastInd = find(noVal, 1, 'first');

% Store the results in the program struct
data.LOCALIZE.result = resultCell(1:lastInd-1);
data.LOCALIZE.xDataOrig = xDataTot;
data.LOCALIZE.xDataCorr = xDataTot;
data.LOCALIZE.yDataOrig = yDataTot;
data.LOCALIZE.yDataCorr = yDataTot;
data.LOCALIZE.zDataOrig = zDataTot;
data.LOCALIZE.sigmaxDataOrig = sigmaxDataTot;
data.LOCALIZE.sigmayDataOrig = sigmayDataTot;
data.LOCALIZE.xDataDevOrig = xDataDevTot;
data.LOCALIZE.yDataDevOrig = yDataDevTot;
data.LOCALIZE.photonsOrig = photonsTot;
data.LOCALIZE.frameNumOrig = frameNumTot;
data.LOCALIZE.activeInd = [1:length(xDataTot)];

guidata(findobj('Tag','hLOC'), data);

% Impose limits on shown xy resolution
LimitXYRes;

end

function display2DButton(~,varargin)

% Load data structure
data = guidata(findobj('Tag','hLOC'));

% Extract relevant data
frame = data.LOCALIZE.current;

activeInd = data.LOCALIZE.activeInd;

xarr = data.LOCALIZE.xDataCorr(activeInd);
yarr = data.LOCALIZE.yDataCorr(activeInd);
zarr = data.LOCALIZE.zDataOrig(activeInd);
xOrig = data.LOCALIZE.xDataCorr;
yOrig = data.LOCALIZE.yDataCorr;
zOrig = data.LOCALIZE.zDataOrig;

% Make sure no negative values
xarr = abs(xarr);
yarr = abs(yarr);

f2D=figure('Name', data.LOCALIZE.filename,'NumberTitle','off');

if get(findobj('Tag', 'LOCALIZE_Visset_display2D_1'), 'Value');
    
    %Read in a file
    [filename, pathname] = uigetfile('*.tif', 'Select BF image file (TIF)');
    if ( filename == 0 )
        disp('Error! No (or wrong) file selected!')
        filename = 0;
        pathname = 0;
        return
    end
    frame = double(imread([ pathname, filename ]));
    % Display it
    hold on
    imagesc(frame);
    colormap(gray);
    plot(unscaled(xarr)+1, unscaled(yarr)+1, '+r');
    rotate3d on
    title('Overlayed image.');
    axis([0 size(frame, 2) 0 size(frame, 1)]);
    title('XY Projection');
    hold off
else
    
    
    % Plot the points
    h2D = plot3(xarr, yarr, zarr, '+r');
    view(2);
    rotate3d on
    title('Select points to include and press any key.');
    ans = [];
    pause on;
    pause;
    figure(f2D);
    pause off;
    
    % Take the new variable containing the points and replot
    if ~isempty(ans)
        xarr = ans(:, 1);
        yarr = ans(:, 2);
        zarr = ans(:, 3);
        h2D = plot3(xarr, yarr, zarr, '+r');
        view(2);
        % Reset the active index array to take the chosen indexes
        activeInd = [];
        for ind = 1 : length(xarr)
            
            xInd = find(xOrig == xarr(ind));
            yInd = find(yOrig == yarr(ind));
            zInd = find(zOrig == zarr(ind));
            
            if isequal(xInd, yInd) %&& (~isequal(z, zeros(size(z))) && isequal(xInd, yInd) && isequal(xInd, yInd))
                activeInd = [activeInd, xInd];
            end
            
        end
        activeInd = sort(activeInd);
    end
    
    
    % Rotate the data to align along the x-axis
    if get(findobj('Tag', 'LOCALIZE_Visset_align_1'), 'Value');
        align(h2D);
    end
    title('XY Projection');
    rotate3d on;
    axis equal;
    
end

data.LOCALIZE.activeInd = activeInd;
guidata(findobj('Tag','hLOC'), data);

set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_0'), 'Enable', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_2'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_0'), 'Enable', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_1'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_2'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_align_0'), 'Enable', 'on');

end

function display3DButton(~,varargin)

% Load data structure
data = guidata(findobj('Tag','hLOC'));

% Extract relevant data
frame = data.LOCALIZE.current;

activeInd = data.LOCALIZE.activeInd;

xarr = data.LOCALIZE.xDataCorr(activeInd);
yarr = data.LOCALIZE.yDataCorr(activeInd);
zarr = data.LOCALIZE.zDataOrig(activeInd);
xOrig = data.LOCALIZE.xDataCorr;
yOrig = data.LOCALIZE.yDataCorr;
zOrig = data.LOCALIZE.zDataOrig;

% Make sure x and y are positive
xarr = abs(xarr);
yarr = abs(yarr);


% % Remove bad points
% zarr = zarr(xarr > 0);
% xarr = xarr(xarr > 0);
% yarr = yarr(yarr > 0);
% % Rescale arrays
% xarr = xarr - min(min(xarr));
% yarr = yarr - min(min(yarr));

f3D=figure('Name', data.LOCALIZE.filename,'NumberTitle','off');
% Plot the points
h3D = plot3(xarr, yarr, zarr, '+r');
rotate3d on
title('Select points to include and press any key.');
ans = [];
pause on;
pause;
figure(f3D);
pause off;

% Take the new variable containing the points and replot
if ~isempty(ans)
    xarr = ans(:, 1);
    yarr = ans(:, 2);
    zarr = ans(:, 3);
    h3D = plot3(xarr, yarr, zarr, '+r');
    % Reset the active index array to take the chosen indexes
    activeInd = [];
    for ind = 1 : length(xarr)
        
        xInd = find(xOrig == xarr(ind));
        yInd = find(yOrig == yarr(ind));
        zInd = find(zOrig == zarr(ind));
        
        if isequal(xInd, yInd) %&& (~isequal(z, zeros(size(z))) && isequal(xInd, yInd) && isequal(xInd, yInd))
            activeInd = [activeInd, xInd];
        end
        
    end
    activeInd = sort(activeInd);
end


% Rotate the data to align along the x-axis
if get(findobj('Tag', 'LOCALIZE_Visset_align_1'), 'Value');
    align(h3D);
end
title('XYZ Plot');
rotate3d on;
axis equal;

%Save the index of the points to work with
data.LOCALIZE.activeInd = activeInd;

guidata(findobj('Tag','hLOC'), data);

set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_0'), 'Enable', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_2'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_0'), 'Enable', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_1'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_2'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_align_0'), 'Enable', 'on');

end

function alignButton(~, varargin)

data = guidata(findobj('Tag','hLOC'));
activeInd = data.LOCALIZE.activeInd;
xarr = data.LOCALIZE.xDataCorr(activeInd);
yarr = data.LOCALIZE.yDataCorr(activeInd);

figure;
h2D = plot(xarr, yarr, '+r');
[xData, yData] = align(h2D);

% Store the aligned coords
data.LOCALIZE.xDataCorr(activeInd) = xData;
data.LOCALIZE.yDataCorr(activeInd) = yData;

data.LOCALIZE.aligned = 'Yes';

guidata(findobj('Tag','hLOC'), data);
end

function correctDriftButton(~, varargin)
data = guidata(findobj('Tag','hLOC'));

xOrig = data.LOCALIZE.xDataOrig;
yOrig = data.LOCALIZE.yDataOrig;
zOrig = data.LOCALIZE.zDataOrig;
activeInd = data.LOCALIZE.activeInd;

x = xOrig(activeInd);
y = yOrig(activeInd);
z = zOrig(activeInd);

numpoints = max(size(x));


meanX = [];
meanY = [];
xCorr = x;
yCorr = y;
stepSize = str2double(get(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'String'));
meanX = [meanX, mean(x(1:stepSize))];
meanY = [meanY, mean(y(1:stepSize))];

for i = (stepSize/2)+1:numpoints-(stepSize/2)
    if stepSize > numpoints
        disp('Not enough points to correct for drift with the current settings.');
        return
    elseif i == numpoints-(stepSize/2)
        meanX = [meanX, mean(x(i-stepSize/2:i+stepSize/2))];
        meanY = [meanY, mean(y(i-stepSize/2:i+stepSize/2))];
        xCorr(i:end) = x(i:end) - (meanX(end)-meanX(1));
        yCorr(i:end) = y(i:end) - (meanY(end)-meanY(1));
        
    else
        meanX = [meanX, mean(x(i-stepSize/2:i+stepSize/2))];
        meanY = [meanY, mean(y(i-stepSize/2:i+stepSize/2))];
        xCorr(i) = x(i) - (meanX(end)-meanX(1));
        yCorr(i) = y(i) - (meanY(end)-meanY(1));
        
    end
end

figure;
hCorr = plot3(xCorr, yCorr, z, '+b');
rotate3d on;
% Rotate the data to align along the x-axis
if get(findobj('Tag', 'LOCALIZE_Visset_align_1'), 'Value');
    align(hCorr);
end
title('XYZ Plot');
rotate3d on;
axis equal;


figure;
plot(meanX, meanY);


data.LOCALIZE.xDataCorr(activeInd) = xCorr;
data.LOCALIZE.yDataCorr(activeInd) = yCorr;

% Set variable stating the change
data.LOCALIZE.corrected = 'Yes';

guidata(findobj('Tag','hLOC'), data);

% Turn off the option of repeating the correction without reverting
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_0'), 'Enable', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'Visible', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_2'), 'Visible', 'off');


end

function revertButton(~, varargin)
data = guidata(findobj('Tag','hLOC'));

data.LOCALIZE.xDataCorr = data.LOCALIZE.xDataOrig;
data.LOCALIZE.yDataCorr = data.LOCALIZE.yDataOrig;
data.LOCALIZE.activeInd = [1:length(data.LOCALIZE.xDataOrig)];

% Reset the variables stating modifications
data.LOCALIZE.cropped = 'No';
data.LOCALIZE.aligned = 'No';
data.LOCALIZE.corrected = 'No';

guidata(findobj('Tag','hLOC'), data);

% Reactivate the option for driftcorrection
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_0'), 'Enable', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'Visible', 'on');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_2'), 'Visible', 'on');

% Impose limits on shown xy resolution
LimitXYRes;

end

function PALMPlotButton(~, varargin)

data = guidata(findobj('Tag','hLOC'));
activeInd = data.LOCALIZE.activeInd;
x = data.LOCALIZE.xDataCorr(activeInd);
y = data.LOCALIZE.yDataCorr(activeInd);
z = data.LOCALIZE.zDataOrig(activeInd);
xDev = data.LOCALIZE.xDataDevOrig(activeInd);
yDev = data.LOCALIZE.yDataDevOrig(activeInd);

% Obtain coord system for entire frame
xC = floor(min(x)-20):4:ceil(max(x)+20);
yC = floor(min(y)-20):4:ceil(max(y)+20);
[xcoord, ycoord] = meshgrid(xC, yC);

xcoordArr = xcoord(:);
ycoordArr = ycoord(:);

% Reconstruct model from fitted parameters
fitFrame = zeros(size(xcoord));
for i = 1:length(x)
    i
    params = [1000/(2*pi*xDev(i)*yDev(i)) 0 x(i) y(i) xDev(i) yDev(i)];
    fitFrame = max(fitFrame, reshape(pointGaussian(params',[xcoordArr, ycoordArr]), size(fitFrame)));
end

figure;
PALM = surf(xC,yC,fitFrame, 'EdgeColor','none');
colormap(hot)
view(0,90)
axis equal
axis off



end

function trackButton(~, varargin)

data = guidata(findobj('Tag','hLOC'));

activeInd = data.LOCALIZE.activeInd;
x = data.LOCALIZE.xDataCorr(activeInd);
y = data.LOCALIZE.yDataCorr(activeInd);
z = data.LOCALIZE.zDataOrig(activeInd);
frameNr = data.LOCALIZE.frameNumOrig(activeInd);

maxDist = str2double(get(findobj('Tag', 'LOCALIZE_Trackset_maxDist_1'), 'String'));
%
% % Form a matrix with x, y, z, frame, distance to prev frame, trajectory Nr
% trajMat = [x; y; z; frameNr; zeros(size(x)); zeros(size(x))];

firstTrajFrame = 0;
traj = cell(1, floor((max(frameNr)-min(frameNr))/2));
lastTrajNr = 0;

nextHash = zeros(20,1);

for i = min(frameNr):max(frameNr)
    lastHash = nextHash;
    nextHash = zeros(20,1);
    currInd = find(frameNr == i);
    nextInd = find(frameNr == i+1);
    if ~isempty(currInd) && ~isempty(nextInd)
        if firstTrajFrame == 0
            firstTrajFrame = i;
        end
        currPos = [x(currInd)', y(currInd)'];
        nextPos = [x(nextInd)', y(nextInd)'];
        
        D = pdist2(currPos, nextPos);
        
        for ii = 1:size(currPos, 1)
            singleCurr = D(ii, :);
            match = singleCurr<=maxDist;
            
            if length(find(match)) > 1;
                % Start new trajectories in the next frame
                newInd = find(match);
                
                for iii = length(newInd)
                    lastTrajNr = lastTrajNr+1;
                    nextHash(newInd(iii)) = lastTrajNr;
                end
                
            end
        end
        
        for ii = 1:size(nextPos, 1)
            singleCurr = D(:, ii);
            match = singleCurr<=maxDist;
            
            if ((length(find(match)) > 1) || (isempty(find(match, 1)))) && (nextHash(ii) == 0)
                % Start new trajectories in the this frame
                lastTrajNr = lastTrajNr+1;
                nextHash(ii) = lastTrajNr;
                
            elseif ((length(find(match)) > 1) || (isempty(find(match)))) && (nextHash(ii) ~= 0);
                % Do nothing =D
                
            else
                % If first frame then add current step
                oldInd = find(match);
                if i == firstTrajFrame
                    lastTrajNr = lastTrajNr+1;
                    lastHash(oldInd) = lastTrajNr;
                    %                     traj{lastHash(oldInd)} = [traj{lastHash(oldInd)}; currPos(oldInd, :), 0, i];
                end
                
                % Start a new trajectory if appears new
                if lastHash(oldInd) == 0
                    lastTrajNr = lastTrajNr+1;
                    nextHash(ii) = lastTrajNr;
                    
                else
                    lastTrajNr
                    % Add the next step in the trajectory
                    nextHash(ii) = lastHash(oldInd);
                    
                    if isempty(traj{nextHash(ii)})
                        traj{nextHash(ii)} = [traj{nextHash(ii)}; currPos(oldInd, :), 0, i];
                        
                    end
                    
                    traj{nextHash(ii)} = [traj{nextHash(ii)}; nextPos(ii, :), D(oldInd, ii), i+1];
                end
            end
            
        end
        
    end
    
end
finalTraj = {};
lHist = [];

% Remove empty trajectories and plot all of them
figure;
hold on
for i=1:length(traj)
    tempTraj = traj{i};
    if ~isempty(tempTraj) && size(tempTraj, 1) > 2
        finalTraj{end+1} = tempTraj;
        lHist = [lHist, size(tempTraj, 1)];
        plot(tempTraj(:, 1), tempTraj(:, 2));
    end
end
title('Trajectories');
xlabel('X [nm]');
ylabel('Y [nm]');
axis equal
hold off

% Plot a histogram of trajectory lengths if desired
if get(findobj('Tag', 'LOCALIZE_Trackset_trajHist_0'), 'Value');
    xBin = [1:max(lHist)];
    figure;
    hist(lHist, xBin);
    title('Histogram over trajectory lengths');
    xlabel('Length [steps]');
    ylabel('Counts');
end

% Make MSD plot(one for all trajectories)
msdCell = cell(1, length(finalTraj));
sqDisplTotCell = cell(1, max(lHist));

% Run through the trajectories
for i = 1:length(finalTraj)
    tempTraj = finalTraj{i};
    
    % Calculate all squared displacements
    for dt = 1:size(tempTraj, 1)
        dCoords = tempTraj(1+dt:end,1:2) - tempTraj(1:end-dt,1:2);
        sqDispl = sum(dCoords.^2,2); % dx^2+dy^2
        sqDisplTotCell{1, dt} = [sqDisplTotCell{1, dt}; sqDispl];
        msd(dt,1) = mean(sqDispl); % average
        msd(dt,2) = std(sqDispl); % std
        msd(dt,3) = length(sqDispl); % n
    end
    % Save the individual MSDs in a cell structure
    msdCell{1, i} = msd;
end

length(finalTraj)

% Make one general MSD list
msdTot = [length(sqDisplTotCell), 3];
for dt = 1:length(sqDisplTotCell)
    msdTot(dt,1) = mean(sqDisplTotCell{dt}); % average
    msdTot(dt,2) = std(sqDisplTotCell{dt}); % std
    msdTot(dt,3) = length(sqDisplTotCell{dt}); % n
end

% Calculate diffusion constant from the 3 first points
diffArr = [0, msdTot(1:3, 1)']./(1000^2);
xArr = [0, 1, 2, 3];
unitTime = str2double(get(findobj('Tag', 'LOCALIZE_Trackset_timeStep_1'), 'String'))/1000; % Time between frames in ms
[p, S] = polyfit(xArr.*unitTime, diffArr, 1);
diffOffset = p(2);
diffCoeff = p(1)/4;



% Plot the MSD if desired
if get(findobj('Tag', 'LOCALIZE_Trackset_MSD_0'), 'Value');
    figure;
    hold on
    xArr = find(msdTot(:, 1));
    fplot(strcat('x*', num2str(p(1)), '+', num2str(p(2))), [0, 5*unitTime], '--r');
    plot(xArr.*unitTime, msdTot(:, 1)./(1000^2));
    errorbar(xArr.*unitTime, msdTot(:, 1)./(1000^2), msdTot(:, 2)./(1000^2.*sqrt(msdTot(:, 3))-1));
    title('MSD');
    xlabel('Time [s]');
    ylabel('Mean square displacement [\mum^2]');
    xlim([0, 15*unitTime]);
    text(0.1, 0.9, ['Diff. Coeff = ', num2str(diffCoeff), '\mum^2/s'], 'Units', 'normalized');
    text(0.1, 0.85, ['Offset = ', num2str(diffOffset), '\mum^2'], 'Units', 'normalized');
    hold off
end

% Calculate and plot the CDF if desired
if get(findobj('Tag', 'LOCALIZE_Trackset_CDF_0'), 'Value');
    
    % Read in the unit step length (in frames) for the CDF
    stepLength = str2double(get(findobj('Tag', 'LOCALIZE_Trackset_CDF_1'), 'String'));
    
    % Read out all the steplengths
    stepsTot = sqDisplTotCell{1, stepLength};
    
    % Get the CDF with lower and upper confidence bounds
    [f, x, flo, fup] = ecdf(sqrt(stepsTot));
    
    figure;
    hold on
    stairs(x, f, '-r');
    stairs(x, flo, '--b');
    stairs(x, fup, '--b');
    legend('Empirical CDF','LCB','UCB','Location','SE')
    title('CDF');
    xlabel('Step length [nm]');
    ylabel('Cumulative probability');
    hold off
end


end




%%%%%%%%%%%%%%%%%%%%%%
% Callback functions %
% ================== %
%%%%%%%%%%%%%%%%%%%%%%


function LocChange(hObject,~,varargin)

switch varargin{1}
    
    case 'photon'
        if ~get(hObject, 'Value')
            set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_cal_0'), 'Enable', 'off');
            
        elseif get(hObject, 'Value')
            set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_cal_0'), 'Enable', 'on');
            
        end
        
    case '3D'
        if ~get(hObject, 'Value')
            set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'Visible', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_0'), 'Enable', 'off');
            set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_1'), 'Enable', 'off');
        elseif get(hObject, 'Value')
            set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'Visible', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_0'), 'Enable', 'on');
            set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_1'), 'Enable', 'on');
        end
        
    case '3DcalX'
        data = guidata(findobj('Tag','hLOC'));
        data.LOCALIZE.xCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String'))];
        guidata(findobj('Tag','hLOC'), data);
    case '3DcalY'
        data = guidata(findobj('Tag','hLOC'));
        data.LOCALIZE.yCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String')), str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String'))];
        guidata(findobj('Tag','hLOC'), data);
end


end

function ScrollImage(hObject,~,varargin)

% Get scroll value and set frame number label
frameN = get(hObject,'Value');
frameN = round(frameN);
set(hObject,'Value',frameN);
set(findobj('Tag','LOCALIZE_label_FrameNumber'),'String',sprintf('Current frame: %g',frameN));

% Load data structure
data = guidata(findobj('Tag','hLOC'));

% Write data
data.LOCALIZE.frameNumber = frameN;

% Update images
data.LOCALIZE.original = data.LOCALIZE.rawData(:, :, frameN);
data.LOCALIZE.current = data.LOCALIZE.original;

% Store all GUI data
guidata(findobj('Tag','hLOC'),data);

% Set filter and image
AdjustImage;

end

function AdjustImage(~,~,varargin)


filterNames = {...
    'log';...
    'gaussian'};
filterTypes = {...
    'LOCALIZE_filt_log_0';...
    'LOCALIZE_filt_gauss_0'};

% Load data struct
data = guidata(findobj('Tag','hLOC'));
frameN = data.LOCALIZE.frameNumber;
frame = data.LOCALIZE.rawData(:, :, frameN);
data.LOCALIZE.original = frame;

% Add filters
for i = 1 : length(filterNames)
    
    if (get(findobj('Tag',filterTypes{i}),'Value'))
        
        switch filterTypes{i}
            
            case 'LOCALIZE_filt_log_0'
                
                p(1) = str2double(get(findobj('Tag','LOCALIZE_filt_log_1'),'String'));
                p(2) = str2double(get(findobj('Tag','LOCALIZE_filt_log_2'),'String'));
                
                mask = -1*fspecial(filterNames{i},p(1),p(2));
%                 enhFact = 60/max(max(mask));
%                 mask = enhFact*mask;
                frame = imfilter(frame, mask, 'symmetric', 'conv');
                
                %Put negative values to zero
                [negRow, negCol] = find(frame<0);
                matSize = size(frame);
                matInd = sub2ind(matSize, negRow, negCol);
                frame(matInd) = 0;
                
            case 'LOCALIZE_filt_gauss_0'
                
                p(1) = str2double(get(findobj('Tag','LOCALIZE_filt_gauss_1'),'String'));
                p(2) = str2double(get(findobj('Tag','LOCALIZE_filt_gauss_2'),'String'));
                
                mask = fspecial(filterNames{i},p(1),p(2));
%                 enhFact = 60/max(max(mask));
%                 mask = enhFact*mask;
                frame = imfilter(frame, mask, 'symmetric', 'conv');
                
        end
        
    end
    
end

% If a posFrame then dont show the original frame tag
if min(min(frame)) == 0
    frame(end, end) = 0;
end

% Write data
data.LOCALIZE.current = frame;

% Store all GUI data
guidata(findobj('Tag','hLOC'),data);

% Update all axes
UpdateAxes;

end

function LimitXYRes(~,~)

data = guidata(findobj('Tag','hLOC'));

activeInd = data.LOCALIZE.activeInd;
xDev = data.LOCALIZE.xDataDevOrig(activeInd);
yDev = data.LOCALIZE.yDataDevOrig(activeInd);

    
% Read in limit for xy resolution to be shown and worked with.
resLimit = str2double(get(findobj('Tag', 'LOCALIZE_Locset_fitError_2'), 'String'));

% Find all indices that dont meet the demands
xInd = find(xDev > resLimit);
yInd = find(yDev > resLimit);

% Remove duplicate indices
remInd = union(xInd, yInd);

% Remove them from the activeInd list
activeInd(remInd) = [];

data.LOCALIZE.activeInd = activeInd;

guidata(findobj('Tag','hLOC'), data);

end


%%%%%%%%%%%%%%%%%%%
% Other functions %
% =============== %
%%%%%%%%%%%%%%%%%%%


function SetAxes(varargin)

% Display Axes
axis(get(findobj('Tag','LOCALIZE_imgsc_display'),'Parent'),...
    'xy','tight');

end

function UpdateSelectionTools(varargin)

% Load data structure
data = guidata(findobj('Tag','hLOC'));

stackSize = data.LOCALIZE.stackSize;

if stackSize > 1
    
    % Frame number scrollbar
    set(findobj('Tag','LOCALIZE_scrollbar_frameNumber'),...
        'Max',stackSize,...
        'Min',1,...
        'SliderStep',[1 10] / (stackSize-1),...
        'Value',1)
else
    set(findobj('Tag','LOCALIZE_scrollbar_frameNumber'),...
        'Value',0)
end

end

function UpdateAxes(varargin)

% Load data structure
data = guidata(findobj('Tag','hLOC'));

% Get Data
pathname = data.LOCALIZE.pathname;
filename = data.LOCALIZE.filename;
full_filename = [pathname filename];
frame = data.LOCALIZE.frameNumber;
current = data.LOCALIZE.current;

% Read out the max min data values
dataMin = min(min(current));
dataMax = max(max(current));

% Main axes
set(findobj('Tag','LOCALIZE_imgsc_display'),...
    'CData',data.LOCALIZE.current,...
    'Visible','on');
set(get(findobj('Tag','LOCALIZE_imgsc_display'),'Parent'),...
    'Clim',[dataMin dataMax]);

drawnow;

end

function ResetLabels(varargin)

% Load Data
data = guidata(findobj('Tag','hLOC'));

filename = data.LOCALIZE.filename;
pathname = data.LOCALIZE.pathname;
original = data.LOCALIZE.original;
stackSize = data.LOCALIZE.stackSize;

% Data Info Panel
set(findobj('Tag','LOCALIZE_label_filename'),'String',filename);
set(findobj('Tag','LOCALIZE_label_pathname'),'String',pathname);
set(findobj('Tag','LOCALIZE_label_stackSize'),'String',sprintf('%g',stackSize));
set(findobj('Tag','LOCALIZE_label_frameSize'),'String',sprintf('[%g,%g]',size(original)));

end

function pdf = modelPDF (params, X)

%Get constants
data = guidata(findobj('Tag','hLOC'));
darkFrameData = data.LOCALIZE.darkFrameData;
baseline = darkFrameData(1);
gaussNoise = darkFrameData(2);

%Rename fitting parameters
gain = params(1);
photons = params(2);

% PDF from Ulbrich and Isacoff Nature Methods 4:4 2007 (same as Mortensen et al Nature Methods 2010).
rawPDF = exp(-photons).*diracOne(X-1/2)+sqrt(photons./((X)*gain)).*exp(-(X)/gain-photons).*besseli(1, 2*sqrt((X)*photons/gain));

%Gaussian noise
range = [-50:50];
gauss = 1/sqrt(2*pi*gaussNoise^2)*exp(-(range).^2./(2*gaussNoise^2));
pdf = conv(rawPDF, gauss, 'same');


% Add offset/baseline
offset = zeros(1, round(baseline));
pdf = [offset, pdf];

%Adjust length by removing end
pdf(end-length(offset)+1:end) = [];

end

function Y = diracOne(X)
% A modified version of a delta function that gives 1 instead of infinite
% (as the DIrac Delta gives) at x = 0.

Y = zeros(1, length(X));

Y(X == 0) = 1;

end

function fit = robustGauss2DFit(peak, varargin)
% Fit a "surface" peak = bg + amp*exp(-((x-x0).^2/(2*sigmax^2) + (y-y0).^2/(2*sigmay^2)))

if nargin > 1
    row = varargin{1};
    col = varargin{2};
    frameNr = varargin{3};
end


dataDim = size(peak);
rangey = dataDim(1)-1;
rangex = dataDim(2)-1;

[xcoord, ycoord] = meshgrid(-rangex/2:rangex/2, -rangey/2:rangey/2);

% Arrange coord and find their boundries and range
xcoord = xcoord(:);
ycoord = ycoord(:);
xBound = [min(xcoord), max(xcoord)];
xRange = range(xcoord);
yBound = [min(ycoord), max(ycoord)];
yRange = range(ycoord);

% Find a suitable range of sigmas to search through.
sigmaMin = 0.1;
sigmaMax = max([xRange, yRange]);
sigmas = exp(log(sigmaMin):.2:log(sigmaMax));

filtx = [0:dataDim(2)/2,-ceil(dataDim(2)/2)+1:-1]';
filty = [0:dataDim(1)/2,-ceil(dataDim(1)/2)+1:-1]';

sigmaTrials = zeros(length(sigmas),7);


% Try all different values for sigma
for l1ind = 1:length(sigmas)
    xGaussFilt = exp(-filtx.^2/2/sigmas(l1ind));
    yGaussFilt = exp(-filty.^2/2/sigmas(l1ind));
    
    % Convolve Data with gaussian filters
    convDataX = convExtEdge(peak, yGaussFilt)';
    convData = convExtEdge(convDataX, xGaussFilt)';
    [~,ind] = max(convData(:));
    
    % Use x0 and y0 = 0
    if get(findobj('Tag', 'LOCALIZE_Locset_centerPeak_0'), 'Value');
        x0 = 0;
        y0 = 0;
        
    else % use what is found by the convolution
        
        x0 = xcoord(ind);
        y0 = ycoord(ind);
    end
    
    % Create a model 2D gaussian
    G = exp(-((xcoord-x0).^2+(ycoord-y0).^2)/(2*sigmas(l1ind)^2));
    
    % Build the matrix equation X*ps = peak
    % The ones are to find the background level
    G2 = [G, ones(length(G), 1)];
    
    % Solve the matrix equation (x = A\B solves the matrix equation Ax = B)
    X = G2\peak(:);
    
    % Save residual, background, amplitude, x0, y0 & sigma for this run
    sigmaTrials(l1ind,:) = [sum((peak(:) - G2*X).^2), X(:)', x0, y0, sigmas(l1ind), sigmas(l1ind)];
end

% Find sigma with corresponding least error
[~, bestSigma] = min(sigmaTrials(:,1));

% Do a careful fitting using lsqcurvefit
opts = statset('Display','off');
% lb = [-Inf, -Inf, xBound(1), yBound(1), sigmaMin/100, sigmaMin/100]';
% ub = [ Inf, Inf, xBound(2), yBound(2), sigmaMax + 1, sigmaMax + 1]';
warning off;
[params, residuals, Jacob, covB, mse] = nlinfit([xcoord, ycoord], peak(:), @pointGaussian, sigmaTrials(bestSigma,2:end)', opts);
warning on;
% Compute the 95% confidence intervals and standard errors of the parameters
[ci, stUncert] = nlparci_FP2(params, residuals, 'covar', covB);

% Add a z0 position and photon count
z0 = 0;
photons = 0;

if get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value') && (nargin > 1)
    
    gain = str2double(get(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'String'));
    bg = params(2);
    bgfreePeak = peak-bg;
    bgfreePeak = bgfreePeak/gain;
    photonParams = [params(1); 0; params(3:end)];
    modelPeak = reshape(pointGaussian(photonParams,[xcoord, ycoord]), size(peak));
    modelPeak = modelPeak/gain;
    photons = sum(sum(modelPeak));
    
end

% Rescale to nm
x = scaled(params(3));
y = scaled(params(4));
sigmax = scaled(params(5));
sigmay = scaled(params(6));
residuals = scaled(residuals);
mse = scaled(mse);
ci = scaled(ci);
stUncert = scaled(stUncert);



% If 3D is chosen do astigmatism fitting to calibration curves
data = guidata(findobj('Tag','hLOC'));
if get(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value') && (nargin > 1) && (sum(isnan(data.LOCALIZE.xCal3D)) == 0) && (sum(isnan(data.LOCALIZE.yCal3D)) == 0)
    
    % Read in allowed min and max PSF values and pixel scale
    minPSF = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'String'));
    maxPSF = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'String'));
    % Get the min and max z value to allow the minima search within
    minZ = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'String'));
    maxZ = str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'String'));
    
    sigmaxy = [sigmax*2, sigmay*2];
    
    % Determine the z-position
    [z, fval] = fminbnd(@(z) zPositioning(z, sigmaxy), minZ, maxZ);
    
    % Put constraints on the astigmatism and z-positioning
    if (sigmax*2 < minPSF) || (sigmax*2 > maxPSF) || (sigmay*2 < minPSF) || (sigmay*2 > maxPSF)
        z0 = -1000;
    elseif (z < minZ) || (z > maxZ)
        z0 = -1000;
    elseif fval > str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'String'))
        z0 = -1000;
    else
        z0 = z;
    end
    
end


if max(stUncert(3), stUncert(4)) > str2double(get(findobj('Tag', 'LOCALIZE_Locset_fitError_1'), 'String')) || (get(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value') && photons < str2double(get(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'String')));
    x0 = 0;
    y0 = 0;
elseif nargin == 1 % If 3D calibration is done
    x0 = x;
    y0 = y;
else
    % Related to the whole image pixel coord
    x0 = scaled(col)+x;
    y0 = scaled(row)+y;
end


% Collect the results
if nargin > 1
    fit.frameNr = frameNr;
end
fit.amp = params(1);
fit.bg = params(2);
fit.x0 = x0;
fit.y0 = y0;
fit.z0 = z0;
fit.sigmax = sigmax;
fit.sigmay = sigmay;
fit.mse = mse;
fit.residuals = residuals;
fit.ci = ci;
fit.stUncert = stUncert;
fit.jacob = Jacob; % NOT rescaled
fit.covB = covB;   % NOT rescaled
fit.photons = photons;

if nargin > 4
fit.G = reshape(pointGaussian(params,[xcoord, ycoord]), size(peak));
end

end

function pG = pointGaussian(beta,xdata)
pG = beta(1)*exp(-.5*(bsxfun(@minus,xdata,beta(3:4)').^2)*(1./beta(5:6).^2)) + beta(2);
end

function A = convExtEdge(A ,filt)
% Convolution using Fourier space with extended edge data

A = bsxfun(@times,fft([repmat(A(1, :), size(A, 1), 1); A; repmat(A(end, :), size(A, 1), 1)]), fft([filt(1:floor(end/2));zeros(length(filt)*2,1);filt(floor(end/2)+1:end)]));
A = ifft(A);
A = A(length(filt)+1:2*length(filt),:);
end

function d = zPositioning (z, sigmaxy)

%Get calibration curves
data = guidata(findobj('Tag','hLOC'));
xPoly = data.LOCALIZE.xCal3D;
yPoly = data.LOCALIZE.yCal3D;

%Rename parameters
sigmax = sigmaxy(1);
sigmay = sigmaxy(2);

% Define the distance to be minimized (Huang, Zhuang Science 8 February 2008: Vol. 319 no. 5864 pp. 810-813 )
d = sqrt((sqrt(sigmax)-sqrt(polyval(xPoly, z)))^2 + (sqrt(sigmay)-sqrt(polyval(yPoly, z)))^2);

end

function varout = scaled(varin)
%Read in the pixelscaling
scale = str2double(get(findobj('Tag', 'LOCALIZE_Locset_scale_1'), 'String'));

varout = scale.*varin;

end

function varout = unscaled(varin)
%Read in the pixelscaling
scale = str2double(get(findobj('Tag', 'LOCALIZE_Locset_scale_1'), 'String'));

varout = varin./scale;

end

function [xData, yData] = align(hObj)

rotVar = [];
rotStep = 0.1;
for i = 0:1:180/rotStep
    rotate(hObj, [0 0 1], rotStep);
    yData = get(hObj, 'Ydata');
    rotVar = [rotVar, var(yData)];
end
[~, ind] = min(rotVar);
rotate(hObj, [0 0 1], 180+(ind-1)*rotStep);
yData = get(hObj, 'Ydata');
xData = get(hObj, 'Xdata');
set(hObj, 'Ydata', yData-min(yData));
axis equal;
end 

function LoadNewData(varargin)

if nargin == 1
    name = varargin{1};
    pathname = name{1};
    filename = name{2}; 
else
% Get filename and path with "uigetfile"
[filename, pathname] = uigetfile({'*.mat'}, 'Select struct file (.mat)');
if ( filename == 0 )
    disp('Error! No (or wrong) file selected!')
    return
end

end

full_filename = [ pathname, filename ];

% Load the .mat file
inStruct = load(full_filename);
if isfield(inStruct, 'DETECT')
    data.LOCALIZE = inStruct.DETECT;
elseif isfield(inStruct, 'LOCALIZE')
    data = inStruct;
else
    data.LOCALIZE = inStruct;
end

% Is it a file that has been through the LOCALIZE
if isfield(inStruct, 'LOCALIZE')
    
    if nargin == 1
       disp('Batch process for files already "localized" is not valid at the moment. Program so that all variables are taken from the GUI instead of the .mat file first...'); 
        return
    end
    
    % If 3D has been used, set the used variables.
    if data.LOCALIZE.use3D
        % Update the edit fields for the calibration curves
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String', num2str(data.LOCALIZE.xCal3D(1)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String', num2str(data.LOCALIZE.xCal3D(2)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String', num2str(data.LOCALIZE.xCal3D(3)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String', num2str(data.LOCALIZE.xCal3D(4)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String', num2str(data.LOCALIZE.yCal3D(1)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String', num2str(data.LOCALIZE.yCal3D(2)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String', num2str(data.LOCALIZE.yCal3D(3)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String', num2str(data.LOCALIZE.yCal3D(4)), 'Visible', 'on');
        
        % Set other variables
        set(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value', data.LOCALIZE.use3D);
        set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_0'), 'Enable', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_cal3DPath_0'), 'String', data.LOCALIZE.cal3DPath);
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'String', num2str(data.LOCALIZE.psfLimits(1)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'String', num2str(data.LOCALIZE.psfLimits(2)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'String', num2str(data.LOCALIZE.zLimits(1)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'String', num2str(data.LOCALIZE.zLimits(2)), 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'String', data.LOCALIZE.dist3D, 'Visible', 'on');
        
    else
        % Inactivate and get the calibration variables from the GUI and
        % let the other variables stand as is.
        set(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value', data.LOCALIZE.use3D);
        data.LOCALIZE.cal3DPath = get(findobj('Tag', 'LOCALIZE_Locset_cal3DPath_0'), 'String');
        data.LOCALIZE.xCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String'))];
        data.LOCALIZE.yCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String')),...
            str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String'))];
        
        % Set all visibility to off regarding 3D
        % Calibration curves
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'Visible', 'off');
        
        % Other variables
        set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_0'), 'Enable', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'Visible', 'off');
        
    end
    
    if data.LOCALIZE.photons
        
        set(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value', data.LOCALIZE.photons);
        set(findobj('Tag', 'LOCALIZE_Locset_cal_0'), 'Enable', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'String', data.LOCALIZE.EMCCDBaseline, 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'String', data.LOCALIZE.EMCCDGain, 'Visible', 'on');
        set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'String', data.LOCALIZE.photonTh, 'Visible', 'on');
    else
        
        set(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value', data.LOCALIZE.photons);
        set(findobj('Tag', 'LOCALIZE_Locset_cal_0'), 'Enable', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'Visible', 'off');

    end
    
    
    % Update the fields for scale and other small things
    set(findobj('Tag', 'LOCALIZE_Locset_scale_1'), 'String', data.LOCALIZE.scale);
    set(findobj('Tag', 'LOCALIZE_Locset_fitError_1'), 'String', data.LOCALIZE.maxxyUnCert);
    set(findobj('Tag', 'LOCALIZE_Locset_fitWindow_1'), 'String', data.LOCALIZE.fitWindowSize);

    
    
    
else
   
    % Inactivate and get the calibration variables from the GUI and
    % let the other variables stand as is but invisible.
    if nargin ~= 1
        set(findobj('Tag', 'LOCALIZE_Locset_3D_0'), 'Value', 0);
    end
    data.LOCALIZE.cal3DPath = get(findobj('Tag', 'LOCALIZE_Locset_cal3DPath_0'), 'String');
    data.LOCALIZE.xCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'String'))];
    data.LOCALIZE.yCal3D = [str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'String')),...
        str2double(get(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'String'))];
    % Set all visibility to off regarding 3D
        % Calibration curves
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_3'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalX_4'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_3'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DcalY_4'), 'Visible', 'off');
        % Other variables
        set(findobj('Tag', 'LOCALIZE_Locset_3Dcal_0'), 'Enable', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DpsfSize_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DzRange_2'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_3DD_1'), 'Visible', 'off');
    
    % Inactivate photon stats but let paramets stay invisible in GUI
    if nargin ~= 1
    set(findobj('Tag', 'LOCALIZE_Locset_photon_0'), 'Value', 0);
    end
    set(findobj('Tag', 'LOCALIZE_Locset_cal_0'), 'Enable', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_baseline_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_gain_1'), 'Visible', 'off');
        set(findobj('Tag', 'LOCALIZE_Locset_minPhoton_1'), 'Visible', 'off');
end

    
    % Put in data from the DETECT interface
    set(findobj('Tag', 'LOCALIZE_label_gaussian'), 'String', sprintf('[%g, %g]', data.LOCALIZE.gaussian));
    set(findobj('Tag', 'LOCALIZE_label_mexiHat'), 'String', sprintf('[%g, %g]', data.LOCALIZE.mexiHat));
    set(findobj('Tag', 'LOCALIZE_label_relIntTh'), 'String', data.LOCALIZE.relIntTh);
    set(findobj('Tag', 'LOCALIZE_label_intTh'), 'String', data.LOCALIZE.intTh);
    set(findobj('Tag', 'LOCALIZE_label_globalScale'), 'String', data.LOCALIZE.globalScale);
    
    % Put in the value for time between frames in the tracking section
    set(findobj('Tag', 'LOCALIZE_Trackset_timeStep_1'), 'String', data.LOCALIZE.timeBetweenFrames);

    
% Turn off buttons that should be available AFTER fitting has been done
set(findobj('Tag', 'LOCALIZE_Visset_display2D_0'), 'Enable', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_display3D_0'), 'Enable', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_0'), 'Enable', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_1'), 'Visible', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_corrDrift_2'), 'Visible', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_0'), 'Enable', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_1'), 'Visible', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_PALMPlot_2'), 'Visible', 'off');
set(findobj('Tag', 'LOCALIZE_Visset_align_0'), 'Enable', 'off');



% Calc. new variables
frameNumber = 1;
full_filename_raw = data.LOCALIZE.full_filename_raw;
if ~isempty(strfind(full_filename_raw, '.tif'))
    
    % Calc. new variables
    imInfo = imfinfo(full_filename_raw);
    imWidth = imInfo(1).Width;
    imHeight = imInfo(1).Height;
    stackSize = numel(imInfo);
    
    rawData = zeros(imHeight, imWidth, stackSize);
    
    t = Tiff(full_filename_raw, 'r');
    for inFrame = 1:stackSize
        inFrame
        rawData(:, :, inFrame) = t.read();
        if inFrame<stackSize
            t.nextDirectory();
        end
    end
    t.close();
    data.LOCALIZE.timeBetweenFrames = 0;
    
else
    [rawData, timeBetweenFrames] = readSTK(full_filename_raw);
    stackSize = size(rawData, 3);
end
data.LOCALIZE.rawData = rawData;

if stackSize==1
    rawData(:, :, 2) = zeros(size(rawData(:, :, 1)));
    stackSize = 2;
end

original = data.LOCALIZE.rawData(:, :, frameNumber);
current = original;

% Store all GUI data
data.LOCALIZE.filename = filename;
data.LOCALIZE.pathname = pathname;
data.LOCALIZE.full_filename_raw = full_filename_raw;
data.LOCALIZE.stackSize = stackSize;
data.LOCALIZE.frameNumber = frameNumber;
data.LOCALIZE.original = original;
data.LOCALIZE.current = current;
data.LOCALIZE.result = cell(1, 1);
data.LOCALIZE.xDataOrig = [];
data.LOCALIZE.yDataOrig = [];
data.LOCALIZE.xDataCorr = [];
data.LOCALIZE.yDataCorr = [];
data.LOCALIZE.zDataOrig = [];
data.LOCALIZE.sigmaxDataOrig = [];
data.LOCALIZE.sigmayDataOrig = [];
data.LOCALIZE.xDataDevOrig = [];
data.LOCALIZE.yDataDevOrig = [];
data.LOCALIZE.photonsOrig = [];
data.LOCALIZE.frameNumOrig = [];
data.LOCALIZE.activeInd = [];
data.LOCALIZE.cropped = 'No';
data.LOCALIZE.aligned = 'No';
data.LOCALIZE.corrected = 'No';

% Save the struct in the GUI handler
guidata(findobj('Tag','hLOC'), data);


% Set Axes to new data and update
UpdateSelectionTools;
UpdateAxes;
if nargin~=1
SetAxes;
AdjustImage;
end
ResetLabels;
end



































% function syncArrays(varargin)
% data = guidata(findobj('Tag','hLOC'));
%
% x = data.LOCALIZE.xDataTot;
% y = data.LOCALIZE.yDataTot;
% z = data.LOCALIZE.zDataTot;
% sigmaxOrig = data.LOCALIZE.sigmaxDataTotOrig;
% sigmayOrig = data.LOCALIZE.sigmayDataTotOrig;
% xDevOrig = data.LOCALIZE.xDataDevTotOrig;
% yDevOrig = data.LOCALIZE.yDataDevTotOrig;
% xOrig = data.LOCALIZE.xDataTotOrig;
% yOrig = data.LOCALIZE.yDataTotOrig;
% zOrig = data.LOCALIZE.zDataTotOrig;
% photonsOrig = data.LOCALIZE.photonsTotOrig;
% frameNumOrig = data.LOCALIZE.frameNumTotOrig;
%
% sigmax = [];
% sigmay = [];
% xDev = [];
% yDev = [];
% photons = [];
% frameNum = [];
%
% for ind = 1 : length(x)
%
%     xInd = find(xOrig == x(ind));
%     yInd = find(yOrig == y(ind));
%     zInd = find(zOrig == z(ind));
%
%     if isequal(xInd, yInd) %&& (~isequal(z, zeros(size(z))) && isequal(xInd, yInd) && isequal(xInd, yInd))
%         sigmax = [sigmax, sigmaxOrig(xInd)];
%         sigmay = [sigmay, sigmayOrig(xInd)];
%         xDev = [xDev, xDevOrig(xInd)];
%         yDev = [yDev, yDevOrig(xInd)];
%         photons = [photons, photonsOrig(xInd)];
%         frameNum = [frameNum, frameNumOrig(xInd)];
%     end
%
% end
%
% data.LOCALIZE.sigmaxDataTot = sigmax;
% data.LOCALIZE.sigmayDataTot = sigmay;
% data.LOCALIZE.xDataDevTot = xDev;
% data.LOCALIZE.yDataDevTot = yDev;
% data.LOCALIZE.photonsTot = photons;
% data.frameNumTot = frameNum;
%
% guidata(findobj('Tag','hLOC'), data);
%
% end



% function LoadMatButton(hObject,varargin)
%
% 	[filename, pathname] = uigetfile('*.mat', 'Select .mat file');
% 	if ( filename == 0 )
% 		disp('Error! No (or wrong) file selected!')
% 		filename = 0;
% 		pathname = 0;
% 		return
% 	end
% 	full_filename = [ pathname, filename ];
%
%     % Load the .mat file
%     load(full_filename);
%
%     % Save the struct in the GUI handler
%     guidata(findobj('Tag','hLOC'), data);
%
%     % Set the buttons to their correct state depending on if there are
%     % results in the struct or not
%     if isempty(data.LOCALIZE.result)
%         set(findobj('Tag', 'LOCALIZE_Visset_display2D_0'), 'Enable', 'off');
%     else
%         set(findobj('Tag', 'LOCALIZE_Visset_display2D_0'), 'Enable', 'on');
%     end
%
%     % Set Axes to new data and update
% 	UpdateSelectionTools;
% 	UpdateAxes;
% 	SetAxes;
% 	AdjustImage;
% 	ResetLabels;
% end











