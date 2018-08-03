function detections = find_endpoints_detections(lines, params)
% find detections of alignments among line segment endpoints
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


H = params.H;
W = params.W;

points_segments = [[lines(:,1); lines(:,3)], H-[lines(:,2); lines(:,4)]];

params.endpoints = 1;
[detections, m, b] = find_detections(points_segments, params);
params.endpoints = 0;