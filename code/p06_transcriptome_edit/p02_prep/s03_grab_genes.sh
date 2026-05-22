#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p02_prep/${FM}"
TRANS_DIR="../../../data/intermediate/p03_trinity/${FM}/s01_trinity"

####

#script pulls out sequences from transcriptome for each gene in gene list

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

for DIR in ${WORKDIR}/*/
do
  SEQDIR=$(basename ${DIR})
  for SP in ${SP1} ${SP2} ${SP3}
  do
    echo ${SP}
    while read SEQ
    do
      echo ${SEQ}
      grep -i "\<${SEQ}\>" ${TRANS_DIR}/${SP}/${SP}_Trinity.fasta -A 160 | tr '\n' '\r' | awk -F'>' '{print $2}' | tr '\r' '\n' >> ${WORKDIR}/${SEQDIR}/${SP}_${SEQDIR}_seqs.fasta
    done < ${WORKDIR}/${SEQDIR}/${SP}_${SEQDIR}_list.txt
  done
done
