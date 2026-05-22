#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#######

#makes directories of all sequences which need checking using actin gene code
#need to have manually added list of seqs to check (seqs_to_check.txt)
#plus this script will add in those to check from the genome pipeline

#####

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p02_prep/${FM}"
INDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome_seqs/${FM}/s07_actin_codes"

###

cat ${INDIR}/actin_code_dets.txt >>${WORKDIR}/seqs_to_check_info.txt
cat ${INDIR}/actin_codes.txt >>${WORKDIR}/seqs_to_check.txt

###

while read SEQ
do
  mkdir ${WORKDIR}/${SEQ}
done < ${WORKDIR}/seqs_to_check.txt
