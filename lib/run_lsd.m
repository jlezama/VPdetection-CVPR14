function lines = run_lsd(img_in);
% Run LSD detector on image
if ~isdeployed
    addpath mex_files/
end

% write image as pgm
img = imread(img_in);

if size(img,3)==3;
    img = rgb2gray(img);
end

lines = lsd(double(img'))'; % uses LSD mex wrapper
lines = lines(:,[1:4]);
