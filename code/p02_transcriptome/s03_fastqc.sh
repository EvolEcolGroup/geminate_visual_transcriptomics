#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s02_rcorrector"
OUTDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s03_fastqc"

###

##RUN FASTQC

fastqc \
    ${INDIR}/*fastq.gz \
    -o ${OUTDIR} \
    -t 6

##CONVERT FASTQC HTML FILES TO PDF

#Creates PDF version of fastqc HTML output files


for file in ${OUTDIR}/*fastqc.html
do
      wkhtmltopdf ${file} ${file%%.html}.pdf
done
