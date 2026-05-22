#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p03_edit/${FM}"
TRANS_DIR="../../../data/intermediate/p03_trinity/${FM}/s01_trinity"
GENE_DIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome_seqs/${FM}/s05_rename"

####

#script pulls out sequences from transcriptome of sequences for each gene in final gene list
#for use after manually going through sequences and creating final sequences list

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

################
#PULL SEQUENCES#
################


for SP in ${SP1} ${SP2} ${SP3}
do
  echo ${SP}
  while read SEQ
  do
    echo ${SEQ}
    grep -i "\<${SEQ}\>" ${TRANS_DIR}/${SP}/${SP}_Trinity.fasta -A 160 | tr '\n' '\r' | awk -F'>' '{print $2}' | tr '\r' '\n' >> ${WORKDIR}/${SP}/${SP}_final_genes.fasta
  done < ${WORKDIR}/${SP}/${SP}_final_genes_list.txt
  cat ${GENE_DIR}/${SP}_modified_sequence.fasta >> ${WORKDIR}/${SP}/manual_final_genes.fasta && \
  cat ${WORKDIR}/${SP}/manual_final_genes.fasta >> ${WORKDIR}/${SP}/${SP}_final_genes.fasta
done



