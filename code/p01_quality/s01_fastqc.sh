#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
INDIR="../../data/raw/${FM}/${SP}/"
READS="*fastq.gz"
OUTDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s01_fastqc"

###

##RUN FASTQC


fastqc \
    ${INDIR}/${READS} \
    -o ${OUTDIR} \
    -t 6

##CONVERT FASTQC HTML FILES TO PDF

#Creates PDF version of fastqc HTML output files


for file in ${OUTDIR}/*fastqc.html
do
      wkhtmltopdf ${file} ${file%%.html}.pdf
done
