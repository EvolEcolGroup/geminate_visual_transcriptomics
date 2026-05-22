#!/usr/bin/env bash

#set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate busco

###

OUTDIR="../../data/intermediate/p04_transcriptome_quality/busco_summaries"

##############
COPY SUMMARIES
##############

for FM in pom serr
do

  if [ ${FM} == pom ]
  then
    for SP in atrilobata multilineata cyanea
    do
        INDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s01_busco/${SP}_busco"
	cp ${INDIR}/short_summary.specific.actinopterygii_odb10.${SP}_busco.txt ${OUTDIR}
    done
  elif [ ${FM} == serr ]
  then
    for SP in colonus furcifer fulva
    do
        INDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s01_busco/${SP}_busco"
	cp ${INDIR}/short_summary.specific.actinopterygii_odb10.${SP}_busco.txt ${OUTDIR}
    done
  fi
done


##############
PLOT SUMMARIES
##############

# using generatre_plot.py script from BUSCO

python3 generate_plot.py \
			–wd ${OUTDIR}
