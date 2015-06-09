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

## Define Paths
TEMPOUTPUT=${TMP}/idba_out
TEMPDATA=${TMP}/data
DATAPATH=/home/ejm335/ProjectData/Fasta-Fixed
OUTPUTPATH=/home/ejm335/ProjectData/IDBAOutput
IDBAPATH=/home/ejm335/Packages/IDBA/bin
mkdir -p $TEMPDATA
mkdir -p $TEMPOUTPUT
mkdir -p $OUTPUTPATH

# Copy data to scratch
cp $DATAPATH/*.fasta $TEMPDATA

# Run IDBA_UD (De Novo Assembly)
$IDBAPATH/idba_ud --num_threads 96 -r $TEMPDATA/*.fasta -o $TEMPOUTPUT

# Move data from scratch
mv $TEMPOUTPUT/* $OUTPUTPATH/
