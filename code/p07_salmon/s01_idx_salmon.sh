#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate salmon

#####

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p06_transcriptome_edit/p02_edit/s03_final_transcriptomes/${FM}/${SP}/${SP}_Trinity_edit.fasta"
OUTDIR="../../data/intermediate/p07_salmon/${FM}/${SP}"

#####

salmon index \
    --index ${OUTDIR}/${SP}_trinity.index \
    --transcripts ${TRANSCRIPTOME}
