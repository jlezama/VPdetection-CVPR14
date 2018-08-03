function y = my_multinorm(x,m,covar, npoints)
% Evaluates a multidimensional Gaussian
% of mean m and covariance matrix covar
% at the array of points x
%

% -----------------------------------------------------------------------
% Copyright (2002): Mario A. T. Figueiredo and Anil K. Jain
%
% This software is distributed under the terms
% of the GNU General Public License 2.0.
% 
% Permission to use, copy, and distribute this software for
% any purpose without fee is hereby granted, provided that this entire
% notice is included in all copies of any software which is or includes
% a copy or modification of this software and in all copies of the
% supporting documentation for such software.
% This software is being provided "as is", without any express or
% implied warranty.  In particular, the authors do not make any
% representation or warranty of any kind concerning the merchantability
% of this software or its fitness for any particular purpose."
% ----------------------------------------------------------------------
%
%[dim npoints] = size(x);

%fprintf('dim:  %i, npoints: %i\n', dim, npoints)

%X = covar+ realmin*eye(dim);
X = covar+ realmin*[1 0;0 1];

dd = det(X);

in = inv(X);

%ff = ((2*pi)^(-dim/2))*((dd)^(-0.5));
ff = ((2*pi)^(-1))*((dd)^(-0.5));


%quadform = zeros(1,npoints);
centered = (x-m*ones(1,npoints));

y = ff * exp(-0.5*sum(centered.*(in*centered)));




