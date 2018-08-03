function c = my_cross(a,b,dim)
% Compute cross product of a and b. Based on MATLAB original function, 
% re-implemented for efficiency with less type checks.

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


% Special case: A and B are vectors
rowvec = 0;

% Check dimensions
% if ~isequal(size(a),size(b)),
%    error(message('MATLAB:cross:InputSizeMismatch'));
% end
   dim = find(size(a)==3,1);

% % Check dimensions
% if (size(a,dim)~=3) || (size(b,dim)~=3),
%   error(message('MATLAB:cross:InvalidDimAorBForCrossProd'))
% end

% Permute so that DIM becomes the row dimension
perm = [dim:max(length(size(a)),dim) 1:dim-1];
a = permute(a,perm);
b = permute(b,perm);

% Calculate cross product
c = [a(2,:).*b(3,:)-a(3,:).*b(2,:)
     a(3,:).*b(1,:)-a(1,:).*b(3,:)
     a(1,:).*b(2,:)-a(2,:).*b(1,:)];
c = reshape(c,size(a));

% Post-process.
c = ipermute(c,perm);
if rowvec, c = c.'; end
