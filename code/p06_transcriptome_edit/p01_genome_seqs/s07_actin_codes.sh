#!/usr/bin/env bash

#set -euxo pipefail
#set -o errtrace

##############

FM=${1}
INDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s03_blast_results"
ANNOT_DIR="../../../data/intermediate/p05_annotation/s02_format_annotation/${FM}"
FASTA_DIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s05_rename"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s07_actin_codes"

# Output file
output_file=${OUTDIR}/${FM}_top_hit.tsv
# Create the output file with headers
echo -e "query_name\tspecies\ttrinity_ID_of_blast_hit\tactin_code" > "$output_file"

# Report file for warnings
report_file=${OUTDIR}/${FM}_report.txt


for hit in ${INDIR}/*hits
do
  blast_hits_file=${hit}
  if [[ $blast_hits_file == *colonus* ]]; then
    annotation_file="${ANNOT_DIR}/colonus.emapper.annotations"
    species="colonus"
  elif [[ $blast_hits_file == *furcifer* ]]; then
    species="furcifer"
    annotation_file="${ANNOT_DIR}/furcifer.emapper.annotations"
  elif [[ $blast_hits_file == *fulva* ]]; then
    annotation_file="${ANNOT_DIR}/fulva.emapper.annotations"
    species="fulva"
  elif [[ $blast_hits_file == *atrilobata* ]]; then
    annotation_file="${ANNOT_DIR}/atrilobata.emapper.annotations"
    species="atrilobata"
  elif [[ $blast_hits_file == *multilineata* ]]; then
    annotation_file="${ANNOT_DIR}/multilineata.emapper.annotations"
    species="multilineata"
  elif [[ $blast_hits_file == *cyanea* ]]; then
    annotation_file="${ANNOT_DIR}/cyanea.emapper.annotations"
    species="cyanea"
  fi

  # Extract the top hit Trinity ID
  top_hit_trinity_id=$(grep -E '^\s+TRINITY_[^[:space:]]+' "$blast_hits_file" | head -n 1 | awk '{print $1}')

  # Check if a top hit Trinity ID is found
  if [[ -n "$top_hit_trinity_id" ]]; then
    evalue=$(awk -v id="$top_hit_trinity_id" '/^TRINITY/{if ($1 == id) print $(NF-1)}' "$blast_hits_file")

    # Search for trinity_id in the annotation file
    actin_code=$(grep -E "\<$top_hit_trinity_id\>" "$annotation_file" | grep -oE ',[[:alnum:]]+@7898\|Actinopterygii' | cut -d',' -f2 | cut -d'@' -f1)

    # Output the result to the output file
    if [[ -z "$actin_code" ]]; then
      echo -e "$(basename "$blast_hits_file")\t$species\t$top_hit_trinity_id\tabsent" >> "$output_file"
    else
      echo -e "$(basename "$blast_hits_file" | sed 's/_.*//')\t$species\t$top_hit_trinity_id\t$actin_code" >> "$output_file"
    fi
  fi
done

echo "Processing complete. Results saved in $output_file"


##########################


#check tsv file

# Set species names based on the input FM
if [ "$FM" == "pom" ]; then
    SP1="atrilobata"
    SP2="multilineata"
    SP3="cyanea"
elif [ "$FM" == "serr" ]; then
    SP1="colonus"
    SP2="furcifer"
    SP3="fulva"
else
    echo "Error: Unknown FM value."
    exit 1
fi

# Check for each query that there is an entry from all 3 species
awk -F'\t' 'NR>1{queries[$1]+=1; species[$1,$2]+=1} END{for (q in queries) if (length(species[q,"'"$SP1"'"]) * length(species[q,"'"$SP2"'"]) * length(species[q,"'"$SP3"'"]) != 1) print "Warning: Query \"" q "\" does not have entries from all species."}' "$output_file" | tee -a "$report_file"

# Check that for each query all the entries have the same actin code
# Create an associative array to store actin codes for each query
declare -A actin_codes

# Read the TSV file and populate the array
while IFS=$'\t' read -r query species trinity_id actin_code; do
    # Ignore the header
    if [ "$query" == "query_name" ]; then
        continue
    fi

    # Skip lines where the actin code is "absent"
    if [ "$actin_code" == "absent" ]; then
        continue
    fi

    # If the query is not in the array, add it
    if [ ! -n "${actin_codes["$query"]}" ]; then
        actin_codes["$query"]=$actin_code
    else
        # If the actin code for the query is different, print a warning
        if [ "${actin_codes["$query"]}" != "$actin_code" ]; then
            echo "Warning: Query \"$query\" has top hits from multiple actin codes: ${actin_codes["$query"]} and $actin_code" | tee -a "$report_file"
        fi
    fi
done < "$output_file"

# Check that each actin code is unique to one query name

# Extract query and actin code columns, sort and keep unique lines
sorted_unique=$(awk -F'\t' 'NR>1 && $4 != "absent"{print $1 "\t" $4}' "$output_file" | sort -u)

# Check if any actin code is repeated
duplicate_actin=$(echo "$sorted_unique" | awk '{count[$2]++; queries[$2] = queries[$2] $1 " "} END {for (code in count) if (count[code] > 1) print code, queries[code]}')

# Output warnings if duplicate actin codes are found
if [ -n "$duplicate_actin" ]; then
    echo "Warning: The following actin codes are associated with multiple queries:" | tee -a "$report_file"
    echo "$duplicate_actin" | tee -a "$report_file"
fi



##################################

#check trinity IDS in headers match the top hit in the tsv file
#warn if any don't

# Loop through each line in the TSV file
while IFS=$'\t' read -r query species trinity_id actin_code; do
    # Skip header
    if [ "$query" == "query_name" ]; then
        continue
    fi

    # Determine the file to check based on species
    case "$species" in
        atrilobata)
            species_file="${FASTA_DIR}/atrilobata_modified_sequence.fasta"
            ;;
        cyanea)
            species_file="${FASTA_DIR}/cyanea_modified_sequence.fasta"
            ;;
        multilineata)
            species_file="${FASTA_DIR}/multilineata_modified_sequence.fasta"
            ;;
	colonus)
            species_file="${FASTA_DIR}/colonus_modified_sequence.fasta"
            ;;
	furcifer)
            species_file="${FASTA_DIR}/furcifer_modified_sequence.fasta"
            ;;
	fulva)
            species_file="${FASTA_DIR}/fulva_modified_sequence.fasta"
            ;;
        *)
            echo "Error: Unknown species \"$species\""
            exit 1
            ;;
    esac

    # Check if the trinity ID is present in the species file
    if ! grep -q "$trinity_id" "$species_file"; then
        echo "Warning: Trinity ID \"$trinity_id\" for query \"$query\" (species: \"$species\") not found in \"$(basename $species_file)\""
    fi

done < "$output_file"


#################################


#save the final actin codes that will be checked/removed later in pipeline also save a version with he gene name
awk 'NR>1{print $4 " " $1}' < $output_file | uniq >${OUTDIR}/actin_code_dets.txt
awk 'NR>1{print $4}' < $output_file | uniq >${OUTDIR}/actin_codes.txt
