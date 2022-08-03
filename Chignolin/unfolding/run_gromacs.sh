#!/bin/bash


gmx_mpi grompp -f md.mdp -c prd.gro -p topol_01.top -o prd.tpr

export OMP_NUM_THREADS=1

mpiexec -n 1 gmx_mpi mdrun -deffnm prd -plumed plumed_rate.dat -pin on -pinoffset 0
