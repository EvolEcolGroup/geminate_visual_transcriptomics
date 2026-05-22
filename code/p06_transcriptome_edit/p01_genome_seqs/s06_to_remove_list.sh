#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

##############

#list of trinity ID's to remove which don't have a annotation entry so won't be picked up by later removal process based on actin code

##############

FM=${1}
IN_TSV="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s04_blast_table/${FM}_output.tsv"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s06_to_remove_list"


# Create an associative array to store Trinity IDs for each species
declare -A trinity_ids

# Read the TSV file line by line
while IFS=$'\t' read -r gene query_name species trinity_id Evalue actin_code; do
    # Check if actin_code is "absent"
    if [[ "$actin_code" == "absent" ]]; then
        # Append the Trinity ID to the corresponding species entry in the array
        trinity_ids["$species"]+=" $trinity_id"
    fi
done < ${IN_TSV}

# Iterate over the species and write the Trinity IDs to the corresponding to_remove.txt file
for species in "${!trinity_ids[@]}"; do
    to_remove_file="${OUTDIR}/${species}_to_remove.txt"
    echo "${trinity_ids[$species]}" | tr ' ' '\n' > "$to_remove_file"
    echo "Trinity IDs for $species with actin_code 'absent' have been written to $to_remove_file"
done


############################################

#Also place in the folder "6_to_remove" any sequences which manully need to be chosen and removed
#for example when there is a blast hit to more than one actin ID and you do not wish to remove
#every trinity seq under that actin code only the one for which there was a hit.

#Assess the 4_blast_table.tsv file to recover any of theses sequences.

#this script makes empty files for each species which can be populated with manually chosen sequences to be removed if required.
#make sure to also write a note to give details of each removed sequence so you remember why its removed - the note if not edited
#will indicate no sequences were required to be removed

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
###############

for SP in ${SP1} ${SP2} ${SP3}
do
  touch ${OUTDIR}/${SP}_manual_remove.txt
done

echo "No seqs need removed." > ${OUTDIR}/manual_remove_details.txt
