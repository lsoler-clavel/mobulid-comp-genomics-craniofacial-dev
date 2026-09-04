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
#$ -l h_rt=12:00:00
#$ -l h_vmem=30G
#$ -P roslin_macqueen_lab
#$ -e error.txt
#$ -o output.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

# load any modules
module load roslin/singularity/3.5.3

# Define query genome and target genome variables (these should be entered as genome
# names found in the SeqFile
QUERY=$1
TARGET=$2
OUTPUT=$3

# halSynteny
singularity exec ./../cactus.sif halSynteny --queryGenome ${QUERY} --targetGenome ${TARGET} --maxAnchorDistance 1000000 --minBlockSize 200000 fivespp_output.hal ${OUTPUT}
