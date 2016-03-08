#!/bin/sh
#
#$ -N bam_reheader
#$ -cwd
#$ -e err_bam_reheader.log
#$ -o out_bam_reheader.log
#$ -S /bin/sh
#$ -M abs.xyz@domain.in
#$ -m bea
#$ -l h_vmem=25G

correct_header=/path/data/PT1/header.sam
folder=/path/project/data/

cd $folder/sample
samtools reheader $correct_header $folder/sample/sample_S1.bam > new_sample_S1.bam
samtools sort new_sample_S1.bam sample_S1.sorted
rm new_sample_S1.bam
samtools view -H sample_S1.sorted.bam | more > header.log
echo "done"
