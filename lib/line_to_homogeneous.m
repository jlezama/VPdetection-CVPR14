function [L] = line_to_homogeneous(l);
% converts line in x1 y1 x2 y2 format to homogeneous coordinates

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


x1 = l(:,1);
y1 = l(:,2);
x2 = l(:,3);
y2 = l(:,4);


dx = x2-x1;
dy = y2-y1;
a = -dy;
b = dx;
c = -a.*x1 -b.*y1;

L = [a, b, c];