function [lines, lines_short_denoised] = denoise_lines(lines, params)
% this script takes a list of line segments and performs denoising by:
% - dividing the set of lines into short and long lines
% - creating groups of lines according to orientation and finding
% alignments of line segment endpoints
% - adding the alignments found to the list of lines
% - removing short lines from the list
%
% Version 0.9, October 2017
%
% This program is written by Jose Lezama <jlezama@gmail.com>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU Affero General Public License for more details.
% 
% You should have received a copy of the GNU Affero General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

%% threshold by line length
lengths = sqrt(sum([lines(:,3)-lines(:,1) lines(:,4)-lines(:,2)].^2,2));

% find lines that dont need denoising
z = find(lengths> params.LENGTH_THRESHOLD);


lines_large = lines(z,:);

lines(z,:)=[];

lines_short = lines;


angles_short = atan((lines_short(:,4)-lines_short(:,2))./(lines_short(:,3)-lines_short(:,1)));
angles_large = atan((lines_large(:,4)-lines_large(:,2))./(lines_large(:,3)-lines_large(:,1)));

angles_short = angles_short*180/pi;
angles_large = angles_large*180/pi;

all_detections = [];

for ANG = [0:30:180-30];
    angdiff_short = abs(angles_short-ANG);
    angdiff_large = abs(angles_large-ANG);
    
    angdiff_short = min(abs(angdiff_short),abs(angdiff_short-180));
    angdiff_large = min(abs(angdiff_large),abs(angdiff_large-180));
    
    z_short = find(angdiff_short<20);
    z_large = find(angdiff_large<20);
    
    params.ANG = ANG;
    
    if ~isempty(z_short)
        % short line segments
        detections = find_endpoints_detections(lines_short(z_short,:), params);
        if ~isempty(detections)
            all_detections = [all_detections; detections(:,[1:4])];
        end
    end
    
    if ~isempty(z_large)
        % long line segments
        detections = find_endpoints_detections(lines_large(z_large,:), params);
        if ~isempty(detections)
            all_detections = [all_detections; detections(:,[1:4])];
        end
    end
end
lines_short_denoised = all_detections;

if ~isempty(lines_short_denoised)
    % Invertion w.r.t H for ease of plotting in Matlab.
    lines_short_denoised(:,[2 4]) = params.H-lines_short_denoised(:,[2 4]);
end
lines = [lines_large; lines_short_denoised];
