%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
% SMT - Single Molecule Tracking                  %
% ==================================              %
%                                                 %
%    Developed by: Fredrik Persson                %
%                                                 %
%    Copyright 2011 GNU GPL License               %
%                                                 %
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
function SMTrack(~,~,varargin)
	clear all
    
	exitButton;
    
    % Font and font size
    font = 'Ariel';
    fontsize = 13;
    
    if ispc || isunix 
        fontsize = fontsize*(72/96); 
    end
	
	f1 = figure('Visible','off');
	
	% Figure
	hSMT = figure(...
	  	'Units','pixels',...
		'MenuBar','none',...
		'Toolbar','none',...
		'NumberTitle','off',...
		'Visible','off',...
		'Position',[0 0 1 1],...
		'Resize','off',...
		'Colormap',hot,...
		'Tag','hSMT');
		
	drawStartContent(hSMT, font, fontsize);
		
	movegui(hSMT,'north');
	set(hSMT,'Visible','on');
	
	close(f1);
		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw GUI content functions %
% ========================== %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawStartContent(hObject,varargin)
	
	% Set name of window
	set(hObject,'Name','SMT - Start');
	
	% Dimensions
	% ==========
	% ------------------
	% |       10       |
	% |    --------    |
	% | 10 |  bw  | 10 |
	% |    --------    |
	% .                .
	% .                .
	% .                .
	% |    --------    |
	% |    |      |    |
	% |    --------    |
	% |       10       |
	% ------------------
	
	bw = 150;
	bh = 27;
	
	w = 10 + 150 + 10;
	h = 10 + 5*(bh+10) + 10;
	
	pos = [0 0 w h];
	set(hObject,'Position',pos);
	
    % Fonts
    font = varargin{1};
    fontsize = varargin{2};
    
    
	% Detect molecules
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
        'FontName', font ,...
        'FontSize',fontsize,...
		'String','DETECT',...
		'Position',[10 h-1*(bh+10) bw bh],...
		'Callback',{@DetectButton, font, fontsize});
	
	% Localize detected molecules
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
        'FontName', font ,...
        'FontSize',fontsize,...
		'String','LOCALIZE',...
		'Position',[10 h-2*(bh+10) bw bh],...
		'Callback',{@LocalizeButton, font, fontsize});

    
	% Analyze results
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
        'FontName', font ,...
        'FontSize',fontsize,...
		'String','ANALYZE',...
		'Position',[10 h-3*(bh+10) bw bh],...
		'Callback',{@AnalyzeButton, font, fontsize});
    
    	% About
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
        'FontName', font ,...
        'FontSize',fontsize,...
		'String','About',...
		'Position',[10 h-4*(bh+10) bw bh],...
		'Callback',{@aboutButton,hObject});
    
	% Exit
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
        'FontName', font ,...
        'FontSize',fontsize,...
		'String','Exit',...
		'Position',[10 h-5*(bh+10) bw bh],...
		'Callback',{@exitButton,hObject});
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button callback functions %
% ========================= %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exitButton(~,~,varargin)
	
	close(findobj('Tag','hDET'));
 	close(findobj('Tag','hLOC'));
 	close(findobj('Tag','hANA'));
	close(findobj('Tag','hSMT'));
	
end

function aboutButton(~,~,varargin)
	
    msgbox(sprintf(...
['\nSMTrack, SMTrack.m \n\n' 'Copyright (C) 2011 Fredrik Persson \n\n' ...
 'This program comes with ABSOLUTELY NO WARRANTY. \n' ...
 'This is free software, and you are welcome to redistribute it \n' ...
 'under certain conditions. See license.txt for details. \n\n ']));
	
end

function DetectButton(~,~,varargin)

    close(findobj('Tag','hANA'));
    close(findobj('Tag','hLOC'));

	% Execute sub-routine
    close(findobj('Tag','hDET'));
	%DetectMolecules_orig;
    DetectMolecules3(varargin{1}, varargin{2});
	
end

function LocalizeButton(~,~,varargin)
	
    close(findobj('Tag','hDET'));
    close(findobj('Tag','hANA'));

    % Execute sub-routine
    close(findobj('Tag','hLOC'));
   %LocalizeMolecules_orig;
    LocalizeMolecules3(varargin{1}, varargin{2});

        
end

function AnalyzeButton(~,~,varargin)
	
    close(findobj('Tag','hDET'));
    close(findobj('Tag','hLOC'));

    % Execute sub-routine
    close(findobj('Tag','hANA'));
    AnalyzeMolecules(varargin{1}, varargin{2});

        
end

%%%%%%%%%%%%%%%%%%%%%%
% Callback functions %
% ================== %
%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% Other functions %
% =============== %
%%%%%%%%%%%%%%%%%%%

