!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#################

FM=${1}
WORKDIR="../../../data/intermediate/p06_transcriptome_edit/p03_edit/${FM}"

###

#fixes sequences after running 1_grab_final_genes.sh
#line one adds > to start of TRINITY line
#line 2 removes empty lines between sequences

#############
#SET SPECIES#
#############

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

############
#FIX FORMAT#
############

for SP in ${SP1} ${SP2} ${SP3}
do
  sed -i '/^TRINITY/ s/./>&/' ${WORKDIR}/${SP}/${SP}_final_genes.fasta &&
  sed -i '/^$/d' ${WORKDIR}/${SP}/${SP}_final_genes.fasta

done



