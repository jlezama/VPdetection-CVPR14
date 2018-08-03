function [detections, m, b] = find_detections(points, params);
% Runs alignment detector on 'points' and returns line coordinates.

% Version 0.9, June 2017
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

% add mixtures code to path
if ~isdeployed
    addpath mixtures/
    addpath mex_files/
end


%% check that points exist
if isempty(points)
    detections = [];
    m = [];
    b = [];
    return
end

%% check if acceleration is needed, and activated
if size(points,1)> params.MAX_POINTS_ACCELERATION && params.ACCELERATION
    disp('- USE ACCELERATED VERSION -');
    ALGORITHM_VERSION =2;
else
    ALGORITHM_VERSION = 1;
end

%% normalize points

M = max(points(:));
m = min(points(:));

points = (points-m)/(M-m)*512; % this version of the alignment detector expects a 512x512 domain


if ALGORITHM_VERSION==1
    detections = alignments_slow(points);
    detections = detections';
else
    candidates = run_mixtures(points, params.GMM_Ks, '');
    detections = alignments_fast(points,candidates);
    detections = detections';
end

% convert detections to line coordinates
if ~isempty(detections)
    dets = detections(:, [1:4]);
    dets = dets/512*(M-m)+m;
    
    detections(:,1:4) = dets;
    
    detections(:,5) = detections(:,5)/512*(M-m);
    
    x1 = dets(:,1);
    y1 = dets(:,2);
    x2 = dets(:,3);
    y2 = dets(:,4);
    
    dy = y2 - y1;
    dx = x2 - x1;
    
    m = dy./dx;
    b = (y1.*x2 -y2.*x1)./dx; % This may result in Nan or Inf, but this 
                              % is handled in read_detections_as_vps.m
else
    dets=[];
    m=[];
    b=[];
end

