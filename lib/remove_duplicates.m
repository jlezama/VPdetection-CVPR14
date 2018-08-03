function [final_vps, final_NFAs] = remove_duplicates(vps, NFAs, params)
% Identifies and removes duplicate detections, keeping only most
% significant ones.
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

THRESHOLD = params.DUPLICATES_THRESHOLD;


clus = aggclus(vps', THRESHOLD);


final_vps = [];
final_NFAs = [];
for i=1:length(clus)
    c = clus{i};
    if length(c)==1
        final_vps = [final_vps, vps(:,c)];
        final_NFAs = [final_NFAs; NFAs(c)];
    else
        [V ,I] = max(NFAs(c)); % keep only the most significant VP in the cluster
        final_vps = [final_vps, vps(:,c(I))];
        final_NFAs = [final_NFAs; NFAs(c(I))]; 
    end
    
end

