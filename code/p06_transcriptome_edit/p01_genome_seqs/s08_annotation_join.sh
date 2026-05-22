#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

#before running this script you must have manually added to the file /8_annotation_join/add_in_annot.tsv all the possible annotation entries that are missing
#takes the species and gene name from the list of sequences that dont have an annotation entry stored in pom_manual_check.txt
#uses this information to make files for each species of annotation entries that need to be added to the annotation once it is at its final stage of editing

##############

FM=${1}
INPUT="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s05_rename/${FM}_manual_check.txt"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s08_annotation_join"


while read line
do

  SP=$(echo ${line} | awk -F'_' '{print $(NF-1)}')
  GENE=$(echo $line | sed 's/_.*//')
  grep "$GENE" ${OUTDIR}/add_in_annot.tsv >>${OUTDIR}/${SP}_add_annotations.tsv

done<${INPUT}
