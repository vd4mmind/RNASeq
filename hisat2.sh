#!/bin/bash
#$ -S /bin/bash
cd /home/client/benchmark/BAM/HISAT2

GENOME=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Sequence/HISAT2/genome_snp_tran_ercc
SPLICESITES=/path_to/genomes/Homo_sapiens/NCBI_spiked/GRCh38/Sequence/HISAT2/splicesites.txt
floc=/path_to/rnaseq/raw/dat_loc

s=$1

tf="\n%E elapsed,\n%U user,\n%S system, \n %P CPU, \n%M max-mem footprint in KB, \n%t avg-mem footprint in KB, \n%K Average total (data+stack+text) memory,\n%F major page faults, \n%I file system inputs by the process, \n%O file system outputs by the process, \n%r socket messages received, \n%s socket messages sent, \n%x status"

s2=`echo $s | sed 's/Sample_//g'`
echo $s2
R1=`echo $floc/$s/*R1*.fastq.gz | tr " " ","`
R2=`echo $floc/$s/*R2*.fastq.gz | tr " " ","`
/path_to/softwares/time -f "$tf" /path_to/softwares/hisat2-2.0.1-beta/hisat2 --rna-strandness RF --known-splicesite-infile $SPLICESITES -x $GENOME -p 8 -1 $R1 -2 $R2 | samtools view -Sb - | samtools sort -m 4000000000 - $s2.sorted
/path_to/benchmark/quantify.sh $s2.HISAT2 /path_to/benchmark/BAM/HISAT2/$s2.sorted.bam
