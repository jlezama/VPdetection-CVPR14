% ALIGNMENTS_SLOW Point alignment detection, full version
% detections = ALIGNMENTS_SLOW(input_points, xsize, ysize, epsilon, min_width, locality, min_k, length_ratio);
% author: jose lezama/rafael grompone von gioi
% version: 8.1 (2014.08.12)
% year: 2014
% desc: MatLab interface for aligned point detector v8 (with candidate points)
% input:
% -req: input_points | Input points (Nx2 matrix).
% -opt: min_k | 5 | Minimum number of points in alignment. 
% -opt: xsize | 512 | X axis domain size.
% -opt: ysize | 512 | Y axis domain size.
% -opt: epsilon | 10 | Detection threshold, (max. NFA).
% -opt: min_width | 1 | Minimal alignment width tested.
% -opt: locality | 10 | Size factor of locality.
% -opt: length_ratio | 25 |  Min ratio b/w length and width.
% output:
% -req: detections | 6xNout alignments matrix with: x1, x2, y1, y2, width, nfa