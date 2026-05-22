#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p02_prep/${FM}"

###

#fixes sequences after running 3_grab_genes.sh
#line one adds > to start of TRINITY line
#line 2 removes empty lines between sequences

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

############
#FIX FORMAT#
############

for DIR in ${WORKDIR}/*/
do
  SEQ=$(basename ${DIR})
  for SP in ${SP1} ${SP2} ${SP3}
  do
    sed -i '/^TRINITY/ s/./>&/' ${WORKDIR}/${SEQ}/${SP}_${SEQ}_seqs.fasta &&
    sed -i '/^$/d' ${WORKDIR}/${SEQ}/${SP}_${SEQ}_seqs.fasta
  done
done
