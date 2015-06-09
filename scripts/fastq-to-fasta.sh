#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M ejm335@drexel.edu
#$ -P nsftuesPrj
#$ -pe shm 32
#$ -l h_rt=48:00:00
#$ -q all.q@@amdhosts

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa

## Define IDBA directory
IDBAPATH=/home/ejm335/Packages/IDBA/bin

## Define Data Files
datafiles=(1_S1_L001_R1_001  1_S1_L001_R2_001  2_S2_L001_R1_001  2_S2_L001_R2_001  3_S3_L001_R1_001  3_S3_L001_R2_001)

## Define Paths
TEMPPATH=${TMP}/fasta
DATAPATH=/home/ejm335/ProjectData/Fastq
OUTPUTPATH=/home/ejm335/ProjectData/Fasta-Fixed
mkdir -p $TEMPPATH
mkdir -p $OUTPUTPATH

$IDBAPATH/fq2fa --merge --filter $DATAPATH/1_S1_L001_R1_001.fastq $DATAPATH/1_S1_L001_R2_001.fastq $TEMPPATH/1_S1_L001.fasta
$IDBAPATH/fq2fa --merge --filter $DATAPATH/2_S2_L001_R1_001.fastq $DATAPATH/2_S2_L001_R2_001.fastq $TEMPPATH/2_S2_L001.fasta
$IDBAPATH/fq2fa --merge --filter $DATAPATH/3_S3_L001_R1_001.fastq $DATAPATH/3_S3_L001_R2_001.fastq $TEMPPATH/3_S3_L001.fasta

mv ${TEMPPATH}/* ${OUTPUTPATH}/
