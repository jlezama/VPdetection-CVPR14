function [mvp_all, NFAs] = read_detections_as_vps(detections_straight, m1, b1,detections_twisted, m2, b2, params);
% converts alignment detections to vanishing points in the image
% returns mvp_all, a list of vanishing points and NFAs, their corresponding
% -log10(true NFA)

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


if isempty(detections_straight) & isempty(detections_twisted)
    mvp_all = [];
    NFAs = [];
    return;
end


H = params.H;
W = params.W;

D1 = size(detections_straight,1);
D2 = size(detections_twisted, 1);


if ~isempty(detections_straight)
    NFAs1 = detections_straight(:,6);
else
    NFAs1 = [];
end
if  ~isempty(detections_twisted)
    NFAs2 = detections_twisted(:,6);
else
    NFAs2 = [];
end


maxNFA1 = max(NFAs1);
maxNFA2 = max(NFAs2);

% get vps in image coordinates (do PCLines inverse)
d = 1;
x1 = b1;
y1 = d*m1+b1;

x2 = b2;
y2 = -(-d*m2+b2);

x1 = x1*W;
y1 = y1*H;

x2 = x2*W;
y2 = y2*H;

vps1 = [x1 y1];
vps2 = [x2 y2];


mvp_all = [vps1' vps2'];

NFAs = [NFAs1; NFAs2];


% remove nan (infinity vp)                                                                                                                                                           
z = find(isnan(mvp_all(1,:)) | isinf(mvp_all(1,:)));
mvp_all(:,z)=[];
NFAs(z) = [];

