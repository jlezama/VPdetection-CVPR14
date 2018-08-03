# lazy makefile
PROG=detect_vps
all:
	$(MAKE) -C mex_files/ all
	mcc -m ${PROG}.m -a mex_files/ -a mixtures/ -a lib/  -R -nodisplay



