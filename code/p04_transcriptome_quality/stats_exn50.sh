#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

####################

FM=${1}
SP=${2}
TRANSCRIPTOME="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
MATRIX="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s04_stats_abund/salmon.isoform.TMM.EXPR.matrix"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s05_stats_exn50"

###

$TRINITY_HOME/util/misc/contig_ExN50_statistic.pl ${MATRIX} ${TRANSCRIPTOME} |& tee ${OUTDIR}/${SP}_trinity_ExN50.stats
