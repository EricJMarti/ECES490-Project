#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M ejm335@drexel.edu
#$ -P nsftuesPrj
#$ -pe openmpi_ib 96
#$ -l h_rt=48:00:00
#$ -q all.q@@amdhosts

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1

## Define Paths
DATAPATH=/home/ejm335/ProjectData/IDBAOutput
READSPATH=/home/ejm335/ProjectData/Fasta-Fixed
MAXBINPATH=/home/ejm335/Packages/MaxBin

## Define Files
reads=(1_S1_L001.fasta  2_S2_L001.fasta  3_S3_L001.fasta)

## Run MaxBin
$MAXBINPATH/run_MaxBin.pl -thread 96 -contig $DATAPATH/scaffold.fa -out cyanobacteria -reads $READSPATH/${reads[0]} -reads2 $READSPATH/${reads[1]} -reads3 $READSPATH/${reads[2]}
