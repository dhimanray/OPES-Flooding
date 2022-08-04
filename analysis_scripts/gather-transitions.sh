#!/bin/bash

rm transitions.dat

touch transitions.dat

for i in {1..20}
do
	tail -n 1 run$i/time >> transitions.dat	
done	
