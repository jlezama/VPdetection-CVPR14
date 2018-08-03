function all_bestpairs = run_mixtures(points, Ks, filename);
% Runs Figueiredo et al. GMM algorithm with different parameters (number of
% Gaussians). The endpoints of the ellipses found are saved as candidates
% for the alignment detector.
% Parameters:
% - points: list of 2D points
% - Ks: number of Gaussians to try (example: [20 40 60])
% - file_path: path where to save a text file with the obtained pairs of
% points

if nargin==1
    Ks = [20 40 60];
    filename = '../algos/candidate_pairs.txt';
end

points = unique(round(points),'rows');
y = points';
npoints = size(points,1);

all_bestpairs = [];

for k =1:length(Ks);
    K=Ks(k);
    [bestk,bestpp,bestmu,bestcov,dl,countf, bestpairs] = mixtures4(y,max(2,K-7),K,0,1e-4,0,npoints);
    all_bestpairs=[ all_bestpairs; bestpairs];
end


% %% plot results
% close all
% plot(points(:,1), points(:,2), 'k.')
% hold on
% for i=1:size(all_bestpairs,1)
% plot([all_bestpairs(i,1), all_bestpairs(i,3)],[all_bestpairs(i,2),all_bestpairs(i,4)],'g')
% end

%% reacommodate points

all_bestpairs = [all_bestpairs(:,[1 2]); all_bestpairs(:,[3 4])];


%% write results
if ~isequal(filename,'')
dlmwrite(filename, all_bestpairs, 'delimiter', ' ');
end