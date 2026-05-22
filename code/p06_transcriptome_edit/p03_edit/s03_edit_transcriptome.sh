#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#######

FM=${1}
INDIR="../../../data/intermediate/p06_transcriptome_edit/p03_edit/${FM}"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p03_edit/s03_final_transcriptomes/${FM}"
TRANS_DIR="../../../data/intermediate/p03_trinity/${FM}/s01_trinity"

####

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

#####################
#EDIT TRANSCRIPTOMES#
#####################

for SP in ${SP1} ${SP2} ${SP3}
do
  awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' ${TRANS_DIR}/${SP}/${SP}_Trinity.fasta | grep -vFf ${INDIR}/${SP}/${SP}_remove_list.txt | tr "\t" "\n">${INDIR}/${SP}/${SP}_Trinity_temp.fasta

  cat ${INDIR}/${SP}/${SP}_final_genes.fasta ${INDIR}/${SP}/${SP}_Trinity_temp.fasta > ${OUTDIR}/${SP}/${SP}_Trinity_edit.fasta
done


