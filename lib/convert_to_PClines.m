function [points_straight, points_twisted] = convert_to_PClines(lines, params);
% Converts lines in the image to PCLines "straight" and "twisted" spaces


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


H = params.H;
W = params.W;

L = size(lines,1);
points_straight = zeros(L,2);
points_twisted = zeros(L,2);

[u, v] = PCLines(lines./repmat([W H W H],[L 1]), 'straight');
points_straight = [u, v];

[u, v] = PCLines(lines./repmat([W H W H],[L 1]), 'twisted');
points_twisted = [u, v];


% impose boundaries of PClines space
z1 = find(points_straight(:,1)> 2 | points_straight(:,2)> 2 | points_straight(:,1)< -1 | points_straight(:,2)< -1 | isnan(points_straight(:,1)) | isnan(points_straight(:,2)));
z2 = find(points_twisted(:,1)> 1 | points_twisted(:,2)> 1.5 | points_twisted(:,1)< -2 | points_twisted(:,2)< -1.5 | isnan(points_twisted(:,1)) | isnan(points_twisted(:,2)));

% Ihe CVPR paper uses a domain in the twisted space between [-2, 1]x[-2, 1]
% Instead, this version uses [-2, 1]x[-1.5 1.5], which is more consistent
% with the transform (see IPOL article)

points_straight(z1,:)=[];
points_twisted(z2,:)=[];
