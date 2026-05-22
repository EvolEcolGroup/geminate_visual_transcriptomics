#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

module load blast/2.4.0

##############

FM=${1}
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/s01_genome_seqs/${FM}/s03_run_blast"
QUERY_SEQ="../../../data/intermediate/p06_transcriptome_edit/s01_genome_seqs/${FM}/s01_genome_seqs"

#############
#SET SPECIES#
#############

if [ ${FM} == "pom" ]
then
    SP1="atrilobata"
    SP2="multilineata"
    SP3="cyanea"
elif [ ${FM} == "serr" ]
then
    SP1="colonus"
    SP2="furcifer"
    SP3="fulva"
fi
###############

for SP in ${SP1} ${SP2} ${SP3}
do

  TRANSCRIPT_DB="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s02_blast_db/${SP}_Trinity.fasta"

  #runs blast search of selected genome sequences against trasncriptomes to pull out trinity hits

  for i in $QUERY_SEQ/*${SP}*
  do
    blastn -query ${i} \
           -db ${TRANSCRIPT_DB} \
           -out ${OUTDIR}/$(basename ${i%%.fasta})_hits \
           -num_threads 12
  done
done
