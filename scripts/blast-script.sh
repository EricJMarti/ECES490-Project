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
DATAPATH=/home/ejm335/BLAST/all-bacteria.ffn
BINPATH=/home/ejm335/ProjectData/MaxBinData

# Make BLAST DB
makeblastdb -in $DATAPATH -dbtype nucl -out ./BactDB/BactDB -parse_seqids

# Blast away
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.001.fasta -out cyanobacteria.001.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.002.fasta -out cyanobacteria.002.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.003.fasta -out cyanobacteria.003.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.004.fasta -out cyanobacteria.004.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.005.fasta -out cyanobacteria.005.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.006.fasta -out cyanobacteria.006.fasta.blast -num_threads 96
