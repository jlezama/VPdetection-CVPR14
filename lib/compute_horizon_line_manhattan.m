
function [Y, vpoimg] = compute_horizon_line_manhattan(mvp_all, NFAs, lines_lsd, params);
% computes horizontal line from vps and using the NFA values to apply
% orthogonality constraints. saves data to output image and output text
% file
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

H = params.H;
W = params.W;

%% York Urban parameters (given)
% focal = 6.05317058975369;
% pixelSize = 0.00896875;
% pp = [307.551305282635, 251.454244960136];

pp = [W H]./params.ppd;
FOCAL_RATIO = params.FOCAL_RATIO; % in YUD = 1.05455933619402


my_vps = image_to_gaussian_sphere(mvp_all, W, H, FOCAL_RATIO, pp);

my_vps(isnan(my_vps)) = 1;

%% impose orthogonality
my_orthogonal_vps = orthogonal_triplet(my_vps, NFAs, ...
    params.ORTHOGONALITY_THRESHOLD);

if size(my_orthogonal_vps,2) == 1
    my_orthogonal_vps = repmat(my_orthogonal_vps,[1 3]);
end

if size(my_orthogonal_vps,2) == 2
    
    fprintf('obtained only 2 VP... estimating the third one...\n')
    estimated_vp = cross(my_orthogonal_vps(:,2),my_orthogonal_vps(:,1));
    estimated_vp = -estimated_vp/norm(estimated_vp);
    
    %% add to current list of vps
    my_orthogonal_vps = [my_orthogonal_vps estimated_vp];
end

vpoimg = gaussian_sphere_to_image(my_orthogonal_vps, W, H, FOCAL_RATIO, pp);

% which one is the vertical vanishing point?
% calculate angle with image
vpoimg_centered = vpoimg - [W/2 W/2 W/2; H/2 H/2 H/2];

cosangles = abs(vpoimg_centered(1,:))./sqrt(sum(vpoimg_centered.^2));

[~, I_vert] = min(cosangles);

I_hor = setdiff([1:3], I_vert);

vpoimg = vpoimg(:, [I_hor(1) I_vert I_hor(2)]);

%% get horizon line
P_ours = polyfit([vpoimg(1,1) vpoimg(1,3)], [vpoimg(2,1) vpoimg(2,3)],1);

X = [1:W];
Y = polyval(P_ours,X);


% draw segments with colors
if params.PRINT
    imgo = imread(params.img_in);
    img = draw_segments(imgo,vpoimg, lines_lsd, params);
    
    % draw horizon line
    linewidth = 4;
    
    for i=1:length(X);
        if mod(i,20)>=10
            col = [255 128 0];
        else
            col = [128 0 255];
        end
        
        for j=-round(linewidth/2):round(linewidth/2)
            try % sometimes falls outside image
                img(round(Y(i)+j),round(X(i)),:)=col;
            end
        end
    end
    
    if ~isdeployed && params.PLOT
        
        figure, imagesc(img);
    end
    
    % write output
    imwrite(img,sprintf('%s/horizon_line.png',params.folder_out));
    
    % save image for each VP
    for i=1:size(vpoimg,2);
        img = draw_segments(imgo,vpoimg(:,i), lines_lsd, params, 1);
        imwrite(img,sprintf('%s/final_vp_%i.png',params.folder_out,i));
    end
    
end

fileID = fopen(sprintf('%s/out.txt',params.folder_out),'w');
fprintf(fileID,'horizontal vps:\n');
fprintf(fileID,'(%f, %f)\n',vpoimg(1,1), vpoimg(2,1));
fprintf(fileID,'(%f, %f)\n',vpoimg(1,3), vpoimg(2,3));
fprintf(fileID,'vertical vp:\n');
fprintf(fileID,'(%f, %f)\n',vpoimg(1,2), vpoimg(2,2));
fprintf(fileID,'horizon line:\n');
fprintf(fileID,'(%f, %f), (%f, %f)\n',X(1), Y(1), X(end), Y(end));
fclose(fileID);
end


