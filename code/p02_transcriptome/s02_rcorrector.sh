#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate rcorrector

###################

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s01_trans_cutadapt"
OUTDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s02_rcorrector"

###

##Run Rcorrector on rrnasorted/trimmed reads for transcriptome assembly.

perl ~/.conda/envs/rcorrector/bin/run_rcorrector.pl \
  -1 Ge1_1_S1_L001_sortmerna_cutadapt_R1.fastq.gz,Ge1_1_S1_L002_sortmerna_cutadapt_R1.fastq.gz  \
  -2 Ge1_1_S1_L001_sortmerna_cutadapt_R2.fastq.gz,Ge1_1_S1_L002_sortmerna_cutadapt_R2.fastq.gz  \
  -t 32 \
  -od 1_rcorrector |& tee ${OUTDIR}/reads.ALL.S1_rcorrector.log
