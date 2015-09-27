#!/bin/bash
#$ -S /bin/bash

cd /path_to/vdas/requester_name/RNA-Seq/scripts

TOPHAT=/path_to/tophat-2.0.14.Linux_x86_64/tophat
BOWTIE_INDEX=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Sequence/Bowtie2Index/genome
GENOME=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Annotation/genes_clean.gtf
fastq_folder=/path_to/FASTQ/Project_ID/Project_name
output_directory=/path_to/vdas/requester_name/RNA-Seq/output/topout

samples="Sample_1
Sample_2
...
...
Sample_N"

for s in $samples; do
s2=`echo $s | sed 's/Sample_//g'`
echo "Running tophat on $s2..."
read1=`echo $fastq_folder/$s/*R1*.fastq.gz | tr " " ","`
read2=`echo $fastq_folder/$s/*R2*.fastq.gz | tr " " ","`

$TOPHAT -p 8 -o $output_directory/$s2.topout -G $GENOME $BOWTIE_INDEX $read1 $read2 --library-type=fr-firststrand
done
