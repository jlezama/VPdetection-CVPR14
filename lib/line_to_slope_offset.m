function [m, b] = line_to_slope_offset(l);
l = line_to_homogeneous(l);
m = -l(1)/l(2);
b = -l(3)/l(2);