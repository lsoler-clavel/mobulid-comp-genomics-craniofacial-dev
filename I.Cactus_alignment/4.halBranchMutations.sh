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
#$ -l h_rt=168:00:00
#$ -l h_vmem=30G
#$ -P roslin_macqueen_lab
#$ -e error.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

# load any modules
module load roslin/singularity/3.5.3

# Define the branch we're extracting mutations for as argument 1
# This should be the species name as in the SeqFile

BRANCH=$1

# Define REF_FILE (the insertion bed file in the branch species' coordinates) and PARENT_FILE (the duplications and
# deletions file in the ancestor's coordinates) as arguments 2 and 3 when submitting the job
# These should be in a form like refspecies_ins.bed parent_dup.bed 

REF_FILE=$2
PARENT_FILE=$3

singularity exec ./../cactus.sif halBranchMutations fivespp_output.hal ${BRANCH} --refFile ${REF_FILE} --parentFile ${PARENT_FILE} --maxNFraction 0
