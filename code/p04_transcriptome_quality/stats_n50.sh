#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s02_stats_n50"

###

$TRINITY_HOME/util/TrinityStats.pl  ${TRANSCRIPTOME} >> ${OUTDIR}/${SP}_trinity_stats_n50.txt
