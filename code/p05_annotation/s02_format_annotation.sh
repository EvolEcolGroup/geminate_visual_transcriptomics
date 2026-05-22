#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

###################

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p05_annotation/s01_eggnog_mapper/${FM}/${SP}"
OUTDIR="../../data/intermediate/p05_annotation/s02_format_annotation/${FM}"

###

cp ${INDIR}/${SP}.emapper.annotations ${OUTDIR}

#Remove first 4 lines
sed -i '1,4d' ${OUTDIR}/${SP}.emapper.annotations

#Remove last 3 lines
sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' ${OUTDIR}/${SP}.emapper.annotations

#Remove problematic '#'
sed -i s'/#//' ${OUTDIR}/${SP}.emapper.annotations
