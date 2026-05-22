#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

module load blast/2.4.0

##############

FM=${1}

if [ ${FM} == "pom" ]
then
    SP1="atrilobata"
    SP2="multilineata"
    SP3="cyanea"
elif [ ${FM} == "serr" ]
then
    SP1="colonus"
    SP2="furcifer"
    SP3="fulva"
fi

for SP in ${SP1} ${SP2} ${SP3}
do
    INFILE="../../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity/${SP}_Trinity.fasta"
    OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s02_blast_db/${SP}_Trinity.fasta"

    #makes blast database out of trinity transcriptomes for each species

    makeblastdb -in ${INFILE} \
                -dbtype nucl \
                -out ${OUTDIR}

done
