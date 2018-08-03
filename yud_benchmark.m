% Benchmark VP detection on York Urban Dataset
%
% This program is written by Jose Lezama <jlezama@gmail.com> and
% distributed under the terms of the GPLv3 license.
%
% York Urban Dataset (YUD) by Patrick Denis
% http://www.elderlab.yorku.ca/YorkUrbanDB/
%
% Reported performance should be close to  96.13% for the training set
% (first 25 images) and 95.48% for the test set


clear
close all

addpath lib

% point the following path to your local copy of YUD
DATASET_PATH = '/home/lezama/datasets/20130613_YorkUrbanDB/all/';

load(sprintf('%s/Manhattan_Image_DB_Names.mat', DATASET_PATH));
load(sprintf('%s/cameraParameters.mat', DATASET_PATH));

all_errors = zeros(size(Manhattan_Image_DB_Names));

PLOT = 0;


params.REFINE_THRESHOLD = 2;
params.VARIATION_THRESHOLD = 0.1;
params.ppd = [2.08095361329015 1.90889599050553]; % principal point = [W H]./params.ppd; values taken from YUD

focal_ratio = 1.08;% 1.05455933619402; % to be multiplied by length of image's largest side

for f = 1:length(Manhattan_Image_DB_Names);
    
    % load image
    filename = Manhattan_Image_DB_Names{f}(1:end-1);
    img_filename = sprintf('%s/%s/%s.jpg', DATASET_PATH, filename, filename);
    img = imread(img_filename);
    [H, W, ~] = size(img);
    if PLOT
        figure, imagesc(img)
    end
    
    manhattan = 1;
    acceleration = 0;
    
    
    % compute  horizon line detection
    params.filenumber = f;
    params.dataset = 'yud';
    horizon_line_ours = detect_vps(img_filename, '/tmp', manhattan, acceleration, focal_ratio,params);
    
    % load ground truth
    load(sprintf('%s/%s/%sGroundTruthVP_CamParams.mat', DATASET_PATH, filename,filename))
    
    % compute ground truth horizon line
    vpimg = [W*focal_ratio*vp(1,:)./vp(3,:)+pp(1); W*focal_ratio*vp(2,:)./vp(3,:) + (H-pp(2))];
    horizon_line =[vpimg(1,1) H-vpimg(2,1) vpimg(1,3) H-vpimg(2,3)];
    
    hl = horizon_line;
    
    if PLOT
        hold on
        plot([hl(1) hl(3)], [hl(2) hl(4)], 'LineWidth',3)
    end
    
    % compute horizon line estimation error
    X = [1 W];
    P_gt = polyfit([vpimg(1,3) vpimg(1,1)],H-[vpimg(2,3) vpimg(2,1)],1);
    Y_gt = polyval(P_gt,X);
    Y_ours = [horizon_line_ours(1) horizon_line_ours(W)];
    err = max(abs(Y_gt-Y_ours))/H;
    
    all_errors(f) = err;
    
    fprintf('----------------------------------------\n')
    fprintf('File %i, error: %f\n', f, err);
    fprintf('----------------------------------------\n')
end


% compute AUC score for training and testing set
auc_train = calc_auc(all_errors(1:25));
auc_test = calc_auc(all_errors(26:end));

fprintf('AUCtrain: %2.4f. AUCtest:%2.4f\n', auc_train, auc_test);

