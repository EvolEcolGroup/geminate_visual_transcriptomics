#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

FM=${1}
WORKDIR="../../data/intermediate/p07_salmon/${FM}"

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

##################
#COPY DIRECTORIES#
##################


for SP in ${SP1} ${SP2} ${SP3}
do
  for dir in ${WORKDIR}/${SP}/S*
  do
    cp -R ${dir} ${WORKDIR}/final
  done
done
