#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate busco

###

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s01_busco"


busco --in ${TRANSCRIPTOME} \
      --lineage_dataset ../../data/raw/busco_databases/lineages/actinopterygii_odb10 \
      --out ${SP}_busco \
      --mode transcriptome \
      --out_path ${OUTDIR} \
      --cpu 53 |& tee ${OUTDIR}/${SP}_busco.log
