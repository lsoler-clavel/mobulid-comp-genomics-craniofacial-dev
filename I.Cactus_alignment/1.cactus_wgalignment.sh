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
#$ -l h_rt=504:00:00
#$ -l h_vmem=60G
#$ -P roslin_macqueen_lab
#$ -e error.txt
#$ -o output.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh
# load any modules
module load roslin/singularity/3.5.3

# Make workdir

#query
# Run cactus
# output Hal is created at this step, we're naming it
singularity exec cactus.sif cactus ./rays/js ./seqFile_updt.txt 
./fivespp_output.hal --workDir ./workdir_cactus --maxCores 16 --maxMemory 768G 
--consCores 2 --consMemory 100Gi

# Convert to MAF
## singularity exec cactus.sif cactus-hal2maf ./pairwise/js ./pairwise/manta_hypanus_output.hal ./pairwise/manta_hypanusMAF-output.maf.gz --refGenome ./GCF_030144855.1 --chunkSize 1000000 --noAncestors --batchCount 4 
#	--batchCores 32 --batchParallelTaf 8 --batchSystem mesos --defaultPreemptable --nodeStorage 2000 --maxNodes 4