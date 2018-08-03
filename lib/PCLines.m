function [u, v] = PCLines_straight_all(l, space);
% Transforms line as [x1 y1 x2 y2] or a point as [x y] with PCLines straight
% transform. Coordinates should be normalized.
% see http://medusa.fit.vutbr.cz/public/data/papers/2011-CVPR-Dubska-PClines.pdf

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


if isempty(l)
    u = [];
    v = [];
    return
end

d = 1; % aribitrary distance between vertical axes x and y

L = size(l,2);

if L==4
    % it's a line, convert to point
    x1 = l(:,1);
    y1 = l(:,2);
    x2 = l(:,3);
    y2 = l(:,4);
    
    dy = y2-y1;
    dx = x2-x1;
    
    m = dy./dx;
    b = (y1.*x2 - y2.*x1)./dx;
    
    if isequal(space,'straight')
        PCline = [repmat(d,size(b)), b, 1-m]; % homogeneous coordinates
    elseif isequal(space, 'twisted')
        PCline = [repmat(-d,size(b)), -b, 1+m]; % homogeneous coordinates
    end
    u = PCline(:,1)./PCline(:,3);
    v = PCline(:,2)./PCline(:,3);
    
elseif L==2
    % it's  a point
    x = l(:,1);
    y = l(:,2);
    
    b = x;
    if isequal(space,'straight')
        m = (y-x)/d;
    elseif isequal(space, 'twisted')
        m = (y+x)/d;
    end
    u = m;
    v = b;
    
end