#!/bin/bash

[ $# -eq 1 ] || echo "rep missing!"
[ $# -eq 1 ] || exit
rep=$1

export OMP_NUM_THREADS=1
cpushift=-1  #CHANGE HERE, either -1 or 15 usually
numcores=32
cpusel=$(( $rep%$numcores + $cpushift ))

inputfile=../../inputs/input_md.${rep}.dat
if [ ! -f "$inputfile" ]
then
  echo "creating $inptufile"
  cd ../../inputs
  ./create_input.sh $rep > input_md.${rep}.dat
  cd -
fi

# Job Settings
jname=${PWD}-$rep
ncore=1
max_t=24:00 #h:min
outfile=log.plumed

#to run locally
host=$HOSTNAME

# Commands
mpi_cmd="plumed ves_md_linearexpansion $inputfile |grep PLUMED"
#extra_cmd="../analyze_single.sh"
extra_cmd="rm stats.out Kernels.data"

# Prepare Submission
bck.meup.sh -i $outfile
#bck.meup.sh -v $logfile |& tee -a $outfile
### if euler ###
if [ ${host:0:3} == "eu-" ]
then
  cmd="mpirun ${mpi_cmd}; ${extra_cmd}"
  submit="bsub -o $outfile -J $jname -n $ncore -W $max_t $cmd"
  echo -e " euler submission:\n$submit" |tee -a $outfile
### if workstation ###
else
  ncore=1
  #submit="time mpirun -np $ncore ${mpi_cmd}"
  submit="mpirun -np $ncore --cpu-set ${cpusel} ${mpi_cmd}"
  echo -e " workstation submission:\n$submit\n$extra_cmd" |tee -a $outfile
  eval "$submit &>> $outfile"
  submit="$extra_cmd" # &>> $outfile"
fi

# Actual Submission
$submit
#eval $submit
