# ECES 490 Final Project
### Analysis of Dr. Bruns Pennsylvania Soil Samples

Given three metagenomic samples from an enrichment culture isolated from local Pennsylvania soil, identify at least two strains of cyanobacteria.

All three samples came from a replicate enrichment culture, meaning there should not be any significant differences between samples. The original sample came from "photosynthetic crust" from the surface of soil in a greenhouse.

![cyanobacteria%20biofilm%20Bruns.PNG](http://news.psu.edu/sites/default/files/styles/threshold-992/public/cyanobacteria%20biofilm%20Bruns.PNG "cyanobacteria biofilm Bruns.PNG")

Source: http://news.psu.edu/story/347590/2015/03/06/research/cyanobacteria-could-help-manage-nitrogen-benefit-chesapeake-bay

Dr. Bruns believes that there are two closely related cyanobacteria in the samples from the Nostocaceae family. She says that there may be other bacteria in the samples. She specifically identified Bosea, which is an alpha proteobacteria in the Rhizobiales family. She also said that there may be "one or more gamma proteobacteria like Stenotrophomonas and Pseudomonas."

Xin, my graduate student has tried to purify this mixture into single strains, but it has not been possible. We therefore suspect other bacteria in this mixture, based on the 16S rRNA results. One is Bosea, a member of the alpha proteobacteria in the Rhizobiales family. This member might be able to fix N2 but it is likely to be “feeding off” the organic carbon fixed by the photosynthetic members of the consortium. There may be one or more gamma proteobacteria like Stenotrophomonas and Pseudomonas.

### Workflow:

##### IDBA-UD
First, I used IDBA-UD to assemble the reads de novo. IDBA-UD requires paired-end reads stored in a Fasta file, so we need to merge our six Fastq files into three Fasta files.

```bash
$IDBAPATH/fq2fa --merge --filter $DATAPATH/1_S1_L001_R1_001.fastq $DATAPATH/1_S1_L001_R2_001.fastq $TEMPPATH/1_S1_L001.fasta
$IDBAPATH/fq2fa --merge --filter $DATAPATH/2_S2_L001_R1_001.fastq $DATAPATH/2_S2_L001_R2_001.fastq $TEMPPATH/2_S2_L001.fasta
$IDBAPATH/fq2fa --merge --filter $DATAPATH/3_S3_L001_R1_001.fastq $DATAPATH/3_S3_L001_R2_001.fastq $TEMPPATH/3_S3_L001.fasta
```

We now have to check for the maximum length of the reads. This is important because the -l IDBA flag did not work for this data, so we need to recompile the code and specify a new value for the kMaxShortSequence constant.

```bash
wc -L *.fasta
```

We get a count of 301 bases for each Fasta file. This means the kMaxShortSequence constant should be changed to 301 or higher. Then IDBA must be recompiled. We can now use IDBA-UD.

```bash
$IDBAPATH/idba_ud --num_threads 96 -r $TEMPDATA/*.fasta -o $TEMPOUTPUT
```

##### MaxBin

I then used MaxBin2 to bin the contigs into individual microbial species. MaxBin is a package that automates the binning process by running through a script that uses FragGeneScan, HMMer3, Bowtie2, and Velvet. The package utilizes the Expectation-Maximization algorithm, which uses nucleotide compostition as well as the contig abundance to bin metagenomic contigs. By default, MaxBin will look for the 107 marker genes found in over 95% of bacteria, but it also has an option to search for the 40 marker gene sets common to bacteria and archaea.

For more information about MaxBin, click [here](http://downloads.jbei.org/data/microbial_communities/MaxBin/MaxBin.html).

```bash
## Define Files
reads=(1_S1_L001.fasta  2_S2_L001.fasta  3_S3_L001.fasta)

## Run MaxBin
$MAXBINPATH/run_MaxBin.pl -thread 96 -contig $DATAPATH/scaffold.fa -out cyanobacteria -plotmarker -reads $READSPATH/${reads[0]} -reads2 $READSPATH/${reads[1]} -reads3 $READSPATH/${reads[2]}
```

MaxBin returned the files below. We have six bins, meaning there are six unique species across all of the samples.

```
cyanobacteria.001.fasta
cyanobacteria.002.fasta
cyanobacteria.003.fasta
cyanobacteria.004.fasta
cyanobacteria.005.fasta
cyanobacteria.006.fasta
cyanobacteria.abund1
cyanobacteria.abund2
cyanobacteria.abund3
cyanobacteria.abundance
cyanobacteria.log
cyanobacteria.marker
cyanobacteria.marker.pdf
cyanobacteria.noclass
cyanobacteria.summary
cyanobacteria.tooshort
```

This is the output graph from the -plotmarker flag:

![cyanobacteria.marker.pdf](https://github.com/EricJMarti/ECES490-Project/blob/master/cyanobacteria.marker.jpg?raw=true "cyanobacteria.marker.pdf")

The following is a table of abundance data returned by MaxBin:

| Bin name        | 1_S1_L001.fasta | 2_S2_L001.fasta | 3_S3_L001.fasta |
|-----------------|-----------------|-----------------|-----------------|
| cyano.001.fasta | 286.02          | 344.80          | 328.68          |
| cyano.002.fasta | 197.98          | 238.68          | 227.34          |
| cyano.003.fasta | 19.37           | 29.39           | 26.90           |
| cyano.004.fasta | 3.73            | 5.10            | 4.58            |
| cyano.005.fasta | 3.61            | 3.77            | 3.06            |
| cyano.006.fasta | 2.21            | 1.56            | 1.15            |

##### BLAST

I used Blast on each of the bins in preparation for importing the reads into MEGAN. First, I downloaded the complete Bacteria genome from NCBI and merged them into one Fasta file. I then ran makeblastdb followed by blastn. Note the -outfmt flag. MEGAN is extremely picky with the format of Blast files and only supports -outfmt 0 and -outfmt 7.

```bash
# Make BLAST DB
makeblastdb -in $DATAPATH -dbtype nucl -out ./BactDB/BactDB -parse_seqids

# Blast away
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.001.fasta -out cyanobacteria.001.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.002.fasta -out cyanobacteria.002.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.003.fasta -out cyanobacteria.003.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.004.fasta -out cyanobacteria.004.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.005.fasta -out cyanobacteria.005.fasta.blast -num_threads 96
blastn -db ./BactDB/BactDB -outfmt 0 -query $BINPATH/cyanobacteria.006.fasta -out cyanobacteria.006.fasta.blast -num_threads 96
```

##### MEGAN

I then imported all of the Blast files and bins into MEGAN to get the taxonomic classifications of all of the bins.

Here we see the overall tree. Out of 9106 reads total, 1229 reads were assigned to the Cyanobacteria phylum, 6072 reads were assigned to the Proteobacteria phylum, and 1639 reads were marked "No hits." In addition, 15 reads were marked "Not assigned."

![taxonomy1.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy1.png?raw=true "taxonomy1.png")

And here we see the cyanobacteria branch. We can clearly identify a species of cyanobacteria: Nostoc punctiforme PCC 73102

![taxonomy2.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy2.png?raw=true "taxonomy2.png")

Many of the results have been proteobacteria.

![taxonomy3.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy3.png?raw=true "taxonomy3.png")

The following is a chart to better visualize the distribution of cyanobacteria to proteobacteria in these samples:

![taxonomy9.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy9.png?raw=true "taxonomy9.png")

The following is a distribution of assigned reads in the Cyanobacteria phylum:

![taxonomy7.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy7.png?raw=true "taxonomy7.png")
![taxonomy10.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy10.png?raw=true "taxonomy10.png")

The following is a distribution of assigned reads in the Proteobacteria phylum:

![taxonomy8.png](https://github.com/EricJMarti/ECES490-Project/blob/master/taxonomy8.png?raw=true "taxonomy8.png")

##### Individual Bins

Bin 1:

![bin1.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin1.png?raw=true "bin1.png")

Bin 2:

![bin2.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin2.png?raw=true "bin2.png")

Bin 3:

![bin3.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin3.png?raw=true "bin3.png")

Bin 4:

![bin4.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin4.png?raw=true "bin4.png")

Bin 5:

![bin5.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin5.png?raw=true "bin5.png")

Bin 6:

![bin6.png](https://github.com/EricJMarti/ECES490-Project/blob/master/bin6.png?raw=true "bin6.png")

##### Future Work

There are 1639 reads that scored no hits with the NCBI Bacteria genome. I plan on running Blast on these reads against the entire NCBI database in hopes of identifying these unknown reads. 
