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
#$ -pe sharedmem 16
#$ -l h_rt=336:00:00
#$ -l h_vmem=50G
#$ -P roslin_macqueen_lab
#$ -e error.txt
#$ -o output.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

# load any modules
module load roslin/singularity/3.5.3

# run RepeatMasker
singularity exec dfam-tetools-latest.sif RepeatMasker -lib hypostoma-families.fa sMobHyp1.curated_primary.mt.scrubbed.fa
