#!/bin/bash
#
# =============================================================================
# Setup Instructions
# =============================================================================
#
# Grid Engine options (lines prefixed with #$)
#  job name: -N
#  use the current working directory: -cwd
#  number of cores -pe sharedmem
#  runtime limit: -l h_rt
#  memory limit: -l h_vmem
#$ -cwd
#$ -pe sharedmem 8
#$ -l h_rt=12:00:00
#$ -l h_vmem=30G
#$ -P roslin_macqueen_lab
#$ -e error2.txt
#$ -o output.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

split -n l/600 -a 3  anc3_dels_plusone.bed split_anc3_dels/anc3_subset_dels_plusone
