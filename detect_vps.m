function [horizon_line, vpimg] = detect_vps(img_in,folder_out,...
    manhattan, acceleration, focal_ratio, input_params)

% DETECT_VPS
% Function for vanishing points and horizon line detection
%
% Version 0.9, June 2017
%
% arguments:
% - img_in: filename of the input image
% - folder_out: path to save resulting image and text files
% - manhattan: boolean variable used to determine if the Manhattan-world
%   hypothesis is assumed
% - acceleration: boolean variable used to determine if acceleration using
%   Figueiredo and Jain GMM algorithm should be used
% - focal_ratio: ratio between the focal lenght and captor width
% - input_params: optional input parameters
%
% output:
% - horizon_line: estimated horizon line in image coordinates
% - vpimg: esitmated vanishing points in image coordinates
%
% Copyright (C) 2017 Jose Lezama <jlezama@gmail.com>
%
% This program is free software: you can use, modify and/or
% redistribute it under the terms of the GNU General Public
% License as published by the Free Software Foundation, either
% version 3 of the License, or (at your option) any later
% version. You should have received a copy of this license along
% this program. If not, see <http://www.gnu.org/licenses/>.
%
% This program is free software: you can use, modify and/or
% redistribute it under the terms of the simplified BSD
% License. You should have received a copy of this license along
% this program. If not, see
% <http://www.opensource.org/licenses/bsd-license.html>.
%
% To the extent possible under law, the authors have dedicated all
% copyright and related and neighboring rights to this software to
% the public domain worldwide. This software is distributed without
% any warranty. You should have received a copy of the CC0 Public
% Domain Dedication along with this software. If not, see
% <http://creativecommons.org/publicdomain/zero/1.0/>.
%
% This program is provided for research and education only: you can
% use and/or modify it for these purposes, but you are not allowed
% to redistribute this work or derivative works in source or
% executable form. A license must be obtained from the patent right
% holders for any other use.
%
%   if ~isdeployed
%     addpath lib
%   end

% input parameters
if isdeployed
    manhattan = str2num(manhattan);
    acceleration = str2num(acceleration);
    focal_ratio = str2num(focal_ratio);
end


if nargin < 6
    input_params = struct();
end

params.MANHATTAN = manhattan;
params.ACCELERATION = acceleration;
params.img_in = img_in;
params.folder_out = folder_out;

if isdeployed
    params.PLOT = 1;
    params.PRINT = 1;
else
    params.PLOT = 0;
    params.PRINT = 0;
end

% method parameters
params.ppd = [2 2]; % principal point = [W H]./params.ppd; values taken from YUD
params.REFINE_THRESHOLD = 2; % (\theta)
params.VARIATION_THRESHOLD = 0.1; % (\zeta)
params.DUPLICATES_THRESHOLD = 0.0001; % (\delta)
params.VERTICAL_ANGLE_THRESHOLD = 50; % (\omega)
params.INFINITY_THRESHOLD = 3.6; % (\lambda)
params.FOCAL_RATIO = focal_ratio; % (f)
params.LENGTH_THRESHOLD = 1.71; % (\tau) final threshold will be sqrt(W+H)/tau
params.DIST_THRESHOLD =.14;% (\kappa)

if params.MANHATTAN
    % inclusive threshold
    params.ORTHOGONALITY_THRESHOLD = cos(87.5*pi/180); % (\gamma_S)
else
    % exclusive threshold
    params.ORTHOGONALITY_THRESHOLD = cos(77.5*pi/180); % (\gamma_R)
end


% acceleration parameters
params.MAX_POINTS_ACCELERATION = 200; % use acceleration if number of points is larger than this
params.GMM_Ks = [30 30 30];

% overwrite with optional input parameters
names = fieldnames(input_params);
for i=1:length(names)
    v = getfield(input_params, names{i});
    params = setfield(params, names{i}, v);
end

%% START SCRIPT


% read image
img = imread(img_in);
[params.H, params.W, ~] = size(img);


% length threshold based on image size
params.LENGTH_THRESHOLD = sqrt((params.H+params.W))/params.LENGTH_THRESHOLD;


% get line segments
lines = run_lsd(img_in);
lines_lsd = lines;

% denoise lines
[lines, line_endpoints] = denoise_lines(lines, params);

if   params.PRINT
    draw_lines(lines, line_endpoints, params);
end

% convert to PClines
[points_straight, points_twisted] = convert_to_PClines(lines, params);

% run alignment detector in straight and twisted spaces
[detections_straight, m1, b1] = find_detections(points_straight, params);
[detections_twisted, m2, b2] = find_detections(points_twisted, params);


% gather intial vanishing point detections
[mvp_all, NFAs] = read_detections_as_vps(detections_straight, m1, b1, ...
    detections_twisted, m2, b2, params); % NFAs is actually -log10(trueNFA)



% refine detections
mvp_all = refine_detections(mvp_all, lines_lsd, params);

[mvp_all, NFAs] = remove_duplicates(mvp_all, NFAs,params);

% draw preliminary detections
if  params.PRINT
    img = imread(img_in);
    
    img2 = draw_segments(img,mvp_all, lines_lsd, params);
    imwrite(img2,sprintf('%s/vps_raw.png',params.folder_out));

end


% compute horizon line
if ~isempty(mvp_all);
    if params.MANHATTAN
        [horizon_line, vpimg] = compute_horizon_line_manhattan(mvp_all, NFAs, lines_lsd, params);
    else
        [horizon_line, vpimg] = compute_horizon_line_non_manhattan(mvp_all, NFAs, lines_lsd, params);
    end
else
    horizon_line = [];
    vpimg = [];
    imwrite(img,sprintf('%s/horizon_line.png',params.folder_out));
    fileID = fopen(sprintf('%s/out.txt',params.folder_out),'w');
    fprintf(fileID,'No Vanishing Points found.\n');
    fclose(fileID);
end

if params.PRINT
    draw_dual_spaces(points_straight, detections_straight, 'straight', vpimg, params)
    draw_dual_spaces(points_twisted, detections_twisted, 'twisted', vpimg, params)
end

disp('FINISHED.')
