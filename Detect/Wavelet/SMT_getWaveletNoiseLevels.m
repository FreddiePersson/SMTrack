function sigmaNoise = SMT_getWaveletNoiseLevels(I, varargin)
%% sigmaNoise=SMT_getWaveletNoiseLevels(I, varargin)
%
% Estimates the wavelet planes noise levels for the coefficients. It
% is possible to make use of three different methods.
%
% Input: 
% I               : The data that should be operated on.
%
% Output: 
% An [1, levels] array, with the corresponding significant noise levels.
% 
% options:
% 'Levels'        : followed by the number of wavelet planes to use.
%                   Default value is 3.
% 'Display'       : if given, the wavelets are displayed in individual plots.
% 'simNoise'      : if given, the significance level is determined from
%                   simulated gaussian noise (Starck et al 1995).
% 'actualPlaneNoise'   : if given the significance level will be estimated from the 
%                   actual plane, using a numeric prefactor (Olivo-Marin 2002). 
% 'firstPlaneNoise'    : if given the significance level will be estimated from
%                   the first wavelet plane. This is the default method.
%
%

%% copyright notice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SMT_getWaveletNoiseLevels.m, Estimates the noise levels in wavelets 
% =========================================================================
% 
% Copyright (C) 2012 Fredrik Persson
% 
% E-mail: freddie.persson@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or any later
% version.   
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program. If not, see <http://www.gnu.org/licenses/>.

%% parse input
extraArgs_AT = {''};
levels = 3;
TH = 1;
do_simNoise = false;
do_actualPlaneNoise = false;
do_firstPlaneNoise = true;

if(nargin>1)        % parse options
    kmax = nargin;   % stopping criterion
    if iscell(varargin{1})
        varargin = varargin{1};     % fulhack
        kmax = length(varargin)+1;
    end
    % argument counter
    k = 1;
    while(k<kmax)
        option=varargin{k};
        if(strcmpi(option,'Display'))
            extraArgs_AT{end+1} = option;
            k=k+1;
        elseif(strcmpi(option,''))     % fulhack
            
            k=k+1;
        elseif(strcmpi(option,'simNoise')) 
            do_simNoise = true;
            k=k+1;
        elseif(strcmpi(option,'actualPlaneNoise'))
            do_actualPlaneNoise = true;
            k=k+1;    
        elseif(strcmpi(option,'firstPlaneNoise')) 
            do_firstPlaneNoise = true;
            k=k+1;  
        elseif(strcmpi(option,'Levels'))
            if(~isempty(varargin{k+1}))
                extraArgs_AT{end+1} = option;
                levels = varargin{k+1};
                extraArgs_AT{end+1} = levels;
                if(~isnumeric(levels) || levels<=2 || levels~=round(levels))
                    error('SMT_getSignWaveletLevels: Levels option must be followed by a positive integer larger than 2.')
                end
            end
            k=k+2;
        else
            error(['SMT_getSignWaveletLevels: option ' option ' not recognized.'])
        end
    end
end

%% start of actual code

tempImg = zeros(size(I));
resultImg = zeros(size(I));
WP = SMT_ATrous(I, extraArgs_AT);


% Calculate the noise behaviour at each resolution level (can also be 
% approximated with std2(WP(:, :, 1)) or std2(WP(:, :, n))/0.67). [Starck et al, "Multiresolution support 
% applied to image filtering and restoration", (1995); Olivo-Marin (2002)]

if do_simNoise   %(Starck et al 1995)
    sigmaNoise = ones(1, levels);
    noise = randn(512);
    noiseWP = SMT_ATrous(noise, extraArgs_AT);
    sigmaI = std2(I);
    for ind = 1:levels
        sigmaNoise(ind) = std2(noiseWP(:, :, ind))*sigmaI;
    end
    
elseif do_actualPlaneNoise
    %% alternative where MAD/0.7 is used (Olivo-Marin 2002, Sadler, Swami, IEEE inf theory 1999)
    sigmaNoise = ones(1, levels);
    for ind = 1:levels
        waveletplane = WP(:, :, ind);
        sigmaNoise(ind) = median(abs(waveletplane(:) - mean(waveletplane(:))))/0.7;
    end
    
elseif do_firstPlaneNoise
    %% alternative where std2(WP(:, :, 1)) is used (Starck et al 1995)
    sigmaNoise = std2(WP(:, :, 1))*ones(1, levels);

end

end




