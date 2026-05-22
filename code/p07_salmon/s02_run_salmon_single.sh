#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate salmon

#####

FM=${1}
SP=${2}
READ_DIR="../../data/intermediate/p01_quality/${FM}/${SP}/s06_concatenated_reads"
IDX_DIR="../../data/intermediate/p07_salmon/${FM}/${SP}"
OUTDIR="../../data/intermediate/p07_salmon/${FM}/${SP}"

#####


R1="${READ_DIR}/reads.ALL.S31.left.fastq.gz"
R2="${R1%left.fastq.gz}right.fastq.gz"

SAMPLE=$(echo ${R1} | sed 's/.*S\(.*\).l.*/\1/')

salmon quant \
  --libType ISR \
  -1 ${R1} \
  -2 ${R2} \
  --seqBias \
  --gcBias \
  --posBias \
  --writeMappings=${OUTDIR}/mappings_${SAMPLE}.txt \
  --threads 52 \
  --index ${IDX_DIR}/${SP}_trinity.index \
  -o ${OUTDIR}/S${SAMPLE}
