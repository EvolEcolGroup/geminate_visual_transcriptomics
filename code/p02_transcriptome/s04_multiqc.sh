#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

conda acitvate multiqcenv

###

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s03_fastqc"
OUTDIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s04_multiqc"

###


multiqc ${INDIR} \
	-o ${OUTDIR} \
	--pdf
