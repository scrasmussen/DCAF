# lc=nvfortran
# lc=mpif90
# lc=gfortran
lc=caf
file=multigputest.f90
file=multigputest_acc.f90

# nvfortran + OpenACC
lflags=-g -O3 -acc -Minfo=accel
# gfortran
lflags=-g -O3 -foffload=-m64 -fdump-fortran-optimized # -fdump-tree-optimized
lflags=-g -O3 -cpp -foffload=-m64 -fdump-fortran-optimized
lflags=-g -O3 -cpp -foffload=-m64
# lflags=-g -O3 -cpp -fdump-fortran-optimized

# dflags+=-DDCAF_CUDA
#-------------------------
name=DCAF_ACC
dflags+=-DDCAF_ACC -fopenacc

# name=DCAF_OMP
# dflags+=-DDCAF_OMP -fopenmp

# name=DCAF_DC
# dflags+=-DDCAF_DC  -fopenacc

# name=DCAF_DO
# dflags+=-DDCAF_DO
#------------------------
lflags+=${dflags}
all: build

build:
	$(lc) $(lflags) $(file) -o runMe_${name}.exe

r: run
run:
	# start=$(data)
	time mpirun -n 2 ./runMe.exe
	# end=$(date)
	# echo "${start} ${end}"

clean:
	rm -rf *~ *.exe *.o *.opt *.cg test_gpu.o* omp_gpu.n001.gpu *.cub *.ptx
