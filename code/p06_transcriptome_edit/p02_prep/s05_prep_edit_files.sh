#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
INDIR="../../../data/intermediate/p06_transcriptome_edit/p02_prep/${FM}"
LIST_DIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome_seqs/${FM}/s06_to_remove"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p02_edit/${FM}"

###

#script to combine per species lists of sequences to be removed in transcriptome
#final unduplicated sequences will replace removed seqs
#adds in sequences to remove from genome pipeline <species>_manual_remove.txt and  <species>_to_remove.txt

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

for DIR in ${INDIR}/*/
do
  SEQ=$(basename ${DIR})
  for SP in ${SP1} ${SP2} ${SP3}
  do
    cat ${INDIR}/${SEQ}/${SP}_${SEQ}_list.txt >> ${OUTDIR}/${SP}/${SP}_remove_list.txt
  done
done

#combine list with genome pipeline to remove
cat ${LIST_DIR}/${SP1}_to_remove.txt ${LIST_DIR}/${SP1}_manual_remove.txt >> ${OUTDIR}/${SP1}/${SP1}_remove_list.txt
cat ${LIST_DIR}/${SP2}_to_remove.txt ${LIST_DIR}/${SP2}_manual_remove.txt >> ${OUTDIR}/${SP2}/${SP2}_remove_list.txt
cat ${LIST_DIR}/${SP3}_to_remove.txt ${LIST_DIR}/${SP3}_manual_remove.txt >> ${OUTDIR}/${SP3}/${SP3}_remove_list.txt

#remove any blank lines from file
grep -v '^$' ${OUTDIR}/${SP1}/${SP1}_remove_list.txt > ${OUTDIR}/${SP1}/temp.txt && mv ${OUTDIR}/${SP1}/temp.txt ${OUTDIR}/${SP1}/${SP1}_remove_list.txt
grep -v '^$' ${OUTDIR}/${SP2}/${SP2}_remove_list.txt > ${OUTDIR}/${SP2}/temp.txt && mv ${OUTDIR}/${SP2}/temp.txt ${OUTDIR}/${SP2}/${SP2}_remove_list.txt
grep -v '^$' ${OUTDIR}/${SP3}/${SP3}_remove_list.txt > ${OUTDIR}/${SP3}/temp.txt && mv ${OUTDIR}/${SP3}/temp.txt ${OUTDIR}/${SP3}/${SP3}_remove_list.txt
