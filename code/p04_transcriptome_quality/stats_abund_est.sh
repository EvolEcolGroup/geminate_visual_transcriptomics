#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

###############

FM=${1}
SP=${2}
INDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s03_salmon"
OUTDIR="../../data/intermediate/p04_transcriptome_quality/${FM}/${SP}/s04_stats_abund"

###

#Selects individual sample names for each species:

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


#Run trinity script to get abundance estimates

$TRINITY_HOME/util/abundance_estimates_to_matrix.pl \
					--est_method salmon \
					--gene_trans_map none \
					--name_sample_by_basedir \
					${INDIR}/S${IND1}/quant.sf \
					${INDIR}/S${IND2}/quant.sf \
					${INDIR}/S${IND3}/quant.sf \
					${INDIR}/S${IND4}/quant.sf

mv salmon.isoform.* ${OUTDIR}
