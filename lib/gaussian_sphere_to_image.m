function vpimg = gaussian_sphere_to_image(vp, W, H, FOCAL_RATIO, pp);
% Convert VP candidates as unit vectors in the Gaussian sphere to
% points in the image.

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

% normalize (just in case)
vp = vp ./ repmat(sqrt(sum(vp.^2)),[3 1]);

vpimg = [W*FOCAL_RATIO*vp(1,:)./vp(3,:)+pp(1);
    W*FOCAL_RATIO*vp(2,:)./vp(3,:) + (H-pp(2))];
vpimg(2,:) = H - vpimg(2,:);
end