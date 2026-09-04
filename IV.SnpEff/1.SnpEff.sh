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
#$ -l h_vmem=40G
#$ -P roslin_macqueen_lab
#$ -e error.txt
#$ -o output.txt
#$ -M s2457124@ed.ac.uk
#$ -m beas

# Initialise the environment modules
. /etc/profile.d/modules.sh

# load any modules
module load roslin/openjdk/11.0.2

# Define REF (reference genome) and BED (the BED file to annotate) variables
REF=sHypSab1.hap1
BED="mh_dels_conserved_stingray_manta_mapped.bed"
OUTPUT="mh_dels_conserved_manta_stingray"

# Annotate chromosome rearrangements/recombination BED files using SnpEff

java -Xmx8g -jar snpEff.jar -c snpEff.config -v -nodownload -i bed sHypSab1.hap1 ${BED} > "${OUTPUT}_annotated.bed"
