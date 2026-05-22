#!/usr/bin/env bash

#set -euxo pipefail
#set -o errtrace

##############

FM=${1}
INDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s03_blast_results"
SEQDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s01_genome_seqs"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s05_rename"

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
  new_fasta_file="${OUTDIR}/${SP}_modified_sequence.fasta"

  for i in ${INDIR}/*${SP}*
  do
    # Define the blast hits file and the corresponding fasta file
    blast_hits_file=${i}
    fasta_file="${SEQDIR}/$(basename ${i%%_hits}).fasta"

   # Extract the top hit Trinity ID
   top_hit_trinity_id=$(grep -E '^\s+TRINITY_[^[:space:]]+' "$blast_hits_file" | head -n 1 | awk '{print $1}')

  # Check if a top hit Trinity ID is found
    if [[ -n "$top_hit_trinity_id" ]]; then

        # Create a new file with the modified header and entire sequence
        awk -v id="$top_hit_trinity_id" '/^>/{sub(/^>.*/, ">" id); print; next} 1' "$fasta_file" >> "$new_fasta_file"

        echo "Sequence for top hit Trinity ID $top_hit_trinity_id has been extracted and saved to $new_fasta_file"
    else

  # If no top hit Trinity ID is found, use the first word in the fasta file name as the header
      header=$(basename "$fasta_file" | awk -F_ '{print $1}')
      awk -v header="$header" '/^>/{sub(/^>.*/, ">" header); print; next} 1' "$fasta_file" >> "$new_fasta_file"
      echo "$(basename $blast_hits_file)" >>"${OUTDIR}/${FM}_manual_check.txt"
    fi
  done
done


cat "${OUTDIR}/${FM}_manual_check.txt" | sort > "${OUTDIR}/${FM}_manual_check_sorted.txt" && mv "${OUTDIR}/${FM}_manual_check_sorted.txt" "${OUTDIR}/${FM}_manual_check.txt"

echo "NO TRINITY BLAST HIT FOUND FOR:"
cat ${OUTDIR}/${FM}_manual_check.txt
