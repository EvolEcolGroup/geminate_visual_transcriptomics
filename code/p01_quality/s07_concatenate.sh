#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
SAMPLE=${3}
INDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s05_cutadapt"
OUTDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s07_concatenated_reads"

###


##Concatenate the reads of one sample into a single set of inputs for trinity assembly test runs.

cat ${INDIR}/*${SAMPLE}*R1*fastq.gz >> ${OUTDIR}/reads.ALL.S${SAMPLE}.left.fastq.gz
cat ${INDIR}/*${SAMPLE}*R2*fastq.gz >> ${OUTDIR}/reads.ALL.S${SAMPLE}.right.fastq.gz
