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
#$ -pe sharedmem 1
#$ -l rl9
#$ -l h_rt=336:00:00
#$ -l h_vmem=30G
#$ -P roslin_macqueen_lab
#$ -M s2457124@ed.ac.uk
#$ -m beas
#$ -t 1-600
#$ -tc 16

# Initialise the environment modules
. /etc/profile.d/modules.sh

# cd to split Anc3 dels directory
cd split_anc3_dels/

#Define variables
INPUT=$(ls anc3_subset_dels_plusonea* | awk "NR == $SGE_TASK_ID")
PREFI="$(basename $INPUT)"

echo "$INPUT"
echo "$PREFI"

# extract the deletions from each maf file into respective directories
while read -r a b c;
do /exports/cmvm/eddie/eb/groups/macqueen_lab/manu/mkg/softwares/mafTools/bin/mafExtractor \
-m ./../fivespp_output_anc2ref.maf -s Anc2."$a" --start $b \
--stop $c > ./../anc3_dels_plusone_extractions/anc3_del_"$a"_"$b"_"$c".maf; done <${PREFI}
