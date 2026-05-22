#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

FM=${1}
SP=${2}
WORKDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s03_salmon"

###


for i in ${WORKDIR}/S*
do
cd ${i}/logs
echo ${i}
grep 'Mapping rate' salmon_quant.log
cd -
done >> ${WORKDIR}/mapping_rate_log.txt

cat ${WORKDIR}/mapping_rate_log.txt
