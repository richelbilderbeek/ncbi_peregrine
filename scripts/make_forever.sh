#!/bin/bash
# Bash script to call make with sbatch
#
# Usage:
#
#   sbatch make_forever.sh
#
#   sbatch make_forever.sh
#
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --job-name=make
#SBATCH --output=make_%j.log
module load R
while (true)
do 
  echo "make $@"
  echo $(date)
  make "$@"
  sleep 60
done

