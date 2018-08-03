function clus = aggclus(X, THRESHOLD);
% agglomerative clustering using single link

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


N = size(X,1);

D = pdist2(X,X);

n = sqrt(X(:,1).^2 + X(:,2).^2);
n = repmat(n, [1 N]);

n = max(n,n'); % max norm

D = D./n;
D(logical(eye(N)))=inf;

clus = cell(1,N);
for i=1:N
    clus{i}=i;
end

[V, I] = min(D(:));

while V < THRESHOLD
    [i, j] = ind2sub(size(D),I);
    
    if i>j
        t = i;
        i=j;
        j = t;
    end
        
    clus{i} = [clus{i} clus{j}];
 
    clus = clus([1:j-1 j+1:end]);
    
    d = min([D(i,:); D(j,:)]);
    
    D(i,:) = d;
    D(:,i) = d';
    D(j,:) = [];
    D(:,j) = [];
    
    D(i,i)=inf;
    
    [V, I] = min(D(:));
end