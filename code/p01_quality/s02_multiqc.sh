#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s01_fastqc"
OUTDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s02_multiqc"

###


multiqc ${INDIR} \
	-o ${OUTDIR} \
	--pdf
