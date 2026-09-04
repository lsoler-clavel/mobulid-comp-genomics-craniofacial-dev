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
#$ -o hypostomamodeler.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

# load any modules
module load roslin/singularity/3.5.3

if [ ! -e ${PWD}/.singularity ]; then mkdir ${PWD}/.singularity; fi
export SINGULARITY_TMPDIR=$PWD/.singularity
export SINGULARITY_CACHEDIR=$PWD/.singularity

singularity build dfam-tetools-latest.sif docker://dfam/tetools:latest

# Make database
singularity exec dfam-tetools-latest.sif BuildDatabase -name hypostoma sMobHyp1.curated_primary.mt.scrubbed.fa

# Run RepeatModeler
singularity exec dfam-tetools-latest.sif nohup RepeatModeler -database hypostoma
