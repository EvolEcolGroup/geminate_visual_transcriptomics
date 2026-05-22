#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p02_prep/${FM}"
ANNOT_DIR="../../../data/intermediate/p05_annotation/s02_format_annotation/${FM}"

###

#makes list of trinity sequences for each gene listed in seqs to check list and puts them in correct directory
#dont use edited split annotation for this so that I can use the original actin gene codes

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

#################
#MAKE GENE LISTS#
#################

for SP in ${SP1} ${SP2} ${SP3}
do
  while read SEQ
  do
    awk -F ${SEQ} /${SEQ}/'{print $1}' ${ANNOT_DIR}/${SP}.emapper.annotations | awk '{print $1}' > ${WORKDIR}/${SEQ}/${SP}_${SEQ}_list.txt
  done < ${WORKDIR}/seqs_to_check.txt
done
