% Benchmark VP detection on Eurasian Cities Dataset
%
% This program is written by Jose Lezama <jlezama@gmail.com> and
% distributed under the terms of the GPLv3 license.
%
% Eurasian Cities Dataset (ECD) by Olga Barinova
% http://graphics.cs.msu.ru/en/research/projects/msr/geometry
%
% Reported performance should be close to  88.95% for the training set
% (first 25 images) and 90.11% for the test set

clear
close all
addpath lib
tic

% point the following path to your local copy of ECD
DATASET_PATH = '~/datasets/20130829_EurasianCitiesBase';

dirlist = dir(sprintf('%s/*.jpg',DATASET_PATH));


params.REFINE_THRESHOLD =  .6;
params.VARIATION_THRESHOLD = .3;
params.DIST_THRESHOLD = .14;
params.INFINITY_THRESHOLD = 3.6;

focal_ratio = 1.08;

PLOT = 0;

for f = 1:length(dirlist)
    
    
    % load image and ground truth
    img_filename = sprintf('%s/%s',DATASET_PATH, dirlist(f).name);
    mat_filename = sprintf('%s/%shor.mat',DATASET_PATH, dirlist(f).name(1:end-4));
    
    
    img = imread(img_filename);
    [H, W, ~] = size(img);
    
    
    
    if PLOT
        figure, imagesc(img)
    end
    
    manhattan = 0;
    acceleration = 0;
    
    % compute  horizon line detection
    horizon_line_ours = detect_vps(img_filename, '.', manhattan, acceleration, focal_ratio, params);
    
    
    % load ground truth
    load(mat_filename)
    
    % compute horizon line estimation error
    X = [1 W];
    P_gt = [-horizon(1)/horizon(2) -horizon(3)/horizon(2)];
    Y_gt = polyval(P_gt,X);
    Y_ours = [horizon_line_ours(1) horizon_line_ours(W)];
    err = max(abs(Y_gt-Y_ours))/H;
    
    if PLOT
        hold on
        plot(X, Y_gt);
    end
    
    fprintf('----------------------------------------\n')
    fprintf('File %i, error: %f\n', f, err);
    fprintf('----------------------------------------\n')
    
    all_errors(f) = err;
end


% compute AUC score for training  and testing set
auc_train = calc_auc(all_errors(1:25)');
auc_test = calc_auc(all_errors(26:end)');

fprintf('AUCtrain: %2.4f. AUCtest:%2.4f\n', auc_train, auc_test);
