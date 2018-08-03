Vanishing Points detection 
==========================
version 0.9 - June 2017
by Jose Lezama <jlezama@gmail.com>


Introduction
------------

This code implements the vanishing point detection algorithm as described in the IPOL article
 "Vanishing Point Detection in Urban Scenes Using Point Alignments" Jose Lezama, Gregory Randall, Jean-Michel Morel and Rafael Grompone von Gioi. 

Optionally, this code uses the algorithm by Figueiredo and Jain, Unsupervised 
learning of finite mixture models, to quickly obtain cluster candidates.

Files and Folders
-----------------

README.txt             - This file
COPYING                - GNU AFFERO GENERAL PUBLIC LICENSE Version 3
Makefile               - Compilation instructions for 'make'
main.m		       - demo script
detect_vps.m	       - main algorithm script
yud_benchmark.m	       - script to run benchmark scores in York Urban Database
ecd_benchmark.m	       - script to run benchmark scores in Eurasian Citites Database
test.jpg	       - test image
lib/		       - folder with auxiliary MATLAB scripts
mex_files/	       - folder with C sources for line segment and point alignment detection, to be compiled as mex files
mixtures/	       - folder with the unsupervised mixtures detection code of Figueiredo and Jain, which can optionally be used for accelerating the method


Compiling
---------

The algorithm depends on three mex scripts that need to be compiled before
execution. For compilation inside MATLAB, cd into the 'mex_files' folder and run
build.m

Optional: run make to produce compiled matlab executables

Running
-------

For a test run on the test image, run main.m
main.m calls the main function, detect_vps.m
Arguments of detect_vps.m are:
 - img_in: filename of the input image
 - folder_out: path to save resulting image and text files
 - manhattan: boolean variable used to determine if the Manhattan-world
   hypothesis is assumed
 - acceleration: boolean variable used to determine if acceleration using
   Figueiredo and Jain GMM algorithm should be used
 - focal_ratio: ratio between the focal lenght and captor width
 - input_params: optional input parameters


Benchmarks
----------

To run benchmarks on York Urban Dataset (YUD) and Eurasian Cities Dataset (ECD)
run yud_benchmark.m and ecd_benchmark.m. You should obtain results similar or
better to the ones reported in our CVPR paper.

Note that without the acceleration the scripts can be slow. In particular for
ECD the non-accelerated version can take up to 3 minutes per image (there are
103 images in that dataset).

The datasets are not provided but can be obtained from the following sites:

YUD, by P. Denis: http://www.elderlab.yorku.ca/YorkUrbanDB/
ECD, by O. Barinova: http://graphics.cs.msu.ru/en/research/projects/msr/geometry


Acceleration
------------

As an optional procedure, an accelerated version of the algorithm can be run by
setting the appropiate flag (see detect_vps.m). This version uses Figueiredo's
"Unsupervised Learning of Finite Mixture Models" algorithm to quickly obtain
cluster candidates.  

The scripts files, available at the author's website (http://www.lx.it.pt/~mtf/)
are included, and have been slightly modified for speed improvement.


Copyright and License
---------------------

Copyright (c) 2013-2015 Jose Lezama <jlezama@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.


Thanks
------

We would be grateful to receive any comment, especially about errors,
bugs, or strange results.
