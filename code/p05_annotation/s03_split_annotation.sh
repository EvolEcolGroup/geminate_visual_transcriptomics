#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#######

FM=${1}
INDIR="../../data/intermediate/p05_annotation/s02_format_annotation/${FM}"
OUTDIR="../../data/intermediate/p05_annotation/s03_split_annotation/${FM}"
LISTDIR="../../data/intermediate/p05_annotation/s03_split_annotation/${FM}/sequence_lists"

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

########################
#SPLIT GENE ANNOTATIONS#
########################

#copy annotation files to split directory
cp ${INDIR}/${SP1}.emapper.annotations ${OUTDIR}
cp ${INDIR}/${SP2}.emapper.annotations ${OUTDIR}
cp ${INDIR}/${SP3}.emapper.annotations ${OUTDIR}


while read ID
do
  echo ${ID}
  for N in 1 2 3 4
  do
    echo ${N}
    for SP in ${SP1} ${SP2} ${SP3}
    do
      echo ${SP}
      while read line
      do
        sed -i "/^${line}\s/s/${ID}/${ID}${N}/g" ${OUTDIR}/${SP}.emapper.annotations
      done < ${LISTDIR}/${SP}_${ID}_list${N}.txt
    done
  done
done < ${OUTDIR}/id_list.txt
