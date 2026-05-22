#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate salmon

#####

FM=${1}
SP=${2}
READ_DIR="../../data/intermediate/p01_quality/${FM}/${SP}/s07_concatenated_reads"
IDX_DIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s03_salmon"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s03_salmon"

#####

for i in ${READ_DIR}/*left*
do

R1=${i}
R2="${R1%left.fastq.gz}right.fastq.gz"

SAMPLE=$(echo ${R1} | sed 's/.*S\(.*\).l.*/\1/')

salmon quant \
  --libType ISR \
  -1 ${R1} \
  -2 ${R2} \
  --seqBias \
  --gcBias \
  --posBias \
  --threads 32 \
  --index ${IDX_DIR}/${SP}_trinity.index \
  -o ${OUTDIR}/S${SAMPLE}

done
