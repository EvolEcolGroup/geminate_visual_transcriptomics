#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
OUTDIR="../../data/intermediate/p05_annotation/s01_eggnog_mapper/${FM}/${SP}"

###


emapper.py \
-i ${TRANSCRIPTOME} \
--itype CDS \
-m diamond \
--cpu 53 \
-o ${SP} \
--dmnd_db ../../data/raw/annotation/diamond/eggnog_proteins.dmnd \
--data_dir ../../data/raw/annotation \
--output ${OUTDIR} \
--tax_scope 7898 |& tee ${OUTDIR}/${SP}_eggnog_mapper.log
