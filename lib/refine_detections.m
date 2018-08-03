function mvp_all = refine_detections(mvp_all, lines_lsd, params);
% Refines VP detections using lines from LSD
%
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

D = size(mvp_all,2);

mvp_refined = zeros(D,2);
for i =1:D
    vp = mvp_all(:,i)';
    vp = refine_vp(lines_lsd, vp, params);
    mvp_refined(i,:) = vp;
end

mvp_all = mvp_refined';
end

%% iterator function
function  vp = refine_vp( lines,  vp, params);

% Given a cluster of line segments, and two segments indicated by p1 and
% p2, obtain the main vanishing point determined by the segments

THRESHOLD = params.REFINE_THRESHOLD;

H = params.H;
W = params.W;

vp_orig = vp;

[vp] = refine_vp_iteration(lines,  vp, THRESHOLD,H, W);


variation = norm(vp-vp_orig)/norm(vp_orig);
% fprintf('variation: %f\n', variation);
if (variation > params.VARIATION_THRESHOLD)
    % fprintf('vp changed too much (%f)... probably unstable conditions, keeping initial vp\n', variation)
    vp = vp_orig;
end

end

%% iteration function
function [vp] = refine_vp_iteration(lines, vp, THRESHOLD, H,  W)
% finds intersection of each line in cluster with vanishing point segments

mp = [lines(:,1)+lines(:,3), lines(:,2)+lines(:,4)]/2;

L = size(lines,1);
O = ones(L,1);
Z = zeros(L,1);
vpmat = my_repmat2(vp,[L 1]);


VP = my_cross2([mp O]', [vpmat O]')';

VP3 = my_repmat(VP(:,3),[1 3]);
VP = VP./VP3;

a = VP(:,1);
b = VP(:,2);

% get angle betwen lines
angle = abs(atan(-a./b)-atan((lines(:,4)-lines(:,2))./(lines(:,3)-lines(:,1))));
angle = min(angle, pi-angle);

z2 = find(angle<THRESHOLD*pi/180);



%% obtain a refined VP estimate from sub-cluster z2
lengths = sum(([lines(:,1) lines(:,2)] - [lines(:,3) lines(:,4)]).^2,2);
weights = lengths/max(lengths);
lis=line_to_homogeneous(lines);


Q=zeros(3);
Is = [1 0 0; 0 1 0; 0 0 0];

%
l2 = lis(z2,:)';
w2 = weights(z2);
w2 = my_repmat(w2,[1 3])';

b = dot((Is'*l2),l2)';
b = my_repmat(b,[1 3])';
Q = (w2.*l2./b)*l2';


p = [0 0 1]';

A = [2*Q -p];

vp = null(A);


vp = vp(1:2,1)/vp(3,1);
vp = vp';

end



