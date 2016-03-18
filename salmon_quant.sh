#!/bin/bash
#$ -S /bin/bash

### path to the scripts running
cd /path_to/vdas/client/RNA-Seq/scripts/hg19

SALMON=/path_to/softwares/Salmon-0.4.2/bin/salmon
SALMON_INDEX=/path_to/genomes/Homo_sapiens/UCSC_spiked/hg19/Sequence/salmonIndexes ##spiken genome since we use ERCC spike-ins
TX2GENE=/path_to/genomes/Homo_sapiens/UCSC_spiked/hg19/Sequence/salmonIndexes/transcript2gene ## a tav delimeted file containing unique transcript name in first column and its corresponding gene symbols total 42029 records
floc=/facility_directory_for_client_samples
#tf="\n%E elapsed,\n%U user,\n%S system, \n %P CPU, \n%M max-mem footprint in KB, \n%t avg-mem footprint in KB, \n%K Average total (data+stack+text) memory,\n%F major page faults, \n%I file system inputs by the process, \n%O file system outputs by the process, \n%r socket messages received, \n%s socket messages sent, \n%x status"

samples="Sample_1##code
Sample_2##code
..
..
..
Sample_N##code"

for s in $samples; do
s2=`echo $s | sed 's/Sample_//g'` ##renaming the output folders of the samples
echo "Running salmon on $s2..."
$SALMON quant -p 8 -i $SALMON_INDEX -g $TX2GENE -l ISR -1 <(zcat $floc/$s/*R1*.fastq.gz) -2 <(zcat $floc/$s/*R2*.fastq.gz) -o /path_to/vdas/client/RNA-Seq/output/hg19_salmon_out/$s2.quant
done
