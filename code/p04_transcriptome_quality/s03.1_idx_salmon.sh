#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate salmon

#####

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s03_salmon"

#####

salmon index \
    --index ${OUTDIR}/${SP}_trinity.index \
    --transcripts ${TRANSCRIPTOME}
