#!/bin/bash
#$ -S /bin/bash

# This script enables you to run the tophat on the fastq.gz files all at one without merging each end read files to one and large fastq
#Move to the directory of the scripts
cd /path_to/vdas/requester_name/RNA-Seq/scripts

# Below are the paths for TOPHAT, INDEX of human genome, GENOME file (here Grch38), Fastq folder of the requester, output directory
TOPHAT=/path_to/tophat-2.0.14.Linux_x86_64/tophat
BOWTIE_INDEX=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Sequence/Bowtie2Index/genome
GENOME=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Annotation/genes_clean.gtf
fastq_folder=/path_to/FASTQ/Project_ID/Project_name
output_directory=/path_to/vdas/requester_name/RNA-Seq/output/topout

## Assign the variable sample the list of samples to be run with tophat
samples="Sample_1
Sample_2
...
...
Sample_N"

for s in $samples; do
s2=`echo $s | sed 's/Sample_//g'` #This line replaces the string Sample_ in the sample name to reduce the name of the string in output folder
echo "Running tophat on $s2..."
read1=`echo $fastq_folder/$s/*R1*.fastq.gz | tr " " ","` ## read files in CSV format
read2=`echo $fastq_folder/$s/*R2*.fastq.gz | tr " " ","`

$TOPHAT -p 8 -o $output_directory/$s2.topout -G $GENOME $BOWTIE_INDEX $read1 $read2 --library-type=fr-firststrand
done
