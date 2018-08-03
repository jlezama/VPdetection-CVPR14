function [Y, vpimg] = compute_horizon_line_non_manhattan(mvp_all, NFAs, lines_lsd, params);
% Computes the horizon line when the Manhattan-world hypothesis cannot be
% assumed.
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

my_vps = mvp_all;
N = size(my_vps,2);

H = params.H;
W = params.W;
pp = [W/2 H/2];

cp = [ones(1,N)*pp(1); ones(1,N)*pp(2)]; % central point

centered_vp = (mvp_all-cp);
angles = atan2(centered_vp(2,:), centered_vp(1,:));

%% estimate vertical VPs by sinus of angle wrt central point
vertical_angle_scores = abs(sin(angles));
vertical_distance_scores = abs(centered_vp(2,:));
vertical_vps_idx = find((vertical_angle_scores > ...
    sin(params.VERTICAL_ANGLE_THRESHOLD/180*pi)) & ...
    (vertical_distance_scores > H));

vertical_vps = mvp_all(:,vertical_vps_idx);
if isempty(vertical_vps);
    % take just the most vertical
    [~, I] = sort(vertical_distance_scores,'descend');
    
    vertical_vps_idx = I(1);
    vertical_vps = mvp_all(:,vertical_vps_idx);
end

%% take vertical vp with lowest NFA
NFAs_vertical_vps = NFAs(vertical_vps_idx);
[~ ,vpI] = max(NFAs_vertical_vps);
vertical_vp = vertical_vps(:,vpI);

% vertical line
vl = vertical_vp'-pp;

%% use remaining points as horizontal
horizontal_vps_idx = setdiff([1:N],vertical_vps_idx);

% if empty, use all of them except the vertical one
if isempty(horizontal_vps_idx)
    horizontal_vps_idx = setdiff([1:N],vpI);
end

horizontal_vps = mvp_all(:,horizontal_vps_idx);
NFAs_horizontal_vps = NFAs(horizontal_vps_idx);

%% order horizontal vps by nfa
[V, I] = sort(NFAs_horizontal_vps, 'descend');

horizontal_vps = horizontal_vps(:,I);
NFAs_horizontal_vps = NFAs_horizontal_vps(I);


%% convert to unit sphere
FOCAL_RATIO = params.FOCAL_RATIO;

%% convert vps to unit sphere
vertical_vp_unit = image_to_gaussian_sphere(vertical_vp, W, H, FOCAL_RATIO, pp);                   
horizontal_vps_unit = image_to_gaussian_sphere(horizontal_vps, W, H, FOCAL_RATIO, pp);                   
                   
%% check orthogonality of horizontal vps with vertical vp
orthogonality_scores = [];
for i=1:size(horizontal_vps_unit,2)
    orthogonality_score = ...
        abs(dot(horizontal_vps_unit(:,i), vertical_vp_unit));
    orthogonality_scores = [orthogonality_scores, orthogonality_score];
end

is_orthogonal = ones(size(orthogonality_scores));
is_orthogonal(orthogonality_scores>params.ORTHOGONALITY_THRESHOLD)=0;
% is_orthogonal is 1 where vps are orthogonal to vertical vp

%% check for horizontal vps from parallel lines
NH = size(horizontal_vps,2);

norm_horizontal_vps = (abs(horizontal_vps(1,:)-pp(1)));

is_not_parallel = ones(size(norm_horizontal_vps));
is_not_parallel(norm_horizontal_vps > W*params.INFINITY_THRESHOLD) = 0;
% is_not_parallel is 1 where vp does not come from parallel lines

if sum(is_not_parallel)==0
    % if all horizontal vps come from parallel lines, take the closest one
    [V, I] = min(norm_horizontal_vps);
    is_not_parallel(I)=1;
    
end

weights_NFA_horizontal_vps = NFAs_horizontal_vps/sum(NFAs_horizontal_vps);

weights_NFA_horizontal_vps = weights_NFA_horizontal_vps.^2;

weights = is_not_parallel' .* weights_NFA_horizontal_vps .*is_orthogonal';

if sum(weights)==0
    % if no vp satisfies all conditions just take the one with lowest NFA
    disp('*************************************')
    disp('CRITICAL: NO orthogonal and finite VP')
    disp('*************************************')
    [V, I] = max(weights_NFA_horizontal_vps);
    weights(I)=1;
end

weights = weights/sum(weights);

z = find(weights==0);
weights(z)=[];
horizontal_vps(:,z)=[];
NH = size(horizontal_vps,2);

[V, I] = sort(weights, 'descend');

weights = V;
horizontal_vps = horizontal_vps(:,I);

% get horizontal line defined by first vp and vertical line (vl)
% get auxiliary point in line perpendicular to vl passing by horizontal vp
i = 1;
hvp = horizontal_vps(:,i);

normal_to_vertical_line = [vl(2); -vl(1)]*norm(hvp);
nvl = normal_to_vertical_line;

aux1 = hvp + nvl ;
aux2 = hvp - nvl ;

% current line coordinates
[m, b] = line_to_slope_offset([aux1' aux2']);

X = [1 W];
Y = X*m+b;

all_Y = zeros(NH,2);
all_Y(1,:) = Y;

for i =2:NH
    hvp = horizontal_vps(:,i);
    aux1 = hvp + nvl;
    aux2 = hvp - nvl;
    
    [m, b] = line_to_slope_offset([aux1' aux2']);
    
    Y = X*m+b;
    all_Y(i,:) = Y;
end

weights = weights/sum(weights);


weights = repmat(weights, [1 2]);

% weighted average of horizon lines
Y = sum(all_Y.*weights,1);

%% remove outliers and re-estimate
Y_dists = abs(all_Y(:,1) - Y(1))/H;

z =  find(Y_dists < params.DIST_THRESHOLD   );

weights2 = weights(z,:);
all_Y2 = all_Y(z,:);
horizontal_vps = horizontal_vps(:,z);
% re-estimate
weights = weights2/sum(weights2(:,1));
Y = sum(all_Y2.*weights,1);

%% obtained horizon line
a = (Y(2)-Y(1))/(X(2)-X(1));
X= [1:W];
Y = X*a+Y(1);

%% obtained vps
vpimg = [horizontal_vps vertical_vp];

%% draw segments with colors
if params.PRINT
    imgo = imread(params.img_in);
    img = draw_segments(imgo, vpimg, lines_lsd, params);
    
    % draw horizon line
    linewidth = 6;
    for i=1:length(X);
        if mod(i,20)>=10
            col = [255 128 0];
        else
            col = [128 0 255];
        end
        
        for j=-round(linewidth/2):round(linewidth/2)
            xx = round(X(i));
            yy = round(Y(i)+j);
            
            if yy>11 & yy<=H & xx>=1 & xx <=W
                img(yy,xx,:)=col;
                
            end
        end
    end
    
    if ~isdeployed & params.PLOT
        figure, imagesc(img);
    end
    
    % write output
    imwrite(img,sprintf('%s/horizon_line.png',params.folder_out));
    
        % save image for each VP
    for i=1:size(vpimg,2);
        img = draw_segments(imgo,vpimg(:,i), lines_lsd, params, 1);
        imwrite(img,sprintf('%s/final_vp_%i.png',params.folder_out,i));
    end
end

fileID = fopen(sprintf('%s/out.txt',params.folder_out),'w');
fprintf(fileID,'horizontal vps:\n');
for i=1:size(horizontal_vps,2);
    hvp = horizontal_vps(:,i);
    fprintf(fileID,'(%f, %f)\n',hvp(1), hvp(2));
end
fprintf(fileID,'vertical vp:\n');
fprintf(fileID,'(%f, %f)\n',vertical_vp(1), vertical_vp(2));
fprintf(fileID,'horizon line:\n');
fprintf(fileID,'(%f, %f), (%f, %f)\n',X(1), Y(1), X(end), Y(end));
fclose(fileID);


