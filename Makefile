
# Makefile for Elmer
# ----------------------------------------
# Use external Geometry to create mesh
# Calculate Depth and Height for Paraview

EXECUTABLES = src/AgeSolverRD src/MyFlowdepth

##Apparantly requires odd numbers, otherwise peculiar jumps in velocity
##at partition boundaries.
NumProcs=8
NumProcx=8
NumProcy=1


InputSif=channel2d.sif
InputSifIni=channel2dIni.sif

#Not used for no
meshresolution = 7500.0



.SUFFIXES: .f90

all: clean ini grid submit

grid:
ifeq ($(NumProcs),1)
	ElmerGrid 1 2 channel2d  -autoclean
else
	
	ElmerGrid 1 2 channel2d  -autoclean
	ElmerGrid 2 2 channel2d  -partition $(NumProcx) $(NumProcy) 0 2
	## The 0 2 is needed because otherwhise StructuredMeshMapper
	## tangles the grid in 2D. See Post from Rupert in Forum 2013.
	#ElmerGrid 2 2 channel2d  -metis $(NumProcs)  -partition $(NumProcx) $(NumProcy) 1
endif


submit: ini
	echo $(InputSifIni) > ELMERSOLVER_STARTINFO
	mpirun -n $(NumProcs) ElmerSolver_mpi
	echo $(InputSif) > ELMERSOLVER_STARTINFO
	mpirun -n $(NumProcs) ElmerSolver_mpi

compile:  $(EXECUTABLES)

clean:
	rm -f channel2d/*vtu
	rm -fr channel2d/parti*
	rm -fr channel2d/*result*
	rm -fr channel2d/*mesh*

ini:
	echo $(InputSif) > ELMERSOLVER_STARTINFO

.f90:
	elmerf90  -o $@ $<
.c:
	gcc  -o $@ $< -lm
