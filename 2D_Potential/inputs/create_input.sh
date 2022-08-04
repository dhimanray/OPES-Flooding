#!/bin/bash

# Create a input_md.i.dat from template
# Needs a long unbiased run from which to take initial config

nstep=2000000000
idum=`shuf -i 10000-99999 -n 1`
#ipos=`shuf ../unbiased/COLVAR.A | grep -v "#" |awk 'END{print $2","$3}'`
#ipos=-1

cat template-input_md.dat | 
sed "s/__NSTEP__/$nstep/" | 
sed "s/__IDUM__/$idum/"   | 
sed "s/__IPOS__/$ipos/"
