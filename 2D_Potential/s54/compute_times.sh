#!/bin/bash
export LC_NUMERIC="en_US.UTF-8"

#first manually create empty directories named with progressive numbers
#this will launch an indipendent replica of the system in each of the directories
barrier=10
num_sim=50
rm times*

directories="`ls -d [0-9]` `ls -d [0-9][0-9]`"
totrep=`echo $directories |wc -w`
echo " found $totrep directories"

for i in $directories
do
  cd $i
  echo "time calculation --- rep $i:"
  tail -n +2 COLVAR | awk '{a=a+exp(($5+bar)/1.0);b=exp(($5+bar)/1.0);c=c+0.5*b;{print $1,$2,c/10.0^0,($1/10.0^0)*(a/(NR+1))}}' bar=$barrier > time 
  tempo=`tail -n 1 time | awk '{print $3}'`
  printf "%e\n" $tempo >> ../times.dat
  tempo2=`tail -n 1 time | awk '{print $4}'`
  printf "%e\n" $tempo2 >> ../times2.dat
  temposim=`tail -n 1 time | awk '{print $1}'`
  printf "%e\n" $temposim >> ../times_sim.dat
  cd ..
done

rm running* mean*
awk '{for(i=1;i<=NR;i++) {sum += $i; sumsq += ($i)^2}};{printf "%e %e \n", sum/NR, sqrt((sumsq-sum^2/NR)/NR)}' times.dat >> running_mean-std_times.dat
awk '{for(i=1;i<=NR;i++) {sum += $i; sumsq += ($i)^2}};{printf "%e %e \n", sum/NR, sqrt((sumsq-sum^2/NR)/NR)}' times2.dat >> running_mean-std_times2.dat
awk '{for(i=1;i<=NR;i++) {sum += $i; sumsq += ($i)^2}};{printf "%e \n", sum/NR}' times_sim.dat >> running_mean-std_times_sim.dat
tail -n 1 running_mean-std_times.dat >> mean-std_times.dat
tail -n 1 running_mean-std_times2.dat >> mean-std_times.dat
tail -n 1 running_mean-std_times_sim.dat >> mean-std_times.dat
rm running*

cat mean-std_times.dat
export PATH="/home/vrizzi@iit.local/programs/miniconda3/bin:$PATH"
python3 KStest.py
