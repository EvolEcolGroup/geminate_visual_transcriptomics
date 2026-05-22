#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

FM=${1}
SP=${2}
READ_DIR="../../data/intermediate/p02_transcriptome/${FM}/${SP}/s05_concatenated_reads"
OUTDIR="../../data/intermediate/p03_trinity/${FM}/${SP}/s01_trinity"

###

#selects appropriate species sample numbers for trinity

if [[ ${SP} == "atrilobata" ]]
then
   IND1="24"
   IND2="25"
   IND3="26"
   IND4="27"
elif [[ ${SP} == "multilineata" ]]
then
   IND1="1"
   IND2="2"
   IND3="3"
   IND4="4"
elif [[ ${SP} == "cyanea" ]]
then
   IND1="20"
   IND2="21"
   IND3="22"
   IND4="23"
elif [[ ${SP} == "colonus" ]]
then
   IND1="28"
   IND2="29"
   IND3="30"
   IND4="31"
elif [[ ${SP} == "furcifer" ]]
then
   IND1="17"
   IND2="18"
   IND3="43"
   IND4="46"
elif [[ ${SP} == "fulva" ]]
then
   IND1="13"
   IND2="14"
   IND3="15"
   IND4="19"
fi

##Trinity assembly with all 4 individual samples

Trinity \
--seqType fq \
--left  ${READ_DIR}/reads.ALL.S${IND1}.left.fastq.gz,${READ_DIR}/reads.ALL.S${IND2}.left.fastq.gz,${READ_DIR}/reads.ALL.S${IND3}.left.fastq.gz,${READ_DIR}/reads.ALL.S${IND4}.left.fastq.gz
--right ${READ_DIR}/reads.ALL.S${IND1}.right.fastq.gz,${READ_DIR}/reads.ALL.S${IND2}.right.fastq.gz,${READ_DIR}/reads.ALL.S${IND3}.right.fastq.gz,${READ_DIR}/reads.ALL.S${IND4}.right.fastq.gz
--SS_lib_type RF \
--CPU 32 \
--full_cleanup \
--output ${SP}_trinity \
--max_memory 50G |& tee ${OUTDIR}/${SP}_trinity.log
