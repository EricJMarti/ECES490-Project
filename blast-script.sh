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
module load ncbi-blast/gcc/64/2.2.29

## Define Paths
TEMPOUTPUT=${TMP}/blast
TEMPDATA=${TMP}/data
DATAPATH=/home/ejm335/BLAST/all-bacteria.ffn
BINPATH=/home/ejm335/ProjectData/MaxBinData
OUTPUTPATH=/home/ejm335/ProjectData/BLASTOutput
mkdir -p $TEMPDATA
mkdir -p $TEMPOUTPUT
mkdir -p $OUTPUTPATH

# Make BLAST DB
#makeblastdb -in $DATAPATH -dbtype nucl -out BactDB -parse_seqids

# Blast
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.001.fasta -out cyanobacteria.001.fasta.blast -num_threads 96
#blastn -db ./BactDB -m 0 -max_target_seqs 3 -query $BINPATH/cyanobacteria.006.fasta -out cyanobacteria.006.fasta.blast -num_threads 96

# Parse

#echo $ '\n\n# parse for hits with >1000 Bit-score'
#awk '$12 > 1000 { print $0 }' cyanobacteria.006.fasta.blast

# parse for best hits for each query
#sort -u -k1,1 cyanobacteria.006.fasta.blast >  cyanobacteria.006.fasta.blast.besthit

## count the hits by species
#awk '{print $2}' cyanobacteria.006.fasta.blast | awk -F "_" '{print $2}' | sort | uniq -c

# count the hits by gene names
#awk '{print $2}' cyanobacteria.006.fasta.blast | awk -F "|" '{print $5}' | awk -F "_" '{print $1}' | sort | uniq -c

