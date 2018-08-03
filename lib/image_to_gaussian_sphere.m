function vp = image_to_gaussian_sphere(vpsimg, W, H, FOCAL_RATIO, pp)
% Convert VP candidates in the image to unit vectors in the Gaussian sphere

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

% The inversion w.r.t. H is for ease of plotting in Matlab.

vp = [vpsimg(1,:)-pp(1);(H-vpsimg(2,:))-(H-pp(2)); 
               ones(size(vpsimg(2,:)))*W*FOCAL_RATIO];

vp = vp ./ repmat(sqrt(sum(vp.^2)),[3 1]);
end