#!/bin/bash

echo -e "nSpheres\tTimeTaken" > performance.dat
for s in 1 2 3 4 5 10 15 20 50 100
do
  echo -ne "$s\t" >> performance.dat
  ./raytrace.out $s >> performance.dat
done
