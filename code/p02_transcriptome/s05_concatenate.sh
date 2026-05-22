#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
SAMPLE=${3}
INDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s02_rcorrector"
OUTDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s05_concatenated_reads"

###


##Concatenate the reads of one sample into a single set of inputs for trinity assembly test runs.

cat ${INDIR}/*${SAMPLE}*R1*fq.gz >> ${OUTDIR}/reads.ALL.S${SAMPLE}.left.fastq.gz
cat ${INDIR}/*${SAMPLE}*R2*fq.gz >> ${OUTDIR}/reads.ALL.S${SAMPLE}.right.fastq.gz
